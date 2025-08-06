/// User Storage Service for Cartify
/// Handles storage and caching of user profile data, addresses,
/// and user preferences for offline access and better performance

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user_models.dart';
import '../log_service.dart';

/// Service for user data storage and caching
class UserStorageService extends GetxService {
  static final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _userProfileKey = 'user_profile';
  static const String _userAddressesKey = 'user_addresses';
  static const String _defaultAddressIdKey = 'default_address_id';

  // Observable user data
  final Rx<UserProfile?> _currentProfile = Rx<UserProfile?>(null);
  final RxList<UserAddress> _userAddresses = <UserAddress>[].obs;
  final RxString _defaultAddressId = ''.obs;

  // Getters for reactive state
  UserProfile? get currentProfile => _currentProfile.value;
  List<UserAddress> get userAddresses => _userAddresses.toList();
  String get defaultAddressId => _defaultAddressId.value;

  // Reactive getters
  Rx<UserProfile?> get currentProfileRx => _currentProfile;
  RxList<UserAddress> get userAddressesRx => _userAddresses;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadStoredUserData();
  }

  /// Load stored user data on app start
  Future<void> _loadStoredUserData() async {
    try {
      LogService.info('Loading stored user data');

      // Load user profile
      final profileData = _storage.read<Map<String, dynamic>>(_userProfileKey);
      if (profileData != null) {
        _currentProfile.value = UserProfile.fromJson(profileData);
        LogService.info('User profile loaded from storage');
      }

      // Load user addresses
      final addressesData = _storage.read<List<dynamic>>(_userAddressesKey);
      if (addressesData != null) {
        final addresses = addressesData
            .map((data) => UserAddress.fromJson(data as Map<String, dynamic>))
            .toList();
        _userAddresses.assignAll(addresses);
        LogService.info('Loaded ${addresses.length} addresses from storage');
      }

      // Load default address ID
      final defaultId = _storage.read<String>(_defaultAddressIdKey);
      if (defaultId != null) {
        _defaultAddressId.value = defaultId;
      }
    } catch (e) {
      LogService.error('Error loading stored user data: $e');
    }
  }

  // ============================================================================
  // USER PROFILE STORAGE
  // ============================================================================

  /// Save user profile to storage
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      LogService.info('Saving user profile to storage');

      await _storage.write(_userProfileKey, profile.toJson());
      _currentProfile.value = profile;

      LogService.info('User profile saved successfully');
    } catch (e) {
      LogService.error('Error saving user profile: $e');
      throw Exception('Failed to save user profile');
    }
  }

  /// Update specific profile fields
  Future<void> updateProfileField(String field, dynamic value) async {
    try {
      final currentProfile = _currentProfile.value;
      if (currentProfile == null) return;

      LogService.info('Updating profile field: $field');

      UserProfile updatedProfile;
      switch (field) {
        case 'name':
          updatedProfile = currentProfile.copyWith(name: value as String?);
          break;
        case 'email':
          updatedProfile = currentProfile.copyWith(email: value as String?);
          break;
        case 'profilePictureUrl':
          updatedProfile = currentProfile.copyWith(
            profilePictureUrl: value as String?,
          );
          break;
        default:
          LogService.warning('Unknown profile field: $field');
          return;
      }

      await saveUserProfile(updatedProfile);
    } catch (e) {
      LogService.error('Error updating profile field: $e');
    }
  }

  /// Clear stored user profile
  Future<void> clearUserProfile() async {
    try {
      await _storage.remove(_userProfileKey);
      _currentProfile.value = null;
      LogService.info('User profile cleared from storage');
    } catch (e) {
      LogService.error('Error clearing user profile: $e');
    }
  }

  /// Get user display name
  String getUserDisplayName() {
    final profile = currentProfile;
    if (profile?.name != null && profile!.name!.isNotEmpty) {
      return profile.name!;
    }
    return profile?.phoneNumber ?? 'User';
  }

  /// Get user initials for avatar
  String getUserInitials() {
    final name = getUserDisplayName();
    if (name == 'User') return 'U';

    final words = name.split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'
          .toUpperCase();
    }
  }

  // ============================================================================
  // ADDRESS STORAGE
  // ============================================================================

  /// Save all user addresses to storage
  Future<void> saveUserAddresses(List<UserAddress> addresses) async {
    try {
      LogService.info('Saving ${addresses.length} addresses to storage');

      final addressesData = addresses
          .map((address) => address.toJson())
          .toList();
      await _storage.write(_userAddressesKey, addressesData);
      _userAddresses.assignAll(addresses);

      LogService.info('User addresses saved successfully');
    } catch (e) {
      LogService.error('Error saving user addresses: $e');
      throw Exception('Failed to save user addresses');
    }
  }

  /// Add single address to storage
  Future<void> addAddress(UserAddress address) async {
    try {
      LogService.info('Adding address to storage');

      final currentAddresses = List<UserAddress>.from(_userAddresses);
      currentAddresses.add(address);

      await saveUserAddresses(currentAddresses);
    } catch (e) {
      LogService.error('Error adding address: $e');
    }
  }

  /// Update existing address in storage
  Future<void> updateAddress(UserAddress updatedAddress) async {
    try {
      LogService.info('Updating address in storage: ${updatedAddress.id}');

      final currentAddresses = List<UserAddress>.from(_userAddresses);
      final index = currentAddresses.indexWhere(
        (addr) => addr.id == updatedAddress.id,
      );

      if (index != -1) {
        currentAddresses[index] = updatedAddress;
        await saveUserAddresses(currentAddresses);
      } else {
        LogService.warning(
          'Address not found for update: ${updatedAddress.id}',
        );
      }
    } catch (e) {
      LogService.error('Error updating address: $e');
    }
  }

  /// Remove address from storage
  Future<void> removeAddress(String addressId) async {
    try {
      LogService.info('Removing address from storage: $addressId');

      final currentAddresses = List<UserAddress>.from(_userAddresses);
      currentAddresses.removeWhere((addr) => addr.id == addressId);

      // Clear default address if it was the deleted one
      if (_defaultAddressId.value == addressId) {
        await setDefaultAddress('');
      }

      await saveUserAddresses(currentAddresses);
    } catch (e) {
      LogService.error('Error removing address: $e');
    }
  }

  /// Set default address ID
  Future<void> setDefaultAddress(String addressId) async {
    try {
      LogService.info('Setting default address: $addressId');

      await _storage.write(_defaultAddressIdKey, addressId);
      _defaultAddressId.value = addressId;

      LogService.info('Default address set successfully');
    } catch (e) {
      LogService.error('Error setting default address: $e');
    }
  }

  /// Get default address
  UserAddress? getDefaultAddress() {
    if (_defaultAddressId.value.isEmpty) return null;

    try {
      return _userAddresses.firstWhere(
        (address) => address.id == _defaultAddressId.value,
      );
    } catch (e) {
      LogService.warning(
        'Default address not found: ${_defaultAddressId.value}',
      );
      return null;
    }
  }

  /// Get address by ID
  UserAddress? getAddressById(String addressId) {
    try {
      return _userAddresses.firstWhere((address) => address.id == addressId);
    } catch (e) {
      LogService.warning('Address not found: $addressId');
      return null;
    }
  }

  /// Clear all stored user addresses
  Future<void> clearUserAddresses() async {
    try {
      await _storage.remove(_userAddressesKey);
      await _storage.remove(_defaultAddressIdKey);
      _userAddresses.clear();
      _defaultAddressId.value = '';
      LogService.info('User addresses cleared from storage');
    } catch (e) {
      LogService.error('Error clearing user addresses: $e');
    }
  }

  /// Get addresses count
  int getAddressesCount() {
    return _userAddresses.length;
  }

  /// Check if user has any addresses
  bool hasAddresses() {
    return _userAddresses.isNotEmpty;
  }

  /// Get primary address (default or first available)
  UserAddress? getPrimaryAddress() {
    final defaultAddress = getDefaultAddress();
    if (defaultAddress != null) return defaultAddress;

    return _userAddresses.isNotEmpty ? _userAddresses.first : null;
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Clear all user data from storage
  Future<void> clearAllUserData() async {
    try {
      LogService.info('Clearing all user data from storage');

      await clearUserProfile();
      await clearUserAddresses();

      LogService.info('All user data cleared successfully');
    } catch (e) {
      LogService.error('Error clearing user data: $e');
    }
  }
}
