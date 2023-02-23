import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:research_buddy/models/project.dart';

class RecordGeoPointFieldTile extends StatelessWidget {
  final ProjectField field;
  final dynamic value;

  const RecordGeoPointFieldTile(
      {Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value is! GeoPoint) {
      return ListTile(
        title: const Text("Location Not Set"),
        subtitle: Text(field.name),
      );
    }

    return ListTile(
      title: Text("${value.latitude}, ${value.longitude} (Tap to open)"),
      subtitle: Text(field.name),
      trailing: const Icon(Icons.open_in_browser),
      onTap: () async {
        final mapsUrl =
            "https://www.google.com/maps/search/?api=1&query=${value.latitude},${value.longitude}";
        final uri = Uri.encodeFull(mapsUrl);
        await launch(uri);
      },
    );
  }
}
