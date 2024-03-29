import 'dart:convert';
import 'dart:developer';

import 'package:animepedia/location/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:animepedia/models/FilterData.dart';
import '../models/characters.dart';

class BookProvider with ChangeNotifier {
  var query = '''
query (\$page: Int, \$perPage: Int, \$sort: [MediaSort], \$search: String, \$isAdult: Boolean, 
\$status:[MediaStatus], \$genre: String, \$format: MediaFormat) {
  Page (page: \$page, perPage: \$perPage) {
    pageInfo {
      currentPage
      hasNextPage
      perPage
    }
    media(sort: \$sort, search: \$search, isAdult: \$isAdult, status_in:\$status, genre:\$genre, format: \$format) {
      id
      title {
        romaji
        english
        native
      }
      type
      description
      startDate{
        year
        month
        day
      }
      endDate{
        year
        month
        day
      }
      coverImage{
        large
        medium
        color
      }
      duration
      isAdult
      genres
      synonyms
      meanScore
      averageScore
      popularity
      episodes
      chapters
      volumes
      countryOfOrigin
      trailer{
        id
        site
        thumbnail
      }
      hashtag
      averageScore
      bannerImage
    }
  }
  GenreCollection
}
''';
  List<AnimeData> animeData = [];
  List<Media> animeList = [];
  List<AnimeData> trendingAnime = [];
  List<AnimeData> trendingTV = [];
  List<AnimeData> trendingManga = [];
  List<AnimeData> trendingMovie = [];
  // List<Results> results = [];
  String state = '';
  String searchText = '';
  Map variables = {
    "perPage": "10",
    "sort": "POPULARITY_DESC",
    "isAdult": false
  };
  final genres = [
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Horror",
    "Mahou Shoujo",
    "Mecha",
    "Music",
    "Mystery",
    "Psychological",
    "Romance",
    "Sci-Fi",
    "Slice of Life",
    "Sports",
    "Supernatural",
    "Thriller"
  ];

  Future getAPILink() async {
    final response = await http.get(
        Uri.parse(
            'https://api.jsonbin.io/v3/b/63cbcb50c0e7653a055df478?meta=false'),
        headers: <String, String>{
          'X-Master-Key':
              '\$2b\$10\$RYSTcmLz39BTePSp8xPVrOPKftCZN46lvCeYoB7UnU3YMVz53/aEK'
        });
    print("REQ SENT");
    if (response.statusCode == 200) {
      print("REQ 200");
      log(response.body);
      print(response.body);
      final data = jsonDecode(response.body);
      print(data['anime']);
      Location.after2 = data['anime'];
      notifyListeners();
    }
    await getTrending();
    await getTrendingAnime();
    await getTrendingManga();
    await getTrendingMovie();
  }

  Future resetVariable() async {
    variables.clear();
    animeData.clear();
    animeList.clear();
    state = '';
    variables = {"perPage": "10", "sort": "POPULARITY_DESC", "isAdult": false};
    FilterData.genreText = 'NONE';
    FilterData.releaseDropdown = 'NONE';
    FilterData.mediaFormat = 'NONE';
    notifyListeners();
    await getData("0");
  }

  Future getHomePageData() async {
    await getAPILink();
  }

  Future getTrending() async {
    Map variables = {"perPage": "5", "sort": "TRENDING_DESC", "isAdult": false};
    print("SENDING REQ");
    print("VAR NOW IS: " + variables.toString());
    final response = await http.post(
      Uri.parse(Location.after2),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"query": query, "variables": variables}),
    );
    if (response.statusCode == 200) {
      log(response.body);
      print(response.body);
      notifyListeners();
      trendingAnime.add(AnimeData.fromJson(jsonDecode(response.body)));
      return trendingAnime.last.data?.page?.media;
    }
  }

  Future getTrendingMovie() async {
    Map variables = {
      "perPage": "5",
      "sort": "TRENDING_DESC",
      "format": "MOVIE",
      "isAdult": false
    };
    print("SENDING REQ");
    print("VAR NOW IS: " + variables.toString());
    final response = await http.post(
      Uri.parse(Location.after2),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"query": query, "variables": variables}),
    );
    if (response.statusCode == 200) {
      log(response.body);
      print(response.body);
      notifyListeners();
      trendingMovie.add(AnimeData.fromJson(jsonDecode(response.body)));
      return trendingMovie.last.data?.page?.media;
    }
  }

  Future getTrendingAnime() async {
    Map variables = {
      "perPage": "5",
      "sort": "TRENDING_DESC",
      "format": "TV",
      "isAdult": false
    };
    print("SENDING REQ");
    print("VAR NOW IS: " + variables.toString());
    final response = await http.post(
      Uri.parse(Location.after2),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"query": query, "variables": variables}),
    );
    if (response.statusCode == 200) {
      log(response.body);
      print(response.body);
      notifyListeners();
      trendingTV.add(AnimeData.fromJson(jsonDecode(response.body)));
      return trendingTV.last.data?.page?.media;
    }
  }

  Future getTrendingManga() async {
    Map variables = {
      "perPage": "5",
      "sort": "TRENDING_DESC",
      "format": "MANGA",
      "isAdult": false
    };
    print("SENDING REQ");
    print("VAR NOW IS: " + variables.toString());
    final response = await http.post(
      Uri.parse(Location.after2),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"query": query, "variables": variables}),
    );
    if (response.statusCode == 200) {
      log(response.body);
      print(response.body);
      notifyListeners();
      trendingManga.add(AnimeData.fromJson(jsonDecode(response.body)));
      return trendingManga.last.data?.page?.media;
    }
  }

  Future getData(String page) async {
    variables["page"] = page;
    variables["isAdult"] = false;
    // if(search!=''){
    //   variables["search"] = search;
    // }
    print("SENDING REQ");
    print("VAR NOW IS: " + variables.toString());
    final response = await http.post(
      Uri.parse(Location.after2),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"query": query, "variables": variables}),
    );
    if (response.statusCode == 200) {
      log(response.body);
      print(response.body);
      // if(search!=''){
      //   animeData = [];
      //   animeList = [];
      // }
      animeData.add(AnimeData.fromJson(jsonDecode(response.body)));
      animeList.addAll(animeData.last.data?.page?.media ?? []);
      // animeList.addAll(iterable)
      // notifyListeners();
      //   if(search!=''){
      //   state = 'search';
      searchText = variables['search'] ?? '';
      // }
      // else{
      //   state = '';
      //   searchText = '';
      // }
      notifyListeners();
      return animeData.last.data?.page?.media;
      // print(animeData.data?.page?.media?.first.title?.english);
    } else {
      log(response.body);
      print(response.body);
      throw Exception(response.reasonPhrase);
    }
  }
}
