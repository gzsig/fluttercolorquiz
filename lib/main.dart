// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho final',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Color Quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  void _play() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Game(
                  username: controller.text,
                  title: 'Math Quiz',
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'whats your username?',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _play,
        tooltip: 'go to game',
        child: const Icon(Icons.arrow_forward_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key, required this.title, required this.username})
      : super(key: key);

  final String title;
  final String username;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _score = 0;
  final controller = TextEditingController();
  List colorNames = [
    "green",
    "black",
    "red",
    "blue",
  ];
  List colors = [Colors.green, Colors.black, Colors.red, Colors.blue];

  Random random = new Random();

  int index = 0;

  void changeIndex() {
    setState(() => index = random.nextInt(colors.length));
  }

  void _play() {
    if (controller.text.toLowerCase() == colorNames[index]) {
      setState(() {
        _score++;
        score();
      });
    } else {
      setState(() {
        _score = 0;
      });
    }
    changeIndex();
    controller.text = "";
  }

  Future<void> score() async {
    String user = widget.username;
    var response = await http.post(
      Uri.parse('https://7c2bad50.us-south.apigw.appdomain.cloud/api/placar'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'usuario': user,
      }),
    );
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print(response.body);
    } else {
      throw Exception('Erro ao mandar ponto');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Text("Score: $_score"),
            Container(
              height: 150.0,
              width: 300.0,
              color: Colors.transparent,
              child: Icon(Icons.stop_rounded,
                  size: 300,
                  color: colors[
                      index] //Colors.primaries[Random().nextInt(Colors.primaries.length)],
                  ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'what color do you see?',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _play,
        tooltip: 'Increment',
        child: const Icon(Icons.check_outlined),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
