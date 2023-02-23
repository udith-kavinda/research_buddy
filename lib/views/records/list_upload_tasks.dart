import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:research_buddy/views/helpers/background_upload.dart';

class UploadTaskList extends StatelessWidget {
  const UploadTaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Record Assets")),
        body: FutureBuilder<List<UploadJob>>(
          future: SharedPreferences.getInstance()
              .then((prefs) => BackgroundUpload.getAllTasks(prefs)),
          builder: (context, snapshot) {
            if (snapshot.hasData && (snapshot.data?.isNotEmpty ?? false)) {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].filePath.length > 25
                      ? "...${data[index].filePath.substring(data[index].filePath.length - 25)}"
                      : data[index].filePath),
                  trailing: Icon(
                    data[index].isUploaded
                        ? Icons.check_circle
                        : Icons.hourglass_bottom,
                    color: data[index].isUploaded ? Colors.green : Colors.blue,
                  ),
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Text("Nothing to show."),
            );
          },
        ),
      ),
    );
  }
}
