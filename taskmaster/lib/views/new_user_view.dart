import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/components/create_user_form.dart';
import 'package:taskmaster/components/screen_title.dart';
import 'package:taskmaster/components/sidebar.dart';
import 'package:taskmaster/dialogs/delete_dialog.dart';
import 'package:taskmaster/dialogs/error_dialog.dart';
import 'package:taskmaster/models/user/user.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';
import 'package:http/http.dart' as http;

class NewUser extends StatefulWidget {
  const NewUser({super.key});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final CurrentUser _currentUser = CurrentUser();

  final List<User> _createdUsers = List.empty(growable: true);

  void _getAllUsersByOwnerId() async {
    await _currentUser.getUserInfo();
    try {
      var response =
          await http.post(Uri.parse(API.returnUsersByOwnerId), body: {
        'owner_id': _currentUser.user.userId.toString(),
      });
      if (response.statusCode == 200) {
        List<dynamic> usersJson = jsonDecode(response.body);
        for (var userJson in usersJson) {
          User user = User.fromJson(userJson);
          setState(() {
            _createdUsers.add(user);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _newUserCreated() {
    setState(() {
      _createdUsers.clear();
      _getAllUsersByOwnerId();
    });
  }

  void _deleteUser(int userId) async {
    try {
      var response = await http.post(Uri.parse(API.deleteUser), body: {
        'user_id': userId.toString(),
      });
      if (response.statusCode == 200) {
        var responseOfDeleteUserBody = jsonDecode(response.body);
        if (responseOfDeleteUserBody['success']) {
          print('User delete succesfull');
          setState(() {
            _createdUsers.clear();
             _getAllUsersByOwnerId();
          });
        } else {
          showErrorDialog(context);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllUsersByOwnerId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.grey.shade100,
            child: Row(children: [
              const Sidebar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ScreenTitle("Create new user"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 50),
                    child: SizedBox(
                      width: 600,
                      child: CreateUserForm(
                          newUserCreated: () => _newUserCreated()),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const ScreenTitle("Created users"),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      width: 600,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: _createdUsers.length,
                        itemBuilder: (context, index) {
                          final user = _createdUsers.elementAt(index);
                          return Card(
                              elevation: 4.0,
                              color: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  user.toString(),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    final shouldDelete =
                                        await showDeleteDialog(context);
                                    if (shouldDelete) {
                                      _deleteUser(user.userId);
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ));
                        },
                      ))
                ],
              )
            ])));
  }
}
