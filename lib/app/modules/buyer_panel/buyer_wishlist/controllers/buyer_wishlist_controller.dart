// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class BuyerWishlistController extends GetxController {
  // Services
  final CartService _cartService = Get.find<CartService>();

  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Loading state
  final RxBool isLoading = false.obs;

  // Wishlist items - For now using local storage, in production would use proper wishlist service
  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadWishlistItems();
  }

  // Load wishlist items - in production this would come from API
  void _loadWishlistItems() {
    // For demo purposes, creating sample ProductModel items
    // In production, this would fetch from wishlist API
    wishlistItems.value = [
      ProductModel(
        id: 'wish_1',
        name: 'Premium Whiskey',
        description: 'Premium aged whiskey with rich flavor profile',
        price: 4999.0,
        stock: 50,
        imageUrls: [AppImages.product1],
      ),
      ProductModel(
        id: 'wish_2',
        name: 'Craft Beer Pack',
        description: 'Premium craft beer collection pack',
        price: 899.0,
        stock: 100,
        imageUrls: [AppImages.product2],
      ),
      ProductModel(
        id: 'wish_3',
        name: 'Red Wine Collection',
        description: 'Finest red wine from premium vineyards',
        price: 2499.0,
        stock: 75,
        imageUrls: [AppImages.product3],
      ),
    ];
  }

  // Method to handle scroll changes for nav bar visibility
  void handleScrollUpdate(double offset) {
    const double threshold =
        50.0; // Minimum scroll distance to trigger hide/show

    if (offset > _lastScrollOffset + threshold) {
      // Scrolling down - hide nav bar
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    } else if (offset < _lastScrollOffset - threshold) {
      // Scrolling up - show nav bar
      if (!isNavBarVisible.value) {
        isNavBarVisible.value = true;
      }
    }

    _lastScrollOffset = offset;
  }

  // Toggle wishlist status
  void toggleWishlist(ProductModel product) {
    if (wishlistItems.any((item) => item.id == product.id)) {
      // Remove from wishlist
      wishlistItems.removeWhere((item) => item.id == product.id);
      LogService.info('Removed ${product.name} from wishlist');
      NotificationService.showSuccess(
        title: 'Removed from Wishlist',
        message: '${product.name} has been removed from your wishlist',
      );
    } else {
      // Add to wishlist
      wishlistItems.add(product);
      LogService.info('Added ${product.name} to wishlist');
      NotificationService.showSuccess(
        title: 'Added to Wishlist',
        message: '${product.name} has been added to your wishlist',
      );
    }
  }

  // Check if product is in wishlist by ProductModel
  bool isInWishlist(ProductModel product) {
    return wishlistItems.any((item) => item.id == product.id);
  }

  // Check if product is in wishlist by ID
  bool isInWishlistById(String productId) {
    return wishlistItems.any((item) => item.id == productId);
  }

  // Remove from wishlist
  void removeFromWishlist(ProductModel product) {
    wishlistItems.removeWhere((item) => item.id == product.id);
    LogService.info('Removed ${product.name} from wishlist');
    NotificationService.showSuccess(
      title: 'Removed from Wishlist',
      message: '${product.name} has been removed from your wishlist',
    );
  }

  // Add to cart from wishlist
  Future<void> addToCartFromWishlist(ProductModel product) async {
    try {
      // Create AddItemToCartDto
      final addItemDto = AddItemToCartDto(productId: product.id, quantity: 1);

      await _cartService.addItemToCart(addItemDto);

      LogService.info('Added ${product.name} to cart from wishlist');
      NotificationService.showSuccess(
        title: 'Added to Cart',
        message: '${product.name} has been added to your cart',
      );
    } catch (e) {
      LogService.error('Failed to add ${product.name} to cart: $e');
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to add item to cart',
      );
    }
  }

  // Clear all wishlist items
  void clearAllWishlist() {
    wishlistItems.clear();
    NotificationService.showInfo(
      title: 'Wishlist Cleared',
      message: 'All items removed from your wishlist',
    );
  }

  // Navigate to home for shopping
  void onNavItemTapped(int index) {
    // This will be handled by parent dashboard controller
    LogService.info('Navigate to tab: $index');
  }
}
