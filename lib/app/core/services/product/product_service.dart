// lib/app/core/services/product/product_service.dart

import 'dart:io';
import 'package:cartify/app/core/models/product/category_model.dart';
import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:cartify/app/core/services/log_service.dart';
import 'package:dio/dio.dart';

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

  /// (Admin/Seller) Creates a new product.
  Future<ProductModel?> createProduct(Map<String, dynamic> productData) async {
    try {
      LogService.info('Creating new product');

      final response = await _apiClient.dio.post(
        '/products',
        data: productData,
      );

      final product = ProductModel.fromJson(response.data);
      LogService.info('Successfully created product', {
        'productId': product.id,
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

  /// (Admin/Seller) Uploads images for a product.
  Future<ProductModel?> uploadProductImages(
    String productId,
    List<File> images,
  ) async {
    try {
      LogService.info('Uploading product images', {
        'productId': productId,
        'imageCount': images.length,
      });

      List<MultipartFile> files = [];
      for (var image in images) {
        String fileName = image.path.split('/').last;
        files.add(await MultipartFile.fromFile(image.path, filename: fileName));
      }
      FormData formData = FormData.fromMap({"files": files});

      final response = await _apiClient.dio.post(
        '/products/$productId/images',
        data: formData,
      );

      final product = ProductModel.fromJson(response.data);
      LogService.info('Successfully uploaded product images');
      return product;
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
}
