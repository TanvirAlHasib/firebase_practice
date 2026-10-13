import 'package:firebase_practice/constraints/Colours.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Colours.backgroundColor),
      appBar: myAppBar(context),
    );
  }

  // appbar
  AppBar myAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Color(Colours.backgroundColor),
      elevation: 2,
      title: Column(
        crossAxisAlignment: .start,
        spacing: 0,
        children: [
          Row(
            spacing: 3,
            mainAxisSize: .min,
            children: [
              Text("Task", style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Color(Colours.fontColor),
                  fontWeight: FontWeight.w600
              ),),
              Card(
                elevation: 0,
                color: Color(0XFFE0EDF4),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text("4TOTAL", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500
                  ),),
                ),
              )
            ],
          ),
          Text("Today. Monday,Oct 5", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Color(Colours.secondaryFontColor),
              fontWeight: FontWeight.w700
          ),),
          const SizedBox(
            height: 10,
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () {

        }, icon: Icon(Icons.search))
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 5),
    );
  }
}
