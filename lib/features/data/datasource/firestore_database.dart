import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liv_social/core/exceptions/account_exception.dart';
import 'package:liv_social/features/data/datasource/firestore_helper.dart';
import 'package:liv_social/features/data/models/user_model.dart';

class FirestoreDatabase {
  final databaseReference = FirebaseFirestore.instance;
  final _fHelper = FirestoreHelper.instance;

  final String collectionUser = 'user';
  final String collectionDriver = 'driver';
  final String collectionAppConfig = 'app-config';
  final String collectionRides = 'rides';

  Future<bool> modifyUser(UserModel user) async {
    try {
      await databaseReference.collection(collectionUser).doc(user.uid).update({
        'image': user.image,
      });
      return true;
    } catch (err, stacktrace) {
      print(stacktrace);
      return false;
    }
  }

  Future<UserModel> registerUser(UserModel user) async {
    try {
      await databaseReference.collection(collectionUser).doc(user.uid).set({
        'name': user.name,
        'email': user.email.toLowerCase(),
        'image': user.image,
      });
      return user;
    } catch (err, stacktrace) {
      print(stacktrace);
      throw RegisterUserFailure();
    }
  }

  Future<bool> userExists(String uid) async {
    var documentSnapshot =
        await databaseReference.collection(collectionUser).doc(uid).get();
    return documentSnapshot.exists;
  }

  Future<UserModel> findUserById(String uid) async {
    var documentSnapshot =
        await databaseReference.collection(collectionUser).doc(uid).get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data == null) throw UserNotExist();

      final user = UserModel.fromJson(data);
      user.uid = uid;
      return user;
    } else {
      throw UserNotExist();
    }
  }

  Stream<UserModel> findUserByIdStream(String uid) async* {
    yield* _fHelper.documentStreamById(
      path: collectionUser,
      id: uid,
      builder: (data) => UserModel.fromJson(data),
    );
  }
}
