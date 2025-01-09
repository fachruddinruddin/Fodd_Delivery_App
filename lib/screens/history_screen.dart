import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: user == null
          ? const Center(
              child: Text(
                'Please log in to view your transaction history.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : FutureBuilder<List<TransactionModel>>(
              future: firestoreService.getTransactions(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No transactions found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  final transactions = snapshot.data!;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            "Transaction ID: ${transaction.id}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                  "Total Price: Rp. ${transaction.totalPrice}"),
                              const SizedBox(height: 5),
                              Text("Status: ${transaction.status}"),
                              const SizedBox(height: 5),
                              Text(
                                "Timestamp: ${DateFormat('yyyy-MM-dd – kk:mm').format(transaction.timestamp)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Items:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              ...transaction.items.map((item) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "Menu ID: ${item['menuId']}, Quantity: ${item['quantity']}, Total: Rp. ${item['total']}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
