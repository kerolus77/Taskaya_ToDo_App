import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class UpdateTask extends StatefulWidget {
 final int taskId;

  UpdateTask({required this.taskId});

  @override
  State<UpdateTask> createState() => __UpdateTaskState();
}

class __UpdateTaskState extends State<UpdateTask> {

 final TaskController _taskController=Get.put(TaskController()); 
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _noteController=TextEditingController();
 DateTime _selectedDate=DateTime.now();
  String _startTime=DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime=DateFormat('hh:mm a').format(DateTime.now().add(const Duration(minutes: 15))).toString();
  int _selectedReminder=5;
  final List<int> _reminderList=[5,10,15,20];
   String? _selectedRepeat='None';
  final List<String> _repeatList=['None','Daily','Weekly','Monthly'];
 int? _selectedColor=0;
  @override
  void initState() {
    
    super.initState();
     _loadTask();
  
    
  }
  _loadTask()async{
 Task task= await _taskController.selectTask(widget.taskId) ;
 print(widget.taskId);
 print(task.note);
  setState(() {
    _titleController.text = task.title!;
    _noteController.text = task.note!;
    _selectedDate=DateFormat('M/d/y').parse(task.date!);
    _startTime=task.startTime!;
    _endTime=task.endTime!;
    _selectedColor=task.color!;
    _selectedReminder=task.remind!;
    _selectedRepeat=task.repeat!;
    
  });
  }
  @override
  Widget build(BuildContext context) {
 return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        // ignore: deprecated_member_use
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        leading: IconButton(onPressed: (){Get.back();},
         icon:Icon(Icons.arrow_back_ios_new_rounded),
         color:Get.isDarkMode?white:darkGreyClr ,),
      ),
      body:Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:  SingleChildScrollView(
          child: Form(
            
            child: Column(children: [
              Text('Update Task',style: titleStyle,),
              InputField(title: 'Title', hint: 'Enter title here',controller: _titleController,),
              InputField(title: 'Note', hint: 'Enter note here',controller: _noteController,maxLines: true, ),
              //DATE FIELD
              InputField(title: 'Date', hint: DateFormat.yMd().format(_selectedDate),
              widget: IconButton(onPressed: (){
                _getDateFromUser();
              },
              icon: const Icon(Icons.calendar_today_outlined,color: Colors.grey,),),),
              
              //TIME FIELD
              Row(children: [
                Expanded(child:
                //START TIME FIELD
                InputField(title: 'Start Time', hint: _startTime,
                widget: IconButton(onPressed: (){
                  _getTimeFromUser(isStartTime:true);
                },icon: const Icon(Icons.access_time_outlined,color: Colors.grey,),))),
                const SizedBox(width: 20,),
                Expanded(child:
                //END TIME FIELD
                InputField(title: 'End Time', hint: _endTime,
                widget: IconButton(onPressed: (){
                  _getTimeFromUser(isStartTime: false);
                },icon: const Icon(Icons.access_time_outlined,color: Colors.grey,),))),
              ],),
              
             //RIMIND FIELD
              InputField(title: 'Remind', hint: '$_selectedReminder minutes early',
              widget:Row(
                children: [
                  DropdownButton(items: _reminderList.map<DropdownMenuItem<String>>((int rem) =>
                  DropdownMenuItem(
                    value: rem.toString(),
                    child: Text('$rem')) ).toList(),
                    icon: const Icon(Icons.keyboard_arrow_down_sharp,color: Colors.grey,),
                    iconSize: 32,
                    dropdownColor: Colors.blueGrey,
                    underline: Container(height: 0,),
                    style: subtitleStyle,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedReminder=int.parse(value!);
                      });
                      },),
                      const SizedBox(width: 6,)
                ],
              )),
              InputField(title: 'Repeat', hint: _selectedRepeat!,
              widget:Row(
                children: [
                  DropdownButton(items: _repeatList.map<DropdownMenuItem<String>>((String rem) =>
                  DropdownMenuItem(
                    value: rem.toString(),
                    child: Text(rem)) ).toList(),
                    icon: const Icon(Icons.keyboard_arrow_down_sharp,color: Colors.grey,),
                    iconSize: 32,
                    dropdownColor: Colors.blueGrey,
                    underline: Container(height: 0,),
                    style: subtitleStyle,
                    onChanged: (String? newvalue) {
                      setState(() {
                        _selectedRepeat=newvalue!;
                      });
                  },),
                  const SizedBox(width: 6,)
                ],
              )),
              const SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPalette(),
                  MyButton(label: 'Update Task', onTap: (){
                  _validation();
                  Get.back();
                  },
                  color: bluishClr)
                ],
              ),
              SizedBox(height: 15,)
            ]),
          ),
        ),
      ),
    );
  }

_validation(){
  if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
    print(_noteController);
    _updateTaskToDb();
    Get.back();
  }
  else if(_titleController.text.isEmpty&&_noteController.text.isEmpty){
    Get.snackbar(
      'Required'
      ,'All Field Are Required!',
      snackPosition: SnackPosition.BOTTOM,
    //  animationDuration: Duration(),
    icon: const Icon(Icons.warning_amber_rounded,color: Colors.red,),
    backgroundColor:Get.isDarkMode?darkHeaderClr:white ,
    colorText: pinkClr,
  
      );

  }else{
    print('#############SOMETHING BAD HAPPEND##########');
  }
}

  _updateTaskToDb()async{
    try{
 int value=await _taskController.updateTask(task:Task(
    id:widget.taskId,
    title: _titleController.text,
    note: _noteController.text,
    color: _selectedColor,
    remind: _selectedReminder,
    repeat: _selectedRepeat,
    isCompleted: 0,
    date: DateFormat.yMd().format(_selectedDate),
    startTime: _startTime,
    endTime: _endTime
  )
  
  );
  print('update$value');
    }catch(e){
      print('ERROR');
    }

  }

  Column _colorPalette()  {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      
      Text('Color',style: titleStyle,),
      Wrap(children: List.generate(3, (index) => GestureDetector(
        onTap: () {
    setState(() {
      _selectedColor = index;
    });
  },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CircleAvatar(
          backgroundColor: index==0?bluishClr:index==1?pinkClr:orangeClr,
          radius: 14,
          child: _selectedColor==index? const Icon(Icons.done,color: Colors.white,size: 16,):null,
        ),
      ),
      ))
        
      ,)
    ],
  );}
  
  void _getDateFromUser()async {
  DateTime? _pickedDate= await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime.now(), lastDate: DateTime(2050),
    );
    if(_pickedDate!=null){
      setState(() {
        _selectedDate=_pickedDate;
      });
    }else{
      print('Null Or Something Wrong!');
    }


  }
  
  void _getTimeFromUser({required bool isStartTime})async {
    TimeOfDay? _pickedTime=await showTimePicker(
      context: context,
      initialTime: isStartTime?TimeOfDay.fromDateTime(DateTime.now())
      :TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))));
      String _formattedTime=_pickedTime!.format(context);
      if(isStartTime){
        setState(() {
          _startTime=_formattedTime;
        });
      }
      else if(!isStartTime){
      setState(() {
          _endTime=_formattedTime;
      });
      }
      else{
        print('Null Or Something Wrong!');
      }
  }
}