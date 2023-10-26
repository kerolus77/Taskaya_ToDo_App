import 'package:get/get.dart';
import 'package:to_do/db/db_helper.dart';
import 'package:to_do/models/task.dart';

class TaskController extends GetxController{
  
final  RxList<Task> taskList=<Task>[].obs;

 Future<int> addTask({Task? task}) {
     return DBHelper.insert(task);
  }

Future<void> getTask() async{
  final List<Map<String, dynamic>> tasks= await DBHelper.query();
  taskList.assignAll(tasks.map((task) => Task.fromJson(task)).toList());
}

Future<Task> selectTask(int id) async {
  final  List<Map<String, dynamic>> taskData = await DBHelper.getTaskById(id);

  if (taskData.isNotEmpty) {
    final Task task = Task.fromJson(taskData[0]);
    print(task.id);
    getTask(); // Assuming the query returns a single task
    return task;
  } else {
    throw Exception('No task found with ID: $id');
  }
}

 void deleteTask(Task task) async{
  await DBHelper.delete(task);
  getTask();
  
}

 void deleteAllTasks() async{
  await DBHelper.deleteAll();
  getTask();
  
}

void makeIsComplite(int id) async{
  await DBHelper.updateIsCompleted(id);
  getTask();
}

 Future<int> updateTask({required Task task}) async{
 int value=await DBHelper.update(task);
  getTask();
  return value;

}

}