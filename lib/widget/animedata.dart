import 'package:animepedia/location/api.dart';
import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../models/FilterData.dart';
import '../models/characters.dart';
import '../provider/character_call.dart';
import '../screens/animedetailscreen.dart';
import '../screens/homepage.dart';
// import 'package:applovin_max/applovin_max.dart';
import 'package:provider/provider.dart';
import 'package:animepedia/constants/color.dart';
import 'package:animepedia/models/FilterData.dart';
import 'package:animepedia/models/characters.dart';
import 'package:extended_image/extended_image.dart';
import 'package:animepedia/provider/character_call.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:animepedia/screens/filterscreen.dart';

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

    // const banner_ad_unit_id = "3a1751bb47b5efbc";
    // AppLovinMAX.createBanner(banner_ad_unit_id, AdViewPosition.bottomCenter);
    // AppLovinMAX.showBanner(banner_ad_unit_id);
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          style: TextStyle(color: MyColors.textColor),
          decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.grey),
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
                icon: Icon(Icons.clear, color: MyColors.textColor),
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
            Navigator.of(context).pushNamedAndRemoveUntil(
                MyHomePage.routeName, (route) => false);
          },
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Most Popular: '),
      ),
      Expanded(
          child: PagedGridView<int, Media>(
              pagingController: _pagingController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3.0 / 4.6),
              builderDelegate: PagedChildBuilderDelegate<Media>(
                itemBuilder: (context, item, index) => InkWell(
                  onTap: () {
                    FilterData.videoId = item.trailer?.id ?? '';
                    Navigator.pushNamed(context, BookDetailScreen.routeName,
                        arguments: item);
                  },
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
              ))),
      // FacebookBannerAd(
      //   placementId: "380574020551996_380576403885091",
      //   bannerSize: BannerSize.STANDARD,
      // ),
      // MaxAdView(
      //   adUnitId: Location.bannerAdId,
      //   adFormat: AdFormat.banner,
      // )
    ]);
  }
}
