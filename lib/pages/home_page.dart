import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_flutter/data/database.dart';
import 'package:learning_flutter/util/dialog_box.dart';
import 'package:learning_flutter/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _myBox = Hive.box('mybox');
  TodoDatabase db = TodoDatabase();
  
  @override
  void initState() {
    if(_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  //checkbox was tapped
  void checkBoxChanged(bool? value,int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  
  
  //controller for dialog input(getter for new task aka todo)
  final _taskInputController = TextEditingController();



  //save function for new todo
  void saveNewTask() {
    // print(_taskInputController.text);
    String task = _taskInputController.text;
    setState(() {
      if(task != "") {
        db.todoList.add([_taskInputController.text,false]);
      }
    });
    db.updateDatabase();
    Navigator.of(context).pop();
    _taskInputController.clear();
  }

  //create new task
  void createNewTask() {
    showDialog(context: context, builder: (context) {
      return DialogBox(
        controller: _taskInputController,
        onSave: saveNewTask,
        onCancel: () => {
          Navigator.of(context).pop(),
          _taskInputController.clear()
        },
      );
    });
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('TO DO'),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context,index) {
          return TodoTile(
            taskName: db.todoList[index][0],
            taskCompleted: db.todoList[index][1],
            onChanged: (val) {
              return checkBoxChanged(val, index);
            },
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}