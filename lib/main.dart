import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

List<ItemToCheck> items = [];

class ItemToCheck {
  final int id;
  final String itemToCheck;
  final String tags;
  final bool toTest;
  final String createdAt;
  final String updatedAt;

  ItemToCheck({
    required this.id,
    required this.itemToCheck,
    required this.tags,
    required this.toTest,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemToCheck.fromJson(Map<String, dynamic> json) {
    return ItemToCheck(
      id: json['id'],
      itemToCheck: json['item_to_check'],
      tags: json['tags'],
      toTest: json['to_test'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _result = '';

  void _search() async {
    final String endpoint = 'http://localhost:3000/check_items.json?query=$_searchQuery';

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        // Парсинг JSON-ответа
        List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          items = jsonData.map((item) => ItemToCheck.fromJson(item)).toList();

          setState(() {
            _result = 'Найдено ${items.length} объектов';
          });
        } else {
          setState(() {
            _result = 'Нет данных';
          });
        }
      } else {
        setState(() {
          _result = 'Ошибка: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Ошибка: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(labelText: 'Поиск'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: Text('Искать'),
            ),
            SizedBox(height: 16),
            Text(_result), // Здесь отображается текстовый результат

            // Вставьте ListView.builder здесь для отображения результатов поиска
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].itemToCheck),
                    subtitle: Text(items[index].tags),
                    // Здесь вы можете добавить другие поля для отображения
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

