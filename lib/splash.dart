import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'package:flutter/material.dart';
import 'music.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Music> music = [];
  @override
  void initState() {
    // TODO: implement initState
    getMusic();
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Homme(
            music: music,
          ),
        ),
      ),
    );
  }

  Future getMusic() async {
    final url = Uri.parse(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=74e32cfc45383c7faf974e833f6503c3");
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        for (int i = 0; i < json['message']['body']['track_list'].length; i++) {
          Music m = new Music.fromJson(json, i);
          music.add(m);
        }
        setState(() {});
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
