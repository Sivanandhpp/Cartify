import 'dart:io';
import 'package:cartify/app/core/widgets/app_dropdown.dart';
import 'package:cartify/app/core/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';
import '../controllers/seller_create_product_controller.dart';

class SellerCreateProductView extends GetView<SellerCreateProductController> {
  const SellerCreateProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressIndicator(),
            Expanded(
              child: Form(
                key: controller.formKey,
                child: Obx(
                  () => IndexedStack(
                    // Fixed: Use IndexedStack for simplicity
                    index: controller.currentStep.value,
                    children: [
                      _buildStep1(), // Product Basics
                      _buildStep2(), // Categorization & Details
                      _buildStep3(), // Discounts & Availability
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.stepTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    controller.stepDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.white,
      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                _buildStepIndicator(
                  0,
                  'Images & Basic',
                  controller.currentStep.value >= 0,
                ),
                Expanded(
                  child: _buildProgressLine(controller.currentStep.value >= 1),
                ),
                _buildStepIndicator(
                  1,
                  'Measurements',
                  controller.currentStep.value >= 1,
                ),
                Expanded(
                  child: _buildProgressLine(controller.currentStep.value >= 2),
                ),
                _buildStepIndicator(
                  2,
                  'Tags & Discounts',
                  controller.currentStep.value >= 2,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: controller.progress,
              backgroundColor: AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : AppColors.grey200,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.grey300,
              width: 2,
            ),
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: AppColors.white, size: 18)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isActive ? AppColors.white : AppColors.grey600,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? AppColors.primary : AppColors.grey600,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.grey200,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Product Images Section
          _buildImageSection(),

          const SizedBox(height: 20),

          // Basic Information Section
          _buildSectionCard(
            title: 'Basic Information',
            subtitle: 'Enter product name, price, and description',
            child: Column(
              children: [
                // Product Name
                AppTextField(
                  controller: controller.nameController,
                  label: 'Product Name',
                  hint: 'e.g., Premium Cotton T-Shirt',
                  icon: Icons.shopping_bag_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Price
                AppTextField(
                  controller: controller.priceController,
                  label: 'Price (₹)',
                  hint: 'e.g., 599',
                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Description
                AppTextField(
                  controller: controller.descriptionController,
                  label: 'Description',
                  hint: 'Enter detailed product description...',
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return _buildSectionCard(
      title: 'Product Images',
      subtitle: 'Add up to 5 high-quality images',
      child: Column(
        children: [
          Obx(
            () => controller.selectedImages.isEmpty
                ? _buildImagePickerPlaceholder()
                : _buildImageGrid(),
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.selectedImages.length < 5
                ? _buildAddImageButton()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerPlaceholder() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.grey300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.grey500,
            ),
            SizedBox(height: 8),
            Text(
              'Tap to add product images',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Upload high-quality images for better visibility',
              style: TextStyle(fontSize: 12, color: AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: EdgeInsets.only(
              right: index < controller.selectedImages.length - 1 ? 12 : 0,
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: FileImage(controller.selectedImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => controller.removeImage(index),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if (index == 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Main',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddImageButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.pickImage,
        icon: const Icon(Icons.add_photo_alternate),
        label: Text('Add Image (${controller.selectedImages.length}/5)'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return _buildSectionCard(
      title: 'Category',
      subtitle: 'Select product category and subcategory',
      child: Column(
        children: [
          Obx(
            () => AppDropdown<CategoryModel>(
              label: 'Category',
              hint: 'Select a category',
              value: controller.selectedCategory.value,
              items: controller.categories,
              itemBuilder: (category) => category.name,
              onChanged: controller.onCategoryChanged,
              icon: Icons.category_outlined,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => AppDropdown<CategoryModel>(
              label: 'Subcategory',
              hint: 'Select a subcategory',
              value: controller.selectedSubCategory.value,
              items: controller.availableSubCategories,
              itemBuilder: (category) => category.name,
              onChanged: controller.onSubCategoryChanged,
              icon: Icons.subdirectory_arrow_right,
              enabled: controller.selectedCategory.value != null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Category Section
          _buildCategorySection(),

          const SizedBox(height: 20),

          // Stock & Measurements Section
          _buildSectionCard(
            title: 'Stock & Measurements',
            subtitle: 'Define quantity and product measurements',
            child: Column(
              children: [
                // Stock Quantity
                AppTextField(
                  controller: controller.stockQuantityController,
                  label: 'Stock Quantity',
                  hint: 'e.g., 100',
                  icon: Icons.inventory,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Stock quantity is required';
                    }
                    final qty = int.tryParse(value);
                    if (qty == null || qty < 0) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Measurements Row
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        controller: controller.measureAmountController,
                        label: 'Measure Amount (Optional)',
                        hint: 'e.g., 500',
                        icon: Icons.straighten,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => AppDropdown<String>(
                          label: 'Unit',
                          hint: 'Select unit',
                          value: controller.selectedMeasureUnit.value,
                          items: controller.measureUnits,
                          itemBuilder: (unit) => unit.toUpperCase(),
                          onChanged: (unit) =>
                              controller.selectedMeasureUnit.value = unit,
                          icon: Icons.straighten,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Custom Attributes Section
          _buildAttributesSection(),
        ],
      ),
    );
  }

  Widget _buildAttributesSection() {
    return _buildSectionCard(
      title: 'Custom Attributes',
      subtitle: 'Add custom attributes (optional)',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: controller.attributeKeyController,
                  label: 'Attribute Name',
                  hint: 'e.g., Color',
                  icon: Icons.label_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: controller.attributeValueController,
                  label: 'Attribute Value',
                  hint: 'e.g., Blue',
                  icon: Icons.text_fields,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: controller.addAttribute,
                  icon: const Icon(Icons.add, color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => controller.attributes.isEmpty
                ? const SizedBox.shrink()
                : _buildAttributesTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Attribute',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Value',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
          ...controller.attributes.entries.map(
            (entry) => Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey300)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(color: AppColors.grey700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.removeAttribute(entry.key),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Tags Section
          _buildSectionCard(
            title: 'Product Tags',
            subtitle: 'Select relevant tags for your product',
            child: Column(
              children: [
                // Available Tags
                Obx(() {
                  if (controller.isLoadingTags.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.availableTags.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'No tags available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.availableTags.map((tag) {
                      final isSelected = controller.selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          controller.toggleTagSelection(tag);
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                        backgroundColor: Colors.grey[100],
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 16),

                // Selected Tags Display
                Obx(() {
                  if (controller.selectedTags.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Tags (${controller.selectedTags.length})',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.selectedTags.map((tag) {
                          return Chip(
                            label: Text(
                              tag.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onDeleted: () => controller.removeSelectedTag(tag),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            deleteIconColor: AppColors.primary,
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Discount Section
          _buildSectionCard(
            title: 'Special Offers',
            subtitle: 'Add optional discount with validity period',
            child: Column(
              children: [
                // Enable Discount Toggle
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: controller.hasDiscount.value
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.hasDiscount.value
                            ? AppColors.primary.withOpacity(0.3)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        'Enable Discount',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Add special pricing for this product',
                      ),
                      value: controller.hasDiscount.value,
                      onChanged: (value) => controller.toggleDiscount(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      activeColor: AppColors.primary,
                    ),
                  ),
                ),

                // Discount Fields
                Obx(() {
                  if (!controller.hasDiscount.value) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 20),

                      // Discount Amount and Percentage Row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: controller.discountAmountController,
                              label: 'Discount Amount (₹)',
                              hint: 'e.g., 50.00',
                              icon: Icons.currency_rupee,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: controller.discountPercentController,
                              label: 'Discount Percentage (%)',
                              hint: 'e.g., 10.5',
                              icon: Icons.percent,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Validity Period Row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller:
                                  controller.discountValidFromController,
                              label: 'Valid From',
                              hint: 'Select start date',
                              icon: Icons.calendar_today,
                              readOnly: true,
                              onTap: () => controller.selectDiscountDate(true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller:
                                  controller.discountValidUptoController,
                              label: 'Valid Until',
                              hint: 'Select end date',
                              icon: Icons.calendar_today,
                              readOnly: true,
                              onTap: () => controller.selectDiscountDate(false),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Live Price Preview
                      _buildLivePricePreview(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Update _buildLivePricePreview method for better UI
  Widget _buildLivePricePreview() {
    return StreamBuilder<String>(
      stream: Stream.periodic(const Duration(milliseconds: 300), (_) {
        return '${controller.priceController.text}|${controller.discountAmountController.text}|${controller.discountPercentController.text}';
      }).distinct(),
      builder: (context, snapshot) {
        final price = double.tryParse(controller.priceController.text) ?? 0.0;
        final discountAmount =
            double.tryParse(controller.discountAmountController.text) ?? 0.0;
        final discountPercent =
            double.tryParse(controller.discountPercentController.text) ?? 0.0;

        if (price > 0 && (discountAmount > 0 || discountPercent > 0)) {
          final finalPrice = price - discountAmount;
          final savings = price - finalPrice;
          final savingsPercent = (savings / price) * 100;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[50]!, Colors.green[100]!],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[300]!),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Original Price',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward, color: Colors.grey[600]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Sale Price',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          '₹${finalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'You Save ₹${savings.toStringAsFixed(2)} (${savingsPercent.toStringAsFixed(1)}% OFF)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            if (controller.canGoPrevious)
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Previous'),
                ),
              ),
            if (controller.canGoPrevious) const SizedBox(width: 12),
            Expanded(
              flex: controller.canGoPrevious ? 1 : 2,
              child: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: controller.isLastStep
                          ? controller.createProduct
                          : controller.nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        controller.isLastStep ? 'Create Product' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.grey600),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }


  // Widget AppDropdown<T>({
  //   required String label,
  //   required String hint,
  //   required T? value,
  //   required List<T> items,
  //   required String Function(T) itemBuilder,
  //   required void Function(T?) onChanged,
  //   required IconData icon,
  //   bool enabled = true,
  // }) {
  //   return DropdownButtonFormField<T>(
  //     value: value,
  //     items: items
  //         .map(
  //           (item) => DropdownMenuItem<T>(
  //             value: item,
  //             child: Text(itemBuilder(item)),
  //           ),
  //         )
  //         .toList(),
  //     onChanged: enabled ? onChanged : null,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       hintText: hint,
  //       prefixIcon: Icon(
  //         icon,
  //         color: enabled ? AppColors.grey500 : AppColors.grey400,
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.grey300),
  //       ),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.grey300),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.primary, width: 2),
  //       ),
  //       disabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: const BorderSide(color: AppColors.grey200),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: 16,
  //         vertical: 16,
  //       ),
  //     ),
  //   );
  // }
}
