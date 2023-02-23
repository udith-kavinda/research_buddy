import 'package:flutter/services.dart';
import 'package:research_buddy/models/project.dart';

class SensorProvider {
  static const platform =
      MethodChannel('com.example.research-buddy/methodChannel');

  static Future<MotionSensorData> getMotionSensorData() async {
    final values = await platform.invokeMethod('getMotionSensorValues');
    return MotionSensorData.fromMap(Map<String, List<Object?>>.from(values));
  }

  static Future<AmbientSensorData> getAmbientSensorData() async {
    final values = await platform.invokeMethod('getAmbientSensorValues');
    return AmbientSensorData.fromMap(Map<String, Object?>.from(values));
  }
}
