import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/log_service.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/config/api_endpoints.dart';

class AuthService {
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      LogService.info('Sending OTP request to: $phone');

      final url = Uri.parse(ApiEndpoints.requestOtp);
      final headers = {'Content-Type': 'application/json'};

      // Format phone number with country code
      final phoneWithCountryCode = phone.startsWith('+91')
          ? phone
          : '+91$phone';

      final body = json.encode({'phone_number': phoneWithCountryCode});

      LogService.apiRequest('POST', url.toString(), headers, body);

      final response = await http.post(url, headers: headers, body: body);

      LogService.apiResponse(
        'POST',
        url.toString(),
        response.statusCode,
        response.body,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        LogService.info('OTP sent successfully: ${responseData['message']}');
        return {
          'success': true,
          'message':
              responseData['message'] ?? 'OTP has been sent successfully.',
        };
      } else {
        LogService.error(
          'Failed to send OTP: ${response.statusCode} - ${response.body}',
        );
        return {
          'success': false,
          'message': responseData['message'] ?? AppStrings.serverError,
        };
      }
    } catch (e) {
      LogService.error('Error sending OTP request', e);
      return {'success': false, 'message': AppStrings.networkError};
    }
  }
}
