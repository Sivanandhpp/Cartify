import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class IOSProductFormWidget extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;
  final VoidCallback? onCancel;

  const IOSProductFormWidget({
    super.key,
    this.product,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<IOSProductFormWidget> createState() => _IOSProductFormWidgetState();
}

class _IOSProductFormWidgetState extends State<IOSProductFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _brandController = TextEditingController();
  final _stockController = TextEditingController();

  String _selectedCategory = 'Electronics';
  String _selectedSubcategory = 'Smartphones';
  bool _isActive = true;
  bool _isFeatured = false;
  List<String> _productImages = [];

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports & Outdoors',
    'Books & Media',
    'Health & Beauty',
    'Automotive',
    'Food & Beverages',
  ];

  final Map<String, List<String>> _subcategories = {
    'Electronics': [
      'Smartphones',
      'Laptops',
      'Tablets',
      'Audio',
      'Gaming',
      'Cameras',
    ],
    'Fashion': [
      'Men\'s Clothing',
      'Women\'s Clothing',
      'Shoes',
      'Accessories',
      'Watches',
    ],
    'Home & Garden': [
      'Furniture',
      'Kitchen',
      'Bathroom',
      'Garden',
      'Decor',
      'Tools',
    ],
    'Sports & Outdoors': [
      'Fitness',
      'Outdoor Gear',
      'Team Sports',
      'Water Sports',
      'Cycling',
    ],
    'Books & Media': [
      'Fiction',
      'Non-Fiction',
      'Educational',
      'Children\'s Books',
      'Digital Media',
    ],
    'Health & Beauty': [
      'Skincare',
      'Makeup',
      'Hair Care',
      'Supplements',
      'Medical Devices',
    ],
    'Automotive': ['Car Parts', 'Accessories', 'Tools', 'Tires', 'Electronics'],
    'Food & Beverages': [
      'Snacks',
      'Beverages',
      'Organic',
      'Frozen Foods',
      'Fresh Produce',
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _populateForm(widget.product!);
    }
  }

  void _populateForm(Product product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _discountPriceController.text = product.discountPrice?.toString() ?? '';
    _brandController.text = product.brand;
    _stockController.text = product.stockQuantity.toString();
    _selectedCategory = product.category;
    _selectedSubcategory = product.subcategory;
    _isActive = product.isActive;
    _isFeatured = product.isFeatured;
    _productImages = List<String>.from(product.images);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _brandController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id:
            widget.product?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        discountPrice: _discountPriceController.text.isNotEmpty
            ? double.parse(_discountPriceController.text)
            : null,
        category: _selectedCategory,
        subcategory: _selectedSubcategory,
        brand: _brandController.text,
        images: _productImages.isNotEmpty
            ? _productImages
            : (widget.product?.images ??
                  ['assets/images/placeholders/product_placeholder.png']),
        specifications: widget.product?.specifications ?? {},
        tags: widget.product?.tags ?? [],
        stockQuantity: int.parse(_stockController.text),
        isActive: _isActive,
        isFeatured: _isFeatured,
        rating: widget.product?.rating ?? 0.0,
        reviewCount: widget.product?.reviewCount ?? 0,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSave(product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.product != null
                        ? Icons.edit_rounded
                        : Icons.add_rounded,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.product != null ? 'Edit Product' : 'Add New Product',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (widget.onCancel != null)
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.1),
                    ),
                  ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information Section
                      _buildSectionTitle('Basic Information'),
                      const SizedBox(height: 16),

                      _buildIOSTextField(
                        controller: _nameController,
                        label: 'Product Name',
                        hint: 'Enter product name',
                        icon: Icons.inventory_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Product name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildIOSTextField(
                        controller: _brandController,
                        label: 'Brand',
                        hint: 'Enter brand name',
                        icon: Icons.business_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Brand is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildIOSTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Enter product description',
                        icon: Icons.description_rounded,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Product Images Section
                      _buildSectionTitle('Product Images'),
                      const SizedBox(height: 16),
                      _buildImagePickerSection(),
                      const SizedBox(height: 32),

                      // Category Section
                      _buildSectionTitle('Category'),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildIOSDropdown(
                              label: 'Category',
                              value: _selectedCategory,
                              items: _categories,
                              icon: Icons.category_rounded,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                  _selectedSubcategory =
                                      _subcategories[value]!.first;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildIOSDropdown(
                              label: 'Subcategory',
                              value: _selectedSubcategory,
                              items: _subcategories[_selectedCategory] ?? [],
                              icon: Icons.label_rounded,
                              onChanged: (value) {
                                setState(() {
                                  _selectedSubcategory = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Pricing Section
                      _buildSectionTitle('Pricing & Inventory'),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildIOSTextField(
                              controller: _priceController,
                              label: 'Price (\$)',
                              hint: '0.00',
                              icon: Icons.attach_money_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Price is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid price';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildIOSTextField(
                              controller: _discountPriceController,
                              label: 'Discount Price (\$)',
                              hint: '0.00 (Optional)',
                              icon: Icons.local_offer_rounded,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildIOSTextField(
                        controller: _stockController,
                        label: 'Stock Quantity',
                        hint: '0',
                        icon: Icons.inventory_2_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Stock quantity is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Settings Section
                      _buildSectionTitle('Product Settings'),
                      const SizedBox(height: 16),

                      _buildIOSSwitch(
                        title: 'Product is Active',
                        subtitle: 'Available for customers to purchase',
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),

                      _buildIOSSwitch(
                        title: 'Featured Product',
                        subtitle: 'Show in featured products section',
                        value: _isFeatured,
                        onChanged: (value) {
                          setState(() {
                            _isFeatured = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          if (widget.onCancel != null) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: widget.onCancel,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _saveProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                widget.product != null
                                    ? 'Update Product'
                                    : 'Add Product',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildIOSTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey.shade600)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.grey.shade700),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  Widget _buildIOSDropdown({
    required String label,
    required String value,
    required List<String> items,
    IconData? icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null
              ? Icon(icon, color: Colors.grey.shade600)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.grey.shade700),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildIOSSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_productImages.isNotEmpty) ...[
            // Display selected images
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _productImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Icon(
                              Icons.image_rounded,
                              size: 40,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _productImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Add image button
          InkWell(
            onTap: _showImagePickerBottomSheet,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue.shade300,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.add_photo_alternate_rounded,
                    size: 48,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _productImages.isEmpty
                        ? 'Add Product Images'
                        : 'Add More Images',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to select images from gallery or camera',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Image Source',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromCamera();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImageSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromGallery();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.blue.shade600),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImageFromCamera() {
    // Simulate adding an image path
    setState(() {
      _productImages.add(
        'camera_image_${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }

  void _pickImageFromGallery() {
    // Simulate adding an image path
    setState(() {
      _productImages.add(
        'gallery_image_${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }
}
