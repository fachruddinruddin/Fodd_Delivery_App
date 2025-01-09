import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/menu_model.dart';
import 'receipt_screen.dart';

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
        backgroundColor: const Color(0xFFD84040),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.16),
                    child: Image.asset(
                      'assets/images/agor.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.menu.name,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.menu.description,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Rp. ${widget.menu.price}",
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.black),
                          onPressed: () {
                            _changeQuantity('+');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        "Total: Rp. $total",
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD84040),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
