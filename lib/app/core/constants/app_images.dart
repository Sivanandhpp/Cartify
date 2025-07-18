/// Asset paths for images used in the application
///
/// This class provides centralized access to all image assets
/// to prevent typos and make asset management easier.
class AppImages {
  AppImages._();

  // Base path for images
  static const String _imagePath = 'assets/images';

  // Background Images
  static const String loginBackground = '$_imagePath/loginbg.jpg';
  static const String otpBackground = '$_imagePath/otpbg.jpg';
  static const String onboardingFirst = '$_imagePath/onboarding1.jpg';

  // Promotional Content
  static const String promoBanner = '$_imagePath/promobanner.gif';
  static const String saleImage1 = '$_imagePath/sale1.jpg';
  static const String saleImage2 = '$_imagePath/sale2.jpg';
  static const String saleImage3 = '$_imagePath/sale3.jpg';

  // Product Images
  static const String _productPath = '$_imagePath/products';
  static const String offerIcon = '$_productPath/off.png';
  static const String product1 = '$_productPath/product1.png';
  static const String product2 = '$_productPath/product2.png';
  static const String product3 = '$_productPath/product3.png';

  // Placeholder Images
  static const String placeholder = 'https://via.placeholder.com/150';
  static const String userPlaceholder =
      'https://via.placeholder.com/100x100/CCCCCC/333333?text=User';
  static const String productPlaceholder =
      'https://via.placeholder.com/200x200/F5F5F5/999999?text=Product';

  // Category Images (placeholders)
  static const String electronicsCategory =
      'https://via.placeholder.com/150/CCCCCC/333333?text=Electronics';
  static const String homeKitchenCategory =
      'https://via.placeholder.com/150/FFCCCC/333333?text=Home+Kitchen';
  static const String fashionCategory =
      'https://via.placeholder.com/150/CCFFCC/333333?text=Fashion';
  static const String sportsCategory =
      'https://via.placeholder.com/150/CCCCFF/333333?text=Sports';
  static const String booksCategory =
      'https://via.placeholder.com/150/FFFFCC/333333?text=Books';

  // Brand Logos (placeholders)
  static const String boatLogo =
      'https://via.placeholder.com/80x40/000000/FFFFFF?text=boAt';
  static const String appleLogo =
      'https://via.placeholder.com/80x40/000000/FFFFFF?text=Apple';
  static const String samsungLogo =
      'https://via.placeholder.com/80x40/000000/FFFFFF?text=Samsung';

  // Empty State Images
  static const String emptyCart =
      'https://via.placeholder.com/200x200/F5F5F5/999999?text=Empty+Cart';
  static const String emptyWishlist =
      'https://via.placeholder.com/200x200/F5F5F5/999999?text=Empty+Wishlist';
  static const String noOrders =
      'https://via.placeholder.com/200x200/F5F5F5/999999?text=No+Orders';
  static const String noNetwork =
      'https://via.placeholder.com/200x200/F5F5F5/999999?text=No+Network';

  // Icon Images (if using image icons instead of font icons)
  static const String homeIcon = '$_imagePath/icons/home.png';
  static const String cartIcon = '$_imagePath/icons/cart.png';
  static const String profileIcon = '$_imagePath/icons/profile.png';
  static const String searchIcon = '$_imagePath/icons/search.png';
}

