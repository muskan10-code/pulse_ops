import 'package:dio/dio.dart';

import '../models/incident.dart';

class IncidentApi {
  final Dio dio;

  IncidentApi(this.dio);

  Future<List<Incident>> fetchIncidents() async {
    try {
      final response = await dio.get('/todos', queryParameters: {'_limit': 20});
      print(response.data);

      final data = response.data as List<dynamic>;

      return data
          .map((json) => Incident.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timed out. Please try again.');
      }

      throw Exception('Unable to load incidents.');
    }
  }
}
