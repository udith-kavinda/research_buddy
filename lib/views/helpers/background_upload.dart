import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';
import 'package:research_buddy/firebase_options.dart';

class UploadJob {
  final String id;
  bool isUploaded;
  final String filePath;
  final String storagePath;

  UploadJob({
    required this.filePath,
    required this.storagePath,
    this.isUploaded = false,
  }) : id = const Uuid().v4();

  factory UploadJob.fromJson(Map<String, dynamic> data) {
    return UploadJob(
      isUploaded: data['isUploaded'] as bool,
      filePath: data['filePath'] as String,
      storagePath: data['storagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isUploaded': isUploaded,
      'filePath': filePath,
      'storagePath': storagePath,
    };
  }

  String toSerialized() {
    return json.encode(toJson());
  }

  static List<UploadJob> getAll(SharedPreferences prefs) {
    final String? tasks = prefs.getString('tasks');
    print('tasks: $tasks');
    if (tasks == null) {
      return [];
    }
    return (json.decode(tasks) as List)
        .map((item) => UploadJob.fromJson(item))
        .toList();
  }

  Future<bool> save(SharedPreferences prefs) async {
    final tasks = getAll(prefs);
    final i = tasks.indexOf(this);
    if (i == -1) {
      tasks.add(this);
    } else {
      tasks[i] = this;
    }
    return await prefs.setString('tasks', json.encode(tasks));
  }

  @override
  bool operator ==(Object other) {
    return other is UploadJob && hashCode == other.hashCode;
  }

  @override
  int get hashCode => id.hashCode;
}

class BackgroundUpload {
  static const ttSingleTask = "TT_SINGLE_TASK";
  static const ttStartupTask = "TT_STARTUP_TASK";
  static const ttTestTask = "TT_TEST_TASK";
  static const retryCount = 3;

  const BackgroundUpload._();

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    _dispatchStartupTask();
    _dispatchTestTask();
  }

  static void dispatchBackgroundUploadTask(UploadJob task) {
    Workmanager().registerOneOffTask(
      const Uuid().v4(),
      ttSingleTask,
      inputData: task.toJson(),
    );
  }

  static void _dispatchStartupTask() {
    Workmanager().registerOneOffTask("2", ttStartupTask, inputData: {});
  }

  static void _dispatchTestTask() {
    Workmanager().registerOneOffTask("3", ttTestTask, inputData: {});
  }

  static List<UploadJob> getAllTasks(SharedPreferences prefs) {
    return UploadJob.getAll(prefs);
  }

  static Future<bool> handleStartupTask(SharedPreferences prefs,
      FirebaseStorage storage, Map<String, dynamic>? data) async {
    final tasks = getAllTasks(prefs);
    for (var task in tasks) {
      if (!task.isUploaded) {
        await _uploadTask(prefs, storage, task);
      }
    }
    print("Startup task finished");
    return true;
  }

  static Future<bool> handleSingleTask(SharedPreferences prefs,
      FirebaseStorage storage, Map<String, dynamic> data) async {
    final task = UploadJob.fromJson(data);
    await task.save(prefs);
    await _uploadTask(prefs, storage, task);
    return true;
  }

  static Future<bool> handleTestTask(Map<String, dynamic>? data) async {
    print("=============Test task==============");
    return true;
  }

  static Future<void> _uploadTask(
      SharedPreferences prefs, FirebaseStorage storage, UploadJob task) async {
    for (var i = 0; i < retryCount; i++) {
      final uploadDone = await _upload(storage, task);
      if (uploadDone) {
        task.isUploaded = true;
        await task.save(prefs);
        break;
      }
    }
  }

  static Future<bool> _upload(FirebaseStorage storage, UploadJob task) async {
    try {
      print("Uploading ${task.filePath} to ${task.storagePath}");
      print("Name ${storage.app.options}");
      print("Ref ${storage.ref(task.storagePath)}");
      await storage.ref(task.storagePath).putFile(File(task.filePath));
      print("Uploaded");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

void callbackDispatcher() {
  Workmanager().executeTask(
    (task, inputData) async {
      //simpleTask will be emitted here.
      try {
        print("Native called background task: $task");
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
        final storage = FirebaseStorage.instance;
        if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
        final prefs = await SharedPreferences.getInstance();
        print("Got shared prefs: ${prefs.getKeys()}");
        switch (task) {
          case BackgroundUpload.ttSingleTask:
            return BackgroundUpload.handleSingleTask(
                prefs, storage, inputData!);
          case BackgroundUpload.ttStartupTask:
            return BackgroundUpload.handleStartupTask(
                prefs, storage, inputData);
          case BackgroundUpload.ttTestTask:
            return BackgroundUpload.handleTestTask(inputData);
        }
      } catch (e) {
        print(e);
      }
      return Future.value(true);
    },
  );
}
