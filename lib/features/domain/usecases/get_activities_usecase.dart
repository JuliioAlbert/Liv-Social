import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/repositories/activity_repository.dart';

class GetActiviesUseCase {
  GetActiviesUseCase(this._activityRepository);
  final ActivityRepository _activityRepository;

  Future<List<Activity>> getActivities() async =>
      await _activityRepository.getActivities();
}
