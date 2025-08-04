// lib/app/core/services/product/product_service.dart

import 'dart:io';
import 'package:cartify/app/core/models/product/category_model.dart';
import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// Service for browsing the product catalog.
class ProductService {
  final ApiClient _apiClient;

  ProductService(this._apiClient);

  /// Retrieves all product categories as a nested tree.
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      return (response.data as List)
          .map((cat) => CategoryModel.fromJson(cat))
          .toList();
    } on DioException catch (e) {
      print('Error getting categories: ${e.response?.data}');
      return [];
    }
  }

  /// Retrieves a list of all products.
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _apiClient.dio.get('/products');
      return (response.data as List)
          .map((prod) => ProductModel.fromJson(prod))
          .toList();
    } on DioException catch (e) {
      print('Error getting products: ${e.response?.data}');
      return [];
    }
  }

  /// Retrieves detailed information for a single product.
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final response = await _apiClient.dio.get('/products/$productId');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error getting product by ID: ${e.response?.data}');
      return null;
    }
  }

  /// (Admin/Seller) Creates a new product.
  /// Note: The DTO for product creation is not defined in the provided JSON.
  /// This is a placeholder for that functionality.
  Future<ProductModel?> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _apiClient.dio.post(
        '/products',
        data: productData,
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error creating product: ${e.response?.data}');
      return null;
    }
  }

  /// (Admin/Seller) Uploads images for a product.
  Future<ProductModel?> uploadProductImages(
    String productId,
    List<File> images,
  ) async {
    try {
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
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error uploading product images: ${e.response?.data}');
      return null;
    }
  }
}
