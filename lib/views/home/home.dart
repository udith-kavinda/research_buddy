import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:research_buddy/views/helpers/firebase_builders.dart';
import 'package:research_buddy/views/helpers/get_projects.dart';
import 'package:research_buddy/views/home/list_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Research Buddy"),
          backgroundColor: Colors.blue,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Projects', icon: Icon(Icons.my_library_books)),
              Tab(text: 'Private Projects', icon: Icon(Icons.person)),
              Tab(text: 'Public Project', icon: Icon(Icons.public))
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Beamer.of(context).beamingHistory.clear();
              Beamer.of(context).beamToNamed("/login");
            },
            child: Icon(
              Icons.logout, // add custom icons also
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FirebaseUserStreamBuilder(
                builder: (context, currentUserId) => SingleChildScrollView(
                  child: Column(
                    children: [
                      HomeProjectListSection(
                        title: "My Projects",
                        path: '/home/my-projects',
                        query: getMyProjects(currentUserId),
                      ),
                      // ListMyProjects(),
                    ],
                  ),
                )
            ),
            FirebaseUserStreamBuilder(
                builder: (context, currentUserId) => SingleChildScrollView(
                  child: Column(
                    children: [
                      HomeProjectListSection(
                        title: "Private Projects",
                        path: '/home/private-projects',
                        query: getPrivateProjects(currentUserId),
                      ),
                    ],
                  ),
                )
            ),
            FirebaseUserStreamBuilder(
                builder: (context, currentUserId) => SingleChildScrollView(
                  child: Column(
                    children: [
                      HomeProjectListSection(
                        title: "Public Projects",
                        path: '/home/public-projects',
                        max: 3,
                        query: getPublicProjects(),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/home/add-project');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
