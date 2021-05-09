import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';

class ManageActivityUseCase {
  ManageActivityUseCase(this._activityRepository);
  final ActivityRepository _activityRepository;

  Future<Activity> createActivity(Activity activity) async =>
      await _activityRepository.createActivity(activity);

  Future<bool> updateActivity(Activity activity) async =>
      await _activityRepository.updateActivity(activity);

  Future<bool> deleteActivity(Activity activity) async =>
      await _activityRepository.deleteActivity(activity);
}
