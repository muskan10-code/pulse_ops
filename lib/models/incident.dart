class Incident {
  final int id;
  final String title;
  final String severity;
  final String status;
  final String service;

  const Incident({
    required this.id,
    required this.title,
    required this.severity,
    required this.status,
    required this.service,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final completed = json['completed'] as bool;

    const services = [
      'Payments API',
      'Authentication',
      'Notification Service',
      'Search Service',
      'Analytics API',
      'Customer Profile API',
    ];

    const issues = [
      'elevated response latency',
      'increased error rate',
      'timeout threshold exceeded',
      'health check failures',
      'connection pool saturation',
      'degraded request throughput',
    ];

    final index = (id - 1) % services.length;

    final service = services[index];

    final issue = issues[index];

    String severity;

    switch (id % 3) {
      case 0:
        severity = 'Critical';
        break;

      case 1:
        severity = 'Warning';
        break;

      default:
        severity = 'Low';
    }

    return Incident(
      id: id,
      title: '$service — $issue',
      severity: severity,
      status: completed ? 'Resolved' : 'Investigating',
      service: service,
    );
  }
}
