import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_ops/models/incident.dart';

void main() {
  test('creates Incident from JSON', () {
    final json = {
      'id': 3,
      'title': 'Payment service latency',
      'completed': false,
    };

    final incident = Incident.fromJson(json);

    expect(incident.id, 3);

    expect(incident.title, 'Payment service latency');

    expect(incident.status, 'Investigating');

    expect(incident.severity, 'Critical');
  });
}
