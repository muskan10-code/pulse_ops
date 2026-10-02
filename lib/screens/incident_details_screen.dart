import 'package:flutter/material.dart';

import '../models/incident.dart';

class IncidentDetailsScreen extends StatelessWidget {
  final Incident incident;

  const IncidentDetailsScreen({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incident Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            incident.title,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _DetailsCard(
            title: 'Severity',
            value: incident.severity,
            icon: Icons.warning_amber,
          ),
          _DetailsCard(
            title: 'Status',
            value: incident.status,
            icon: Icons.timeline,
          ),
          _DetailsCard(
            title: 'Affected Service',
            value: incident.service,
            icon: Icons.cloud_outlined,
          ),
          _DetailsCard(
            title: 'Incident ID',
            value: '#${incident.id}',
            icon: Icons.tag,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Incident acknowledged')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Acknowledge Incident'),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DetailsCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
