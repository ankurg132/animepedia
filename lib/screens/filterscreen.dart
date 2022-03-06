import 'package:flutter/material.dart';
import 'package:starwars_guide/models/FilterData.dart';
import 'package:starwars_guide/models/characters.dart';
import 'package:provider/provider.dart';
import 'package:starwars_guide/screens/homepage.dart';

import '../provider/character_call.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);
  static const routeName = '/filter';

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  //for NSFW
  bool showNsfw = FilterData.nsfwEnabled;
  bool nsfwEnabled = false;
  
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
  TextEditingController genreController = TextEditingController(text: FilterData.genreText);

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
      ),
      body: Column(
        children: [

          //FOR NSFW
          const Text('Show NSFW'),
          Switch( 
            onChanged: (v){
            setState(() {
              showNsfw = v;
              nsfwEnabled = true;
            });
          }, value: showNsfw,),

          //RELEASE STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Release Status'),
              Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
              DropdownButton(
                  value: releaseDropdown,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: releaseDropdownItem.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
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
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Genre',
              ),
              onChanged: (value) {
              },
              controller: genreController,
            ),

            //media format
            DropdownButton(
              value: mediaFormat,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: mediaFormatItem.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) { 
                setState(() {
                  mediaFormat = newValue!;
                });
              },
            ),
          TextButton(
              onPressed: (){
                if(nsfwEnabled){
                  prov.variables['isAdult'] = showNsfw;
                  FilterData.nsfwEnabled = showNsfw;
                }
                switch(releaseDropdown){
                  case 'NONE': prov.variables.remove('status'); break;
                  case 'FINISHED': prov.variables['status'] = 'FINISHED'; break;
                  case 'RELEASING': prov.variables['status'] = 'RELEASING'; break;
                  case 'NOT_YET_RELEASED': prov.variables['status'] = 'NOT_YET_RELEASED'; break;
                  case 'CANCELLED': prov.variables['status'] = 'CANCELLED'; break;
                  default: break;
                }
                FilterData.releaseDropdown = releaseDropdown;
                if(genreController.text!=''){
                  prov.variables['genre'] = genreController.text;
                  FilterData.genreText = genreController.text;
                }
                switch(mediaFormat){
                  case 'NONE':prov.variables.remove('format'); break;
                  case 'TV': prov.variables['format'] = 'TV'; break;
                  case 'TV_SHORT': prov.variables['format'] = 'TV_SHORT'; break;
                  case 'MOVIE': prov.variables['format'] = 'MOVIE'; break;
                  case 'OVA': prov.variables['format'] = 'OVA'; break;
                  case 'ONA': prov.variables['format'] = 'ONA'; break;
                  case 'SPECIAL': prov.variables['format'] = 'SPECIAL'; break;
                  case 'MUSIC': prov.variables['format'] = 'MUSIC'; break;
                  case 'MANGA': prov.variables['format'] = 'MANGA'; break;
                  case 'NOVEL': prov.variables['format'] = 'NOVEL'; break;
                  case 'ONE_SHOT': prov.variables['format'] = 'ONE_SHOT'; break;
                  default: break;
                }
                FilterData.mediaFormat = mediaFormat;
                Navigator.of(context)
                  .pushNamedAndRemoveUntil(MyHomePage.routeName,((route) => false));},
              child: const Text('Save'))
        ],
      ),
    );
  }
}


