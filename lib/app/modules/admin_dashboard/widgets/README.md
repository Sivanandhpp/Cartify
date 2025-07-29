# Admin Dashboard Reusable Widgets

This directory contains reusable widgets for the admin dashboard that can be used throughout the application with any data model.

## Available Widgets

### 1. `DashboardCard`
A beautiful card widget for displaying statistics and metrics.

**Features:**
- Responsive design
- Loading state support
- Optional tap functionality
- Customizable colors and icons
- Subtitle support

**Usage:**
```dart
DashboardCard(
  title: 'Total Sales',
  value: '1,234',
  icon: Icons.trending_up,
  color: Colors.green,
  subtitle: '+12% this month',
  onTap: () => print('Card tapped'),
  isLoading: false,
)
```

### 2. `StatsCardsWidget`
A responsive grid layout for displaying multiple dashboard cards.

**Features:**
- Responsive column count
- Customizable spacing
- Loading state for all cards
- Flexible grid configuration

**Usage:**
```dart
StatsCardsWidget(
  cards: [
    StatsCardData(
      title: 'Total Sales',
      value: '1,234',
      icon: Icons.trending_up,
      color: Colors.green,
      subtitle: '+12% this month',
      onTap: () => print('Sales tapped'),
    ),
    // ... more cards
  ],
  isLoading: false,
  crossAxisCount: 2,
  childAspectRatio: 1.4,
  spacing: 16,
)
```

### 3. `QuickActionsWidget`
A horizontal row of action buttons for common tasks.

**Features:**
- Responsive spacing
- Loading state support
- Customizable actions
- Icon and color theming

**Usage:**
```dart
QuickActionsWidget(
  title: 'Quick Actions',
  actions: [
    QuickActionData(
      title: 'Add Product',
      icon: Icons.add,
      color: Colors.blue,
      onTap: () => print('Add Product'),
    ),
    // ... more actions
  ],
  isLoading: false,
)
```

### 4. `RecentProductsWidget<T>`
A generic vertical list widget for displaying products or similar items.

**Features:**
- Generic type support
- Loading, error, and empty states
- Retry functionality
- Image support with fallbacks
- Customizable item display
- See all functionality

**Usage:**
```dart
RecentProductsWidget<Product>(
  title: 'Recent Products',
  products: productList,
  isLoading: false,
  hasError: false,
  errorMessage: '',
  getName: (product) => product.name,
  getBrand: (product) => product.brand,
  getCategory: (product) => product.category,
  getPrice: (product) => product.price,
  getStockQuantity: (product) => product.stockQuantity,
  getImageUrl: (product) => product.imageUrl,
  onSeeAllPressed: () => print('See all products'),
  onRetryPressed: () => refreshProducts(),
  onProductTap: (product) => openProduct(product),
  maxItems: 5,
)
```

### 5. `HorizontalProductListWidget<T>`
A generic horizontal scrolling list widget for displaying products.

**Features:**
- Generic type support
- Horizontal scrolling
- Loading, error, and empty states
- Retry functionality
- Card-based layout
- Image support
- Customizable dimensions

**Usage:**
```dart
HorizontalProductListWidget<Product>(
  title: 'Hot Deals',
  products: hotDealsController.products.take(10).toList(),
  isLoading: hotDealsController.isLoading.value,
  hasError: hotDealsController.hasError.value,
  errorMessage: hotDealsController.errorMessage.value,
  getName: (product) => product.name,
  getBrand: (product) => product.brand,
  getCategory: (product) => product.category,
  getPrice: (product) => product.price,
  getStockQuantity: (product) => product.stockQuantity,
  getImageUrl: (product) => product.imageUrl,
  onSeeAllPressed: () {
    LogService.info('See All button pressed in Hot Deals');
  },
  onRetryPressed: () => hotDealsController.refreshHotDeals(),
  onProductTap: (product) => navigateToProduct(product),
  itemWidth: 180,
  itemHeight: 220,
)
```

### 6. `SectionWidget`
A utility widget for consistent section spacing and styling.

**Features:**
- Optional title
- Customizable padding and margin
- Background color and styling options
- Border radius and shadow support

**Usage:**
```dart
SectionWidget(
  title: 'Sales Overview',
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.only(bottom: 24),
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(16),
  child: YourContentWidget(),
)
```

## Data Models

### `StatsCardData`
```dart
class StatsCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;
}
```

### `QuickActionData`
```dart
class QuickActionData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
```

## Best Practices

1. **Use Generic Types**: For product lists, use the generic type parameter to work with your specific data models.

2. **Handle States**: Always provide loading, error, and empty states for better user experience.

3. **Consistent Theming**: Use your app's color scheme and maintain consistent spacing.

4. **Responsive Design**: The widgets are designed to be responsive, but test on different screen sizes.

5. **Error Handling**: Implement retry mechanisms for failed operations.

6. **Performance**: Use `take()` or similar methods to limit the number of items in lists for better performance.

## Import

To use these widgets, import the barrel file:

```dart
import 'package:your_app/modules/admin_dashboard/widgets/widgets.dart';
```

Or import individual widgets:

```dart
import 'package:your_app/modules/admin_dashboard/widgets/dashboard_card.dart';
import 'package:your_app/modules/admin_dashboard/widgets/stats_cards_widget.dart';
// ... etc
```

## Examples

See `examples/widget_usage_example.dart` for complete usage examples and integration patterns.
