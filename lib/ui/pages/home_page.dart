import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do/services/theme_services.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../ui/pages/add_task_page.dart';
import '../../ui/pages/update_task.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/button.dart';
import '../../ui/widgets/task_tile.dart';
import '../size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final TaskController _taskController=Get.put(TaskController());
late NotifyHelper notifyHelper;
 DateTime _selectedDate=DateTime.now();
 DateFormat dateFormat = DateFormat('M/d/yyyy');


 @override
  void initState() {
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTask();
  
   
  }

  @override
  Widget build(BuildContext context) {
     SizeConfig().init(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        // ignore: deprecated_member_use
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        leading: IconButton(onPressed: (){ThemeServices().switchTheme();},
         icon: Get.isDarkMode?Icon(Icons.wb_sunny_outlined):Icon(Icons.nightlight_round_outlined),
         color:Get.isDarkMode?white:darkGreyClr ,),
         actions: [
          CircleAvatar(backgroundImage: AssetImage('assets/images/avatar_default_02_0079D3.png',),radius: 20,),
          SizedBox(width: 20,)
         ],
         
      ),
      body: Column(children: [
        _addTaskBar(),
        _addDateBar(),
        const SizedBox(height: 20,),
        _showTasks(),
        

      ]),
      
    );
    
  }
  
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(right: 10,left: 20,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat.yMMMMd().format(DateTime.now()),style: subheadingStyle,),
         Row(
  children: [
    (_selectedDate.year == DateTime.now().year &&
    _selectedDate.month == DateTime.now().month &&
    _selectedDate.day == DateTime.now().day)  ?Text(
      'Today',
      style: TextStyle(fontSize: 20),
    ):Container(),
  ],
),
          ],
        ),
        MyButton(label: '+Add Task', onTap: ()async{
       await Get.to(()=>AddTaskPage());
        _taskController.getTask();
        }, color: bluishClr)
      ]),
    );
  }
  
  // _addDateBar() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 7,),
  //     child: DatePicker( DateTime(2023, 8, 24), 

  //     width: 65,
  //     height: 90,
  //     selectionColor: primaryClr,
  //     initialSelectedDate: _selectedDate,
      
  //     selectedTextColor: white,
  //     onDateChange: (newSelectedDate) => setState(() {
  //       _selectedDate=newSelectedDate;
  //     }),
  //     dayTextStyle:GoogleFonts.lato(
  //     textStyle:  const TextStyle
  //               (fontSize: 15,
  //               fontWeight: FontWeight.w600,
  //               color:Colors.grey),
  //   ),
  //     monthTextStyle: GoogleFonts.lato(
  //     textStyle:  const TextStyle
  //               (fontSize: 11,
  //               fontWeight: FontWeight.w600,
  //               color:Colors.grey),
  //   ),
  //     dateTextStyle:GoogleFonts.lato(
  //     textStyle:  const TextStyle
  //               (fontSize: 19,
  //               fontWeight: FontWeight.w600,
  //               color:Colors.grey),
  //   ) ,)
  //   );
  // }
   _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 7,),
      child: CalendarTimeline(
        initialDate: _selectedDate,
        firstDate: DateTime(2020, 1, 1),
        lastDate: DateTime(2029, 11, 20),
        monthColor: Colors.grey[600],
      activeDayColor:white ,
      dayColor: Colors.grey,
      activeBackgroundDayColor:primaryClr ,
      dotsColor: primaryClr,
      onDateSelected: (newSelectedDate) => setState(() {
        _selectedDate=newSelectedDate;
      }),
    //   dayTextStyle:GoogleFonts.lato(
    //   textStyle:  const TextStyle
    //             (fontSize: 15,
    //             fontWeight: FontWeight.w600,
    //             color:Colors.grey),
    // ),
    //   monthTextStyle: GoogleFonts.lato(
    //   textStyle:  const TextStyle
    //             (fontSize: 11,
    //             fontWeight: FontWeight.w600,
    //             color:Colors.grey),
    // ),
    //   dateTextStyle:GoogleFonts.lato(
    //   textStyle:  const TextStyle
    //             (fontSize: 19,
    //             fontWeight: FontWeight.w600,
    //             color:Colors.grey),
   // ) 
    )
    );
  }
  
  _showTasks() {
    
    return Expanded(child:Obx((){
          if(_taskController.taskList.isEmpty){
     return _noTaskMsg();
    }else{
     return RefreshIndicator(
      onRefresh: _onRefresh,
       child: ListView.builder(
         
          scrollDirection: SizeConfig.orientation==Orientation.landscape?Axis.horizontal:Axis.vertical,
        itemCount: _taskController.taskList.length,
          itemBuilder:(context, index) {
          
            Task task=_taskController.taskList[index];
      try {
      // January, March, May, July, August, October, December have 31 days
                // Attempt to parse the date string
                DateTime taskDate = dateFormat.parse(task.date!);
            
                // Calculate the number of days between the task date and the selected date
                int daysDifference = taskDate.difference(_selectedDate).inDays;

                // Check if the task is either 'Daily' or 'Weekly' (every 7 days)
                if (task.repeat == 'Daily' || (taskDate.year == _selectedDate.year &&
                  taskDate.month == _selectedDate.month &&
                  taskDate.day == _selectedDate.day)||
                (task.repeat == 'Weekly' && daysDifference % 7 == 0)||
                (task.repeat == 'Monthly' && taskDate.day == _selectedDate.day)) {
                  return _makeTask(task, index, context);
                } else {
                  return Container();
                }
              } catch (e) {
                // Handle date parsing error, e.g., print an error message
                print('Error parsing date: ${task.date}');
                print(e);
                return Container();
              }
        },),
     );
    }
}
     
    )
    
  
      );
  
  }

  AnimationConfiguration _makeTask(Task task, int index, BuildContext context) {
       var hour=task.startTime.toString().split(':')[0];
               var minutes=task.startTime.toString().split(':')[1];
               debugPrint('$hour');
    
              debugPrint('$minutes');
       if (task.startTime != null) {
      var date = DateFormat('h:mm a').parse(task.startTime!);
      var myTime = DateFormat('HH:mm').format(date);
    
      notifyHelper.scheduledNotification(
        int.parse(myTime.split(':')[0]),
        int.parse(myTime.split(':')[1]),
        
        task,
      );
      debugPrint('done');
    }
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
    horizontalOffset: 400,
    child: FlipAnimation(
      child: GestureDetector(
        onTap: () => _showBottomSheet(context, task),
        child:TaskTile(task: task) ,
      ),
    ),
                ),
              );
  }
  
  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction:  SizeConfig.orientation==Orientation.landscape?Axis.horizontal:Axis.vertical,
                children: [
                  SizeConfig.orientation==Orientation.landscape?const SizedBox(height: 6,):const SizedBox(height:100,),
                  Image.asset('assets/images/empty-box_7486744.png',
                // ignore: deprecated_member_use
                height: 200,semanticLabel: 'Tasks',color: primaryClr.withOpacity(.5),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  child: Text("You Don't Have Any Tasks Yet!\nAdd New Tasks To Make Your Days Productive",
                  style: subtitleStyle,textAlign: TextAlign.center,),
                ),
                  SizeConfig.orientation==Orientation.landscape?const SizedBox(height: 120,):const SizedBox(height: 100,),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

_showBottomSheet(BuildContext context,Task task){
  Get.bottomSheet( shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top:Radius.circular(25)), // Adjust the radius as needed
      // You can also add a border if needed
    ),
  SingleChildScrollView(
    child: Container(
      decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      color: Get.isDarkMode?darkHeaderClr:white,
      ),
      width: SizeConfig.screenWidth,
      height:SizeConfig.orientation==Orientation.landscape? 
      task.isCompleted==1?SizeConfig.screenHeight*0.6
      :SizeConfig.screenHeight*0.8:task.isCompleted==1?SizeConfig.screenHeight*0.30
      :SizeConfig.screenHeight*0.39,
      padding: const EdgeInsets.only(top: 4),
      
      child: Column(
        children: [
          Flexible(child: Container(
            height: 6,width: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
            color:Get.isDarkMode?Colors.grey[600]:Colors.grey[300] ),
            )),
            const SizedBox(height: 10,),
            task.isCompleted==1?Container():
            _builtBottomSheet(label: 'Task Completed', onTap: (){
              notifyHelper.cancelNotification(task);
              _taskController.makeIsComplite(task.id!);
              Get.back();
            }, clr: primaryClr,),
             _builtBottomSheet(label: 'Update Task', onTap: (){
              
              Get.to(()=>UpdateTask(taskId: task.id!));
              
            }, clr: primaryClr,),
              Divider(color: Get.isDarkMode?Colors.grey:darkGreyClr,),
            _builtBottomSheet(label: 'Delete Task', onTap: (){
              notifyHelper.cancelNotification(task);
              _taskController.deleteTask(task);
              Get.back();
            }, clr: Colors.red[300]!),
        ],
      ),
    ),
  )
  );

}

_builtBottomSheet({required String label,
required Function() onTap,
required Color clr,
bool isClose=false}){
  return GestureDetector(
    onTap:  onTap,
    child: Container(
      margin: const EdgeInsets.all(8),
      width: SizeConfig.screenWidth*0.9,
      height: 65,
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
        color: isClose?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr,
      ),
      borderRadius: BorderRadius.circular(20),
      color: isClose?Colors.transparent:clr,
    ),
    child: Center(
    child: Text(label,style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),)
    ),
    ),
  );

}

  Future<void> _onRefresh() async{
_taskController.getTask();
  }


}

