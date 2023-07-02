import 'package:flutter/material.dart';
import 'package:voiceass/pallete.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String descriptiontext;
  final String headertext;
  const FeatureBox(
      {super.key,
      required this.color,
      required this.headertext,
      required this.descriptiontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(top: 20,left: 15,bottom: 20,),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headertext,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
           const SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.only(right:20.0),
              child: Text(
                descriptiontext,
                style: const TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Pallete.mainFontColor,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
