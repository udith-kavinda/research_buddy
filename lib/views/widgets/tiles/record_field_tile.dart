import 'package:flutter/material.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/widgets/tiles/boolean_tile.dart';
import 'package:research_buddy/views/widgets/tiles/file_tile.dart';
import 'package:research_buddy/views/widgets/tiles/geo_point_tile.dart';
import 'package:research_buddy/views/widgets/tiles/multiple_value_tile.dart';
import 'package:research_buddy/views/widgets/tiles/table_tile.dart';
import 'package:research_buddy/views/widgets/tiles/timestamp_tile.dart';

class RecordFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordFieldTile({Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (field.type == ProjectFieldType.location) {
      return RecordGeoPointFieldTile(field: field, value: value);
    }
    if (field.type == ProjectFieldType.boolean) {
      return RecordBooleanFieldTile(field: field, value: value == "true");
    }
    if (field.type == ProjectFieldType.date ||
        field.type == ProjectFieldType.dateTime ||
        field.type == ProjectFieldType.time) {
      return RecordTimestampFieldTile(field: field, value: value);
    }
    if (field.type == ProjectFieldType.video ||
        field.type == ProjectFieldType.audio ||
        field.type == ProjectFieldType.image) {
      return RecordFileFieldTile(field: field, value: value);
    }
    if (field.type == ProjectFieldType.locationSeries) {
      return RecordTableFieldTile(
          field: field,
          columnNames: const ["Time", "Longitude", "Latitude"],
          value: value);
    }
    if (field.type == ProjectFieldType.motionSensorSeries) {
      return RecordTableFieldTile(
          field: field,
          columnNames: const [
            "Time",
            "Accelerometer/x (m/s^-2)",
            "Accelerometer/y (m/s^-2)",
            "Accelerometer/z (m/s^-2)",
            "Linear Acceleration/x (m/s^-2)",
            "Linear Acceleration/y (m/s^-2)",
            "Linear Acceleration/z (m/s^-2)",
            "Magnetic Field/x (µT)",
            "Magnetic Field/y (µT)",
            "Magnetic Field/z (µT)",
            "Gravity/x (m/s-2)",
            "Gravity/y (m/s-2)",
            "Gravity/z (m/s-2)",
            "Gyroscope/x (rad/s)",
            "Gyroscope/y (rad/s)",
            "Gyroscope/z (rad/s)",
            "Rotation Vector/x*sin(θ/2) (rad/s)",
            "Rotation Vector/y*sin(θ/2) (rad/s)",
            "Rotation Vector/z*sin(θ/2) (rad/s)",
            "Rotation Vector/cos(θ/2) (rad/s)",
            "Rotation Vector/accuracy (rad/s)",
          ],
          value: value);
    }
    if (field.type == ProjectFieldType.ambientSensorSeries) {
      return RecordTableFieldTile(
          field: field,
          columnNames: const [
            "Time",
            "Temperature (°C)",
            "Light (lux)",
            "Pressure (hPa)",
            "Proximity (cm)",
            "Relative Humidity (%)"
          ],
          value: value);
    }
    if (field.type == ProjectFieldType.checkBoxes) {
      return RecordMultipleValueFieldTile(field: field, value: value);
    }
    return ListTile(
      title: Text(value.toString()),
      subtitle: Text(field.name),
    );
  }
}
