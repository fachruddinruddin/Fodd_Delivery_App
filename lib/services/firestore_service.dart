import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  // Mengambil menu dari Firestore
  Future<List<MenuModel>> getMenus() async {
    try {
      var snapshot = await _db.collection('menus').get();
      var data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print('Received data: $data');
      return snapshot.docs
          .map((doc) =>
              MenuModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load menus: $e');
    }
  }

  // Mengupdate menu
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

  // Membuat transaksi
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

      // Update status transaksi (misalnya jadi completed setelah proses berhasil)
      await _db.collection('transactions').doc(transactionRef.id).update({
        'status': 'completed',
      });
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  // Menambahkan transaksi untuk pengguna (untuk melihat data transaksi)
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      var snapshot = await _db
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .get();
      var data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print('Received data: $data');
      return snapshot.docs
          .map((doc) => TransactionModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }
}
