import 'package:liv_social/features/domain/entities/activity.dart';

abstract class ActivityRepository {
  /// Retrieve a [List<Activity>] created by users
  Future<List<Activity>> getActivities();

  /// Retrieve the [Activity] by unique id.
  Future<Activity> getActivityById(String id);

  /// Create the [Activity] to persist. It must have its uid.
  Future<Activity> createActivity(Activity activity);

  /// Update the [Activity] created by a user
  Future<bool> updateActivity(Activity activity);

  /// Delete an [Activity].
  Future<bool> deleteActivity(Activity activity);
}
