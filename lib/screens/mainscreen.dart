import 'dart:async';
import 'package:bouncy/controllers/sensordatacontroller.dart';
import 'package:bouncy/widgets/exitdpopup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Mainscreen extends StatefulWidget {
  Size size;
  Mainscreen({super.key, required this.size});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> with WidgetsBindingObserver {

  // Variables for sensor event subscriptions.
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  AccelerometerEvent? _accelerometerEvent;

  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  GyroscopeEvent? _gyroscopeEvent;

  // Variables for the positions of images on the screen.
  late double _image1X;
  late double _image1Y;
  late double _image2X;
  late double _image2Y;

  // Variable for the save status.
  late String shouldSave;

  // Variable for rotation along Z-axis.
  double _rotationZ = 0.0;

  // Factors for movement and thresholds for sensor input.
  final double _movementFactor = 3.0;
  final double _movementThreshold = 0.3;

  // Controller instance to interact with the sensor data controller.
  late final Sensordatacontroller controller;  

  @override
  void initState() {
    super.initState();

    // Add the widget as an observer of app lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Center the image
    _image1X = (widget.size.width - 50) / 2  + 50;
    _image1Y = widget.size.height / 2;
    _image2X = (widget.size.width - 50) / 2 - 100;
    _image2Y = widget.size.height / 2;

    // Instantiate the sensor data controller.
    controller = Sensordatacontroller();
    
    // Start recording sensor data.
    startRecording();
    
  }

  @override
  void dispose() {
    // Remove the app lifecycle observer and stop sensor data recording when the widget is disposed.
    WidgetsBinding.instance.removeObserver(this);
    stopRecording();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,  // Disable the back navigation on this screen.
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _gyroscopeEvent == null && _accelerometerEvent == null 
        ? const Center(child: Text("System doesn't support gyroscope and accelerometer"))
        : Stack(
          children: [
            // Positioned images that move based on accelerometer input.
            Positioned(
              left: _image1X,
              top: _image1Y,
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/pika.png")
              )
            ),
            Positioned(
              left: _image2X,
              top: _image2Y,
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/bulba.png")
              )
            ),
            
            // Rotating image based on gyroscope input.
            Center(
              child: Transform.rotate(
                angle: _rotationZ,
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/snorlax.png"),
                ),
              ),
            ),
            // Back button with an exit confirmation dialog.
            Positioned(
              top: 25.h,
              left: 10.w,
              child: IconButton(
                onPressed: () async {
                  stopRecording();
                  final shouldSave = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const ExitPopup(),
                  ) ;
                  if (shouldSave == 'delete'){
                    await controller.deleteSensorData();
                  }
                  await Future.delayed(const Duration(milliseconds: 500));
                  startRecording();
                }, 
                icon: const Icon(Icons.arrow_back_ios)
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Stop recording sensor data by canceling subscriptions.
  void stopRecording() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }

  // Start recording sensor data and update the UI based on sensor input.
  void startRecording() {
    _accelerometerSubscription = SensorsPlatform.instance.accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval).listen((event) {

      if (!mounted) return;
      setState(() {
        _accelerometerEvent = event;

        // Move the images based on accelerometer data.
        if (event.x.abs() > _movementThreshold || event.y.abs() > _movementThreshold) {
          final orientation = MediaQuery.of(context).orientation;
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          double dx, dy;

          // Adjust image positions based on device orientation.
          if (orientation == Orientation.portrait) {
            dx = -event.x;
            dy = event.y;
          } else {
            dx = event.y;
            dy = event.x;
          }

          _image1X += dx * _movementFactor;
          _image1Y += dy * _movementFactor;


          _image1X = _image1X.clamp(0.0, screenWidth - 100.w);
          _image1Y = _image1Y.clamp(0.0, screenHeight - 100.h);

          _image2X += dx * _movementFactor * 0.8;
          _image2Y += dy * _movementFactor * 0.8;

          _image2X = _image2X.clamp(0.0, screenWidth - 100.w);
          _image2Y = _image2Y.clamp(0.0, screenHeight - 100.h);
        }

        // Save sensor data.
        controller.saveSensorData(_accelerometerEvent, _gyroscopeEvent);
      });
    });

    _gyroscopeSubscription = SensorsPlatform.instance.gyroscopeEventStream(samplingPeriod: SensorInterval.gameInterval,).listen((event) {
      if (!mounted) return;

      setState(() {
        _gyroscopeEvent = event;

        // Update the rotation angle based on gyroscope data.
        if (event.z.abs() > _movementThreshold / 10) {
          _rotationZ += event.z * _movementThreshold;
        }

        // Save sensor data.
        controller.saveSensorData(_accelerometerEvent, _gyroscopeEvent);
      });
    });
  }

  // Handle app lifecycle changes (e.g., background/foreground).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('App is in foreground.');
      FlutterBackgroundService().invoke('stopService');
    } else if (state == AppLifecycleState.paused) {
      debugPrint('App is in background.');
      FlutterBackgroundService().invoke('startService');
    }
  }

}