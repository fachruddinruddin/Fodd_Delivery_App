import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_model.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Menambahkan menu baru
  Future<void> addMenu(
      String name, String description, double price, int stock) async {
    try {
      await _db.collection('menus').add({
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'createdAt': FieldValue.serverTimestamp(),
      });
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

  // Memperbarui menu
  Future<void> updateMenu(String id, String name, String description,
      double price, int stock) async {
    try {
      await _db.collection('menus').doc(id).update({
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update menu: $e');
    }
  }

  // Menghapus menu
  Future<void> deleteMenu(String id) async {
    try {
      await _db.collection('menus').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete menu: $e');
    }
  }

  // Membuat transaksi baru
  Future<void> createTransaction(String userId,
      List<Map<String, dynamic>> items, double totalPrice) async {
    try {
      var transactionRef = await _db.collection('transactions').add({
        'userId': userId,
        'items': items,
        'totalPrice': totalPrice,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Simulasi perubahan status transaksi menjadi 'completed'
      await _db.collection('transactions').doc(transactionRef.id).update({
        'status': 'completed',
      });
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Mengambil transaksi berdasarkan userId
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      var snapshot = await _db
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
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
