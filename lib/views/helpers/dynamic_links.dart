import 'package:beamer/beamer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';

Future<Uri> getPrivateProjectDynamicLink(String projectId) async {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final DynamicLinkParameters parameters = DynamicLinkParameters(
    // The Dynamic Link URI domain. You can view created URIs on your Firebase console
    uriPrefix: 'https://researchbuddy.page.link',
    // The deep Link passed to your application which you can use to affect change
    link: Uri.parse(
      'https://example.com/privateproject/?id=$projectId',
    ),
    // Android application details needed for opening correct app on device/Play Store
    androidParameters: const AndroidParameters(
      packageName: "com.example.research_buddy",
      minimumVersion: 1,
    ),
  );
  final shortLink = await dynamicLinks.buildShortLink(parameters);
  print(shortLink);
  return shortLink.shortUrl;
}

Future<void> initDynamicLinks(BuildContext context) async {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
  if (initialLink != null) {
    _handleDynamicLink(initialLink, context);
  }

  dynamicLinks.onLink.listen((dynamicLinkData) {
    print(dynamicLinkData);
    _handleDynamicLink(dynamicLinkData, context);
  }).onError((error) {
    print('onLink error');
    print(error.message);
  });
}

void _handleDynamicLink(
    PendingDynamicLinkData data, BuildContext context) async {
  final Uri deepLink = data.link;

  print(deepLink);
  if (deepLink.pathSegments.contains('privateproject')) {
    var projectId = deepLink.queryParameters['id'];
    if (projectId != null) {
      print("project ID=$projectId");
      Beamer.of(context).beamToNamed("/home/project/$projectId");
    }
  }
}
