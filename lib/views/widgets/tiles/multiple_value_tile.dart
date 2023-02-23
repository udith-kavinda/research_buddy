import 'package:flutter/material.dart';
import 'package:research_buddy/models/project.dart';

class RecordMultipleValueFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordMultipleValueFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! String) {
      return ListTile(
        title: const Text("Nothing Selected"),
        subtitle: Text(field.name),
      );
    }

    return ListTile(
      title: Text(value),
      subtitle: Text(field.name),
    );
  }
}
