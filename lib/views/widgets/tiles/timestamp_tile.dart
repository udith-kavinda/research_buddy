import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:research_buddy/models/project.dart';

class RecordTimestampFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordTimestampFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! Timestamp) {
      return ListTile(
        title: const Text("Date/Time Not Set"),
        subtitle: Text(field.name),
      );
    }

    String timeStr = DateFormat('yyyy-MM-dd - kk:mm:ss').format(value.toDate());
    if (field.type == ProjectFieldType.date) {
      timeStr = DateFormat('yyyy-MM-dd').format(value.toDate());
    } else if (field.type == ProjectFieldType.time) {
      timeStr = DateFormat('kk:mm:ss').format(value.toDate());
    }
    return ListTile(
      title: Text(timeStr),
      subtitle: Text(field.name),
    );
  }
}
