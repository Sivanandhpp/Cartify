// // Core imports (absolute)
// import 'package:cartify/app/core/index.dart';
// import 'package:get/get.dart';

// class BuyerWishlistController extends GetxController {
//   // Navigation bar visibility control
//   final isNavBarVisible = true.obs;
//   double _lastScrollOffset = 0.0;

//   // Wishlist items
//   final RxList<Product> wishlistItems = <Product>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadWishlistItems();
//   }

//   // Load wishlist items - in production this would come from API
//   void _loadWishlistItems() {
//     wishlistItems.value = [
//       Product(
//         id: 'wish_1',
//         name: 'Premium Whiskey',
//         brand: 'Highland Reserve',
//         category: 'Spirits',
//         subCategory: 'Whiskey',
//         volume: '750ml',
//         alcoholContentABV: 40.0,
//         priceINR: 4999.0,
//         offerPercentage: 20,
//         offerPrice: 3999.0,
//         rating: 4.5,
//         reviewCount: 150,
//         description: 'Premium aged whiskey with rich flavor profile',
//         imageUrl: AppImages.product1,
//       ),
//       Product(
//         id: 'wish_2',
//         name: 'Craft Beer Pack',
//         brand: 'BrewMaster',
//         category: 'Beer',
//         subCategory: 'Craft Beer',
//         volume: '330ml x 6',
//         alcoholContentABV: 5.2,
//         priceINR: 899.0,
//         offerPercentage: 15,
//         offerPrice: 764.0,
//         rating: 4.7,
//         reviewCount: 320,
//         description: 'Premium craft beer variety pack with unique flavors',
//         imageUrl: AppImages.product2,
//       ),
//     ];
//   }

//   // Method to handle scroll changes for nav bar visibility
//   void handleScrollUpdate(double offset) {
//     const double threshold =
//         50.0; // Minimum scroll distance to trigger hide/show

//     if (offset > _lastScrollOffset + threshold) {
//       // Scrolling down - hide nav bar
//       if (isNavBarVisible.value) {
//         isNavBarVisible.value = false;
//       }
//     } else if (offset < _lastScrollOffset - threshold) {
//       // Scrolling up - show nav bar
//       if (!isNavBarVisible.value) {
//         isNavBarVisible.value = true;
//       }
//     }

//     _lastScrollOffset = offset;
//   }

//   // Method to add/remove item from wishlist
//   void toggleWishlist(Product product) {
//     final existingIndex = wishlistItems.indexWhere(
//       (item) => item.id == product.id,
//     );
//     if (existingIndex != -1) {
//       wishlistItems.removeAt(existingIndex);
//       NotificationService.showInfo(
//         title: 'Removed from Wishlist',
//         message: '${product.name} removed from your wishlist',
//       );
//     } else {
//       wishlistItems.add(product);
//       NotificationService.showSuccess(
//         title: 'Added to Wishlist',
//         message: '${product.name} added to your wishlist',
//       );
//     }
//   }

//   // Check if product is in wishlist
//   bool isInWishlist(String productId) {
//     return wishlistItems.any((item) => item.id == productId);
//   }

//   // Clear all wishlist items
//   void clearAllWishlist() {
//     wishlistItems.clear();
//     NotificationService.showInfo(
//       title: 'Wishlist Cleared',
//       message: 'All items removed from your wishlist',
//     );
//   }

//   // Add to cart from wishlist
//   void addToCartFromWishlist(Product product) {
//     final cartService = Get.find<CartService>();
//     cartService.addToCart(product);
//     LogService.info('Added ${product.name} to cart from wishlist');
//   }

//   // Navigate to home for shopping
//   void onNavItemTapped(int index) {
//     // This will be handled by parent dashboard controller
//     LogService.info('Navigate to tab: $index');
//   }
// }
