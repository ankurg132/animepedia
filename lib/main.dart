import 'package:animepedia/constants/color.dart';
import 'package:animepedia/screens/homepagenew.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animepedia/provider/character_call.dart';
import 'package:animepedia/screens/animedetailscreen.dart';
import 'package:animepedia/screens/filterscreen.dart';
import 'screens/homepage.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BookProvider>(
          create: (_) => BookProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Animepedia: Anime/Manga Recs',
        home: const MyHomePageNew(title: 'Animepedia: Anime/Manga Recs'),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
            primaryColor: MyColors.primaryColor,
            scaffoldBackgroundColor: MyColors.primaryColor,
            iconTheme: const IconThemeData(color: MyColors.textColor),
            primaryIconTheme: const IconThemeData(color: MyColors.textColor),
            // inputDecorationTheme: const InputDecorationTheme(
            //     labelStyle: TextStyle(color: MyColors.textColor,)),
            textTheme: const TextTheme(
              bodyText1: TextStyle(
                color: MyColors.textColor,
                fontSize: 18,
              ),
              bodyText2: TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            )),
        routes: {
          MyHomePage.routeName: (context) =>
              const MyHomePage(title: 'Animepedia: Anime/Manga Recs'),
          BookDetailScreen.routeName: (context) => BookDetailScreen(),
          FilterScreen.routeName: (context) => const FilterScreen(),
          MyHomePageNew.routeName: (context) => const MyHomePageNew(title: 'Animepedia: Anime/Manga Recs'),
        },
      ),
    );
  }
}
