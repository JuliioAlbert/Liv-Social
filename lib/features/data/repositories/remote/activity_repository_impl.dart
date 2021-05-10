import 'dart:io';

import 'package:liv_social/core/exceptions/activity_exception.dart';
import 'package:liv_social/features/data/datasource/firestore_database.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';
import 'package:liv_social/features/domain/repositories/cloud_storage_repository.dart';
import 'package:uuid/uuid.dart';

class ActivityRepositoryImpl extends ActivityRepository {
  final FirestoreDatabase _firestoreDatabase;
  final CloudStorageRepository _cloudStorageRepository;
  final uuid = const Uuid();

  ActivityRepositoryImpl(this._firestoreDatabase, this._cloudStorageRepository);

  @override
  Future<Activity> createActivity(Activity activity, File? image) async {
    try {
      activity.uid = uuid.v4();
      var imageURL = '';
      if (image != null) {
        imageURL = await _cloudStorageRepository.uploadFile(
            image, 'activity/${activity.ownerId}');
      }
      if (imageURL.isNotEmpty) {
        activity.image = imageURL;
      }
      return await _firestoreDatabase.createActivity(activity);
    } catch (e) {
      throw CreateActivityFailure();
    }
  }

  @override
  Future<bool> deleteActivity(Activity activity) async {
    try {
      await _firestoreDatabase.deleteActivity(activity);
      return true;
    } catch (e) {
      throw DeleteActivityFailure();
    }
  }

  @override
  Future<List<Activity>> getActivities() async {
    try {
      return await _firestoreDatabase.getActivities();
    } catch (e) {
      throw GetActivitiesFailure();
    }
  }

  @override
  Future<Activity> getActivityById(String id) async =>
      await _firestoreDatabase.findActivityById(id);

  @override
  Future<bool> updateActivity(Activity activity) async {
    try {
      await _firestoreDatabase.updateActivity(activity);
      return true;
    } catch (e) {
      throw UpdateActivityFailure();
    }
  }
}
