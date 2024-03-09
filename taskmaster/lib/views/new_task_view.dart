import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/components/create_task_form.dart';
import 'package:taskmaster/components/screen_title.dart';
import 'package:taskmaster/components/sidebar.dart';
import 'package:taskmaster/dialogs/no_assigned_users.dart';
import 'package:taskmaster/models/categories/category_model.dart';
import 'package:taskmaster/models/task/task.dart';
import 'package:taskmaster/models/user/user.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';
import 'package:http/http.dart' as http;

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  CurrentUser _currentUser = CurrentUser();
  List<User> _assignedUsers = List.empty(growable: true);
  List<CategoryModel> _assignedCategories = List.empty(growable: true);
  User? _user;
  CategoryModel? _category;

  @override
  void initState() {
    super.initState();
    _currentUser.getUserInfo();
  }

  _newCategoryAsigned(CategoryModel categoryToAssign) {
    setState(() {
      if (_assignedCategories.contains(categoryToAssign)) {
        print('CategoryModel already assigned');
      } else {
        _category = categoryToAssign;
        _assignedCategories.add(_category!);
      }
    });
  }

  _newUserAsigned(User userToAsign) {
    setState(() {
      if (_assignedUsers.contains(userToAsign)) {
        print('User already assigned');
      } else {
        _user = userToAsign;
        _assignedUsers.add(_user!);
      }
    });
  }

  Future<Task?> returnLastTask() async {
    try {
      var response = await http.post(Uri.parse(API.returnLastTask), body: {
        'creator_id': _currentUser.user.userId.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {
        var responseBodyOfReturnTask = jsonDecode(response.body);
        if (responseBodyOfReturnTask['success']) {
          Task task = Task.fromJson(responseBodyOfReturnTask['task']);
          return task;
        } else {
          return null;
        }
      }
      return null;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void _assignCategoriesToTask(CategoryModel category) async{
    Task? task = await returnLastTask();
    if(task!=null){
      try {
        var response = await http.post(
          Uri.parse(API.assignCategoryToTask),
          body: {
            'task_id' : task.id.toString(),
            'category_id' : category.categoryId.toString()
          }
        );
        if(response.statusCode == 200){
          var responseBodyOfAssignCategory = jsonDecode(response.body);
          if(responseBodyOfAssignCategory['success']){
            print('Category assigned succesfuly');
          }else{
             print('Category assigned unsuccesfuly');
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
  void _assignUsersToTask(User user) async {
    Task? task = await returnLastTask();
    if (task != null) {
      try {
        var response = await http.post(Uri.parse(API.assignUserToTask), body: {
          'task_id': task.id.toString(),
          'user_id': user.userId.toString()
        });
        if (response.statusCode == 200) {
          var responseBodyOfAssignUser = jsonDecode(response.body);
          if (responseBodyOfAssignUser['success']) {
            print('User assigned succesfuly');
          } else {
            print('User assigned unsuccesfuly');
          }
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      print('Task was not created');
    }
  }

  void _submitForm(String title, String description) async {
    if (_assignedUsers.isNotEmpty) {
      Task task = Task.createTask(3, title, description, 'To Do',
          _currentUser.user.userId, _assignedUsers, _assignedCategories);
      try {
        var response =
            await http.post(Uri.parse(API.createTask), body: task.toJson());
        print(response.body);
        if (response.statusCode == 200) {
          var responseBodyOfCreateTask = jsonDecode(response.body);
          if (responseBodyOfCreateTask['success'] == true) {
            for (var user in task.assignedUsers!) {
              _assignUsersToTask(user);
            }
            for (var category in task.assignedCategories!) {
              _assignCategoriesToTask(category);
            }
            print('Task created succefuly');
          } else {
            print('Error while creating task!');
          }
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      noAssignedUsersDialog(context);
    }
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
                  const ScreenTitle("Create new task"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 50),
                    child: SizedBox(
                      width: 600,
                      child: CreateTaskForm(
                        newUserAsigned: _newUserAsigned,
                        newCategoryAsigned: _newCategoryAsigned,
                        submitForm: _submitForm,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const ScreenTitle("Assigned users"),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: 600,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: _assignedUsers.length,
                        itemBuilder: (context, index) {
                          final assignedUser = _assignedUsers.elementAt(index);
                          return Card(
                              elevation: 4.0,
                              color: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  assignedUser.toString(),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _assignedUsers.remove(assignedUser);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ));
                        },
                      )),
                  const ScreenTitle("Assigned categories"),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: 600,
                      child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: _assignedCategories.length,
                        itemBuilder: (context, index) {
                          final assignedCategory =
                              _assignedCategories.elementAt(index);
                          return Card(
                              elevation: 4.0,
                              color: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  assignedCategory.toString(),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _assignedCategories
                                          .remove(assignedCategory);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ));
                        },
                      )),
                ],
              )
            ])));
  }
}
