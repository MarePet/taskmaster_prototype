import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/components/task_card.dart';
import 'package:taskmaster/models/categories/category_model.dart';
import 'package:taskmaster/models/task/stage.dart';
import 'package:taskmaster/models/task/task.dart';
import 'package:http/http.dart' as http;
import 'package:taskmaster/models/user/userPrefs/current_user.dart';

class TaskDragTarget extends StatefulWidget {
  const TaskDragTarget({
    super.key,
    required this.stages,
    required this.constraints,
  });
  final List<Stage> stages;
  final BoxConstraints constraints;

  @override
  State<TaskDragTarget> createState() => _TaskDragTargetState();
}

class _TaskDragTargetState extends State<TaskDragTarget> {
  final CurrentUser _currentUser = CurrentUser();

  List<Task> tasks = List.empty(growable: true);
  List<CategoryModel> allCategories = List.empty(growable: true);
  List<CategoryModel> selectedCategories = List.empty(growable: true);

  Future<List<CategoryModel>?> _getCategoriesDb(int id) async {
    try {
      var response = await http.post(Uri.parse(API.getCategoriesByTaskId),
          body: {'task_id': id.toString()});
      if (response.statusCode == 200) {
        List<CategoryModel> categories = List.empty(growable: true);
        List<dynamic> categoriesJson = jsonDecode(response.body);
        for (var categoryJson in categoriesJson) {
          CategoryModel category = CategoryModel.fromJson(categoryJson);
          categories.add(category);
        }
        return categories;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  void _getCategoriesOfTask() async {
    for (var task in tasks) {
      try {
        task.assignedCategories = await _getCategoriesDb(task.id);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void _getTasks() async {
    await _currentUser.getUserInfo();
    if (_currentUser.user.userRole == "Superadmin" ||
        _currentUser.user.userRole == "Admin" ||
        _currentUser.user.userRole == "Subscriber") {
      await _getAdminTasks();
    } else {
      await _getUserTasks();
    }
  }

  void _removeTaskFromList(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  Future<void> _getUserTasks() async {
    try {
      var response = await http.post(Uri.parse(API.returnAssignedTasks), body: {
        'user_id': _currentUser.user.userId.toString(),
      });
      if (response.statusCode == 200) {
        List<dynamic> tasksJson = jsonDecode(response.body);
        for (var taskJson in tasksJson) {
          Task task = Task.fromJson(taskJson);
          setState(() {
            tasks.add(task);
          });
          setState(() {
            _getCategoriesOfTask();
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getAdminTasks() async {
    try {
      var response = await http.post(Uri.parse(API.retrunCreatorTasks), body: {
        'creator_id': _currentUser.user.userId.toString(),
      });
      if (response.statusCode == 200) {
        List<dynamic> tasksJson = jsonDecode(response.body);
        for (var taskJson in tasksJson) {
          Task task = Task.fromJson(taskJson);
          setState(() {
            tasks.add(task);
          });
          setState(() {
            _getCategoriesOfTask();
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _updateTask(Task task) async {
    try {
      var response =
          await http.post(Uri.parse(API.updateTask), body: task.toJson());
      if (response.statusCode == 200) {
        var responseBodyOfUpdateTask = jsonDecode(response.body);
        if (responseBodyOfUpdateTask['success'] == true) {
          print('Task updated successfuly');
        } else {
          print('Error while updating task');
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  void _getAllCategories() async {
    try {
      var response = await http.post(
        Uri.parse(API.returnCategories),
      );
      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = jsonDecode(response.body);
        for (var categoryJson in categoriesJson) {
          CategoryModel category = CategoryModel.fromJson(categoryJson);
          setState(() {
            allCategories.add(category);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getTasks();
    _getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // margin: const EdgeInsets.all(8),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: allCategories
                  .map((category) => FilterChip(
                      label: Text(category.toString()),
                      selected: selectedCategories.contains(category),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      }))
                  .toList(),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  for (Stage stage in widget.stages)
                    (widget.constraints.maxWidth > 1200)
                        ? Expanded(
                            child: _bildDragTarget(
                            context,
                            stage,
                          ))
                        : _bildDragTarget(context, stage)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _bildDragTarget(BuildContext context, Stage stage) {
    List<Task> stageTask =
        tasks.where((task) => task.stage == stage.name).toList();
    
    final filtered = stageTask.where((task) {
      return selectedCategories.isEmpty  || selectedCategories.every((category) => task.assignedCategories!.contains(category));
    }
  ).toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: stage.color, borderRadius: BorderRadius.circular(5)),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                stage.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Divider(
            color: stage.color,
            height: 20,
            thickness: 2,
          ),
          Expanded(
            child: DragTarget<Task>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(20)),
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: ScrollController(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                            task: filtered[index],
                            deleteCallback: _removeTaskFromList);
                      }),
                );
              },
              onAccept: (task) {
                setState(() {
                  Task newTask = task.copyWith(stage: stage.name);
                  tasks = List.from(tasks)
                    ..remove(task)
                    ..add(newTask);
                  _updateTask(newTask);
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
