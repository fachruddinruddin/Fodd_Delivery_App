import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login dengan email dan password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      // Masuk dengan email dan password
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Ambil data pengguna dari Firestore
        final DocumentSnapshot userData = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (userData.exists) {
          return user;
        } else {
          throw Exception('Data pengguna tidak ditemukan');
        }
      }
      return null;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Pengguna tidak ditemukan untuk email tersebut.';
          break;
        case 'wrong-password':
          message = 'Password yang diberikan salah.';
          break;
        case 'invalid-email':
          message = 'Alamat email tidak valid.';
          break;
        case 'user-disabled':
          message = 'Akun pengguna ini telah dinonaktifkan.';
          break;
        default:
          message = 'Terjadi kesalahan saat login: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  // Registrasi dengan email dan password
  Future<User?> registerWithEmailPassword(String email, String password, String username) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password yang diberikan terlalu lemah.';
          break;
        case 'email-already-in-use':
          message = 'Akun dengan email tersebut sudah ada.';
          break;
        case 'invalid-email':
          message = 'Alamat email tidak valid.';
          break;
        default:
          message = 'Terjadi kesalahan saat registrasi: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Registrasi gagal: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Logout gagal: $e');
    }
  }

  // Ambil pengguna saat ini
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
