import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double totalPrice;
  final String status;
  final DateTime timestamp;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.timestamp,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
    return TransactionModel(
      id: id,
      userId: data['userId'],
      items: List<Map<String, dynamic>>.from(data['items']),
      totalPrice: data['totalPrice'],
      status: data['status'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
