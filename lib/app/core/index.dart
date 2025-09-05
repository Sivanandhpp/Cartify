// CORE BARREL FILE
// This file exports all the core components of the application.
// Onboarding: Keep non-API related exports separate for clarity.

// =================================================================================================
//                                      CONFIGURATION
// =================================================================================================
// Purpose: Exports related to application setup and environment.
export 'config/app_identity.dart';
export 'config/app_config.dart';
export 'config/app_initservices.dart';  // Added: Service initialization logic

// =================================================================================================
//                                        CONSTANTS
// =================================================================================================
// Purpose: Exports for static values used across the app.
export 'constants/app_strings.dart';
export 'constants/app_images.dart';
export 'constants/app_validators.dart';
export 'constants/app_spacing.dart';  // Consolidated spacing, padding, and border radius

// =================================================================================================
//                                     MODELS & DTOS
// =================================================================================================
// Purpose: Data structures and Data Transfer Objects for API communication.

// Authentication
export 'models/authentication/request_otp_dto.dart';
export 'models/authentication/verify_otp_dto.dart';

// User & Address
export 'models/user/user_model.dart';
export 'models/user/update_user_dto.dart';
export 'models/user/address_model.dart';
export 'models/user/create_address_dto.dart';
export 'models/user/update_address_dto.dart';  // Added: Address update DTO

// Dashboard
export 'models/dashboard/dashboard_model.dart';
export 'models/dashboard/banner_model.dart';

// Onboarding
export 'models/onboarding/onboarding_model.dart';
export 'models/onboarding/onboarding_data.dart';

// Product & Catalog
export 'models/product/product_model.dart';
export 'models/product/category_model.dart';
export 'models/product/create_product_dto.dart';  // Added: Product creation DTO
export 'models/product/update_product_dto.dart';  // Added: Product update DTO
export 'models/product/discount_model.dart';      // Added: Discount model
export 'models/product/tag_model.dart';           // Added: Tag model

// Cart
export 'models/cart/cart_model.dart';
export 'models/cart/add_item_to_cart_dto.dart';
export 'models/cart/update_cart_item_dto.dart';

// Reviews
export 'models/review/review_model.dart';
export 'models/review/create_review_dto.dart';

// Order
export 'models/order/order_model.dart';
export 'models/order/create_order_dto.dart';
export 'models/order/order_item_model.dart';      // Added: Order item model
export 'models/order/update_order_item_dto.dart'; // Added: Order item update DTO

// =================================================================================================
//                                        SERVICES
// =================================================================================================
// Purpose: Business logic, API clients, and other service classes.

// Core API Client
export 'services/api_client.dart';
export 'services/api_clean_url.dart';  // Added: URL cleaning utility for API

// Feature-specific Services
export 'services/authentication/authentication_service.dart';
export 'services/user/user_service.dart';
export 'services/user/user_controller.dart';
export 'services/dashboard/dashboard_service.dart';
export 'services/product/product_service.dart';
export 'services/cart/cart_service.dart';
export 'services/review/review_service.dart';
export 'services/order/order_service.dart';  // Added: Order service

// Foundational Services (Non-API specific)
export 'services/log_service.dart';
export 'services/error_service.dart';
export 'services/notification_service.dart';
export 'services/theme_service.dart';
export 'services/storage_service.dart';

// =================================================================================================
//                                          THEME
// =================================================================================================
// Purpose: Exports for UI styling and appearance.
export 'theme/app_colors.dart';
export 'theme/app_text_styles.dart';
export 'theme/app_theme.dart';

// =================================================================================================
//                                        UTILITIES
// =================================================================================================
// Purpose: Helper functions and utility classes.
export 'utils/app_formatters.dart';
export 'utils/app_regex.dart';
export 'utils/order_status_utils.dart';  // Added: Order status utilities

// =================================================================================================
//                                         WIDGETS
// =================================================================================================
// Purpose: Common and reusable UI components.
export 'widgets/app_button.dart';
export 'widgets/app_image.dart';
export 'widgets/app_dialog.dart';       // Added: Reusable dialog widget
export 'widgets/app_dropdown.dart';     // Added: Reusable dropdown widget
export 'widgets/app_image_picker.dart'; // Added: Image picker widget
export 'widgets/app_textfield.dart';    // Added: Reusable text field widget