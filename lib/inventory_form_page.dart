import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryFormPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void _addItem(BuildContext context) {
    final String name = _nameController.text;
    final int quantity = int.tryParse(_quantityController.text) ?? 1;

    if (name.isNotEmpty) {
      FirebaseFirestore.instance.collection('inventory').add({
        'name': name,
        'quantity': quantity,
      }).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Inventory Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addItem(context),
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
