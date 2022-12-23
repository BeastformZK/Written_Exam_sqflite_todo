import 'package:assignment_sqflite_todo/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../DB/db_hand.dart';
import '../Model/model.dart';

class AddupTask extends StatefulWidget {
  final int? todoId;
  final String? todoTitle;
  final String? todoDisc;
  final String? todoDateTime;
  final bool? todoUpdate;

  const AddupTask(
      {super.key,
      this.todoId,
      this.todoTitle,
      this.todoDisc,
      this.todoDateTime,
      this.todoUpdate});

  @override
  State<AddupTask> createState() => _AddupTaskState();
}

class _AddupTaskState extends State<AddupTask> {
  DBhelper? dBhelp;
  late Future<List<TodoModel>> dataList;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dBhelp = DBhelper();
    loadData();
  }

  loadData() async {
    dataList = dBhelp!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: widget.todoTitle);
    final TextEditingController discController =
        TextEditingController(text: widget.todoDisc);
    String? appDate;
    if (widget.todoUpdate == true) {
      appDate = 'Update todo';
    } else {
      appDate = 'Add todo';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appDate),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.help_outline_rounded, size: 30)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Note Title',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Task';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: discController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write Here',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Task';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                      color: Colors.green[400],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_formKey.currentState!.validate()) {
                              if (widget.todoUpdate == true) {
                                dBhelp!.update(TodoModel(
                                    id: widget.todoId,
                                    title: titleController.text,
                                    disc: discController.text,
                                    dateAndtime: widget.todoDateTime));
                              } else {
                                dBhelp!.insert(TodoModel(
                                    title: titleController.text,
                                    disc: discController.text,
                                    dateAndtime: DateFormat('ymd')
                                        .add_jm()
                                        .format(DateTime.now())
                                        .toString()));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                              titleController.clear();
                              discController.clear();
                              const snackBar = SnackBar(
                                content: Text('Successfully'),
                                backgroundColor: Colors.green,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              //showSuccessMessage('Update Successful');
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      )),
                  Material(
                      color: Colors.red[400],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            titleController.clear();
                            discController.clear();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
