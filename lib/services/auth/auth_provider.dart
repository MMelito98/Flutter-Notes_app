import 'dart:ffi';

import 'package:primo/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<AuthUser?> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<Void> logOut();

  Future<Void> sendEmailVerification();
}
//need getter to get current user
