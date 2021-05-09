import 'package:liv_social/features/domain/entities/user_model.dart';

abstract class AccountRepository {
  Future<UserModel> findUserById(String uid);

  Future<UserModel> registerUser(UserModel user);
}
