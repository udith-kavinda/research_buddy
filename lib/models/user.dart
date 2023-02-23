import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:research_buddy/models/utils/reference.dart';

part 'user.g.dart';

@JsonSerializable()
@FirestoreReference()
class User {
  final String name;
  final String email;
  final List<DocumentReference<Map<String, dynamic>>> allowedPrivateProjects;

  User(
      {required this.name,
      required this.email,
      this.allowedPrivateProjects = const []});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
