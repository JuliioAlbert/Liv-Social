import 'package:liv_social/features/data/datasource/firestore_database.dart';
import 'package:liv_social/features/data/models/user_model.dart';
import 'package:liv_social/features/domain/repositories/account_repository.dart';

class AccountRepositoryImpl extends AccountRepository {
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();

  @override
  Future<UserModel> findUserById(String uid) async =>
      await _firestoreDatabase.findUserById(uid);

  @override
  Future<UserModel> registerUser(UserModel user) =>
      _firestoreDatabase.registerUser(user);
}
