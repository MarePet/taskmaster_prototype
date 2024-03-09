import 'package:get/get.dart';
import 'package:taskmaster/models/user/user.dart';
import 'package:taskmaster/models/user/userPrefs/user_prefs.dart';

class CurrentUser extends GetxController {

  final Rx<User> _currentUser =  User(0,  '',  '',  '',  '', '',null).obs;

  User get user => _currentUser.value;

   Future<void> getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.getUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}