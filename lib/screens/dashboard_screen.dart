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
                          color: (data[index]["isDone"]) ? Colors.grey.shade200 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: BoxBorder.all(
                              color: Colors.grey.shade300,
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignOutside
                          )
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: data[index]["isDone"],
                          onChanged: (value) async {
                            try{
                              await firebaseFirestore.collection(Firestore.collectionName)
                                  .doc(auth.currentUser!.uid)
                                  .collection(Firestore.taskCollectionName)
                                  .doc(data[index]["docId"])
                                  .update({
                                "isDone": value ?? false
                              });

                            } on FirebaseException catch(e){
                              if(mounted){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(e.message!),
                                ));
                              }
                            }
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
              builder: (context) => CreateTaskScreen(forEdit: false,),
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
  
  // get the priority color
  List<Color> getPriorityColor(dynamic data, int index){
    if(data[index]["priority"].toString().contains("Low")){
      return [Colors.green.shade900, Colors.green.shade50];
    } else if(data[index]["priority"].toString().contains("Medium")){
      return [Colors.orange.shade900, Colors.orange.shade50];
    } else {
      return [Colors.red.shade900, Colors.red.shade50];
    }
  }

  // tasks
  Widget tasks(dynamic data, int index){
    List<Color> priorityColors = getPriorityColor(data, index);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Card(
              color: priorityColors[1],
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
                          color: priorityColors[0],
                          borderRadius: BorderRadius.circular(6)
                      ),
                    ),
                    Text(data[index]["priority"], style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: priorityColors[0],
                        fontWeight: FontWeight.w600
                    ),),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: data[index]["isDone"],
              child: Card(
                color: Colors.green.shade50,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                  child: Row(
                    spacing: 4,
                    mainAxisSize: .min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.green.shade800,
                            borderRadius: BorderRadius.circular(6)
                        ),
                      ),
                      Text("Done", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600
                      ),),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                //edit the task
                String title = data[index]["title"];
                String note = data[index]["note"];
                DateTime dueDate = data[index]["dueDate"].toDate();
                String priority = data[index]["priority"];
                bool isDone = data[index]["isDone"];
                String docId = data[index]["docId"];

                //navigate to the create task screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTaskScreen(
                  forEdit: true,
                  titleText: title,
                  noteText: note,
                  priority: priority,
                  dueDate: dueDate,
                  docId: docId,
                  isDone: isDone,
                ),));
              },
              style: IconButton.styleFrom(
                  foregroundColor: Color(Colours.secondaryFontColor)
              ),
              icon: Icon(Icons.edit)
            ),
            IconButton(
              onPressed: () async {
                //delete the task
                try{
                  await showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      title: Row(
                        mainAxisSize: .min,
                        spacing: 6,
                        children: [
                          Icon(Icons.dangerous, color: Colors.orange.shade700, size: 20,),
                          Text("Delete!!", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Color(Colours.fontColor),
                            fontWeight: FontWeight.w600
                          ),)
                        ],
                      ),
                      content: Text("Do you want to delete the task?", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Color(Colours.fontColor),
                      ),),
                      actions: [
                        TextButton(onPressed: () async {
                          await firebaseFirestore.collection(Firestore.collectionName)
                              .doc(auth.currentUser!.uid)
                              .collection(Firestore.taskCollectionName)
                              .doc(data[index]["docId"])
                              .delete();
                          Navigator.pop(context);
                        }, child: Text("Yes")),
                        TextButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("No")),
                      ],
                    );
                  },);
                } on FirebaseException catch(e){
                  if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
                  }
                }
              },
              style: IconButton.styleFrom(
                  foregroundColor: Color(Colours.secondaryFontColor)
              ),
              icon: Icon(Icons.delete)
            ),
          ],
        ),
        Text(data[index]["title"], style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: (data[index]["isDone"]) ? Color(Colours.secondaryFontColor) : Color(Colours.fontColor),
          fontWeight: FontWeight.w600,
          decoration: (data[index]["isDone"]) ? TextDecoration.lineThrough : TextDecoration.none,
          decorationColor: Color(Colours.secondaryFontColor)
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
            data[index]["isDone"] ? Icon(Icons.check_circle_rounded, size: 17, color: Color(Colours.secondaryFontColor),)
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
