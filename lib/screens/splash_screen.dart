import 'package:firebase_practice/constraints/Colours.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Colours.backgroundColor),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          mainAxisAlignment: .center,
          children: [
            Spacer(),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("lib/assets/flutter_logo.png",height: 40,),
              ),
            ),
            Text("Firebase Task Manager", style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Color(Colours.fontColor),
              fontWeight: FontWeight.w600
            ),),
            Text("A simple task manager powered by Flutter & Firestore", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Color(Colours.secondaryFontColor),
            ),),
            Spacer(),
            CircularProgressIndicator(
              color: Colors.blue.shade800,
              backgroundColor: Colors.white,
              strokeWidth: 3,
              strokeAlign: -6,
            ),
            Text("Initializing...", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Color(Colours.secondaryFontColor),
            ),),
            Text("FLUTTER . FIREBASE", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Color(Colours.secondaryFontColor),
            ),),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
