import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageImage extends StatelessWidget {
  final String? storageUrl;

  const StorageImage({Key? key, required this.storageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: storageUrl == null
          ? Future.value()
          : FirebaseStorage.instance.ref(storageUrl).getDownloadURL(),
      builder: (context, urlSnapshot) {
        final url = urlSnapshot.data;
        if (url == null) {
          return Container(
            color: Colors.black,
            height: 300,
            width: MediaQuery.of(context).size.width,
          );
        }
        return Image.network(
          url,
          fit: BoxFit.cover,
          color: Colors.black.withAlpha(127),
          colorBlendMode: BlendMode.srcOver,
          height: 300,
          width: MediaQuery.of(context).size.width,
        );
      },
    );
  }
}
