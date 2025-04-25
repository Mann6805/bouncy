import 'dart:ui';
import 'package:bouncy/models/sensordata.dart';
import 'package:bouncy/screens/homescreen.dart';
import 'package:bouncy/services/backgroundservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // Ensures that Flutter bindings and Dart plugins are initialized before the app runs
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Initializes Hive for local storage
  await Hive.initFlutter();
  Hive.registerAdapter(SensordataAdapter());
  await Hive.openBox<Sensordata>('sensorDataBox');

  // Initializes the background service for any background tasks
  await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit provides screen size adjustments for different screen resolutions
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bouncy',
          theme: ThemeData(
            useMaterial3: true,
          ),
          builder: (context, widget) {
            // Customizes the text scaling factor for the app
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          home: child,
        );
      },
      child: const Homescreen(),
    );
  }
}
