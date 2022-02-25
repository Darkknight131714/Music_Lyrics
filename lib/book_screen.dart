import 'dart:convert';

import 'package:music_lyrics/music.dart';
import 'package:http/http.dart' as http;
import 'bookmark.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'second.dart';

class Book_Screen extends StatefulWidget {
  List<Music> music;
  Book_Screen({required this.music});
  @override
  _Book_ScreenState createState() => _Book_ScreenState();
}

class _Book_ScreenState extends State<Book_Screen> {
  bool val = true;
  List<Music> music = [];
  @override
  void initState() {
    music = widget.music;
    // TODO: implement initState
    super.initState();
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
      body: ListView.builder(
        itemCount: music.length,
        itemBuilder: (context, index) {
          if (!Provider.of<BookMarkList>(context, listen: false)
              .trackIds
              .contains(music[index].stringID)) {
            return SizedBox();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Loading Screen"),
                        ),
                      );
                      final url = Uri.parse(
                          'https://api.musixmatch.com/ws/1.1/track.get?track_id=${music[index].stringID}&apikey=74e32cfc45383c7faf974e833f6503c3');
                      final json = await http.get(url);
                      final url1 = Uri.parse(
                          'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${music[index].stringID}&apikey=74e32cfc45383c7faf974e833f6503c3');
                      final json1 = await http.get(url1);
                      try {
                        if (json.statusCode == 200 && json1.statusCode == 200) {
                          Map<String, dynamic> m = jsonDecode(json.body);
                          Map<String, dynamic> m1 = jsonDecode(json1.body);
                          DetailMusic dm = DetailMusic.fromJson(m, m1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SecondScreen(
                                music: dm,
                              ),
                            ),
                          );
                        }
                      } on Exception catch (e) {
                        print(e);
                      }
                    },
                    title: Text(music[index].songName),
                    subtitle: Text("Artist: " + music[index].artistName),
                    trailing: IconButton(
                      onPressed: () async {
                        if (Provider.of<BookMarkList>(context, listen: false)
                            .trackIds
                            .contains(music[index].stringID)) {
                          Provider.of<BookMarkList>(context, listen: false)
                              .deleteTrack(music[index].stringID);
                        } else {
                          Provider.of<BookMarkList>(context, listen: false)
                              .addTrack(music[index].stringID);
                        }
                      },
                      icon: (Provider.of<BookMarkList>(context)
                              .trackIds
                              .contains(music[index].stringID))
                          ? Icon(Icons.bookmark)
                          : Icon(Icons.bookmark_add),
                    ),
                  ),
                ),
              ),
              // Divider(
              //   color: Colors.white,
              //   height: 10,
              //   thickness: 2,
              //   indent: 50,
              //   endIndent: 50,
              // ),
            ],
          );
        },
      ),
    );
  }
}
