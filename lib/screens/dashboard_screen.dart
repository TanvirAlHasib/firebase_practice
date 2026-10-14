import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/constraints/Colours.dart';
import 'package:firebase_practice/constraints/firestore.dart';
import 'package:firebase_practice/screens/create_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDone = false;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Colours.backgroundColor),
      appBar: myAppBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: StreamBuilder(
          stream: firebaseFirestore.collection(Firestore.collectionName)
              .doc(auth.currentUser?.uid).collection(Firestore.taskCollectionName).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            //checking the state
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(snapshot.hasError){
              return Center(
                child: Text("Failed to load task!!", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Color(Colours.fontColor),
                ),),
              );
            }

            //if there is no data
            if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return Center(
                child: Text("There is no task!!", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Color(Colours.fontColor)
                )),
              );
            }

            //getting the data
            final data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: BoxBorder.all(
                              color: Colors.grey.shade300,
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignOutside
                          )
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = value ?? false;
                            });
                          },
                          shape: const CircleBorder(),
                          side: BorderSide(
                              color: Color(Colours.buttonColor),
                              width: 1
                          ),
                          checkColor: Colors.white,
                          activeColor: Color(Colours.secondaryFontColor),
                        ),
                        title: tasks(data, index),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(Colours.buttonColor),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          "New Task",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
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
          Text("Today. ${getDateFormat()}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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

  // get dateFormat
  String getDateFormat(){
    final date = DateTime.now();
    return DateFormat('EEEE, MMM d').format(date);
  }

  // tasks
  Widget tasks(dynamic data, int index){
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Card(
              color: Colors.red.shade50,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                child: Row(
                  spacing: 4,
                  mainAxisSize: .min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color: Colors.red.shade900,
                          borderRadius: BorderRadius.circular(6)
                      ),
                    ),
                    Text(data[index]["priority"], style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.w600
                    ),),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isDone,
              child: Card(
                color: Colors.green.shade50,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                  child: Text("Done", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w600
                  ),),
                ),
              ),
            ),
            Spacer(),
            IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                    foregroundColor: Color(Colours.secondaryFontColor)
                ),
                icon: Icon(Icons.edit)
            ),
            IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                    foregroundColor: Color(Colours.secondaryFontColor)
                ),
                icon: Icon(Icons.delete)
            ),
          ],
        ),
        Text(data[index]["title"], style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Color(Colours.fontColor),
            fontWeight: FontWeight.w600
        ),),
        const SizedBox(
          height: 2,
        ),
        Text(data[index]["note"], style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Color(Colours.secondaryFontColor),
        ),),
        const SizedBox(
          height: 8,
        ),
        Divider(
          color: Color(Colours.secondaryFontColor),
          thickness: 0.5,
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            isDone ? Icon(Icons.check_circle_rounded, size: 17, color: Color(Colours.secondaryFontColor),)
                : Icon(Icons.calendar_month, size: 17, color: Color(Colours.secondaryFontColor),),
            const SizedBox(
              width: 6,
            ),
            Text("Due ${DateFormat("EEEE, dd MMM").format(data[index]["dueDate"].toDate())}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Color(Colours.secondaryFontColor),
                fontWeight: FontWeight.w600
            ),),
          ],
        )
      ],
    );
  }
}
