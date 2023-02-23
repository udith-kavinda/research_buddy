import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FirestoreGeoPoint implements JsonConverter<GeoPoint, GeoPoint> {
  const FirestoreGeoPoint();

  @override
  GeoPoint fromJson(GeoPoint geoPoint) => geoPoint;

  @override
  GeoPoint toJson(GeoPoint geoPoint) => geoPoint;
}
