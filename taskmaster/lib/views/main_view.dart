import 'package:flutter/material.dart';
import 'package:taskmaster/components/screen_title.dart';
import 'package:taskmaster/components/sidebar.dart';
import 'package:taskmaster/components/task_drag_target.dart';
import 'package:taskmaster/models/task/stage.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final List<Stage> stages = Stage.stages;
  final BoxConstraints constraints = const BoxConstraints();

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.grey.shade100,
            child: Row(
              children: [
                const Sidebar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ScreenTitle("Your tasks"),
                      Expanded(child: TaskDragTarget(stages: stages, constraints: constraints,))
                    ],
                  ),
                )
              ],
            ),
          );
        }
  }

