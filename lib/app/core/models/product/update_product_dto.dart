/// DTO for updating an existing product (seller functionality)
class UpdateProductDto {
  final String? name;
  final String? description;
  final double? price;
  final int? stockQuantity;
  final String? categoryId;
  final List<String>? tags;
  final bool? isActive;
  final String? measureUnitCode;
  final double? measureAmount;
  final Map<String, dynamic>? attributes;

  UpdateProductDto({
    this.name,
    this.description,
    this.price,
    this.stockQuantity,
    this.categoryId,
    this.tags,
    this.isActive,
    this.measureUnitCode,
    this.measureAmount,
    this.attributes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (stockQuantity != null) data['stock_quantity'] = stockQuantity;
    if (categoryId != null) data['category_id'] = categoryId;
    if (tags != null) data['tags'] = tags;
    if (isActive != null) data['is_active'] = isActive;
    if (measureUnitCode != null) data['measure_unit_code'] = measureUnitCode;
    if (measureAmount != null) data['measure_amount'] = measureAmount;
    if (attributes != null) data['attributes'] = attributes;
    
    return data;
  }

  /// Check if DTO has any data to update
  bool get hasUpdates => 
    name != null || 
    description != null || 
    price != null || 
    stockQuantity != null || 
    categoryId != null || 
    tags != null || 
    isActive != null ||
    measureUnitCode != null ||
    measureAmount != null ||
    attributes != null;
}