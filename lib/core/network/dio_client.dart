import 'package:dio/dio.dart';

/// HTTP client wrapper using Dio for API communication.
///
/// Configured with base URL and timeouts for the 8club staging API.
class DioClient {
  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://staging.chamberofsecrets.8club.co',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

  final Dio dio;

  Future<List<dynamic>> getExperiences() async {
    final res = await dio.get(
      '/v1/experiences',
      queryParameters: {'active': true},
    );
    final data = res.data;
    if (data is Map &&
        data['data'] is Map &&
        data['data']['experiences'] is List) {
      return List<dynamic>.from(data['data']['experiences'] as List);
    }
    return const [];
  }
}
