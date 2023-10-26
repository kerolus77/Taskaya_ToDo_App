import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '/models/task.dart';
import '/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  }
    void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    
  await Get.to(NotificationScreen(payload: payload!));
}

  displayNotification({required String title, required String body}) async {
    print('doing test');
  AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      _nextInstanceOfTenAM(hour, minutes,task.remind,task.repeat,task.date),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description'),
      ),
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes, int? remind, String? repeat, String? date) {
   
    final tz.TZDateTime now = getCurrentTimeInEgypt();
    var formatedDate=DateFormat.yMd().parse(date!);
    final tz.TZDateTime fd=tz.TZDateTime.from(formatedDate, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);
        print('finall schedulDate= $scheduledDate');
        
    scheduledDate = afterRemind(5, scheduledDate);
    print('1');

    if (scheduledDate.isBefore(now)) {
      if(repeat=='Daily'){
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, formatedDate.day+1, hour, minutes);
     scheduledDate = afterRemind(remind, scheduledDate);
      }
      if(repeat=='weekly'){
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, formatedDate.day+7, hour, minutes);
      }
      if(repeat=='monthly'){
        scheduledDate = tz.TZDateTime(tz.local, now.year, formatedDate.month+1, formatedDate.day, hour, minutes);
      }
      
      print(2);
    }
      print('final schedulDate= $scheduledDate');
      print('final schedulDate= ${DateFormat.yMd().add_Hm().format(scheduledDate)}');
      print('Scheduled Notification Time: ${scheduledDate.toString()}');
print('Current Time: ${tz.TZDateTime.now(tz.local).toString()}');
print(now);

    return scheduledDate;
  }

  tz.TZDateTime afterRemind(int? remind, tz.TZDateTime scheduledDate) {
    if(remind==5){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if(remind==10){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if(remind==15){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if(remind==20){
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
 
    return scheduledDate;
  }
  tz.TZDateTime getCurrentTimeInEgypt() {
  final egyptTimeZone = tz.getLocation('Africa/Cairo'); // Egypt Standard Time
  final currentTimeInEgypt = tz.TZDateTime.now(egyptTimeZone);
  return currentTimeInEgypt;
}

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission(
      
    );
  }

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String egyptTimeZoneName = 'Africa/Cairo'; // EET time zone
  tz.setLocalLocation(tz.getLocation(egyptTimeZoneName));
  print('ooooooooooooooooo$egyptTimeZoneName');
}

/*   Future selectNotification(String? payload) async {
    if (payload != null) {
      //selectedNotificationPayload = "The best";
      selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => SecondScreen(selectedNotificationPayload));
  } */

//Older IOS
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    /* showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Title'),
        content: const Text('Body'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Container(color: Colors.white),
                ),
              );
            },
          )
        ],
      ),
    ); 
 */
    Get.dialog( Text(body!));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is $payload');
      await Get.to(() => NotificationScreen(payload:payload));
    });
  }

 cancelNotification(Task task)async{
  await flutterLocalNotificationsPlugin.cancel(task.id!);
}

cancelAllNotification()async{
  await flutterLocalNotificationsPlugin.cancelAll();
}

}
