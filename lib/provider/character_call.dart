import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:starwars_guide/models/FilterData.dart';
import '../models/characters.dart';

class BookProvider with ChangeNotifier {
  List<AnimeData> animeData = [];
  List<Media> animeList = [];
  // List<Results> results = [];
  String state = '';
  String searchText = '';
  Map variables = {
    "perPage": "10",
    "sort":"POPULARITY_DESC"
  };

  Future resetVariable() async {
    variables.clear();
    animeData.clear();
    animeList.clear();
    state = '';
    variables = {
    "perPage": "10",
    "sort":"POPULARITY_DESC"
    };
    FilterData.genreText = '';
    FilterData.releaseDropdown = 'NONE';
    FilterData.nsfwEnabled = false;
    FilterData.mediaFormat = 'NONE';
    notifyListeners();
    await getData("0");
  }

  Future getData(String page) async {
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
        medium
      }
      duration
      isAdult
      genres
      averageScore
      popularity
      episodes
      chapters
      volumes
      countryOfOrigin
      hashtag
      averageScore
      bannerImage
    }
  }
}
''';
    variables["page"] = page;
    // if(search!=''){
    //   variables["search"] = search;
    // }
    print("SENDING REQ");
    print("VAR NOW IS: "+variables.toString());
    final response = await http.post(
      Uri.parse('https://graphql.anilist.co'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"query": query, "variables": variables}),
    );
    if (response.statusCode == 200) {
      log(response.body);
      // if(search!=''){
      //   animeData = [];
      //   animeList = [];
      // }
      animeData.add(AnimeData.fromJson(jsonDecode(response.body)));
      animeList.addAll(animeData.last.data?.page?.media??[]);
      // animeList.addAll(iterable)
      // notifyListeners();
    //   if(search!=''){
    //   state = 'search';
      searchText = variables['search']??'';
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
  
    // print(response);
  }
}
