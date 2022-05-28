import 'dart:ffi';

import 'auth_user.dart';
import 'auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  @override
  Future<AuthUser> createUser(
      {required String email,
        required String password,
      }) =>  provider.createUser(
      email: email,
      password: password,
    );


  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<Void> logOut() => provider.logOut();

  @override
  Future<Void> sendEmailVerification() => provider.sendEmailVerification();
}
