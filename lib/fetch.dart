import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Fetch extends StatefulWidget {
  const Fetch({super.key});

  @override
  _FetchState createState() => _FetchState();
}

class _FetchState extends State<Fetch> {
  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1/firstphp/fetch.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Mobile')),
              ],
              rows: snapshot.data!.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item['name'])),
                  DataCell(Text(item['email'])),
                  DataCell(Text(item['mobile'])),
                ]);
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
