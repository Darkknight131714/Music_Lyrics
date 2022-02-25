class Music {
  late String artistName, songName, albumName, stringID;

  Music(
      {required this.albumName,
      required this.songName,
      required this.artistName});

  Music.fromJson(Map<String, dynamic> json, int index) {
    artistName =
        json['message']['body']['track_list'][index]['track']['artist_name'];
    songName =
        json['message']['body']['track_list'][index]['track']['track_name'];
    albumName =
        json['message']['body']['track_list'][index]['track']['album_name'];
    stringID = json['message']['body']['track_list'][index]['track']['track_id']
        .toString();
  }
}

class DetailMusic {
  late String songName, artistName, albumName, rating, lyrics;
  late bool explicit;
  DetailMusic.fromJson(Map<String, dynamic> json, Map<String, dynamic> json1) {
    songName = json['message']['body']['track']['track_name'];
    artistName = json['message']['body']['track']['artist_name'];
    albumName = json['message']['body']['track']['album_name'];
    rating = json['message']['body']['track']['track_rating'].toString();
    explicit = json['message']['body']['track']['explicit'] == 1 ? true : false;
    if (json1['message']['header']['status_code'] == 200) {
      lyrics = json1['message']['body']['lyrics']['lyrics_body'];
    } else {
      lyrics = "Not Available";
    }
  }
}
