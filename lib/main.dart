import 'dart:async';
import 'package:firstphp/fetch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

String username = '';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App with MYSQL',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();

  Future<void> senddata() async {
    final response = await http.post(
      Uri.parse("http://127.0.0.1/firstphp/insertdata.php"),
      body: {
        "name": name.text,
        "email": email.text,
        "mobile": mobile.text,
      },
    );

    if (response.statusCode == 200) {
      // Clear text fields after successful registration
      setState(() {
        name.clear();
        email.clear();
        mobile.clear();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Function to delete data
  Future<void> deleteData() async {
    // Your PHP script URL
    var url = Uri.parse('http://127.0.0.1/firstphp/delete.php?id=1'); // Pass the ID of the record to delete

    try {
      // Send HTTP DELETE request to the PHP script
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // If deletion is successful, show success message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Record deleted successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If deletion fails, show error message
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete data: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
              "Username",
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: name,
              onChanged: (_) {
                deleteData(); // Call deleteData function when text changes
              },
              decoration: const InputDecoration(hintText: 'name'),
            ),
            const Text(
              "Email",
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const Text(
              "Mobile",
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: mobile,
              decoration: const InputDecoration(hintText: 'Mobile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: senddata,
              child: const Text("Register"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Fetch()));
              },
              child: const Text('Fetch data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: deleteData,
              child: const Text('Delete Data'),
            ),
          ],
        ),
      ),
    );
  }
}
