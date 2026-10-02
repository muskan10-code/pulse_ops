import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/incident.dart';
import '../providers/incident_providers.dart';
import 'incident_details_screen.dart';

class IncidentsScreen extends ConsumerStatefulWidget {
  const IncidentsScreen({super.key});

  @override
  ConsumerState<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends ConsumerState<IncidentsScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final incidentsAsync = ref.watch(incidentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Incidents',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: incidentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(
            child: FilledButton.icon(
              onPressed: () {
                ref.invalidate(incidentsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          );
        },
        data: (incidents) {
          final filtered = _filterIncidents(incidents);

          return Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _filterChip('All'),
                    _filterChip('Critical'),
                    _filterChip('Warning'),
                    _filterChip('Low'),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(incidentsProvider);
                    await ref.read(incidentsProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final incident = filtered[index];

                      return _IncidentTile(incident: incident);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filterChip(String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(value),
        selected: selectedFilter == value,
        onSelected: (_) {
          setState(() {
            selectedFilter = value;
          });
        },
      ),
    );
  }

  List<Incident> _filterIncidents(List<Incident> incidents) {
    if (selectedFilter == 'All') {
      return incidents;
    }

    return incidents
        .where((incident) => incident.severity == selectedFilter)
        .toList();
  }
}

class _IncidentTile extends StatelessWidget {
  final Incident incident;

  const _IncidentTile({required this.incident});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(child: Icon(_severityIcon(incident.severity))),
        title: Text(
          incident.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('${incident.service} • ${incident.status}'),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IncidentDetailsScreen(incident: incident),
            ),
          );
        },
      ),
    );
  }

  IconData _severityIcon(String severity) {
    switch (severity) {
      case 'Critical':
        return Icons.error;
      case 'Warning':
        return Icons.warning_amber;
      default:
        return Icons.info_outline;
    }
  }
}
