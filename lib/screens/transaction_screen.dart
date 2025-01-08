import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/menu_model.dart';

class TransactionScreen extends StatefulWidget {
  final MenuModel menu;
  const TransactionScreen({Key? key, required this.menu}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _quantity = 1;

  void _processTransaction() async {
    try {
      double totalPrice = widget.menu.price * _quantity;
      await _firestoreService.createTransaction(
        'userId', // replace with actual user id from authentication
        [
          {
            'menuId': widget.menu.id,
            'quantity': _quantity,
            'price': widget.menu.price,
            'total': totalPrice,
          }
        ],
        totalPrice,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction processed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to process transaction: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction for ${widget.menu.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Price: \$${widget.menu.price}'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Text('Quantity: $_quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _processTransaction, child: const Text('Confirm Transaction')),
          ],
        ),
      ),
    );
  }
}
