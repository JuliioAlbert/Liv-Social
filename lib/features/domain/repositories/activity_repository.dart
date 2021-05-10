import 'dart:io';

import 'package:liv_social/features/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<List<Activity>> getActivities();

  Future<Activity> getActivityById(String id);

  Future<Activity> createActivity(Activity activity, File? image);

  Future<bool> updateActivity(Activity activity);

  Future<bool> deleteActivity(Activity activity);
}
