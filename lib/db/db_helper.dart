import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';
class DBHelper {
  static Database? _db;
  static final int _version=1;
  static final String _tableName='task';
  static Future <void> initDb()async{
    if(_db!=null){
      debugPrint('Already exists');
      return ;
    }
    
      try {
        String _databasesPath = await getDatabasesPath()+'task.db';
        debugPrint(_databasesPath);
       _db = await openDatabase(_databasesPath, version: _version,
    onCreate: (Database db, int version) async {
      debugPrint('Create new table');
  // When creating the db, create the table
   await db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, note STRING, date STRING, '
            'startTime STRING, endTime STRING, '
            'remind INTEGER, repeat STRING, '
            'color INTEGER, isCompleted INTEGER)');
});

      } catch (e) {
        print(e);
        
      }
    

  }
  static Future<int> insert (Task? task)async{
    return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete (Task task)async{
    return await _db!.delete(_tableName,where: 'id=?',whereArgs: [task.id]);
  }

    static Future<int> deleteAll ()async{
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query ()async{
    return await _db!.query(_tableName);
  }

   static Future<List<Map<String, dynamic>>> getTaskById (int id)async{
    return await _db!.query(_tableName,where:'id=?',whereArgs: [id] );
  }

static Future<int> update(Task task) async {
  try {
    print('Updating task with ID: ${task.id}');
    final int rowsAffected = await _db!.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );

    print('Rows affected: $rowsAffected');
    return rowsAffected;
  } catch (e) {
    print('Error updating task: $e');
    return 0;
  }
}
// '''UPDATE $_tableName SET title = ?, note = ?,
//     date = ?,
//     startTime = ?,
//     endTime = ?,
//     remind = ?,
//     repeat = ?,
//     color  = ?,
//     isCompleted = ?
//     WHERE id = ?''',
    
//     [task.title,task.note,task.date,task.startTime,task.endTime,
//       task.remind,task.repeat,task.color,task.isCompleted,task.id]
  static Future<int> updateIsCompleted (int id)async{
    return await _db!.rawUpdate('UPDATE $_tableName SET isCompleted = ? WHERE id = ?',
    [1,id]);
  }


}
