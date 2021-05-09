import 'package:liv_social/core/exceptions/account_exception.dart';
import 'package:liv_social/features/data/datasource/firestore_database.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final FirestoreDatabase _firestoreDatabase;

  AccountRepositoryImpl(this._firestoreDatabase);

  @override
  Future<UserModel> findUserById(String uid) async =>
      await _firestoreDatabase.findUserById(uid);

  @override
  Future<UserModel> registerUser(UserModel user) {
    try {
      return _firestoreDatabase.registerUser(user);
    } catch (e) {
      throw RegisterUserFailure();
    }
  }
}
