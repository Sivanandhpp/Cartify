# Hot Deals Grid Implementation

This implementation provides a dynamic, configurable grid layout for the hot deals section using the products.json data structure.

## Features

### 🏗️ Dynamic Grid Layout
- Configurable rows and columns (default: 2 rows × 6 columns)
- Grid dimensions can be changed programmatically
- Automatic height calculation based on grid size
- Responsive design support

### 📱 Product Display
- Displays 12 products from the JSON data
- Smart image assignment using asset fallbacks
- Product badges and fast delivery indicators
- Discount percentage and pricing display
- Star ratings and review counts

### 🛒 Cart Integration
- Add/remove products from cart
- Quantity selector with increment/decrement
- Seamless integration with existing CartService

### 🔄 Data Management
- Structured models for type safety
- Service-based architecture
- Mock data with real JSON structure
- Error handling and loading states

## Architecture

### Models
- **`HotDealsModel`**: Represents the hot deals section structure
- **`HotDealProduct`**: Individual product model matching JSON structure
- **`Product`**: Existing product model for cart operations

### Services
- **`ProductsService`**: Manages products data and grid configuration
- Reactive state management with GetX
- Configurable grid dimensions
- Mock data loading (ready for API integration)

### Components
- **`HotDealsSection`**: Main grid container widget
- **`ProductCard`**: Individual product display widget
- Responsive grid layout with GridView.builder

## Configuration

### Default Configuration
```dart
Rows: 2
Columns: 6
Total Items: 12
```

### Dynamic Configuration
```dart
final ProductsService productsService = Get.find<ProductsService>();

// Configure to 3x4 layout
productsService.configureGrid(rows: 3, columns: 4);

// Configure to 1x12 layout (horizontal scroll effect)
productsService.configureGrid(rows: 1, columns: 12);
```

### Responsive Configuration
```dart
// Configure based on screen size
void configureForScreenSize(double screenWidth) {
  final ProductsService productsService = Get.find<ProductsService>();
  
  if (screenWidth > 800) {
    productsService.configureGrid(rows: 2, columns: 6);
  } else if (screenWidth > 600) {
    productsService.configureGrid(rows: 3, columns: 4);
  } else {
    productsService.configureGrid(rows: 6, columns: 2);
  }
}
```

## Data Structure

The implementation uses the exact structure from the provided products.json:

```json
{
  "hot_deals": {
    "title": "🌿 Today's Fresh Vegetable Deals",
    "description": "Handpicked from local farms! Get the freshest vegetables at the best prices.",
    "products": [
      {
        "id": "prod_veg_001",
        "name": "Fresh Onion",
        "brand": "Local Farm",
        "price": 45.00,
        "discountPrice": 32.00,
        "discountPercentage": 29,
        "unit": "kg",
        "rating": 4.6,
        "reviewCount": 1850,
        "imageUrl": "https://api.example.com/products/fresh_onion.jpg",
        "badge": "Daily Essential",
        "inStock": true,
        "fastDelivery": true
      }
    ]
  }
}
```

## Usage Examples

### Basic Usage
```dart
// The HotDealsSection automatically displays in 2x6 grid format
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Other sections...
        HotDealsSection(),
        // Other sections...
      ],
    );
  }
}
```

### Dynamic Configuration
```dart
class ProductsController extends GetxController {
  final ProductsService _productsService = Get.find<ProductsService>();
  
  void changeToCompactLayout() {
    _productsService.configureGrid(rows: 3, columns: 4);
  }
  
  void changeToWideLayout() {
    _productsService.configureGrid(rows: 1, columns: 12);
  }
}
```

### Reactive Updates
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductsService productsService = Get.find<ProductsService>();
    
    return Obx(() => Text(
      'Showing ${productsService.hotDealsProducts.length} products '
      'in ${productsService.gridRows}x${productsService.gridColumns} grid'
    ));
  }
}
```

## Files Created/Modified

### New Files
- `lib/app/core/models/hot_deals_model.dart` - Data models
- `lib/app/core/services/products_service.dart` - Service layer
- `lib/app/examples/hot_deals_grid_config_example.dart` - Usage examples

### Modified Files
- `lib/app/core/index.dart` - Added exports for new models/services
- `lib/main.dart` - Added ProductsService initialization
- `lib/app/modules/user_dashboard/views/home/widgets/hot_deals_section.dart` - Complete rewrite with grid layout

## Future Enhancements

### HTTP Integration
When ready to connect to the actual API:

1. Add `http` dependency to `pubspec.yaml`
2. Update `ProductsService.fetchHotDeals()` to make actual HTTP calls
3. Handle network errors and caching

### Image Loading
- Replace asset fallbacks with proper network image loading
- Add image caching and placeholder states
- Optimize for different screen densities

### Performance Optimizations
- Implement pagination for large product lists
- Add lazy loading for images
- Optimize grid rendering performance

## Debug Features

In debug mode, the hot deals section includes controls to dynamically adjust the grid layout:
- Row increment/decrement buttons
- Column increment/decrement buttons
- Real-time grid updates

These controls are automatically hidden in production builds.

## Grid Layout Examples

| Configuration | Layout | Use Case |
|---------------|--------|----------|
| 2×6 | 2 rows, 6 columns | Default desktop layout |
| 3×4 | 3 rows, 4 columns | Balanced mobile layout |
| 1×12 | 1 row, 12 columns | Horizontal scroll effect |
| 4×3 | 4 rows, 3 columns | Vertical mobile layout |
| 6×2 | 6 rows, 2 columns | Very narrow screens |

The grid automatically adjusts its height based on the number of rows, ensuring optimal display across different configurations.
