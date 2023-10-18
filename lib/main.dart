import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_item_page.dart';
import 'priority_list.dart';
// import 'check_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поиск',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  PriorityList? _priorityList;

  void _search() async {
    final String endpoint = _searchQuery == ''
        ? 'http://localhost:3000/check_items.json'
        : 'http://localhost:3000/check_items.json?query=$_searchQuery';

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final priorityList = PriorityList.fromJson(jsonData);
        setState(() {
          _priorityList = priorityList;
        });
      } else {
        setState(() {
          _priorityList = null;
        });
      }
    } catch (e) {
      setState(() {
        _priorityList = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewItemPage()),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Поиск'),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _search,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          if (_priorityList != null)
            Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final item in _priorityList!.priorityItemList)
                      ListTile(
                        title: Text(item.description),
                        subtitle: Text(item.tags.join(', ')),
                      ),
                    const SizedBox(height: 16),
                  ],
                ))
          else
            const Text('Результат: Нет данных или произошла ошибка'),
        ],
      ),
    );
  }
}