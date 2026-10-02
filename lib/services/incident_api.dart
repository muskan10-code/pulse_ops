import 'package:dio/dio.dart';

import '../models/incident.dart';

class IncidentApi {
  final Dio dio;

  IncidentApi(this.dio);

  Future<List<Incident>> fetchIncidents() async {
    try {
      final response = await dio.get(
        '/todos',
        queryParameters: {'limit': 20, 'skip': 0},
      );

      final data = response.data as Map<String, dynamic>;

      final todos = data['todos'] as List<dynamic>;

      return todos
          .map((json) => Incident.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timed out. Please try again.');
      }

      if (error.type == DioExceptionType.connectionError) {
        throw Exception('No network connection.');
      }

      throw Exception('Unable to load incidents.');
    }
  }
}
