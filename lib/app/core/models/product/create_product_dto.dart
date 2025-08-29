/// DTO for creating a new product (seller functionality)
class CreateProductDto {
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String categoryId;
  final List<String>? tags;
  final String? measureUnitCode;
  final double? measureAmount;
  final Map<String, dynamic>? attributes;

  CreateProductDto({
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    this.tags,
    this.measureUnitCode,
    this.measureAmount,
    this.attributes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'category_id': categoryId,
      'tags': tags,
      'measure_unit_code': measureUnitCode,
      'measure_amount': measureAmount,
      'attributes': attributes,
    };
  }

  /// Validation method
  String? validate() {
    if (name.trim().isEmpty) return 'Product name is required';
    if (description.trim().isEmpty) return 'Product description is required';
    if (price <= 0) return 'Price must be greater than 0';
    if (stockQuantity < 0) return 'Stock quantity cannot be negative';
    if (categoryId.trim().isEmpty) return 'Category is required';
    return null;
  }
}