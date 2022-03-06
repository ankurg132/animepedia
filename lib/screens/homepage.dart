import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:starwars_guide/models/characters.dart';
import 'package:extended_image/extended_image.dart';
import 'package:starwars_guide/provider/character_call.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:starwars_guide/screens/filterscreen.dart';
import 'bookdetailscreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: prov.state != 'search' ? prov.getData("0") : Future(() => null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
                child: Column(
                  children: [
                    const Text('Error! Please check your connection or try again later'),
                    TextButton(onPressed: (){prov.getData("0");}, child: const Text('Try Again'))
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
        onPressed: () =>
            Navigator.of(context).pushNamed(FilterScreen.routeName),
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(
      //         child: Text(
      //           'Star Wars Guide',
      //           style: TextStyle(fontSize: 20, color: Colors.white),
      //         ),
      //         // decoration: BoxDecoration(
      //         //   color: MyColors.primary,
      //         // ),
      //       ),
      //       ListTile(
      //         title: Text('Text to Yoda'),
      //         onTap: () {
      //           Navigator.pushNamed(context, YodaTextScreen.routeName,
      //               arguments: 'yoda');
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Text to Sith'),
      //         onTap: () {
      //           Navigator.pushNamed(context, YodaTextScreen.routeName,
      //               arguments: 'sith');
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Text to Gungan'),
      //         onTap: () {
      //           Navigator.pushNamed(context, YodaTextScreen.routeName,
      //               arguments: 'gungan');
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Text to Huttesse'),
      //         onTap: () {
      //           Navigator.pushNamed(context, YodaTextScreen.routeName,
      //               arguments: 'huttesse');
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Text to Mandalorian'),
      //         onTap: () {
      //           Navigator.pushNamed(context, YodaTextScreen.routeName,
      //               arguments: 'mandalorian');
      //         },
      //       ),
      //       ListTile(
      //         title: Text('Text to cheunh'),
      //         onTap: () {
      //           Navigator.pushNamed(context, YodaTextScreen.routeName,
      //               arguments: 'cheunh');
      //         },
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

class DataWidget extends StatefulWidget {
  const DataWidget({Key? key}) : super(key: key);

  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  static const _pageSize = 10;
  bool first = false;

  final PagingController<int, Media> _pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final prov = Provider.of<BookProvider>(context, listen: false);
      print("FETCHING PAGE " +
          (prov.animeData.last.data?.page?.pageInfo?.currentPage).toString());
      var nextPage = 0;
      if (prov.animeData.last.data?.page?.pageInfo?.currentPage != null &&
          first) {
        nextPage = prov.animeData.last.data!.page!.pageInfo!.currentPage + 1;
      }
      final newItems = await prov.getData((nextPage).toString());
      first = true;
      if (prov.animeData.last.data?.page?.pageInfo?.hasNextPage == false) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        print("NEXTPAGEKY" + nextPageKey.toString());
        _pagingController.appendPage(newItems, nextPageKey.toInt());
        print("Appeded");
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<BookProvider>(context);
    searchController.text = prov.searchText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.black),
              suffix: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  if (searchController.text != '') {
                    prov.variables['search'] = searchController.text;
                  } else {
                    prov.variables.remove('search');
                  }
                  prov.getData("0");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MyHomePage.routeName, (route) => false);
                },
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  prov.resetVariable();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MyHomePage.routeName, (route) => false);
                  // prov.getData("0", "");
                },
                icon: Icon(Icons.clear),
              )
              // hintText: 'Search Docs',
              ),
          controller: searchController,
          onFieldSubmitted: (value) {
            if (searchController.text != '') {
              prov.variables['search'] = searchController.text;
            } else {
              prov.variables.remove('search');
            }
            prov.getData("0");
            Navigator.of(context)
                .pushNamedAndRemoveUntil(MyHomePage.routeName, (route) => false);
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Most Popular: '),
      ),
      Expanded(
          child:
              // child: prov.state == 'search'
              // ? GridView.builder(
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2, childAspectRatio: 3.0 / 4.6),
              //     itemCount: prov.animeList.length,
              //     itemBuilder: (context, index) {
              //       return InkWell(
              //         // onTap: () => Navigator.pushNamed(
              //         //     context, BookDetailScreen.routeName,
              //         //     arguments: prov.searchData.results?[index]),
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Card(
              //             color: Colors.white12,
              //             child: Column(
              //               children: <Widget>[
              //                 ExtendedImage.network(
              //                   prov.animeList[index].coverImage?.medium
              //                           .toString() ??
              //                       '',
              //                   width: double.infinity,
              //                   height: 230,
              //                   fit: BoxFit.fitHeight,
              //                   cache: true,
              //                   //cancelToken: cancellationToken,
              //                 ),
              //                 const Spacer(),
              //                 // prov.state == 'search'
              //                 //     ? Text(
              //                 //         prov.searchData.results![index].title
              //                 //             .toString(),
              //                 //         overflow: TextOverflow.ellipsis)
              //                 //     :
              //                 Text(
              //                   prov.animeList[index].title?.english ??
              //                       prov.animeList[index].title?.romaji ??
              //                       prov.animeList[index].title?.native ??
              //                       '',
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //                 const Spacer()
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     })
              // :
              PagedGridView<int, Media>(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 3.0 / 4.6),
                  builderDelegate: PagedChildBuilderDelegate<Media>(
                    itemBuilder: (context, item, index) => InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, BookDetailScreen.routeName,
                          arguments: item),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white12,
                          child: Column(
                            children: <Widget>[
                              ExtendedImage.network(
                                item.coverImage?.medium.toString() ?? '',
                                width: double.infinity,
                                height: 230,
                                fit: BoxFit.fitHeight,
                                cache: true,
                                //cancelToken: cancellationToken,
                              ),
                              const Spacer(),
                              Text(
                                item.title?.english ??
                                    item.title?.romaji ??
                                    item.title?.native ??
                                    '',
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer()
                            ],
                          ),
                        ),
                      ),
                    ),
                  )))
    ]);
  }
}
