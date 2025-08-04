// lib/app/core/services/dashboard/dashboard_service.dart

import 'package:cartify/app/core/models/dashboard/dashboard_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// Service for fetching the dynamic dashboard data.
class DashboardService {
  final ApiClient _apiClient;

  DashboardService(this._apiClient);

  /// Retrieves the data for the app's home screen.
  Future<DashboardModel?> getDashboard() async {
    try {
      final response = await _apiClient.dio.get('/dashboard');
      return DashboardModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error fetching dashboard: ${e.response?.data}');
      return null;
    }
  }
}
