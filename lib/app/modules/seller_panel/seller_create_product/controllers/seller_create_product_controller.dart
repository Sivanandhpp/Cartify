import 'dart:io';
import 'package:cartify/app/core/models/product/create_product_dto.dart';
import 'package:cartify/app/core/widgets/app_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

class SellerCreateProductController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  // Form controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final measureAmountController = TextEditingController();
  final attributeKeyController = TextEditingController();
  final attributeValueController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Page controller for navigation - make it nullable initially
  PageController? _pageController;
  PageController get pageController {
    _pageController ??= PageController();
    return _pageController!;
  }

  // Observable states
  final currentStep = 0.obs;
  final isLoading = false.obs;
  final selectedImages = <File>[].obs;
  final categories = <CategoryModel>[].obs;
  final selectedCategory = Rxn<CategoryModel>();
  final selectedSubCategory = Rxn<CategoryModel>();
  final selectedMeasureUnit = Rxn<String>();
  final attributes = <String, String>{}.obs;

  // Available measure units
  final measureUnits = [
    'kg', 'g', 'mg', 'l', 'ml', 'pcs', 'dozen', 'm', 'cm', 'inch', 'sq_ft', 'sq_m'
  ].obs;

  // Progress indicator
  double get progress => (currentStep.value + 1) / 3;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    measureAmountController.dispose();
    attributeKeyController.dispose();
    attributeValueController.dispose();
    _pageController?.dispose();
    super.onClose();
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final productService = Get.find<ProductService>();
      final loadedCategories = await productService.getAllCategories();
      categories.value = loadedCategories;
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

  // Image management
  Future<void> pickImage() async {
    if (selectedImages.length >= 5) {
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

  // Step navigation - Fixed approach
  void nextStep() {
    if (currentStep.value < 2) {
      if (validateCurrentStep()) {
        currentStep.value++;
        // Use a post-frame callback to ensure the widget is built
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
      // Use a post-frame callback to ensure the widget is built
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

  // Alternative method: Direct step change without animation for now
  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      currentStep.value = step;
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
        return validateStep3();
      default:
        return false;
    }
  }

  bool validateStep1() {
    if (selectedImages.isEmpty) {
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

    if (selectedCategory.value == null) {
      NotificationService.showError(
        title: 'Category Required',
        message: 'Please select a category',
      );
      return false;
    }

    return true;
  }

  bool validateStep2() {
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
    if (descriptionController.text.trim().isEmpty) {
      NotificationService.showError(
        title: 'Description Required',
        message: 'Please enter product description',
      );
      return false;
    }

    return true;
  }

  // Create product
  Future<void> createProduct() async {
    if (!formKey.currentState!.validate() || !validateCurrentStep()) {
      return;
    }

    try {
      isLoading.value = true;

      // Create product DTO
      final dto = CreateProductDto(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text),
        stockQuantity: 100, // Default stock quantity
        categoryId: selectedSubCategory.value?.id ?? selectedCategory.value!.id,
        measureUnitCode: selectedMeasureUnit.value,
        measureAmount: measureAmountController.text.trim().isNotEmpty
            ? double.parse(measureAmountController.text)
            : null,
        attributes: attributes.isNotEmpty ? Map<String, dynamic>.from(attributes) : null,
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

      NotificationService.showSuccess(
        title: 'Success!',
        message: 'Product created successfully',
      );

      // Reset form and navigate back
      resetForm();
      Get.back();

    } catch (e) {
      LogService.error('Error creating product', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to create product. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    currentStep.value = 0;
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    measureAmountController.clear();
    attributeKeyController.clear();
    attributeValueController.clear();
    selectedImages.clear();
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedMeasureUnit.value = null;
    attributes.clear();
  }

  // Helper getters
  bool get canGoNext => currentStep.value < 2;
  bool get canGoPrevious => currentStep.value > 0;
  bool get isLastStep => currentStep.value == 2;

  String get stepTitle {
    switch (currentStep.value) {
      case 0:
        return 'Basic Information';
      case 1:
        return 'Measurements';
      case 2:
        return 'Details & Attributes';
      default:
        return '';
    }
  }

  String get stepDescription {
    switch (currentStep.value) {
      case 0:
        return 'Add images, name, price, and category';
      case 1:
        return 'Add measure amount and unit';
      case 2:
        return 'Add description and custom attributes';
      default:
        return '';
    }
  }
}