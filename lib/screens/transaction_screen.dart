import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/menu_model.dart';
import 'receipt_screen.dart'; // Import the receipt screen

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(
            menu: widget.menu,
            quantity: _quantity,
            totalPrice: totalPrice,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process transaction: $e')));
    }
  }

  void _changeQuantity(String action) {
    setState(() {
      if (action == '+') {
        _quantity++;
      } else if (action == '-' && _quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.menu.price * _quantity;
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Pesanan Anda", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/images/agor.jpg',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              widget.menu.name,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 15),
            Text(
              widget.menu.description,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            const SizedBox(height: 15),
            Text(
              "Rp. ${widget.menu.price}",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.black),
                  onPressed: () {
                    _changeQuantity('-');
                  },
                ),
                Text(
                  _quantity.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: () {
                    _changeQuantity('+');
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Total: Rp. $total",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _processTransaction,
                child: const Text("Pesan Sekarang",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
