import 'package:flutter/material.dart';
import 'package:resto/screens/home_screen.dart';
import '../models/menu_model.dart';

class ReceiptScreen extends StatelessWidget {
  final MenuModel menu;
  final int quantity;
  final double totalPrice;

  const ReceiptScreen({
    Key? key,
    required this.menu,
    required this.quantity,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle boldTextStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    final TextStyle normalTextStyle = const TextStyle(fontSize: 16);
    final TextStyle totalTextStyle = const TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nota Anda", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 186, 186, 186).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Pesanan Anda", style: boldTextStyle),
              const Divider(color: Colors.deepOrange),
              const SizedBox(height: 10),
              Text(menu.name, style: normalTextStyle),
              const SizedBox(height: 5),
              Text("${menu.price} x $quantity", style: normalTextStyle),
              const SizedBox(height: 5),
              Text("Berhasil Disimpan", style: normalTextStyle),
              const SizedBox(height: 20),
              const Text("Total Bayar:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text("Rp. $totalPrice",
                  style: totalTextStyle.copyWith(color: Colors.black)),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (Route<dynamic> r) => false,
                  );
                },
                child: const Text("Kembali ke Menu",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
