import 'package:assignment_sqflite_todo/DB/db_hand.dart';
import 'package:flutter/material.dart';
import '../Model/model.dart';
import 'appupdate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBhelper? dBhelp;
  late Future<List<TodoModel>> dataList;

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
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text('Home Todo'),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.help_outline_rounded, size: 30)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: dataList,
            builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Task to do',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int todoId = snapshot.data![index].id!.toInt();
                      String todoTitle = snapshot.data![index].title.toString();
                      String todoDisc = snapshot.data![index].disc.toString();
                      String todoDT =
                          snapshot.data![index].dateAndtime.toString();
                      return Dismissible(
                        key: ValueKey<int>(todoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete_forever,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            dBhelp!.delete(todoId);
                            dataList = dBhelp!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.lightGreenAccent,
                              Colors.green
                            ]),
                          ),
                          child: Column(
                            children: [
                              const Divider(
                                color: Colors.white,
                                thickness: 1.5,
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Text(
                                    todoTitle,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                subtitle: Text(
                                  todoDisc,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      todoDT,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.8,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddupTask(
                                                      todoId: todoId,
                                                      todoTitle: todoTitle,
                                                      todoDisc: todoDisc,
                                                      todoDateTime: todoDT,
                                                      todoUpdate: true,
                                                    )));
                                      },
                                      child: const Icon(
                                        Icons.edit_notifications_rounded,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddupTask(),
              ));
        },
      ),
    );
  }
}
