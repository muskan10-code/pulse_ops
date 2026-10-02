import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/incident.dart';
import '../services/incident_api.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      // 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
});

final incidentApiProvider = Provider<IncidentApi>((ref) {
  return IncidentApi(ref.watch(dioProvider));
});

final incidentsProvider = FutureProvider<List<Incident>>((ref) async {
  final api = ref.watch(incidentApiProvider);

  return api.fetchIncidents();
});
