import 'package:flutter/material.dart';
import 'package:taskmaster/models/task/task.dart';
import 'dart:convert';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;

typedef DeleteCallback = void Function(Task task);

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task, required this.deleteCallback,});

  final DeleteCallback deleteCallback;

  void _deleteTask(Task task) async {
    try {
      var response = await http.post(Uri.parse(API.deleteTask),
          body: {'task_id': task.id.toString()});
          if(response.statusCode == 200){
            var responseBodyOfDeleteTask = jsonDecode(response.body);
            if(responseBodyOfDeleteTask['success']){
              print('Task deleted');
              deleteCallback(task);
            }
            else{
              print('Error while deleting task');
            }
          }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Task>(
      data: task,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Text(
        task.title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold),
        maxLines: 2,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildImage(),
            const SizedBox(
              height: 10,
            ),
            ..._buildCardInfo(context),
            const SizedBox(
              height: 10,
            ),
            task.stage == "Done"
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 1,
                    ),
                    onPressed: () {
                      _deleteTask(task);
                      
                    },
                    child: const Text(
                      "Delete task",
                      style: TextStyle(color: Colors.white),
                    ))
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCardInfo(BuildContext context) {
    return [
      Text(
        task.title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        task.description,
        maxLines: 2,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.normal),
      )
    ];
  }

  // Widget _buildImage() {
  //   return (task.image == null)
  //       ? const SizedBox()
  //       : ClipRRect(
  //           borderRadius: BorderRadius.circular(10),
  //           child: Image(
  //             image: task.image!,
  //             width: double.infinity,
  //             height: 100,
  //             fit: BoxFit.cover,
  //           ),
  //         );
  // }
}
