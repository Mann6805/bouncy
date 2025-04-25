import 'package:bouncy/controllers/sensordatacontroller.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

// Initializes the background service for sensor data handling
Future<void> initializeService() async {
  // Create an instance of the background service
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, 
      isForegroundMode: false,  // Configures the service to run in background (not in the foreground)
    )
  );
}

// The entry point when the background service starts
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
    
  // Create an instance of the Sensordatacontroller to handle sensor data
  Sensordatacontroller controller = Sensordatacontroller();
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;

  // Check if the service is running on Android 
  if(service is AndroidServiceInstance){

    // Listen for the event to start the sensor data service
    service.on('startService').listen((event) {

      SensorsPlatform.instance.accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval).listen((event) {
        _accelerometerEvent = event;

        // If gyroscope data is available, save both sensor data
        if (_gyroscopeEvent != null) {
          controller.saveSensorData(_accelerometerEvent, _gyroscopeEvent);
        }
      });

      SensorsPlatform.instance.gyroscopeEventStream(samplingPeriod: SensorInterval.gameInterval).listen((event) {
        _gyroscopeEvent = event;
        // If accelerometer data is available, save both sensor data
        if (_accelerometerEvent != null) {
          controller.saveSensorData(_accelerometerEvent, _gyroscopeEvent);
        }
      });
    });

    // Listen for the event to stop the background service
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

  }
}