import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class AddNewItemPage extends StatelessWidget {
  final TextEditingController _addNewItemController = TextEditingController();
  final TextEditingController _addNewTagController = TextEditingController();

  void _add_new_item(context, item_to_check, tags) async {
    final String endpoint = 'http://localhost:3000/check_items/add_new.json';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"item_to_check": item_to_check, "tags": tags}),
      );
      if (response.statusCode == 204) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      } else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _addNewItemController,
              decoration: InputDecoration(
                labelText: 'Item to check',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addNewTagController,
              decoration: InputDecoration(
                labelText: 'Tags',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var itemToCheck = _addNewItemController.text;
                var tags = _addNewTagController.text;
                _add_new_item(context, itemToCheck, tags);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
