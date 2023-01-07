import 'package:animepedia/constants/color.dart';
import 'package:animepedia/screens/homepagenew.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:animepedia/models/FilterData.dart';
import 'package:animepedia/models/characters.dart';
import 'package:extended_image/extended_image.dart';
import 'package:animepedia/provider/character_call.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:animepedia/screens/filterscreen.dart';
import '../widget/animedata.dart';
import 'animedetailscreen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  static const routeName = '/home';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 1;
    final prov = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.primaryColor,
          title: Text(widget.title, style: const TextStyle(color: MyColors.secColor),),
        ),
        body: FutureBuilder(
          future:
              prov.state != 'search' ? prov.getData("0") : Future(() => null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Column(
                children: [
                  const Text(
                      'Error! Please check your connection or try again later'),
                  TextButton(
                      onPressed: () {
                        prov.getData("0");
                      },
                      child: const Text('Try Again'))
                ],
              ));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const DataWidget();
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.filter_list),
          onPressed: () {
            print(FilterData.genreText);
            print(FilterData.releaseDropdown);
            print(FilterData.mediaFormat);
            print(FilterData.nsfwEnabled);
            Navigator.of(context).pushNamed(FilterScreen.routeName);
          },
        ),
        bottomNavigationBar: CustomNavigationBar(
          iconSize: 30.0,
          selectedColor: Color(0xff040307),
          strokeColor: Color(0x30040307),
          unSelectedColor: Color(0xffacacac),
          backgroundColor: Colors.white,
          items: [
            CustomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
            )
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, MyHomePageNew.routeName);
            }
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}