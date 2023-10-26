// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../../ui/size_config.dart';

import '../theme.dart';

class TaskTile extends StatelessWidget {

final Task task;
   const TaskTile({
    Key? key,
    required this.task,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal:(SizeConfig.orientation==Orientation.landscape?4:20),),
      width:SizeConfig.orientation==Orientation.landscape?SizeConfig.screenWidth/2: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task.color),
        ),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Text(task.title!,
            style: GoogleFonts.lato(
                  textStyle:  const TextStyle
                  (fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color:Colors.white),),),
            const SizedBox(height: 12,),
            Row(children: [
              Icon(Icons.access_alarms_rounded,color: Colors.grey[200],size: 18,),
              const SizedBox(width: 12,),
              Text('${task.startTime}-${task.endTime}',style: GoogleFonts.lato(
                  textStyle:  TextStyle
                  (fontSize: 13,
                  color:Colors.grey[100]),),),
            ],),
            const SizedBox(height: 12,),
            Text(task.note!,style: GoogleFonts.lato(
                  textStyle:  TextStyle
                  (fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color:Colors.grey[100]),),)
                ],
              ),
            )),
            Container(
              width: .5,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.grey[200]!.withOpacity(.7),
            ),
            RotatedBox(quarterTurns: 3,child: Text(task.isCompleted==0?'TODO':'Completed',style: GoogleFonts.lato(
      textStyle:  const TextStyle
                (fontSize: 10,
                fontWeight: FontWeight.w700,
                color:Colors.white),
    ),),),
          ],
        ) ,
      ),
    );
  }
  
  _getBGClr(int? color) {
    switch (color) {
      case 0:return bluishClr ;
     
      
        case 1:return pinkClr ;
      
        case 2:return orangeClr;
  
      default:return bluishClr;
    }
  }
}
