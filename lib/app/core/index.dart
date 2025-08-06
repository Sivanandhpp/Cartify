// CORE BARREL FILE
// This file exports all the core components of the application.
// Onboarding: Keep non-API related exports separate for clarity.

// =================================================================================================
//                                      CONFIGURATION
// =================================================================================================
// Purpose: Exports related to application setup and environment.
export 'config/app_identity.dart';
export 'config/app_config.dart';
export 'config/app_environment.dart';
export 'config/api_endpoints.dart';

// =================================================================================================
//                                        CONSTANTS
// =================================================================================================
// Purpose: Exports for static values used across the app.
export 'constants/app_strings.dart';
export 'constants/app_images.dart';
export 'constants/app_validators.dart';
export 'constants/app_spacing.dart'; // Consolidated spacing, padding, and border radius

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

// Dashboard
export 'models/dashboard/dashboard_model.dart';

// Product & Catalog
// export 'models/product/product_model.dart';
// export 'models/product/category_model.dart';

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

// =================================================================================================
//                                        SERVICES
// =================================================================================================
// Purpose: Business logic, API clients, and other service classes.

// Core API Client
export 'services/api_client.dart';

// Feature-specific Services
export 'services/authentication/authentication_service.dart';
export 'services/user/user_service.dart';
export 'services/dashboard/dashboard_service.dart';
export 'services/product/product_service.dart';
export 'services/cart/cart_service.dart';
export 'services/review/review_service.dart';
export 'services/order/order_service.dart';

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

// =================================================================================================
//                                         WIDGETS
// =================================================================================================
// Purpose: Common and reusable UI components.
export 'widgets/app_buttons.dart';
