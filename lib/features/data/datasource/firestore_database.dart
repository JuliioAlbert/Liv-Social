import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:liv_social/core/exceptions/account_exception.dart';
import 'package:liv_social/core/exceptions/activity_exception.dart';
import 'package:liv_social/features/data/datasource/firestore_helper.dart';
import 'package:liv_social/features/domain/entities/activity.dart';
import 'package:liv_social/features/domain/entities/user_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreDatabase {
  final databaseReference = FirebaseFirestore.instance;
  final _fHelper = FirestoreHelper.instance;
  final uuid = const Uuid();

  final String _userCollection = 'user';
  final String _activityCollection = 'activity';

  Future<bool> modifyUser(UserModel user) async {
    await databaseReference
        .collection(_userCollection)
        .doc(user.uid)
        .update(user.toJson());
    return true;
  }

  Future<UserModel> registerUser(UserModel user) async {
    await databaseReference
        .collection(_userCollection)
        .doc(user.uid)
        .set(user.toJson());
    return user;
  }

  Future<bool> userExists(String uid) async {
    final documentSnapshot =
        await databaseReference.collection(_userCollection).doc(uid).get();
    return documentSnapshot.exists;
  }

  Future<UserModel> findUserById(String uid) async {
    final documentSnapshot =
        await databaseReference.collection(_userCollection).doc(uid).get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data == null) throw UserNotExist();

      final user = UserModel.fromJson(data);
      return user;
    } else {
      throw UserNotExist();
    }
  }

  Stream<UserModel> findUserByIdStream(String uid) async* {
    yield* _fHelper.documentStreamById(
      path: _userCollection,
      id: uid,
      builder: (data) => UserModel.fromJson(data),
    );
  }

  Future<List<Activity>> getActivities() async {
    return _fHelper.collection<Activity>(
      path: _activityCollection,
      builder: (data) => Activity.fromJson(data),
    );
  }

  Future<Activity> createActivity(Activity activity) async {
    activity.uid = uuid.v4();
    await databaseReference
        .collection(_activityCollection)
        .doc(activity.uid)
        .set(activity.toJson());
    return activity;
  }

  Future<bool> updateActivity(Activity activity) async {
    await databaseReference
        .collection(_activityCollection)
        .doc(activity.uid)
        .update(activity.toJson());
    return true;
  }

  Future<bool> deleteActivity(Activity activity) async {
    activity.status = false;
    await databaseReference
        .collection(_activityCollection)
        .doc(activity.uid)
        .update(activity.toJson());
    return true;
  }

  Future<Activity> findActivityById(String uid) async {
    final documentSnapshot =
        await databaseReference.collection(_activityCollection).doc(uid).get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data();
      if (data == null) throw ActivityNotExist();

      final activity = Activity.fromJson(data);
      return activity;
    } else {
      throw ActivityNotExist();
    }
  }
}
