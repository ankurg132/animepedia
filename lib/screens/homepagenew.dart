import 'package:animepedia/constants/color.dart';
import 'package:animepedia/extensions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:animepedia/models/FilterData.dart';
import 'package:animepedia/models/characters.dart';
import 'package:extended_image/extended_image.dart';
import 'package:animepedia/provider/character_call.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:animepedia/screens/filterscreen.dart';
import 'animedetailscreen.dart';
import 'homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

class MyHomePageNew extends StatefulWidget {
  const MyHomePageNew({Key? key, required this.title}) : super(key: key);
  static const routeName = '/homenew';
  final String title;
  @override
  State<MyHomePageNew> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageNew> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context, listen: false);
    List<Widget> _widgetOptions = <Widget>[
      HomeTabBarWidget(
        prov: prov,
      ),
      MyHomePage(title: "Animepedia: Anime/Manga Recs"),
    ];
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Movies',
                  ),
                  Tab(
                    text: 'TV Shows',
                  ),
                  Tab(
                    text: 'Manga',
                  ),
                ],
              ),
              backgroundColor: MyColors.primaryColor,
              title: Text(
                widget.title,
                style: TextStyle(color: MyColors.secColor),
              ),
            ),
            body: HomeTabBarWidget(prov: prov),
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
                if (index == 1) {
                  Navigator.pushReplacementNamed(context, MyHomePage.routeName);
                }
                setState(() {
                  _currentIndex = index;
                });
              },
            )));
  }
}

class HomeTabBarWidget extends StatelessWidget {
  const HomeTabBarWidget({
    Key? key,
    required this.prov,
  }) : super(key: key);

  final BookProvider prov;

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      FutureBuilder(
        future: prov.getHomePageData(),
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
                      prov.getHomePageData();
                    },
                    child: const Text('Try Again'))
              ],
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomeDataWidget();
          }
          return Container();
        },
      ),
      Container(),
      Container(),
      Container()
    ]);
  }
}

class HomeDataWidget extends StatefulWidget {
  const HomeDataWidget({Key? key}) : super(key: key);

  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<HomeDataWidget> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context);
    final data = prov.trendingAnime.last.data?.page?.media;
    // print(data?.coverImage?.color.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Trending Anime',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBoxMedSize(),
        CarouselSlider(
          options: CarouselOptions(height: 250.0, autoPlay: true),
          items: [0, 1, 2, 3, 4].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: (() => {
                        Navigator.pushNamed(context, BookDetailScreen.routeName,
                            arguments: data?[i])
                      }),
                  child: Card(
                      // color: HexColor(data?[i].coverImage?.color ?? '#ffffff'),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Image.network(
                            data?[i].coverImage?.large.toString() ?? '',
                            fit: BoxFit.fitWidth,
                            height: 200,
                            width: 500,
                          ),
                          SizedBoxMedSize(),
                          Text(
                            data?[i].title?.english ??
                                data?[i].title?.romaji ??
                                '',
                            style: TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      )),
                );
              },
            );
          }).toList(),
        )
      ]),
    );
  }
}
