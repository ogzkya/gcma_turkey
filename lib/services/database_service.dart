import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(String uid, String role,
      {String? firstName,
      String? lastName,
      String? username,
      String? region,
      String? email}) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'role': role,
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'region': region,
        'email': email,
      });
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(uid).get();
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      return userData?['role'];
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _firestore.collection('users').doc(uid).update({'role': newRole});
    } catch (e) {
      print('Error updating user role: $e');
    }
  }

  Future<QuerySnapshot> getUsers() {
    return _firestore.collection('users').get();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> userData) {
    return _firestore.collection('users').doc(uid).update(userData);
  }

  // Kullanıcıyı silmek için bir Future metodu
  Future<void> deleteUser(String uid) {
    return _firestore.collection('users').doc(uid).delete();
  }
}
