import 'package:flutter/material.dart';
import 'music.dart';
import 'constants.dart';

class SecondScreen extends StatefulWidget {
  DetailMusic music;
  SecondScreen({required this.music});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: kTitle,
              ),
              Text(widget.music.songName),
              Text(
                "Album Name",
                style: kTitle,
              ),
              Text(widget.music.albumName),
              Text(
                "Explicit",
                style: kTitle,
              ),
              Text(widget.music.explicit.toString().toUpperCase()),
              Text(
                "Rating",
                style: kTitle,
              ),
              Text(widget.music.rating),
              Text(
                "Lyrics",
                style: kTitle,
              ),
              Text(widget.music.lyrics),
            ],
          ),
        ),
      ),
    );
  }
}
