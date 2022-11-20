import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String desc = "";
  String poster = "";
  bool imageShow = false;
  var img = "";
  TextEditingController movie = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialApp',
      home: Scaffold(
          appBar: AppBar(title: const Text('Search movie info')),
          body: SingleChildScrollView(
            child: Column(children: [
              const Text(
                "Search for movie",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                  controller: movie,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      hintText: "Key in the movie name",
                      border: OutlineInputBorder())),
              ElevatedButton(
                  onPressed: () {
                    _showDiag();
                  },
                  child: const Text("Search")),
              imageShow ? Image.network(poster) : Container(),
              Text(
                desc,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ]),
          )),
    );
  }

  Future<void> _getMovie() async {
    var apiid = "7796bb2f";
    var mv = movie.text;
    var url = Uri.parse('http://www.omdbapi.com/?t=$mv&apikey=$apiid&');
    var response = await http.get(url);
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      var name = parsedJson['Title'];
      var year = parsedJson['Year'];
      var gen = parsedJson['Genre'];
      poster = parsedJson['Poster'];
      var plot = parsedJson['Plot'];

      setState(() {
        imageShow = true;
        desc = "Movie title :$name"
            "\nYear :$year"
            "\nGenre :$gen"
            "\nPlot : $plot";
      });
    }
  }

  void _showDiag() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _getMovie();
              },
            ),
            TextButton(
              child: const Text(
                "No",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
