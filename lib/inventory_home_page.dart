import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'inventory_form_page.dart';

class InventoryHomePage extends StatefulWidget {
  @override
  _InventoryHomePageState createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  // Function to delete an item from Firestore
  void _deleteItem(String documentId) {
    FirebaseFirestore.instance.collection('inventory').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory Management"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('inventory').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;
          if (items.isEmpty) {
            return Center(child: Text("No items in inventory"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return Dismissible(
                key: Key(item.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  // Delete the item when swiped
                  _deleteItem(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Item deleted")),
                  );
                },
                child: ListTile(
                  title: Text(item['name']), // Use field names that match your Firestore data
                  subtitle: Text("Quantity: ${item['quantity']}"),
                  leading: Icon(Icons.inventory),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(item.id), // Delete item on button press
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InventoryFormPage()),
          );
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
