package com.muskan.pulse_ops

import android.content.Context
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "com.muskan.pulseops/device"

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channel
        ).setMethodCallHandler { call, result ->

            if (call.method == "getBatteryLevel") {

                val batteryManager =
                    getSystemService(
                        Context.BATTERY_SERVICE
                    ) as BatteryManager

                val batteryLevel =
                    batteryManager.getIntProperty(
                        BatteryManager.BATTERY_PROPERTY_CAPACITY
                    )

                if (batteryLevel >= 0) {
                    result.success(batteryLevel)
                } else {
                    result.error(
                        "BATTERY_ERROR",
                        "Battery level unavailable",
                        null
                    )
                }

            } else {
                result.notImplemented()
            }
        }
    }
}