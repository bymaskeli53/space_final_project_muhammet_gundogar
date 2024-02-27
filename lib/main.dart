


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'News App',
      home: NewsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

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
          content: Text(
            'Welcome to space news app which supported by Nasa API, To see the image of day about space click -click here',
            style: TextStyle(color: Colors.amber, fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: 'Arial'),
          ),
          action: SnackBarAction(
            label: 'Click Here',
            onPressed: () {
              // Snackbar'a tıklandığında yapılacak işlem
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondScreen()), // İkinci sayfa için bir MaterialPageRoute oluşturun
              );
            },
          ),
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
        title: const Text('News'),
        backgroundColor: Color.fromRGBO(249, 231, 159, 1.0),
      ),
      backgroundColor: Color.fromRGBO(241, 196, 15, 1.0),
      body: FutureBuilder<News>(
        
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
                  title: Text("Date: " + snapshot.data!.date+ "\n"),
                  subtitle: Text("News: " +"\n" + snapshot.data!.explanation),
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





class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late String _imageUrl;
  late String _imageExplanation;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=M9coFPSVJSmLhzYsU2e1QL053a1pVUVxqihBWIeQ');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _imageUrl = jsonData['url'];
        _imageExplanation = jsonData['explanation'];
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NASA Image of the Day'),
        backgroundColor: Color.fromRGBO(249, 231, 159, 1.0),
      ),
      backgroundColor: Color.fromRGBO(241, 196, 15, 1.0),
      body: _imageUrl != null
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              _imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _imageExplanation ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}


