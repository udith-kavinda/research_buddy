import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class FirestoreTimestamp implements JsonConverter<Timestamp, Timestamp> {
  const FirestoreTimestamp();

  @override
  Timestamp fromJson(Timestamp timestamp) => timestamp;

  @override
  Timestamp toJson(Timestamp timestamp) => timestamp;
}
