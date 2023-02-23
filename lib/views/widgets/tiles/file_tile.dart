import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:research_buddy/models/project.dart';
import 'package:research_buddy/views/helpers/snackbar_messages.dart';

class RecordFileFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordFileFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! String) {
      return ListTile(
        title: const Text("File Not Set"),
        subtitle: Text(field.name),
      );
    }

    return ListTile(
      title: Text(field.name),
      subtitle: const Text("Tap to open"),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () async {
        try {
          final url =
              await FirebaseStorage.instance.ref(value).getDownloadURL();
          await launch(url);
        } catch (e) {
          showErrorMessage(context, "File is not uploaded correctly");
        }
      },
    );
  }
}
