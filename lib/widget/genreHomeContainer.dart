import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../provider/character_call.dart';
import '../screens/animedetailscreen.dart';
import '../screens/homepage.dart';

class GenreHomeContainer extends StatelessWidget {
  const GenreHomeContainer({
    Key? key,
    required this.prov,
  }) : super(key: key);

  final BookProvider prov;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBoxMedSize(),
        SizedBox(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: prov.genres.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    prov.variables['genre'] = prov.genres[index];
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        MyHomePage.routeName, ((route) => false));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: MyColors.secColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      prov.genres[index],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
