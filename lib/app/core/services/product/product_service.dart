// lib/app/core/services/product/product_service.dart

import 'dart:io';
import 'package:cartify/app/core/models/product/create_product_dto.dart';
import 'package:cartify/app/core/models/product/update_product_dto.dart';
import 'package:dio/dio.dart';
import 'package:cartify/app/core/index.dart';

/// Service for browsing the product catalog.
class ProductService {
  final ApiClient _apiClient;

  ProductService(this._apiClient);

  /// Retrieves all product categories as a nested tree structure.
  /// Uses the public endpoint that doesn't require authentication.
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      LogService.info('Fetching category tree from /categories/public');

      final response = await _apiClient.dio.get('/categories/public');

      final categories = (response.data as List)
          .map((cat) => CategoryModel.fromJson(cat))
          .toList();

      LogService.info(
        'Successfully fetched ${categories.length} top-level categories',
      );
      return categories;
    } on DioException catch (e) {
      LogService.error('Error getting categories', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return [];
    } catch (e) {
      LogService.error('Unexpected error getting categories', e);
      return [];
    }
  }

  /// Retrieves products for a SPECIFIC category ONLY (not including sub-categories).
  /// Used when user wants to see products assigned directly to a sub-category.
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      LogService.info('Fetching products for specific category', {
        'categoryId': categoryId,
      });

      final response = await _apiClient.dio.get(
        '/products',
        queryParameters: {'category_id': categoryId},
      );

      final products = (response.data as List)
          .map((prod) => ProductModel.fromJson(prod))
          .toList();

      LogService.info(
        'Successfully fetched ${products.length} products for category',
      );
      return products;
    } on DioException catch (e) {
      LogService.error('Error getting products by category', {
        'categoryId': categoryId,
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return [];
    } catch (e) {
      LogService.error('Unexpected error getting products by category', e);
      return [];
    }
  }

  /// NEW: Retrieves products for a parent category AND ALL its sub-categories.
  /// This is the powerful endpoint for getting all products in a category tree.
  Future<List<ProductModel>> getProductsInCategoryTree(
    String categoryId,
  ) async {
    try {
      LogService.info('Fetching products in category tree', {
        'categoryId': categoryId,
      });

      final response = await _apiClient.dio.get(
        '/categories/$categoryId/products',
      );

      final products = (response.data as List)
          .map((prod) => ProductModel.fromJson(prod))
          .toList();

      LogService.info(
        'Successfully fetched ${products.length} products in category tree',
      );
      return products;
    } on DioException catch (e) {
      LogService.error('Error getting products in category tree', {
        'categoryId': categoryId,
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return [];
    } catch (e) {
      LogService.error('Unexpected error getting products in category tree', e);
      return [];
    }
  }

  /// Retrieves a list of all products (without category filtering).
  Future<List<ProductModel>> getAllProducts() async {
    try {
      LogService.info('Fetching all products');

      final response = await _apiClient.dio.get('/products');

      final products = (response.data as List)
          .map((prod) => ProductModel.fromJson(prod))
          .toList();

      LogService.info('Successfully fetched ${products.length} products');
      return products;
    } on DioException catch (e) {
      LogService.error('Error getting all products', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return [];
    } catch (e) {
      LogService.error('Unexpected error getting all products', e);
      return [];
    }
  }

  /// Retrieves detailed information for a single product.
  Future<ProductModel?> getProductById(String productId) async {
    try {
      LogService.info('Fetching product by ID', {'productId': productId});

      final response = await _apiClient.dio.get('/products/$productId');

      final product = ProductModel.fromJson(response.data);
      LogService.info('Successfully fetched product details');
      return product;
    } on DioException catch (e) {
      LogService.error('Error getting product by ID', {
        'productId': productId,
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error getting product by ID', e);
      return null;
    }
  }

  // ===== SELLER-SPECIFIC METHODS =====

  /// Get all products for the authenticated seller (admin endpoint)
  /// GET /products/admin
  Future<List<ProductModel>> getMyProducts() async {
    try {
      LogService.info('Fetching seller products');
      
      final response = await _apiClient.dio.get('/products/admin');
      
      final List<dynamic> productsJson = response.data;
      final products = productsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();

      LogService.info('Fetched ${products.length} seller products');
      return products;
    } on DioException catch (e) {
      LogService.error('Error fetching seller products', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return [];
    } catch (e) {
      LogService.error('Unexpected error fetching seller products', e);
      return [];
    }
  }

  /// Create a new product (Step 1: Product data)
  /// POST /products
  Future<ProductModel?> createProduct(CreateProductDto dto) async {
    try {
      LogService.info('Creating new product', {
        'name': dto.name,
        'price': dto.price,
        'categoryId': dto.categoryId,
      });

      final response = await _apiClient.dio.post(
        '/products',
        data: dto.toJson(),
      );

      final product = ProductModel.fromJson(response.data);
      LogService.info('Product created successfully', {
        'productId': product.id,
        'name': product.name,
      });
      
      return product;
    } on DioException catch (e) {
      LogService.error('Error creating product', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error creating product', e);
      return null;
    }
  }

  /// Upload images for a product (Step 2: Images)
  /// POST /products/:id/images
  Future<ProductModel?> uploadProductImages(
    String productId,
    List<File> imageFiles,
  ) async {
    try {
      LogService.info('Uploading product images', {
        'productId': productId,
        'imageCount': imageFiles.length,
      });

      // Create FormData with multiple files
      final formData = FormData();
      
      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final fileName = file.path.split('/').last;
        
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        ));
      }

      final response = await _apiClient.dio.post(
        '/products/$productId/images',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final updatedProduct = ProductModel.fromJson(response.data);
      LogService.info('Product images uploaded successfully', {
        'productId': productId,
        'imageCount': updatedProduct.images.length,
      });
      
      return updatedProduct;
    } on DioException catch (e) {
      LogService.error('Error uploading product images', {
        'productId': productId,
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error uploading product images', e);
      return null;
    }
  }

  /// Update an existing product
  /// PATCH /products/:id
  Future<ProductModel?> updateProduct(
    String productId,
    UpdateProductDto dto,
  ) async {
    try {
      LogService.info('Updating product', {
        'productId': productId,
        'hasUpdates': dto.hasUpdates,
      });

      if (!dto.hasUpdates) {
        LogService.warning('No updates provided for product', {
          'productId': productId,
        });
        return null;
      }

      final response = await _apiClient.dio.patch(
        '/products/$productId',
        data: dto.toJson(),
      );

      final updatedProduct = ProductModel.fromJson(response.data);
      LogService.info('Product updated successfully', {
        'productId': productId,
        'name': updatedProduct.name,
      });
      
      return updatedProduct;
    } on DioException catch (e) {
      LogService.error('Error updating product', {
        'productId': productId,
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error updating product', e);
      return null;
    }
  }

  /// Delete a product
  /// DELETE /products/:id
  Future<bool> deleteProduct(String productId) async {
    try {
      LogService.info('Deleting product', {'productId': productId});

      await _apiClient.dio.delete('/products/$productId');

      LogService.info('Product deleted successfully', {
        'productId': productId,
      });
      
      return true;
    } on DioException catch (e) {
      LogService.error('Error deleting product', {
        'productId': productId,
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return false;
    } catch (e) {
      LogService.error('Unexpected error deleting product', e);
      return false;
    }
  }

  /// Toggle product active status
  Future<ProductModel?> toggleProductStatus(String productId, bool isActive) async {
    final dto = UpdateProductDto(isActive: isActive);
    return updateProduct(productId, dto);
  }

  /// GET /tags: Fetch all available tags
  Future<List<TagModel>> getTags() async {
    try {
      final response = await _apiClient.dio.get('/tags');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TagModel.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch tags');
    } on DioException catch (e) {
      LogService.error('Error fetching tags: ${e.response?.data}');
      throw e;
    }
  }
}
