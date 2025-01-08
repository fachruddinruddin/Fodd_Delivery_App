import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({Key? key}) : super(key: key);

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  void _addMenu() async {
    try {
      await _firestoreService.addMenu(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        double.parse(_priceController.text.trim()),
        int.parse(_stockController.text.trim()),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add menu: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price')),
            TextField(controller: _stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _addMenu, child: const Text('Add Menu')),
          ],
        ),
      ),
    );
  }
}
