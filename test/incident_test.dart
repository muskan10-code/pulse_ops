import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_ops/models/incident.dart';

void main() {
  test('creates Incident from backend JSON', () {
    final json = {
      'id': 3,
      'todo': 'Generic backend task',
      'completed': false,
      'userId': 15,
    };

    final incident = Incident.fromJson(json);

    expect(incident.id, 3);

    expect(incident.title, 'Notification Service — timeout threshold exceeded');

    expect(incident.status, 'Investigating');

    expect(incident.severity, 'Critical');

    expect(incident.service, 'Notification Service');
  });
}
