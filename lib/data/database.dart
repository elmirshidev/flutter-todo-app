import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List todoList = [];
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    todoList = [
      ["Learn flutter",false],
      ["Be pro at flutter",false]
    ];
    // _myBox.put("TODOLIST", todoList);
  }
  
  
  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  void updateDatabase() {
    _myBox.put("TODOLIST", todoList);
  }
}