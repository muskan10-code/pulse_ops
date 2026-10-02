import 'package:flutter/services.dart';

class DeviceService {
  static const MethodChannel _channel = MethodChannel(
    'com.muskan.pulseops/device',
  );

  Future<int> getBatteryLevel() async {
    try {
      final batteryLevel = await _channel.invokeMethod<int>('getBatteryLevel');

      return batteryLevel ?? -1;
    } on PlatformException catch (error) {
      throw Exception('Unable to read battery level: ${error.message}');
    }
  }
}
