


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<News> _newsFuture;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Welcome to space news app which supported by Nasa API',
            style: TextStyle(color: Colors.amber,fontSize: 16.0,fontWeight: FontWeight.bold,fontFamily: 'Arial'),),
        ),
      );
    });
    _newsFuture = fetchNews();
  }


  Future<News> fetchNews() async {
    const url = "https://api.nasa.gov/planetary/apod?api_key=M9coFPSVJSmLhzYsU2e1QL053a1pVUVxqihBWIeQ";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return News.fromJson(jsonData);
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: FutureBuilder<News>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView(
              children: [
                ListTile(
                  title: Text(snapshot.data!.date),
                  subtitle: Text(snapshot.data!.explanation),
                  // Burada resmi göstermek için bir Image widget'i eklenebilir
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class News {
  final String date;
  final String explanation;
  final String hdurl;

  News({
    required this.date,
    required this.explanation,
    required this.hdurl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      date: json['date'],
      explanation: json['explanation'],
      hdurl: json['hdurl'],
    );
  }
}
