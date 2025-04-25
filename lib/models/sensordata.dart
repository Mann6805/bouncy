import 'package:hive/hive.dart';

// This part is required for Hive to generate the adapter code for this class.
part 'sensordata.g.dart';

// This annotation tells Hive that this class is a Hive object and it will be stored in a Hive box.
@HiveType(typeId: 0)
class Sensordata {

  // These are the fields that will be stored in the Hive database.
  // @HiveField(0) marks this field as a part of the data structure

  @HiveField(0)
  double acex;  // X-axis acceleration data from the accelerometer.

  @HiveField(1)
  double acey;  // Y-axis acceleration data from the accelerometer.

  @HiveField(2)
  double gyroz; // Z-axis gyroscope data (rotation on Z-axis).

  @HiveField(3)
  int timestamp;  // The timestamp when the sensor data was recorded.

  Sensordata({required this.acex, required this.acey, required this.gyroz, required this.timestamp});
}