import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CatApp());
}

class CatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Cat App',
      home: RandomCatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RandomCatPage extends StatefulWidget {
  @override
  _RandomCatPageState createState() => _RandomCatPageState();
}

class _RandomCatPageState extends State<RandomCatPage> {
  String? imageUrl;
  bool isLoading = false;

  Future<void> fetchCatImage() async {
    setState(() {
      isLoading = true;
    });

    final uri = Uri.parse('https://api.thecatapi.com/v1/images/search');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageUrl = data[0]['url'];
        });
      } else {
        setState(() {
          imageUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        imageUrl = null;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCatImage(); // Load image on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🐱 Random Cat Viewer')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : imageUrl != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(imageUrl!),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchCatImage,
                        child: Text('🔄 New Cat'),
                      ),
                    ],
                  )
                : Text('😿 Failed to load cat image.'),
      ),
    );
  }
}
