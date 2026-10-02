import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulse_ops/models/incident.dart';
import 'package:pulse_ops/providers/incident_providers.dart';
import 'package:pulse_ops/screens/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard displays incident data', (WidgetTester tester) async {
    final testIncidents = [
      const Incident(
        id: 1,
        title: 'Payment API latency',
        severity: 'Critical',
        status: 'Investigating',
        service: 'Payments API',
      ),
      const Incident(
        id: 2,
        title: 'Notification failure',
        severity: 'Warning',
        status: 'Resolved',
        service: 'Notifications',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          incidentsProvider.overrideWith((ref) async => testIncidents),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('PulseOps'), findsOneWidget);
    expect(find.text('System Overview'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Payments API'), findsOneWidget);
  });
}
