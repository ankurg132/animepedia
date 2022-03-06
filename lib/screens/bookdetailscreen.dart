import 'package:flutter/material.dart';
import 'package:starwars_guide/models/characters.dart';
import 'package:extended_image/extended_image.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({ Key? key }) : super(key: key);
  static const routeName = '/books';

  @override
  Widget build(BuildContext context) {
    final Media results =
        ModalRoute.of(context)!.settings.arguments as Media;
    return Scaffold(
      appBar: AppBar(
        title: Text(results.title?.english??''),
      ),
      body: Column(
          children: [
            ExtendedImage.network(results.bannerImage.toString()),
            Text("TITLE: ${results.title?.english??''}"),
            Text("AVERAGE SCORE: ${results.averageScore.toString()}"),
            Text("COUNTRY: ${results.countryOfOrigin.toString()}"),
            Text("DESCRIPTION: ${results.description.toString()}"),
            Text("GENRE: ${results.genres.toString()}"),
            Text("DURATION: ${results.duration.toString()} mins"),
            Text("CHAPTERS (if manga): ${results.chapters.toString()}"),
            Text("EPISODES: ${results.episodes.toString()}"),
            Text("END DATE: ${results.endDate?.day.toString()}/${results.endDate?.month.toString()}/${results.endDate?.year.toString()}"),
            Text("START DATE: ${results.startDate?.day.toString()}/${results.startDate?.month.toString()}/${results.startDate?.year.toString()}"),
          ],
        ),
    );
  }
}