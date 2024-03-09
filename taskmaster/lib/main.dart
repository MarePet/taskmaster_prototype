import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskmaster/models/user/userPrefs/user_prefs.dart';
import 'package:taskmaster/views/login_or_register_view.dart';
import 'package:taskmaster/views/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        )),
        title: 'Taskmaster',
        home: FutureBuilder(
            future: RememberUserPrefs.getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const LoginOrRegisterView();
              } else {
                return MainView();
              }
            }));
  }
}
