import "dart:convert";

import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:shared_preferences/shared_preferences.dart';

import "../model/task.dart";

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;
  late List<Task> _tasks;
  late List<bool> _tasksDone;

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);

    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    list.add(json.encode(t.getMap())); //add the last element to list
    // //encode for converting to JSON string by calling list and set to data storage
    prefs.setString('task', json.encode(list));

    // prefs.remove('task');
    _taskController.text = '';
    Navigator.of(context).pop();

    getTasks();
  }

  void getTasks() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    for (dynamic d in list) {
      // print(d.runtimeType);
      _tasks.add(Task.fromMap(json.decode(d)));
    }

    _tasksDone = List.generate(_tasks.length, (index) => false);
    print(_tasks);
    setState(() {});
  }

  void updatePendingTasksList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList =[];
    for(var i=0;i<_tasks.length; i++){
      if(!_tasksDone[i]) pendingList.add(_tasks[i]);
    }
    
    var pendingListEncoded = List.generate(pendingList.length, (i) => json.encode(pendingList[i].getMap()));

    prefs.setString('task', json.encode(pendingListEncoded));

    getTasks();
  }

  void deleteTasksList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('task', json.encode([]));

    getTasks();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _taskController = TextEditingController();

    getTasks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Task Manager", style: GoogleFonts.montserrat(),),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: updatePendingTasksList,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteTasksList,
            )
          ],
      ),
      body: (_tasks == null) ? Center(child: Text("No Tasks added yet!")) :
      Column(
        children: _tasks.map((e)=> Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5.0
          ),
          padding: const EdgeInsets.only(
              left: 10.0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e.task, style: GoogleFonts.montserrat()),
              Checkbox(
                  value: _tasksDone[_tasks.indexOf(e)],
                  key: GlobalKey(),
                  onChanged: (val) {
                    setState(() {
                      _tasksDone[_tasks.indexOf(e)] = val!;
                    });
                  }
              )
            ],
          ),
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () =>
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) =>
                    Container(
                        padding: EdgeInsets.all(10.0),
                        height: 900,
                        color: Colors.blue.shade100,
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                      "Add Task",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 20
                                      )
                                  ),
                                  //
                                  GestureDetector(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Icon(Icons.add)
                                  ),
                                ],
                              ),
                              Divider(thickness: 1.2),
                              SizedBox(height: 20.0),
                              TextField(
                                controller: _taskController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            5.0),
                                        borderSide: const BorderSide(color: Colors
                                            .blue)
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Enter task",
                                    hintStyle: GoogleFonts.montserrat()
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                // height: 200.0,
                                child: Row(
                                  children: [
                                    Container(
                                      //half screen size - padding(10)
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2 - 20,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.blue),
                                        ),
                                        child: Text(
                                          "RESET",
                                          style: GoogleFonts.montserrat(),
                                        ),
                                        onPressed: () =>
                                        _taskController.text = "",
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width / 2 - 20,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.white),
                                        ),
                                        child: Text(
                                          "ADD",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.blue),
                                        ),
                                        onPressed: () => saveData(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ])
                    )),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}