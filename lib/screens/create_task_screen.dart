import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/constraints/Colours.dart';
import 'package:firebase_practice/constraints/firestore.dart';
import 'package:firebase_practice/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends StatefulWidget {
  CreateTaskScreen({super.key, this.titleText, this.noteText, this.priority, this.dueDate, required this.forEdit});
  String? titleText;
  String? noteText;
  DateTime? dueDate;
  String? priority;
  final bool forEdit;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  DateTime selectedDate = DateTime.now();
  String selectedPriority = "Medium";
  bool isLoading = false;

  @override
  void initState() {
    if(widget.forEdit){
      titleController.text = widget.titleText!;
      notesController.text = widget.noteText!;
      selectedDate = widget.dueDate!;
      selectedPriority = widget.priority!;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // Select Due Date
  Future<void> selectDueDate() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(Colours.backgroundColor),

      appBar: AppBar(
        backgroundColor: Color(Colours.backgroundColor),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(Colours.fontColor),
          ),
        ),

        title: Text(
          "New Task",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Color(Colours.fontColor),
            fontWeight: FontWeight.w600,
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: Color(0xFFE2E8F0),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [

              // Scrollable Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16, bottom: 20),

                  child: Form(
                    key: formKey,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // TITLE
                        _buildLabel("TITLE"),

                        const SizedBox(height: 8),

                        TextFormField(
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          controller: titleController,
                          textInputAction: TextInputAction.next,

                          decoration: _inputDecoration(
                            hintText: "e.g. Complete Flutter Assignment",
                          ),

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter task title";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        // NOTES
                        _buildLabel("NOTES"),

                        const SizedBox(height: 8),

                        TextFormField(
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          controller: notesController,
                          maxLines: 4,
                          minLines: 4,
                          keyboardType: TextInputType.multiline,

                          decoration: _inputDecoration(
                            hintText: "Add details, links, or notes...",
                          ),
                        ),

                        const SizedBox(height: 22),

                        // DUE DATE
                        _buildLabel("DUE DATE"),

                        const SizedBox(height: 8),

                        InkWell(
                          onTap: selectDueDate,

                          borderRadius: BorderRadius.circular(12),

                          child: Container(
                            width: double.infinity,
                            height: 50,

                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),

                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                              children: [

                                Text(
                                  DateFormat('dd/MM/yyyy').format(selectedDate),

                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(Colours.fontColor),
                                  ),
                                ),

                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 19,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // PRIORITY
                        _buildLabel("PRIORITY"),

                        const SizedBox(height: 10),

                        Row(
                          children: [

                            _priorityButton(
                              title: "Low",
                              color: const Color(0xFF10B981),
                            ),

                            const SizedBox(width: 8),

                            _priorityButton(
                              title: "Medium",
                              color: const Color(0xFFF59E0B),
                            ),

                            const SizedBox(width: 8),

                            _priorityButton(
                              title: "High",
                              color: const Color(0xFFF43F5E),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // BOTTOM BUTTONS
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 10,
                ),

                child: Column(
                  children: [

                    // SAVE TASK
                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (formKey.currentState!.validate()) {

                            final title = titleController.text.trim();
                            final notes = notesController.text.trim();
                            final dueDate = selectedDate;
                            final priority = selectedPriority;

                            try{
                              setState(() {
                                isLoading = true;
                              });
                              // firebase task manage
                              if(auth.currentUser != null && !widget.forEdit){
                                //getting the document reference to store the document id
                                // later it will be needed to update a specific task
                                final docRef = firebaseFirestore.collection(Firestore.collectionName)
                                    .doc(auth.currentUser!.uid)
                                    .collection(Firestore.taskCollectionName)
                                    .doc();
                                //adding the task with doc id
                                await docRef.set({
                                  "title": title,
                                  "note": notes,
                                  "dueDate": dueDate,
                                  "priority": priority,
                                  "isDone": false,
                                  "docId": docRef.id,
                                  "createdAt": DateFormat('dd/MM/yyyy').format(DateTime.now())
                                });

                                if(mounted){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added successfully!!")));
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
                                }

                              } else if(auth.currentUser != null && widget.forEdit){
                                await firebaseFirestore.collection(Firestore.collectionName).doc(auth.currentUser!.uid)
                                    .collection(Firestore.taskCollectionName)
                                    .doc()
                                    .update({
                                      "title": title,
                                      "note": notes,
                                      "dueDate": dueDate,
                                      "priority": priority,
                                      "isDone": false,
                                      "createdAt": DateFormat('dd/MM/yyyy').format(DateTime.now())
                                    });
                                if(mounted){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task updated successfully!!")));
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
                                }
                              } else{
                                return;
                              }

                            } on FirebaseException catch(e){
                              if(mounted){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
                              }
                            } finally{
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Color(Colours.buttonColor),

                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: isLoading
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Save Task",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // CANCEL
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(Colours.secondaryFontColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Label Widget
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Color(Colours.secondaryFontColor),
      ),
    );
  }

  // Input Decoration
  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,

      hintStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF94A3B8),
      ),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Color(Colours.buttonColor),
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  // Priority Button
  Widget _priorityButton({
    required String title,
    required Color color,
  }) {

    final bool isSelected = selectedPriority == title;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPriority = title;
          });
        },

        borderRadius: BorderRadius.circular(12),

        child: Container(
          height: 40,

          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.06)
                : Colors.white,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(
              color: isSelected
                  ? color
                  : const Color(0xFFE2E8F0),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Container(
                width: 6,
                height: 6,

                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 6),

              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF92400E)
                        : Color(Colours.fontColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}