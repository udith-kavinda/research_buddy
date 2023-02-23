import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:research_buddy/models/project.dart';

bool isAllowedToAddRecord(
    DocumentReference<Map<String, dynamic>> userRef, Project project) {
  // If private, must be in allowed users, but not in blacklisted
  if (project.isPrivate) {
    if (project.blacklistedUsers.contains(userRef)) {
      return false;
    }
    if (!project.allowedUsers.contains(userRef)) {
      return false;
    }
    return true;
  }

  // If public, must not be in blacklisted
  if (project.blacklistedUsers.contains(userRef)) {
    return false;
  }
  return true;
}

bool isAllowedToView(
    DocumentReference<Map<String, dynamic>> userRef, Project project) {
  // if public, then allowed
  if (!project.isPrivate) {
    return true;
  }

  // if project owner, then allowed
  if (project.owner.id == userRef.id) {
    return true;
  }

  // if user in project's allowed users, then allowed
  if (project.allowedUsers.contains(userRef)) {
    return true;
  }
  return false;
}
