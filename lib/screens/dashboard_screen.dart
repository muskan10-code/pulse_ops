import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/incident_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentsAsync = ref.watch(incidentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PulseOps',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(incidentsProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: incidentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to load dashboard',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(incidentsProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (incidents) {
          final critical = incidents
              .where((incident) => incident.severity == 'Critical')
              .length;

          final investigating = incidents
              .where((incident) => incident.status == 'Investigating')
              .length;

          final resolved = incidents
              .where((incident) => incident.status == 'Resolved')
              .length;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(incidentsProvider);
              await ref.read(incidentsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'System Overview',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Monitor system health and active incidents.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricCard(
                      title: 'Incidents',
                      value: '${incidents.length}',
                      icon: Icons.warning_amber,
                    ),
                    _MetricCard(
                      title: 'Critical',
                      value: '$critical',
                      icon: Icons.error_outline,
                    ),
                    _MetricCard(
                      title: 'Investigating',
                      value: '$investigating',
                      icon: Icons.search,
                    ),
                    _MetricCard(
                      title: 'Resolved',
                      value: '$resolved',
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Service Status',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const _ServiceTile(
                  name: 'Payments API',
                  status: 'Healthy',
                  icon: Icons.payments_outlined,
                ),
                const _ServiceTile(
                  name: 'Authentication',
                  status: 'Healthy',
                  icon: Icons.security,
                ),
                const _ServiceTile(
                  name: 'Notifications',
                  status: 'Degraded',
                  icon: Icons.notifications_outlined,
                ),
                const _ServiceTile(
                  name: 'Analytics',
                  status: 'Healthy',
                  icon: Icons.analytics_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.sizeOf(context).width - 52) / 2;

    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 18),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String name;
  final String status;
  final IconData icon;

  const _ServiceTile({
    required this.name,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(name),
        subtitle: Text(status),
        trailing: Icon(
          status == 'Healthy'
              ? Icons.check_circle
              : Icons.warning_amber_rounded,
          color: status == 'Healthy' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
