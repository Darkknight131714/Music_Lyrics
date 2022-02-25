import 'dart:convert';
import 'package:music_lyrics/book_screen.dart';

import 'bookmark.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_lyrics/second.dart';
import 'music.dart';
import 'splash.dart';

bool val = true;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}

class Homme extends StatefulWidget {
  List<Music> music;
  Homme({required this.music});

  @override
  State<Homme> createState() => _HommeState();
}

class _HommeState extends State<Homme> {
  List<Widget> pages = [];

  int ind = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    pages = [
      MyHomePage(
        music: widget.music,
      ),
      Book_Screen(
        music: widget.music,
      ),
    ];
    super.initState();
    _pageController = PageController(initialPage: ind);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      title: 'Flutter Demo',
      home: ChangeNotifierProvider<BookMarkList>(
        create: (context) {
          return BookMarkList();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Music List"),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ind,
            onTap: (int index) {
              ind = index;
              setState(() {
                // _pageController.animateToPage(index,
                //     duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'BookMark',
              ),
            ],
          ),
          body: PageView(
            children: pages,
            controller: _pageController,
            onPageChanged: (int index) {
              ind = index;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  List<Music> music;
  MyHomePage({required this.music});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Music> music = [];
  @override
  void initState() {
    music = widget.music;
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
      body: music.length == 0
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: music.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
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
                          if (json.statusCode == 200 &&
                              json1.statusCode == 200) {
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
                    Divider(
                      color: Colors.white,
                      height: 10,
                      thickness: 2,
                      indent: 50,
                      endIndent: 50,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
