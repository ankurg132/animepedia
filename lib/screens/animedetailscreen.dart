import 'package:flutter/material.dart';
import 'package:animepedia/models/FilterData.dart';
import 'package:animepedia/models/characters.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter_html/flutter_html.dart';

class BookDetailScreen extends StatefulWidget {
  BookDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/books';

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: true,
      ),
    )..onInit = () {
        _controller.loadVideoById(
          videoId: FilterData.videoId,
        );
      };
  }

  // YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: FilterData.videoId,
  //   params: YoutubePlayerParams(
  //     showControls: true,
  //     showFullscreenButton: true,
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    final Media results = ModalRoute.of(context)!.settings.arguments as Media;
    List<String> genres = results.genres ?? [];
    return YoutubePlayerScaffold(
        controller: _controller,
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              title: Text(results.title?.english ?? ''),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExtendedImage.network(results.bannerImage.toString()),
                    const SizedBoxMedSize(),
                    Text(results.title?.english ?? results.title?.native ?? ''),
                    SizedBox(
                      // width: double.infinity,
                      height: 50,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var genre in genres)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    genre,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text("AVERAGE SCORE: ${results.averageScore.toString()}"),
                    Text(
                        "Originated In: ${results.countryOfOrigin.toString()}"),
                    const SizedBoxMedSize(),
                    results.trailer?.site == 'youtube' ? player : Container(),
                    const SizedBoxMedSize(),
                    Html(
                      data: results.description.toString(),
                    ),
                    // Text(results.description.toString()),
                    const SizedBoxMedSize(),
                    Text("GENRE: ${results.genres.toString()}"),
                    Text("SYNONYMS: ${results.synonyms.toString()}"),
                    results.duration.toString() == "null"
                        ? Container()
                        : Text("DURATION: ${results.duration.toString()} mins"),
                    results.chapters.toString() == "null"
                        ? Container()
                        : Text("CHAPTERS: ${results.chapters.toString()}"),
                    results.volumes.toString() == "null"
                        ? Container()
                        : Text("VOLUMES: ${results.volumes.toString()}"),
                    results.hashtag.toString() == "null"
                        ? Container()
                        : Text("HASHTAG: ${results.hashtag.toString()}"),
                    results.episodes.toString() == "null"
                        ? Container()
                        : Text("EPISODES: ${results.episodes.toString()}"),
                    Text("POPULARITY: ${results.popularity.toString()}"),
                    Text("MEAN SCORE: ${results.meanScore.toString()}"),
                    const SizedBoxMedSize(),
                    Text(
                        "END DATE: ${results.endDate?.day.toString()}/${results.endDate?.month.toString()}/${results.endDate?.year.toString()}"),
                    Text(
                        "START DATE: ${results.startDate?.day.toString()}/${results.startDate?.month.toString()}/${results.startDate?.year.toString()}"),
                    const SizedBoxMedSize(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class SizedBoxMedSize extends StatelessWidget {
  const SizedBoxMedSize({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 10);
  }
}
