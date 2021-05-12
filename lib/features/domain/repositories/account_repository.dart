import 'package:liv_social/features/domain/entities/user_model.dart';

abstract class AccountRepository {
  /// Get the User's [UserModel] by its uid
  Future<UserModel> findUserById(String uid);

  /// Create and return the User's [UserModel] to persist
  Future<UserModel> registerUser(UserModel user);
}
