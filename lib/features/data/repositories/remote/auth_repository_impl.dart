import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:liv_social/core/exceptions/auth_exception.dart';
import 'package:liv_social/features/data/models/auth_type.dart';
import 'package:liv_social/features/data/models/user_model.dart';
import 'package:liv_social/features/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _databaseReference = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedIn = false;
  UserModel? user;
  String idToken = '';

  late StreamSubscription userModelSubscription;

  User? get currentFirebaseUser => _auth.currentUser;

  @override
  Future<void> logout() async {
    if (isLoggedIn) {
      try {
        await Future.wait([
          _auth.signOut(),
          _googleSignIn.signOut(),
        ]);
        idToken = '';
      } on Exception {
        throw LogOutFailure();
      }
    }

    isLoggedIn = false;
    user = null;
    idToken = '';
  }

  @override
  Future<UserModel> signIn(AuthType authType,
      {String? email, String? password}) async {
    isLoggedIn = false;
    UserCredential? userCredential;
    user = UserModel();
    idToken = '';

    if (authType == AuthType.Email) {
      try {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);
      } catch (e) {
        throw LogInWithEmailAndPasswordFailure();
      }
    } else if (authType == AuthType.Google) {
      try {
        final googleSignInAccount = await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final googleAuth = await googleSignInAccount.authentication;

          final googleCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          userCredential = await _auth.signInWithCredential(googleCredential);
        }
      } catch (e) {
        throw LogInWithGoogleFailure();
      }
    }

    if (userCredential != null) {
      idToken = await userCredential.user!.getIdToken();

      await _databaseReference.collection('login').add({
        'email': userCredential.user!.providerData.first.email,
        'datetime': Timestamp.now(),
      });
      user?.name = userCredential.user!.providerData.first.displayName!;
      user?.email = userCredential.user!.providerData.first.email ?? '';
      user?.image = userCredential.user!.providerData.first.photoURL;
      user?.uid = userCredential.user!.uid;

      isLoggedIn = true;

      return user!;
    } else {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<UserCredential> createUser(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  void sendPasswordResetEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  void modifyPassword(String newPassword) async {
    if (currentFirebaseUser != null) {
      await currentFirebaseUser!.updatePassword(newPassword);
    } else {
      throw NotAuthException();
    }
  }

  @override
  Future<UserModel> getAuthUser() async {
    if (currentFirebaseUser != null && user != null) {
      return user!;
    } else {
      throw NotAuthException();
    }
  }

  @override
  Future<UserCredential> createUserByEmailAuth(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw CreateUserByEmailFailure();
    }
  }
}
