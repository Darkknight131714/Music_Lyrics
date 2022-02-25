import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMark extends StatefulWidget {
  const BookMark({Key? key}) : super(key: key);

  @override
  _BookMarkState createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BookMarkList extends ChangeNotifier {
  List<String> trackIds = [];
  BookMarkList() {
    callme();
  }

  Future callme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    trackIds = prefs.getStringList('trackIds') ?? [];
    print(trackIds);
    notifyListeners();
  }

  Future addTrack(String trackid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    trackIds.add(trackid);
    print(trackIds);
    prefs.setStringList('trackIds', trackIds);
    notifyListeners();
  }

  Future deleteTrack(String trackid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    trackIds.remove(trackid);
    prefs.setStringList('trackIds', trackIds);
    notifyListeners();
  }
}
