import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/menu_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart'; // Pastikan Anda punya model untuk User
import 'sqlite_helper.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final SQLiteHelper _sqliteHelper = SQLiteHelper.instance;

  // Menambahkan menu baru
  Future<void> addMenu(String name, String description, double price) async {
    try {
      var menuRef = await _db.collection('menus').add({
        'name': name,
        'description': description,
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await _sqliteHelper.insertMenu(menuRef.id, name, description, price);
    } catch (e) {
      throw Exception('Failed to add menu: $e');
    }
  }

  // Mengambil daftar menu dari Firestore
  Future<List<MenuModel>> getMenus() async {
    try {
      var snapshot = await _db.collection('menus').get();
      return snapshot.docs.map((doc) {
        return MenuModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load menus: $e');
    }
  }

  // Mengambil daftar menu dari SQLite (offline)
  Future<List<Map<String, dynamic>>> getMenusOffline() async {
    return await _sqliteHelper.getMenus();
  }

  // Memperbarui menu
  Future<void> updateMenu(String id, String name, String description, double price) async {
    try {
      await _db.collection('menus').doc(id).update({
        'name': name,
        'description': description,
        'price': price,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _sqliteHelper.updateMenu(id, name, description, price);
    } catch (e) {
      throw Exception('Failed to update menu: $e');
    }
  }

  // Menghapus menu
  Future<void> deleteMenu(String id) async {
    try {
      await _db.collection('menus').doc(id).delete();
      await _sqliteHelper.deleteMenu(id);
    } catch (e) {
      throw Exception('Failed to delete menu: $e');
    }
  }

  // Membuat transaksi baru
  Future<void> createTransaction(String userId, List<Map<String, dynamic>> items, double totalPrice) async {
    try {
      // Ambil ID pengguna yang sedang login (menggunakan Firebase Authentication)
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? userId;

      var transactionRef = await _db.collection('transactions').add({
        'userId': currentUserId, // Pastikan ID pengguna yang benar dikirim
        'items': items,
        'totalPrice': totalPrice,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Simulasi perubahan status transaksi menjadi 'completed'
      await _db.collection('transactions').doc(transactionRef.id).update({
        'status': 'completed',
      });

      await _sqliteHelper.insertTransaction(
        transactionRef.id,
        currentUserId,
        items.toString(),
        totalPrice,
        'completed',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Mengambil transaksi berdasarkan userId
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      print('Fetching transactions for userId: $userId');
      var snapshot = await _db
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        print('No transactions found for userId: $userId');
      }

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      throw Exception('Failed to load transactions: $e');
    }
  }

  // Mengambil transaksi dari SQLite (offline)
  Future<List<Map<String, dynamic>>> getTransactionsOffline(String userId) async {
    return await _sqliteHelper.getTransactions(userId);
  }

  // Method to create the required Firestore index programmatically
  Future<void> createIndex() async {
    try {
      await _db.collection('transactions').add({
        'userId': 'exampleUserId',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create index: $e');
    }
  }
}
