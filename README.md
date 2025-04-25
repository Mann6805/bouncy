# Bouncy App - Sensor Data Controller

This project implements a **SensorDataController** in Flutter to handle accelerometer and gyroscope data. The data is managed using **Hive** for local storage, allowing efficient storage, retrieval, and deletion of sensor data.

## Features
- **Save Sensor Data**: Capture accelerometer and gyroscope sensor data and store it in a local database.
- **Delete Sensor Data**: Clear all sensor data from the local storage.
- **Paginated Data Fetching**: Retrieve sensor data efficiently with pagination to manage large datasets.

## Libraries Used
- [Hive](https://pub.dev/packages/hive): A fast and lightweight local database.
- [sensors_plus](https://pub.dev/packages/sensors_plus): A Flutter plugin for accessing accelerometer and gyroscope sensor data.
- [quickanimate](https://pub.dev/packages/quickanimate): A Flutter package for animations to enhance user interface.

## Code Overview

### `SensorDataController`
The `SensorDataController` is the main class responsible for managing sensor data. It provides methods to:
- **Save sensor data**: Captures accelerometer and gyroscope data and stores it in the `Hive` database.
- **Delete all sensor data**: Clears all data stored in the database.
- **Fetch sensor data with pagination**: Retrieves data in chunks, improving performance when dealing with large datasets.

### `SensorData` Model
The `SensorData` class defines the structure of the sensor data being stored:
- **Accelerometer data**: X and Y axis values.
- **Gyroscope data**: Z axis value.
- **Timestamp**: The time the data was captured.

### `Background` Service
- **Initialization**: Configures a background service using the flutter_background_service package to run Dart code continuously, even when the application is closed.
- **Sensor Data Collection**: Listens to accelerometer and gyroscope events and saves the data using the SensorDataController.
- **Service Management**: Provides functionality to start and stop the background service.

## Working Demo
https://github.com/user-attachments/assets/e4331e6a-ffdc-4607-a8ea-13fde529624e
