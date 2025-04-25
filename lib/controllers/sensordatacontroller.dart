import 'package:bouncy/models/sensordata.dart';
import 'package:hive/hive.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Sensordatacontroller {
  late Box<Sensordata> sensorDataBox;

  // Constructor to initialize the sensorDataBox. It uses the 'sensorDataBox' name.
  Sensordatacontroller(){
    sensorDataBox = Hive.box<Sensordata>('sensorDataBox');
  }

  // Method to save sensor data (accelerometer and gyroscope readings).
  void saveSensorData(AccelerometerEvent? accelerometerEvent, GyroscopeEvent? gyroscopeEvent) {

    // If either the accelerometer or gyroscope event is null, exit the method.
    if (accelerometerEvent == null || gyroscopeEvent == null) {
      return;
    }

    // Create a new Sensordata object with the provided sensor readings.
    final sensordata = Sensordata(
      acex: accelerometerEvent.x,
      acey: accelerometerEvent.y,
      gyroz: gyroscopeEvent.z,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    // Add the newly created Sensordata object to the Hive box.
    sensorDataBox.add(sensordata);

  }

  // Method to delete all sensor data from the Hive box.
  Future<void> deleteSensorData() async {
    await sensorDataBox.clear();
  }

  // Method to fetch sensor data with pagination.
  Future<List<Sensordata>> fetchSensorData(int pageKey, int pageSize) async {

    // Calculate the start and end indices for fetching the data.
    final startIndex = pageKey * pageSize;
    final endIndex = startIndex + pageSize;

    // Loop through the range of indices to fetch the corresponding sensor data.
    final List<Sensordata> newItems = [];
    for (int i = startIndex; i < endIndex; i++) {
      if (i >= sensorDataBox.length) break;
      newItems.add(sensorDataBox.getAt(sensorDataBox.length - i)!);
    }

    return newItems;  // Return the list of fetched sensor data.
  }

}
