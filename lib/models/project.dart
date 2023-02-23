import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:research_buddy/models/utils/reference.dart';

part 'project.g.dart';

@JsonSerializable(explicitToJson: true)
@FirestoreReference()
class Project {
  final String name;
  final String description;
  final DocumentReference<Map<String, dynamic>> owner;
  final String? imageUrl;
  final bool isPrivate;
  final bool isPublished;
  final String? entryCode;
  final List<DocumentReference<Map<String, dynamic>>> allowedUsers;
  final List<DocumentReference<Map<String, dynamic>>> blacklistedUsers;
  final List<ProjectField> fields;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Project({
    required this.name,
    required this.description,
    required this.owner,
    required this.imageUrl,
    required this.isPrivate,
    required this.isPublished,
    required this.entryCode,
    required this.allowedUsers,
    required this.blacklistedUsers,
    required this.fields,
  });

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  List<String> fieldHeaders() => fields.map((e) => e.name).toList();
}

@JsonSerializable(explicitToJson: true)
class ProjectField {
  final String name;
  final ProjectFieldType type;
  final String? helperText;
  final List<ProjectFieldValidator> validators;
  final List<String>? options;

  factory ProjectField.fromJson(Map<String, dynamic> json) =>
      _$ProjectFieldFromJson(json);

  ProjectField({
    required this.name,
    required this.type,
    required this.helperText,
    required this.validators,
    required this.options,
  });

  Map<String, dynamic> toJson() => _$ProjectFieldToJson(this);
}

@JsonSerializable()
class ProjectFieldValidator {
  final ProjectFieldValidatorType type;
  final dynamic value;

  factory ProjectFieldValidator.fromJson(Map<String, dynamic> json) =>
      _$ProjectFieldValidatorFromJson(json);

  ProjectFieldValidator({
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toJson() => _$ProjectFieldValidatorToJson(this);
}

enum ProjectFieldType {
  @JsonValue('STRING')
  string,
  @JsonValue('NUMERIC')
  numeric,
  @JsonValue('LOCATION')
  location,
  @JsonValue('LOCATION_SERIES')
  locationSeries,
  @JsonValue('MOTION_SENSOR_SERIES')
  motionSensorSeries,
  @JsonValue('AMBIENT_SENSOR_SERIES')
  ambientSensorSeries,
  @JsonValue('IMAGE')
  image,
  @JsonValue('VIDEO')
  video,
  @JsonValue('AUDIO')
  audio,
  @JsonValue('TEXT')
  text,
  @JsonValue('BOOLEAN')
  boolean,
  @JsonValue('DATETIME')
  dateTime,
  @JsonValue('DATE')
  date,
  @JsonValue('TIME')
  time,
  @JsonValue('DROPDOWN')
  dropdown,
  @JsonValue('RADIO')
  radio,
  @JsonValue('CHECKBOXES')
  checkBoxes,
}

enum ProjectFieldValidatorType {
  @JsonValue('REQUIRED')
  required,
  @JsonValue('EMAIL')
  email,
  @JsonValue('INTEGER')
  integer,
  @JsonValue('MATCH')
  match,
  @JsonValue('MAX')
  max,
  @JsonValue('MIN')
  min,
  @JsonValue('MAXLENGTH')
  maxLength,
  @JsonValue('MINLENGTH')
  minLength,
  @JsonValue('URL')
  url,
}

// --------------------- Series Data Models ------------------------------------

class SeriesDataPoint<T> {
  final DateTime timestamp;
  final T dataPoint;

  SeriesDataPoint._(this.timestamp, this.dataPoint);

  factory SeriesDataPoint(T dataPoint) {
    return SeriesDataPoint._(DateTime.now(), dataPoint);
  }

  String toRepr() {
    final dataPoint = this.dataPoint;
    if (dataPoint is Position) {
      return "${timestamp.toIso8601String()}|${dataPoint.longitude}|${dataPoint.latitude}";
    }
    if (dataPoint is MotionSensorData) {
      return "${timestamp.toIso8601String()}|${dataPoint.toRepr()}";
    }
    if (dataPoint is AmbientSensorData) {
      return "${timestamp.toIso8601String()}|${dataPoint.toRepr()}";
    }
    throw UnimplementedError();
  }
}

class MotionSensorData {
  final List<double> accelerometer;
  final List<double> linearAcceleration;
  final List<double> magneticField;
  final List<double> gravity;
  final List<double> gyroscope;
  final List<double> rotationVector;

  MotionSensorData({
    required this.accelerometer,
    required this.linearAcceleration,
    required this.magneticField,
    required this.gravity,
    required this.gyroscope,
    required this.rotationVector,
  });

  factory MotionSensorData.fromMap(Map<String, List<Object?>> map) {
    return MotionSensorData(
      accelerometer: List<double>.from(map['accelerometer']!),
      linearAcceleration: List<double>.from(map['linearAcceleration']!),
      magneticField: List<double>.from(map['magneticField']!),
      gravity: List<double>.from(map['gravity']!),
      gyroscope: List<double>.from(map['gyroscope']!),
      rotationVector: List<double>.from(map['rotationVector']!),
    );
  }

  String toRepr() {
    return "${accelerometer.join('|')}|${linearAcceleration.join('|')}"
        "|${magneticField.join('|')}|${gravity.join('|')}"
        "|${gyroscope.join('|')}|${rotationVector.join('|')}";
  }
}

class AmbientSensorData {
  final double ambientTemperature;
  final double light;
  final double pressure;
  final double proximity;
  final double relativeHumidity;

  AmbientSensorData({
    required this.ambientTemperature,
    required this.light,
    required this.pressure,
    required this.proximity,
    required this.relativeHumidity,
  });

  factory AmbientSensorData.fromMap(Map<String, Object?> map) {
    return AmbientSensorData(
      ambientTemperature: map['ambientTemperature'] as double,
      light: map['light'] as double,
      pressure: map['pressure'] as double,
      proximity: map['proximity'] as double,
      relativeHumidity: map['relativeHumidity'] as double,
    );
  }

  String toRepr() {
    return "$ambientTemperature|$light|$pressure|$proximity|$relativeHumidity";
  }
}
