import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starwars_guide/provider/character_call.dart';
import 'package:starwars_guide/screens/bookdetailscreen.dart';
import 'package:starwars_guide/screens/filterscreen.dart';
import 'screens/homepage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
              home: const MyHomePage(title: 'Animepedia: Anime/Manga Recs'),
              routes: {
                MyHomePage.routeName: (context) => const MyHomePage(title: 'Animepedia: Anime/Manga Recs'),
                BookDetailScreen.routeName: (context) => const BookDetailScreen(),
                FilterScreen.routeName: (context) => const FilterScreen(),
              },
      ),
    );
  }
}