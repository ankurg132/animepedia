import 'package:animepedia/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:animepedia/models/FilterData.dart';
import 'package:animepedia/models/characters.dart';
import 'package:provider/provider.dart';
import 'package:animepedia/screens/homepage.dart';

import '../provider/character_call.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);
  static const routeName = '/filter';

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  //Release Status
  String releaseDropdown = FilterData.releaseDropdown;
  final releaseDropdownItem = [
    'NONE',
    'FINISHED',
    'RELEASING',
    'NOT_YET_RELEASED',
    'CANCELLED',
  ];

  //Genre
  String genreDropdown = FilterData.genreText;
  final genreDropdownItem = [
    "NONE",
    "Action",
    "Adventure",
    "Comedy",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Hentai",
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
  // TextEditingController genreController = TextEditingController(text: FilterData.genreText);

  //Media Format
  String mediaFormat = FilterData.mediaFormat;
  final mediaFormatItem = [
    'NONE',
    'TV',
    'TV_SHORT',
    'MOVIE',
    'OVA',
    'ONA',
    'SPECIAL',
    'MUSIC',
    'MANGA',
    'NOVEL',
    'ONE_SHOT'
  ];

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              switch (releaseDropdown) {
                case 'NONE':
                  prov.variables.remove('status');
                  break;
                default:
                  prov.variables['status'] = releaseDropdown;
                  break;
              }
              FilterData.releaseDropdown = releaseDropdown;
              switch (genreDropdown) {
                case 'NONE':
                  prov.variables.remove('genre');
                  break;
                default:
                  prov.variables['genre'] = genreDropdown;
                  break;
              }
              FilterData.genreText = genreDropdown;
              switch (mediaFormat) {
                case 'NONE':
                  prov.variables.remove('format');
                  break;
                default:
                  prov.variables['format'] = mediaFormat;
                  break;
              }
              FilterData.mediaFormat = mediaFormat;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MyHomePage.routeName, ((route) => false));
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          //RELEASE STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Release Status'),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
              DropdownButton(
                dropdownColor: Colors.black,
                value: releaseDropdown,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: releaseDropdownItem.map((String items) {
                  return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(color: MyColors.textColor),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    releaseDropdown = newValue!;
                  });
                },
              ),
            ],
          ),

          //genre
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Genre'),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
              DropdownButton(
                dropdownColor: Colors.black,
                value: genreDropdown,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: genreDropdownItem.map((String items) {
                  return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(color: MyColors.textColor),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    genreDropdown = newValue!;
                  });
                },
              ),
            ],
          ),

          //media format
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Format'),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
              DropdownButton(
                dropdownColor: Colors.black,
                value: mediaFormat,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: mediaFormatItem.map((String items) {
                  return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: const TextStyle(color: Colors.white),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    mediaFormat = newValue!;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                switch (releaseDropdown) {
                  case 'NONE':
                    prov.variables.remove('status');
                    break;
                  default:
                    prov.variables['status'] = releaseDropdown;
                    break;
                }
                FilterData.releaseDropdown = releaseDropdown;
                switch (genreDropdown) {
                  case 'NONE':
                    prov.variables.remove('genre');
                    break;
                  default:
                    prov.variables['genre'] = genreDropdown;
                    break;
                }
                FilterData.genreText = genreDropdown;
                switch (mediaFormat) {
                  case 'NONE':
                    prov.variables.remove('format');
                    break;
                  default:
                    prov.variables['format'] = mediaFormat;
                    break;
                }
                FilterData.mediaFormat = mediaFormat;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MyHomePage.routeName, ((route) => false));
              },
              child: const Text('Search'))
        ],
      ),
    );
  }
}
