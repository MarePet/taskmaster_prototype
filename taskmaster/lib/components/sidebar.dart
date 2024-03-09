import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmaster/components/sidebar_button.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';
import 'package:taskmaster/models/user/userPrefs/user_prefs.dart';
import 'package:taskmaster/views/login_or_register_view.dart';
import 'package:taskmaster/views/main_view.dart';
import 'package:taskmaster/views/new_task_view.dart';
import 'package:taskmaster/views/new_user_view.dart';
import 'package:taskmaster/views/subscriptions_view.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final CurrentUser _currentUser = CurrentUser();
  void _getUserInfo() async {
    await _currentUser.getUserInfo();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     _getUserInfo();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(
          flex: 1,
        ),
        Image.asset(
          'images/6.jpg',
          width: 300,
        ),
        FutureBuilder(
            future: _currentUser.getUserInfo(),
            builder: (context, snapshot) {
              return Column(children: [
                //BUTTON - HOME PAGE
                SidebarButton(
                    btnName: "Home page",
                    view: () => MainView(),
                    icon: Icons.home),
                //BUTTON - NEW TASK
                if (_currentUser.user.userRole == "Superadmin" ||
                    _currentUser.user.userRole == "Admin" ||
                    _currentUser.user.userRole == "Subscriber")
                  SidebarButton(
                    btnName: "     New task",
                    view: () => const NewTask(),
                    icon: Icons.add,
                  ),
                //BUTTON - NEW USER
                if (_currentUser.user.userRole == "Superadmin" ||
                    _currentUser.user.userRole == "Admin" ||
                    _currentUser.user.userRole == "Subscriber")
                  SidebarButton(
                      btnName: "     New user",
                      view: () => const NewUser(),
                      icon: Icons.verified_user),
                if (_currentUser.user.userRole == "Superadmin" ||
                    _currentUser.user.userRole == "Admin" ||
                    _currentUser.user.userRole == "Subscriber")
                  //BUTTON - SUBSCRIPTIONS
                  SidebarButton(
                      btnName: "Subscriptions",
                      view: () => const Subscriptions(),
                      icon: Icons.wallet),
              ]);
            }),

        const Spacer(
          flex: 4,
        ),
        //BUTTON - LOGOUT
        Center(
          child: TextButton.icon(
            style: TextButton.styleFrom(
              fixedSize: const Size(180, 90),
            ),
            onPressed: () {
              signOutUser();
            },
            icon: Icon(
              Icons.logout,
              color: const Color(0xFF3A86FF).withAlpha(155),
              size: 30,
            ),
            label: const Text(
              '       Logout',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Spacer(
          flex: 1,
        ),
      ]),
    );
  }

  void signOutUser() async {
    var result = await Get.dialog(
      AlertDialog(
        title: const Text(
          "Logout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("No")),
          TextButton(
              onPressed: () {
                Get.back(result: "loggedOut");
              },
              child: const Text("Yes"))
        ],
      ),
    );
    if(result == "loggedOut"){
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(const LoginOrRegisterView());
      });
    }
  }
}
