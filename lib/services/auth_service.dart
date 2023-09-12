import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gcma_v1/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:gcma_v1/screens/admin/admin_home_screen.dart';
import 'package:gcma_v1/screens/moderator/moderator_home_screen.dart';
import 'package:gcma_v1/screens/user/user_home_screen.dart';
import 'package:gcma_v1/screens/login_screen.dart';
import 'package:gcma_v1/app.dart';

enum UserRole { none, admin, moderator, user }

class AuthService with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get userStream => _firebaseAuth.authStateChanges();

  Future<void> navigateUser(UserRole userRole, BuildContext context) async {
    switch (userRole) {
      case UserRole.admin:
        Navigator.pushNamed(context, '/Admin');
        break;
      case UserRole.moderator:
        Navigator.pushNamed(context, '/Moderator');
        break;
      case UserRole.user:
        Navigator.pushNamed(context, '/User');
        break;
      default:
        break;
    }
  }

  Stream<UserRole> get userRoleStream {
    return _firebaseAuth.authStateChanges().asyncMap((User? user) async {
      if (user == null) {
        return UserRole.none;
      } else {
        String? role = await _databaseService.getUserRole(user.uid);
        if (role == 'admin') {
          return UserRole.admin;
        } else if (role == 'moderator') {
          return UserRole.moderator;
        } else {
          return UserRole.user;
        }
      }
    });
  }

  Future<User?> signUp(
    String email,
    String password, {
    String? firstName,
    String? lastName,
    String? username,
    String? region,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? newUser = userCredential.user;
      if (newUser != null) {
        await createUser(newUser.uid, 'user',
            firstName: firstName,
            lastName: lastName,
            username: username,
            region: region,
            email: email);
        return newUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Handle errors
      return null;
    }
  }
  // ...

  Future<void> createUser(String uid, String role,
      {String? firstName,
      String? lastName,
      String? username,
      String? region,
      String? email}) async {
    await _databaseService.createUser(uid, role,
        firstName: firstName,
        lastName: lastName,
        username: username,
        region: region,
        email: email);
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle errors
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> refreshUser() async {
    await currentUser!.reload();
  }

  Future<void> updateUser(String uid, String email, String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && user.uid == uid) {
      await user.updateEmail(email);
      await user.updatePassword(password);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> deleteUser(String uid) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && user.uid == uid) {
      await user.delete();
    } else {
      throw Exception('User not found');
    }
  }
}
