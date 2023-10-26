// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  const NotificationScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload='';
  @override
  void initState() {
    
    super.initState();
    _payload=widget.payload;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: ()=>Get.back(), icon: const Icon(Icons.arrow_back)),
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
      title: Text(_payload.toString().split('|')[0],
      style: TextStyle(color:Get.isDarkMode?Colors.white:darkGreyClr),),
      centerTitle: true,
      ),
      body: SafeArea(child: 
      Column(
        children: [
        const SizedBox(height: 20,),
          Column(
          
            children: [
              Text("Hello Kerolus",
               style: TextStyle
                (fontSize: 26,
                fontWeight: FontWeight.w900,
                color:Get.isDarkMode?Colors.white:darkGreyClr),),
                const SizedBox(height: 10,),
                Text("You Have New Reminder",
                style: TextStyle
                (fontSize: 18,
                fontWeight: FontWeight.w300,
                color:Get.isDarkMode?Colors.grey[300]:darkGreyClr),),


            ],
          ),
        const SizedBox(height: 10,),

       Expanded(child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
        color: primaryClr),
        child: SingleChildScrollView(
          child: Column(children: [
            const Row(children: [
            Icon(Icons.text_format,size: 30,color: Colors.white,),
            SizedBox(width: 2,),
              Text("Title",
                style: TextStyle
                (fontSize: 30,
                color:Colors.white),),

          ],),
const SizedBox(height: 10,),
          Text(_payload.toString().split('|')[0],
      style: const TextStyle(color:Colors.white,fontSize: 20),),
const SizedBox(height: 10,),
          const Row(children: [
            Icon(Icons.description,size: 30,color: Colors.white,),
            SizedBox(width: 2,),
            Text("Description",
              style: TextStyle
                (fontSize: 30,
                color:Colors.white),),
          ],),
const SizedBox(height: 10,),
          Text(_payload.toString().split('|')[1],
      style: const TextStyle(color:Colors.white,fontSize: 20),textAlign:TextAlign.justify,),
const SizedBox(height: 10,),
          const Row(children: [
            Icon(Icons.today_rounded,size: 30,color: Colors.white,),
            SizedBox(width: 2,),
            Text("Date",
              style: TextStyle
                (fontSize: 30,
                color:Colors.white),),
          ],),
const SizedBox(height: 10,),
          Text(_payload.toString().split('|')[2],
      style: const TextStyle(color:Colors.white,fontSize: 20),textAlign:TextAlign.justify,),
const SizedBox(height: 10,),
          ],
          ),
        ),
       )),
        const SizedBox(height: 10,),

        ],
      ),
      
      ),
    );
  }
}
