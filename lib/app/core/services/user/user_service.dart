/// High-level user service with intelligent caching and state management
///
/// This service provides a simple, easy-to-use interface for all user operations,
/// including profile management, address operations, and smart caching to improve
/// performance and reduce API calls.

import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user/user_models.dart';
import '../auth/auth_service.dart';
import '../log_service.dart';
import 'user_api_client.dart';

/// User service managing profile, addresses, and caching
///
/// Provides high-level functions for user operations with automatic
/// caching, state management, and error handling. All operations
/// ensure proper authentication and handle token refresh automatically.
class UserService extends GetxService {
  static const String _logTag = 'UserService';
  static const String _storagePrefix = 'user_service_';
  static const Duration _cacheExpiry = Duration(minutes: 15);

  // Storage keys
  static const String _profileKey = '${_storagePrefix}profile';
  static const String _addressesKey = '${_storagePrefix}addresses';
  static const String _profileCacheTimeKey =
      '${_storagePrefix}profile_cache_time';
  static const String _addressesCacheTimeKey =
      '${_storagePrefix}addresses_cache_time';

  // Dependencies
  final GetStorage _storage = GetStorage();
  late final AuthService _authService;

  // Reactive state
  final Rx<UserProfile?> _currentProfile = Rx<UserProfile?>(null);
  final RxList<Address> _addresses = <Address>[].obs;
  final RxBool _isLoadingProfile = false.obs;
  final RxBool _isLoadingAddresses = false.obs;

  // Getters for reactive state
  UserProfile? get currentProfile => _currentProfile.value;
  List<Address> get addresses => _addresses.toList();
  bool get isLoadingProfile => _isLoadingProfile.value;
  bool get isLoadingAddresses => _isLoadingAddresses.value;

  // Reactive getters
  Rx<UserProfile?> get currentProfileRx => _currentProfile;
  RxList<Address> get addressesRx => _addresses;
  RxBool get isLoadingProfileRx => _isLoadingProfile;
  RxBool get isLoadingAddressesRx => _isLoadingAddresses;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _loadCachedData();

    // Listen to auth state changes
    _authService.authStateStream.listen((authState) {
      if (!authState.isAuthenticated) {
        _clearUserData();
      }
    });

    LogService.info('$_logTag: Service initialized');
  }

  /// Load cached user data from storage
  ///
  /// Attempts to load previously cached profile and addresses data
  /// from local storage if they haven't expired.
  void _loadCachedData() {
    try {
      // Load cached profile
      final profileData = _storage.read(_profileKey);
      final profileCacheTime = _storage.read(_profileCacheTimeKey);

      if (profileData != null && profileCacheTime != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(
          profileCacheTime as int,
        );
        if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
          _currentProfile.value = UserProfile.fromJson(
            profileData as Map<String, dynamic>,
          );
          LogService.debug('$_logTag: Loaded cached profile');
        }
      }

      // Load cached addresses
      final addressesData = _storage.read(_addressesKey);
      final addressesCacheTime = _storage.read(_addressesCacheTimeKey);

      if (addressesData != null && addressesCacheTime != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(
          addressesCacheTime as int,
        );
        if (DateTime.now().difference(cacheTime) < _cacheExpiry) {
          final addressList = (addressesData as List<dynamic>)
              .map((item) => Address.fromJson(item as Map<String, dynamic>))
              .toList();
          _addresses.assignAll(addressList);
          LogService.debug(
            '$_logTag: Loaded cached addresses - Count: ${_addresses.length}',
          );
        }
      }
    } catch (e) {
      LogService.warning('$_logTag: Failed to load cached data: $e');
      _clearCachedData();
    }
  }

  /// Clear all user data from memory and storage
  void _clearUserData() {
    _currentProfile.value = null;
    _addresses.clear();
    _clearCachedData();
    LogService.info('$_logTag: User data cleared');
  }

  /// Clear cached data from storage
  void _clearCachedData() {
    _storage.remove(_profileKey);
    _storage.remove(_addressesKey);
    _storage.remove(_profileCacheTimeKey);
    _storage.remove(_addressesCacheTimeKey);
    LogService.debug('$_logTag: Cached data cleared');
  }

  /// Cache profile data to storage
  ///
  /// Stores the profile data with a timestamp for cache expiry management.
  ///
  /// [profile] - Profile data to cache
  void _cacheProfile(UserProfile profile) {
    try {
      _storage.write(_profileKey, profile.toJson());
      _storage.write(
        _profileCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      LogService.debug('$_logTag: Profile cached');
    } catch (e) {
      LogService.warning('$_logTag: Failed to cache profile: $e');
    }
  }

  /// Cache addresses data to storage
  ///
  /// Stores the addresses list with a timestamp for cache expiry management.
  ///
  /// [addresses] - Addresses list to cache
  void _cacheAddresses(List<Address> addresses) {
    try {
      final addressesJson = addresses
          .map((address) => address.toJson())
          .toList();
      _storage.write(_addressesKey, addressesJson);
      _storage.write(
        _addressesCacheTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      LogService.debug(
        '$_logTag: Addresses cached - Count: ${addresses.length}',
      );
    } catch (e) {
      LogService.warning('$_logTag: Failed to cache addresses: $e');
    }
  }

  /// Get user profile with smart caching
  ///
  /// Retrieves the user's profile information. Uses cached data if available
  /// and not expired, otherwise fetches fresh data from the API.
  ///
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: [UserProfile] or null if not available
  /// Throws: [UserApiException] on API failure
  Future<UserProfile?> getProfile({bool forceRefresh = false}) async {
    try {
      LogService.info(
        '$_logTag: Getting user profile (forceRefresh: $forceRefresh)',
      );

      // Return cached data if available and not forcing refresh
      if (!forceRefresh && _currentProfile.value != null) {
        LogService.debug('$_logTag: Returning cached profile');
        return _currentProfile.value;
      }

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning('$_logTag: Cannot get profile - not authenticated');
        return null;
      }

      _isLoadingProfile.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot get profile - no valid access token',
        );
        return null;
      }

      // Fetch profile from API
      final profile = await UserApiClient.getUserProfile(accessToken);

      // Update state and cache
      _currentProfile.value = profile;
      _cacheProfile(profile);

      LogService.info('$_logTag: Profile fetched successfully');
      return profile;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error getting profile: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error getting profile: $e');
      rethrow;
    } finally {
      _isLoadingProfile.value = false;
    }
  }

  /// Update user profile
  ///
  /// Updates the user's profile with the provided information.
  /// Automatically updates the cached profile data.
  ///
  /// [name] - Updated display name (optional)
  /// [email] - Updated email address (optional)
  /// Returns: Updated [UserProfile] or null if failed
  /// Throws: [UserApiException] on API failure
  Future<UserProfile?> updateProfile({String? name, String? email}) async {
    try {
      LogService.info('$_logTag: Updating user profile');

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning(
          '$_logTag: Cannot update profile - not authenticated',
        );
        return null;
      }

      // Create update DTO
      final updateDto = UpdateUserProfileDto(name: name, email: email);

      // Validate that we have updates
      if (!updateDto.hasUpdates) {
        LogService.warning('$_logTag: No updates provided for profile');
        return _currentProfile.value;
      }

      _isLoadingProfile.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot update profile - no valid access token',
        );
        return null;
      }

      // Update profile via API
      final updatedProfile = await UserApiClient.updateUserProfile(
        accessToken,
        updateDto,
      );

      // Update state and cache
      _currentProfile.value = updatedProfile;
      _cacheProfile(updatedProfile);

      LogService.info('$_logTag: Profile updated successfully');
      return updatedProfile;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error updating profile: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error updating profile: $e');
      rethrow;
    } finally {
      _isLoadingProfile.value = false;
    }
  }

  /// Upload profile picture
  ///
  /// Uploads a new profile picture for the user. Supports various image formats
  /// with automatic size validation and compression.
  ///
  /// [imageFile] - Image file to upload
  /// Returns: Updated [UserProfile] with new picture URL or null if failed
  /// Throws: [UserApiException] on API failure
  Future<UserProfile?> uploadProfilePicture(File imageFile) async {
    try {
      LogService.info('$_logTag: Uploading profile picture');

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning(
          '$_logTag: Cannot upload profile picture - not authenticated',
        );
        return null;
      }

      _isLoadingProfile.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot upload profile picture - no valid access token',
        );
        return null;
      }

      // Upload via API
      final updatedProfile = await UserApiClient.uploadProfilePicture(
        accessToken,
        imageFile,
      );

      // Update state and cache
      _currentProfile.value = updatedProfile;
      _cacheProfile(updatedProfile);

      LogService.info('$_logTag: Profile picture uploaded successfully');
      return updatedProfile;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error uploading profile picture: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error(
        '$_logTag: Unexpected error uploading profile picture: $e',
      );
      rethrow;
    } finally {
      _isLoadingProfile.value = false;
    }
  }

  /// Get all user addresses with smart caching
  ///
  /// Retrieves all addresses for the authenticated user. Uses cached data
  /// if available and not expired, otherwise fetches fresh data from the API.
  ///
  /// [forceRefresh] - Skip cache and fetch fresh data
  /// Returns: List of [Address] objects
  /// Throws: [UserApiException] on API failure
  Future<List<Address>> getAddresses({bool forceRefresh = false}) async {
    try {
      LogService.info(
        '$_logTag: Getting user addresses (forceRefresh: $forceRefresh)',
      );

      // Return cached data if available and not forcing refresh
      if (!forceRefresh && _addresses.isNotEmpty) {
        LogService.debug(
          '$_logTag: Returning cached addresses - Count: ${_addresses.length}',
        );
        return _addresses.toList();
      }

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning(
          '$_logTag: Cannot get addresses - not authenticated',
        );
        return [];
      }

      _isLoadingAddresses.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot get addresses - no valid access token',
        );
        return [];
      }

      // Fetch addresses from API
      final addresses = await UserApiClient.getAllAddresses(accessToken);

      // Update state and cache
      _addresses.assignAll(addresses);
      _cacheAddresses(addresses);

      LogService.info(
        '$_logTag: Addresses fetched successfully - Count: ${addresses.length}',
      );
      return addresses;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error getting addresses: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error getting addresses: $e');
      rethrow;
    } finally {
      _isLoadingAddresses.value = false;
    }
  }

  /// Add new address
  ///
  /// Creates a new address for the authenticated user and updates the local cache.
  ///
  /// [label] - Address label/name
  /// [recipientName] - Full name of the recipient
  /// [phoneNumber] - Contact phone number for delivery
  /// [addressLine1] - Street address line 1
  /// [addressLine2] - Street address line 2 (optional)
  /// [city] - City name
  /// [state] - State name
  /// [country] - Country name
  /// [postalCode] - Postal/ZIP code
  /// [isDefault] - Whether this should be the default address
  /// Returns: Created [Address] or null if failed
  /// Throws: [UserApiException] on API failure
  Future<Address?> addAddress({
    required String label,
    required String recipientName,
    required String phoneNumber,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    bool isDefault = false,
  }) async {
    try {
      LogService.info('$_logTag: Adding new address: $label');

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning('$_logTag: Cannot add address - not authenticated');
        return null;
      }

      // Create address DTO
      final createDto = CreateAddressDto(
        label: label,
        recipientName: recipientName,
        phoneNumber: phoneNumber,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country,
        isDefault: isDefault,
      );

      _isLoadingAddresses.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot add address - no valid access token',
        );
        return null;
      }

      // Add address via API
      final newAddress = await UserApiClient.addAddress(accessToken, createDto);

      // Update local state
      _addresses.add(newAddress);

      // If this is set as default, update other addresses
      if (newAddress.isDefault) {
        for (int i = 0; i < _addresses.length - 1; i++) {
          if (_addresses[i].isDefault) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }

      // Update cache
      _cacheAddresses(_addresses.toList());

      LogService.info('$_logTag: Address added successfully: ${newAddress.id}');
      return newAddress;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error adding address: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error adding address: $e');
      rethrow;
    } finally {
      _isLoadingAddresses.value = false;
    }
  }

  /// Update existing address
  ///
  /// Updates an existing address with new information and refreshes the local cache.
  ///
  /// [addressId] - ID of the address to update
  /// [label] - Updated address label/name (optional)
  /// [recipientName] - Updated recipient name (optional)
  /// [phoneNumber] - Updated phone number (optional)
  /// [addressLine1] - Updated street address line 1 (optional)
  /// [addressLine2] - Updated street address line 2 (optional)
  /// [city] - Updated city name (optional)
  /// [state] - Updated state name (optional)
  /// [country] - Updated country name (optional)
  /// [postalCode] - Updated postal/ZIP code (optional)
  /// [isDefault] - Updated default status (optional)
  /// Returns: Updated [Address] or null if failed
  /// Throws: [UserApiException] on API failure
  Future<Address?> updateAddress({
    required String addressId,
    String? label,
    String? recipientName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    bool? isDefault,
  }) async {
    try {
      LogService.info('$_logTag: Updating address: $addressId');

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning(
          '$_logTag: Cannot update address - not authenticated',
        );
        return null;
      }

      // Create update DTO
      final updateDto = UpdateAddressDto(
        label: label,
        recipientName: recipientName,
        phoneNumber: phoneNumber,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country,
        isDefault: isDefault,
      );

      // Validate that we have updates
      if (!updateDto.hasUpdates) {
        LogService.warning('$_logTag: No updates provided for address');
        return _addresses.firstWhereOrNull((addr) => addr.id == addressId);
      }

      _isLoadingAddresses.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot update address - no valid access token',
        );
        return null;
      }

      // Update address via API
      final updatedAddress = await UserApiClient.updateAddress(
        accessToken,
        addressId,
        updateDto,
      );

      // Find and update the address in local state
      final index = _addresses.indexWhere((addr) => addr.id == addressId);
      if (index != -1) {
        _addresses[index] = updatedAddress;

        // If this is set as default, update other addresses
        if (updatedAddress.isDefault) {
          for (int i = 0; i < _addresses.length; i++) {
            if (i != index && _addresses[i].isDefault) {
              _addresses[i] = _addresses[i].copyWith(isDefault: false);
            }
          }
        }

        // Update cache
        _cacheAddresses(_addresses.toList());
      }

      LogService.info('$_logTag: Address updated successfully: $addressId');
      return updatedAddress;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error updating address: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error updating address: $e');
      rethrow;
    } finally {
      _isLoadingAddresses.value = false;
    }
  }

  /// Delete address
  ///
  /// Removes an address from the user's account and updates the local cache.
  ///
  /// [addressId] - ID of the address to delete
  /// Returns: true if successful, false otherwise
  /// Throws: [UserApiException] on API failure
  Future<bool> deleteAddress(String addressId) async {
    try {
      LogService.info('$_logTag: Deleting address: $addressId');

      // Check authentication
      if (!_authService.isAuthenticated) {
        LogService.warning(
          '$_logTag: Cannot delete address - not authenticated',
        );
        return false;
      }

      _isLoadingAddresses.value = true;

      // Get access token
      final accessToken = await _authService.getValidAccessToken();
      if (accessToken == null) {
        LogService.warning(
          '$_logTag: Cannot delete address - no valid access token',
        );
        return false;
      }

      // Delete address via API
      final success = await UserApiClient.deleteAddress(accessToken, addressId);

      if (success) {
        // Remove from local state
        _addresses.removeWhere((addr) => addr.id == addressId);

        // Update cache
        _cacheAddresses(_addresses.toList());

        LogService.info('$_logTag: Address deleted successfully: $addressId');
      }

      return success;
    } on UserApiException catch (e) {
      LogService.error('$_logTag: API error deleting address: $e');

      // Handle auth errors by triggering refresh
      if (UserApiClient.isAuthorizationError(e)) {
        await _authService.refreshTokens();
      }

      rethrow;
    } catch (e) {
      LogService.error('$_logTag: Unexpected error deleting address: $e');
      rethrow;
    } finally {
      _isLoadingAddresses.value = false;
    }
  }

  /// Get default address
  ///
  /// Returns the user's default address from the cached list.
  ///
  /// Returns: Default [Address] or null if none set
  Address? getDefaultAddress() {
    return _addresses.firstWhereOrNull((address) => address.isDefault);
  }

  /// Set address as default
  ///
  /// Marks the specified address as the default and updates others accordingly.
  ///
  /// [addressId] - ID of the address to set as default
  /// Returns: Updated [Address] or null if failed
  Future<Address?> setDefaultAddress(String addressId) async {
    return updateAddress(addressId: addressId, isDefault: true);
  }

  /// Check if user has complete profile
  ///
  /// Determines if the user has filled in all required profile information.
  ///
  /// Returns: true if profile is complete
  bool hasCompleteProfile() {
    final profile = _currentProfile.value;
    if (profile == null) return false;

    return profile.name?.isNotEmpty == true &&
        profile.email?.isNotEmpty == true &&
        profile.phoneNumber.isNotEmpty;
  }

  /// Get user's display name
  ///
  /// Returns a user-friendly display name based on available profile information.
  ///
  /// Returns: Display name or fallback string
  String getDisplayName() {
    final profile = _currentProfile.value;
    if (profile == null) return 'User';

    if (profile.name?.isNotEmpty == true) {
      return profile.name!;
    } else if (profile.email?.isNotEmpty == true) {
      return profile.email!.split('@').first;
    } else {
      return 'User';
    }
  }

  /// Refresh all user data
  ///
  /// Forces a complete refresh of all user data from the API,
  /// bypassing any cached information.
  ///
  /// Returns: true if successful
  Future<bool> refreshAllData() async {
    try {
      LogService.info('$_logTag: Refreshing all user data');

      if (!_authService.isAuthenticated) {
        LogService.warning('$_logTag: Cannot refresh data - not authenticated');
        return false;
      }

      // Clear cached data first
      _clearCachedData();

      // Fetch fresh data
      await Future.wait([
        getProfile(forceRefresh: true),
        getAddresses(forceRefresh: true),
      ]);

      LogService.info('$_logTag: All user data refreshed successfully');
      return true;
    } catch (e) {
      LogService.error('$_logTag: Error refreshing user data: $e');
      return false;
    }
  }

  /// Clear all user data and cache
  ///
  /// Completely clears all user data from memory and storage.
  /// Used during logout or when switching users.
  void clearAllData() {
    LogService.info('$_logTag: Clearing all user data');
    _clearUserData();
  }
}
