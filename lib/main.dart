import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do/services/notification_services.dart';
import 'package:to_do/services/theme_services.dart';

import '../../db/db_helper.dart';
import '../../ui/pages/home_page.dart';
import '../../ui/theme.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  await NotifyHelper().initializeNotification();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode:ThemeServices().theme,
      // ThemeServices().theme,
      title: 'Taskaya',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
