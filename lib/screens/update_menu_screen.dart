import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/menu_model.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class UpdateMenuScreen extends StatefulWidget {
  final MenuModel menu;

  const UpdateMenuScreen({Key? key, required this.menu}) : super(key: key);

  @override
  _UpdateMenuScreenState createState() => _UpdateMenuScreenState();
}

class _UpdateMenuScreenState extends State<UpdateMenuScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.menu.name);
    _descriptionController =
        TextEditingController(text: widget.menu.description);
    _priceController =
        TextEditingController(text: widget.menu.price.toString());
    _stockController =
        TextEditingController(text: widget.menu.stock.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _updateMenu() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestoreService.updateMenu(
        widget.menu.id,
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        double.parse(_priceController.text.trim()),
        int.parse(_stockController.text.trim()),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update menu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                labelText: 'Price',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _stockController,
                labelText: 'Stock',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid stock';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      label: 'Update',
                      onPressed: _updateMenu,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
