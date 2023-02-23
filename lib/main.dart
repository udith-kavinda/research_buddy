import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:research_buddy/views/helpers/background_upload.dart';
import 'package:research_buddy/views/helpers/dynamic_links.dart';
import 'package:research_buddy/views/home/home.dart';
import 'package:research_buddy/views/login.dart';
import 'package:research_buddy/views/projects/add_project.dart';
import 'package:research_buddy/views/projects/detail_project.dart';
import 'package:research_buddy/views/projects/list_blacklisted.dart';
import 'package:research_buddy/views/projects/lists.dart';
import 'package:research_buddy/views/records/add_record.dart';
import 'package:research_buddy/views/records/detail_record.dart';
import 'package:research_buddy/views/records/list_record.dart';
import 'package:research_buddy/views/records/list_upload_tasks.dart';
import 'package:research_buddy/views/register.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final loggedInUser = await FirebaseAuth.instance.userChanges().first;
  BackgroundUpload.initialize();
  runApp(MyApp(loggedIn: loggedInUser != null));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  late final BeamerDelegate routerDelegate;

  MyApp({Key? key, required this.loggedIn}) : super(key: key) {
    routerDelegate = BeamerDelegate(
      initialPath: loggedIn ? '/home' : '/login',
      locationBuilder: RoutesLocationBuilder(
          routes: {
            '/login': (context, state, data) => const LoginPage(),
            '/register': (context, state, data) => const RegisterPage(),
            '/home': (context, state, data) => const HomePage(),
            '/home/add-project': (context, state, data) =>
                const AddProjectPage(),
            '/home/my-projects': (context, state, data) =>
                const ListMyProjects(),
            '/home/private-projects': (context, state, data) =>
                const ListPrivateProjects(),
            '/home/public-projects': (context, state, data) =>
                const ListPublicProjects(),
            '/home/project/:projectId': (context, state, data) {
              final projectId = state.pathParameters['projectId']!;
              return BeamPage(
                key: ValueKey('details$projectId'),
                title: projectId,
                popToNamed: '/home',
                child: DetailProjectPage(projectId: projectId),
              );
            },
            '/home/project/:projectId/record/add': (context, state, data) {
              final projectId = state.pathParameters['projectId']!;
              return BeamPage(
                key: ValueKey('recordAdd$projectId'),
                title: projectId,
                popToNamed: '/home/project/$projectId',
                child: AddRecordPage(projectId: projectId),
              );
            },
            '/home/project/:projectId/records': (context, state, data) {
              final projectId = state.pathParameters['projectId']!;
              return BeamPage(
                key: ValueKey('recordList$projectId'),
                title: projectId,
                child: ListRecordPage(projectId: projectId),
              );
            },
            '/home/project/:projectId/records/:recordId':
                (context, state, data) {
              final projectId = state.pathParameters['projectId']!;
              final recordId = state.pathParameters['recordId']!;
              return BeamPage(
                key: ValueKey('recordDetails$recordId'),
                title: recordId,
                child:
                    DetailRecordPage(projectId: projectId, recordId: recordId),
              );
            },
            '/home/project/:projectId/blacklisted': (context, state, data) {
              final projectId = state.pathParameters['projectId']!;
              return BeamPage(
                key: ValueKey('blacklistedUsersList$projectId'),
                title: projectId,
                child: BlacklistedUserListPage(projectId: projectId),
              );
            },
            '/home/record-assets': (context, state, data) =>
                const UploadTaskList(),
          },
          builder: (context, child) {
            initDynamicLinks(context);
            return child;
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
        ],
        title: 'Research Buddy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            secondary: Colors.red,
          ),
          useMaterial3: false,
        ),
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
        backButtonDispatcher:
            BeamerBackButtonDispatcher(delegate: routerDelegate),
      ),
    );
  }
}
