import 'package:flutter/material.dart';

import '../services/device_service.dart';

class DeviceDiagnosticsScreen extends StatefulWidget {
  const DeviceDiagnosticsScreen({super.key});

  @override
  State<DeviceDiagnosticsScreen> createState() =>
      _DeviceDiagnosticsScreenState();
}

class _DeviceDiagnosticsScreenState extends State<DeviceDiagnosticsScreen> {
  final DeviceService deviceService = DeviceService();

  int? batteryLevel;
  bool loading = false;
  String? error;

  Future<void> loadBatteryLevel() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final result = await deviceService.getBatteryLevel();

      setState(() {
        batteryLevel = result;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Device Diagnostics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.battery_charging_full, size: 60),
                    const SizedBox(height: 16),
                    const Text('Battery Level', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    if (loading)
                      const CircularProgressIndicator()
                    else if (error != null)
                      Text(error!)
                    else
                      Text(
                        '${batteryLevel ?? '--'}%',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: loadBatteryLevel,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Diagnostics'),
            ),
          ],
        ),
      ),
    );
  }
}
