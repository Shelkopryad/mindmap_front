import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

class PriorityItem {
  final String description;
  final List<String> tags;

  PriorityItem({required this.description, required this.tags});

  factory PriorityItem.fromJson(Map<String, dynamic> json) {
    print(json);
    final description = json.keys.first;
    final tags = json[description].cast<String>();
    return PriorityItem(description: description, tags: tags);
  }
}

class PriorityList {
  final List<PriorityItem> lowPriority;
  final List<PriorityItem> highPriority;

  PriorityList({required this.lowPriority, required this.highPriority});

  factory PriorityList.fromJson(Map<String, dynamic> json) {
    final lowPriorityJson = json['low']; // .cast<List<Map<String, List<String>>>>();
    final highPriorityJson = json['high']; // .cast<List<Map<String, dynamic>>>();

    print(highPriorityJson);
    highPriorityJson.forEach(print);

    final lowPriority =
        lowPriorityJson.map((item) => PriorityItem.fromJson(item)).toList();
    final highPriority =
        highPriorityJson.map((item) => PriorityItem.fromJson(item)).toList();

    return PriorityList(lowPriority: lowPriority, highPriority: highPriority);
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  PriorityList? _priorityList;

  void _search() async {
    final String endpoint =
        'http://localhost:3000/check_items.json?query=$_searchQuery';

    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
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
            if (_priorityList != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('High Priority:'),
                  for (final item in _priorityList!.highPriority)
                    ListTile(
                      title: Text(item.description),
                      subtitle: Text(item.tags.join(', ')),
                    ),
                  SizedBox(height: 16),
                  Text('Low Priority:'),
                  for (final item in _priorityList!.lowPriority)
                    ListTile(
                      title: Text(item.description),
                      subtitle: Text(item.tags.join(', ')),
                    ),
                ],
              )
            else
              Text('Результат: Нет данных или произошла ошибка'),
          ],
        ),
      ),
    );
  }
}
