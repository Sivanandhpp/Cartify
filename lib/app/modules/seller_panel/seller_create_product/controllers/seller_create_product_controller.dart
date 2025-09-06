import 'dart:io';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_dashboard_controller.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_data_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

class SellerCreateProductController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final _sellerDataController = Get.find<SellerDataController>();

  // Form controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final measureAmountController = TextEditingController();
  final attributeKeyController = TextEditingController();
  final attributeValueController = TextEditingController();
  final stockQuantityController = TextEditingController();

  // Discount controllers
  final discountAmountController = TextEditingController();
  final discountPercentController = TextEditingController();
  final discountValidFromController = TextEditingController();
  final discountValidUptoController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Page controller for navigation - Fixed initialization
  PageController? _pageController;
  PageController get pageController {
    _pageController ??= PageController();
    return _pageController!;
  }

  // Observable states
  final currentStep = 0.obs;
  final isLoading = false.obs;
  final isLoadingTags = false.obs;
  final selectedImages = <File>[].obs;
  final existingImages = <String>[].obs;
  final categories = <CategoryModel>[].obs;
  final availableTags = <TagModel>[].obs;
  final selectedTags = <TagModel>[].obs;
  final selectedCategory = Rxn<CategoryModel>();
  final selectedSubCategory = Rxn<CategoryModel>();
  final selectedMeasureUnit = Rxn<String>();
  final attributes = <String, String>{}.obs;
  final hasDiscount = false.obs;

  // Available measure units
  final measureUnits = [
    'kg',
    'g',
    'mg',
    'l',
    'ml',
    'pcs',
    'dozen',
    'm',
    'cm',
    'inch',
    'sq_ft',
    'sq_m',
  ].obs;

  // Edit mode
  ProductModel? editingProduct;

  // Progress indicator
  double get progress => (currentStep.value + 1) / 3;

  @override
  void onInit() {
    super.onInit();
    // Check if editing
    editingProduct = Get.arguments as ProductModel?;
    loadCategories();
    loadAvailableTags();

    // Prefill fields if editing
    if (editingProduct != null) {
      _prefillFields();
    }

    // Add discount calculation listeners
    discountAmountController.addListener(_calculateDiscountPercent);
    discountPercentController.addListener(_calculateDiscountAmount);
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    stockQuantityController.dispose();
    measureAmountController.dispose();
    attributeKeyController.dispose();
    attributeValueController.dispose();
    discountAmountController.dispose();
    discountPercentController.dispose();
    discountValidFromController.dispose();
    discountValidUptoController.dispose();
    _pageController?.dispose(); // Fixed: Proper disposal
    super.onClose();
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final productService = Get.find<ProductService>();
      final loadedCategories = await productService.getAllCategories();
      categories.value = loadedCategories;

      // Prefill category if editing
      if (editingProduct != null) {
        _prefillCategory();
      }
    } catch (e) {
      LogService.error('Error loading categories', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to load categories',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load available tags
  Future<void> loadAvailableTags() async {
    try {
      isLoadingTags.value = true;
      final tags = await _productService.getTags();
      availableTags.assignAll(tags.where((tag) => tag.isActive).toList());

      // Prefill tags if editing
      if (editingProduct != null) {
        _prefillTags();
      }

      LogService.info('Loaded ${availableTags.length} available tags');
    } catch (e) {
      LogService.error('Error loading tags', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to load tags',
      );
    } finally {
      isLoadingTags.value = false;
    }
  }

  // Prefill fields for editing
  void _prefillFields() {
    if (editingProduct == null) return;

    nameController.text = editingProduct!.name;
    priceController.text = editingProduct!.price.toString();
    descriptionController.text = editingProduct!.description ?? '';
    stockQuantityController.text = editingProduct!.stockQuantity.toString();
    measureAmountController.text =
        editingProduct!.measureAmount?.toString() ?? '';
    selectedMeasureUnit.value = editingProduct!.measureUnitCode;
    attributes.value = Map<String, String>.from(
      editingProduct!.attributes ?? {},
    );
    existingImages.assignAll(
      editingProduct!.images,
    ); // Added: Prefill existing images

    // Prefill discounts
    if (editingProduct!.discounts != null &&
        editingProduct!.discounts!.isNotEmpty) {
      hasDiscount.value = true;
      final discount = editingProduct!.discounts!.first;
      discountAmountController.text = discount.discountAmount?.toString() ?? '';
      discountPercentController.text =
          discount.discountPercent?.toString() ?? '';
      discountValidFromController.text =
          discount.validFrom?.toIso8601String().split('T')[0] ?? '';
      discountValidUptoController.text =
          discount.validUpto?.toIso8601String().split('T')[0] ?? '';
    }
  }

  void _prefillCategory() {
    if (editingProduct == null) return;

    // Find category by ID
    CategoryModel? foundCategory;
    for (final cat in categories) {
      if (cat.id == editingProduct!.categoryId) {
        foundCategory = cat;
        break;
      }
      // Check children
      foundCategory = cat.findChildById(editingProduct!.categoryId ?? '');
      if (foundCategory != null) break;
    }

    if (foundCategory != null) {
      if (foundCategory.parentId == null) {
        selectedCategory.value = foundCategory;
      } else {
        // It's a subcategory, find parent
        selectedCategory.value = categories.firstWhereOrNull(
          (c) => c.id == foundCategory!.parentId,
        );
        selectedSubCategory.value = foundCategory;
      }
    }
  }

  void _prefillTags() {
    if (editingProduct == null) return;

    selectedTags.assignAll(
      availableTags.where(
        (tag) => editingProduct!.tags?.any((et) => et.id == tag.id) ?? false,
      ),
    );
  }

  // Image management
  Future<void> pickImage() async {
    if (selectedImages.length + existingImages.length >= 5) {
      // Updated: Include existing images in limit
      NotificationService.showWarning(
        title: 'Limit Reached',
        message: 'You can only add up to 5 images',
      );
      return;
    }

    final result = await AppImagePicker.pickProductImage();
    if (result != null) {
      selectedImages.add(result.selectedImage);
      NotificationService.showSuccess(
        title: 'Image Added',
        message: 'Product image added successfully',
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  // Category management
  void onCategoryChanged(CategoryModel? category) {
    selectedCategory.value = category;
    selectedSubCategory.value = null; // Reset subcategory
  }

  void onSubCategoryChanged(CategoryModel? subCategory) {
    selectedSubCategory.value = subCategory;
  }

  List<CategoryModel> get availableSubCategories {
    return selectedCategory.value?.children ?? [];
  }

  // Tag management
  void toggleTagSelection(TagModel tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void removeSelectedTag(TagModel tag) {
    selectedTags.remove(tag);
  }

  // Attribute management
  void addAttribute() {
    final key = attributeKeyController.text.trim();
    final value = attributeValueController.text.trim();

    if (key.isEmpty || value.isEmpty) {
      NotificationService.showWarning(
        title: 'Invalid Input',
        message: 'Both key and value are required',
      );
      return;
    }

    if (attributes.containsKey(key)) {
      NotificationService.showWarning(
        title: 'Duplicate Key',
        message: 'This attribute key already exists',
      );
      return;
    }

    attributes[key] = value;
    attributeKeyController.clear();
    attributeValueController.clear();

    NotificationService.showSuccess(
      title: 'Attribute Added',
      message: 'Product attribute added successfully',
    );
  }

  void removeAttribute(String key) {
    attributes.remove(key);
  }

  // Discount calculation methods
  void _calculateDiscountPercent() {
    if (discountAmountController.text.isEmpty || priceController.text.isEmpty) {
      return;
    }

    final price = double.tryParse(priceController.text);
    final amount = double.tryParse(discountAmountController.text);

    if (price != null && amount != null && price > 0) {
      final percent = (amount / price) * 100;
      discountPercentController.removeListener(_calculateDiscountAmount);
      discountPercentController.text = percent.toStringAsFixed(1);
      discountPercentController.addListener(_calculateDiscountAmount);
    }
  }

  void _calculateDiscountAmount() {
    if (discountPercentController.text.isEmpty ||
        priceController.text.isEmpty) {
      return;
    }

    final price = double.tryParse(priceController.text);
    final percent = double.tryParse(discountPercentController.text);

    if (price != null && percent != null && percent >= 0 && percent <= 100) {
      final amount = (price * percent) / 100;
      discountAmountController.removeListener(_calculateDiscountPercent);
      discountAmountController.text = amount.toStringAsFixed(2);
      discountAmountController.addListener(_calculateDiscountPercent);
    }
  }

  void toggleDiscount() {
    hasDiscount.value = !hasDiscount.value;
    if (!hasDiscount.value) {
      discountAmountController.clear();
      discountPercentController.clear();
      discountValidFromController.clear();
      discountValidUptoController.clear();
    }
  }

  // Date picker for discount validity
  Future<void> selectDiscountDate(bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final formattedDate = picked.toIso8601String().split('T')[0];
      if (isFromDate) {
        discountValidFromController.text = formattedDate;
      } else {
        discountValidUptoController.text = formattedDate;
      }
    }
  }

  // Step navigation - Fixed with safety checks
  void nextStep() {
    if (currentStep.value < 2) {
      if (validateCurrentStep()) {
        currentStep.value++;
        // Fixed: Check if controller is attached before animating
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              currentStep.value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      // Fixed: Same safety check
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController != null && _pageController!.hasClients) {
          _pageController!.animateToPage(
            currentStep.value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  // Validation
  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        return validateStep1();
      case 1:
        return validateStep2();
      case 2:
        return validateStep3(); // Tags and discounts (optional, so always true)
      default:
        return false;
    }
  }

  bool validateStep1() {
    if (selectedImages.isEmpty && existingImages.isEmpty) {
      NotificationService.showError(
        title: 'Images Required',
        message: 'Please add at least one product image',
      );
      return false;
    }

    if (nameController.text.trim().isEmpty) {
      NotificationService.showError(
        title: 'Name Required',
        message: 'Please enter product name',
      );
      return false;
    }

    if (priceController.text.trim().isEmpty) {
      NotificationService.showError(
        title: 'Price Required',
        message: 'Please enter product price',
      );
      return false;
    }

    final price = double.tryParse(priceController.text);
    if (price == null || price <= 0) {
      NotificationService.showError(
        title: 'Invalid Price',
        message: 'Please enter a valid price',
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      NotificationService.showError(
        title: 'Description Required',
        message: 'Please enter product description',
      );
      return false;
    }

    return true;
  }

  bool validateStep2() {
    if (selectedCategory.value == null) {
      NotificationService.showError(
        title: 'Category Required',
        message: 'Please select a category',
      );
      return false;
    }

    if (stockQuantityController.text.trim().isEmpty) {
      NotificationService.showError(
        title: 'Stock Quantity Required',
        message: 'Please enter stock quantity',
      );
      return false;
    }

    final stockQty = int.tryParse(stockQuantityController.text);
    if (stockQty == null || stockQty < 0) {
      NotificationService.showError(
        title: 'Invalid Stock Quantity',
        message: 'Please enter a valid stock quantity',
      );
      return false;
    }

    if (measureAmountController.text.trim().isNotEmpty) {
      final amount = double.tryParse(measureAmountController.text);
      if (amount == null || amount <= 0) {
        NotificationService.showError(
          title: 'Invalid Measure Amount',
          message: 'Please enter a valid measure amount',
        );
        return false;
      }

      if (selectedMeasureUnit.value == null) {
        NotificationService.showError(
          title: 'Measure Unit Required',
          message: 'Please select a measure unit',
        );
        return false;
      }
    }

    return true;
  }

  bool validateStep3() {
    // Tags and discounts are optional, so always valid
    // You can add custom validation here if needed
    return true;
  }

  // Create or update product - Fixed to handle new model fields
  Future<void> createProduct() async {
    if (!formKey.currentState!.validate() || !validateCurrentStep()) {
      return;
    }

    try {
      isLoading.value = true;

      // Prepare discount data
      List<Map<String, dynamic>>? discounts;
      if (hasDiscount.value &&
          (discountAmountController.text.isNotEmpty ||
              discountPercentController.text.isNotEmpty)) {
        final discount = <String, dynamic>{};

        if (discountAmountController.text.isNotEmpty) {
          discount['discount_amount'] = double.parse(
            discountAmountController.text,
          );
        }
        if (discountPercentController.text.isNotEmpty) {
          discount['discount_percent'] = double.parse(
            discountPercentController.text,
          );
        }
        if (discountValidFromController.text.isNotEmpty) {
          discount['valid_from'] =
              '${discountValidFromController.text}T00:00:00.000Z';
        }
        if (discountValidUptoController.text.isNotEmpty) {
          discount['valid_upto'] =
              '${discountValidUptoController.text}T23:59:59.000Z';
        }

        discounts = [discount];
      }

      if (editingProduct != null) {
        // Update product
        final dto = UpdateProductDto(
          // id: editingProduct!.id,
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          price: double.parse(priceController.text),
          stockQuantity: int.parse(stockQuantityController.text),
          categoryId:
              selectedSubCategory.value?.id ?? selectedCategory.value!.id,
          tags: selectedTags
              .map((tag) => tag.name)
              .toList(), // Add selected tag names
          measureUnitCode: selectedMeasureUnit.value,
          measureAmount: measureAmountController.text.trim().isNotEmpty
              ? double.parse(measureAmountController.text)
              : null,
          attributes: attributes.isNotEmpty
              ? Map<String, dynamic>.from(attributes)
              : null,
          discounts: discounts, // Add discounts
        );

        final product = await _productService.updateProduct(
          editingProduct!.id,
          dto,
        );
        if (product == null) {
          throw Exception('Failed to update product');
        }

        // Upload new images if any
        if (selectedImages.isNotEmpty) {
          await _productService.uploadProductImages(product.id, selectedImages);
        }
      } else {
        // Create product DTO - Fixed: Use correct field names
        final dto = CreateProductDto(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          price: double.parse(priceController.text),
          stockQuantity: int.parse(stockQuantityController.text),
          categoryId:
              selectedSubCategory.value?.id ?? selectedCategory.value!.id,
          tags: selectedTags
              .map((tag) => tag.name)
              .toList(), // Add selected tag names
          measureUnitCode: selectedMeasureUnit.value,
          measureAmount: measureAmountController.text.trim().isNotEmpty
              ? double.parse(measureAmountController.text)
              : null,
          attributes: attributes.isNotEmpty
              ? Map<String, dynamic>.from(attributes)
              : null,
          discounts: discounts, // Add discounts
        );

        // Step 1: Create product
        final product = await _productService.createProduct(dto);
        if (product == null) {
          throw Exception('Failed to create product');
        }

        // Step 2: Upload images
        final updatedProduct = await _productService.uploadProductImages(
          product.id,
          selectedImages,
        );

        if (updatedProduct == null) {
          throw Exception('Failed to upload product images');
        }
      }

      // Reset form and navigate back
      resetForm();
    } catch (e) {
      LogService.error('Error creating/updating product', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to save product. Please try again.',
      );
    } finally {
      _sellerDataController.refreshProducts();
      Get.back();

      NotificationService.showSuccess(
        title: 'Success!',
        message: 'Product saved successfully',
      );
      isLoading.value = false;
    }
  }

  void resetForm() {
    currentStep.value = 0;
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    stockQuantityController.clear();
    measureAmountController.clear();
    attributeKeyController.clear();
    attributeValueController.clear();
    discountAmountController.clear();
    discountPercentController.clear();
    discountValidFromController.clear();
    discountValidUptoController.clear();
    selectedImages.clear();
    existingImages.clear(); // Added: Clear existing images
    selectedTags.clear();
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedMeasureUnit.value = null;
    attributes.clear();
    hasDiscount.value = false;
    editingProduct = null;
  }

  // Helper getters
  bool get canGoNext => currentStep.value < 2; // Changed from 3 to 2
  bool get canGoPrevious => currentStep.value > 0;
  bool get isLastStep => currentStep.value == 2; // Changed from 3 to 2

  String get stepTitle {
    switch (currentStep.value) {
      case 0:
        return 'Product Basics';
      case 1:
        return 'Categorization & Details';
      case 2:
        return 'Discounts & Availability';
      default:
        return '';
    }
  }

  String get stepDescription {
    switch (currentStep.value) {
      case 0:
        return 'Give your product a name, price, and first look';
      case 1:
        return 'Organize your product and define key details';
      case 2:
        return 'Set special offers and time period';
      default:
        return '';
    }
  }

  String get submitButtonText => editingProduct != null ? 'Update' : 'Create';
}
