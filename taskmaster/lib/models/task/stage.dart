import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Stage extends Equatable {
  final int id;
  final String name;
  final Color color;

  const Stage(this.id, this.name, this.color);

  static List<Stage> stages = [
    const Stage(1, 'To Do', Colors.red),
    const Stage(2, 'In Progress', Colors.orange),
    const Stage(3, 'Under review', Colors.yellow),
    const Stage(4, 'Done', Colors.green),
  ];

  @override
  List<Object?> get props => [
    id,
    name,
    color
  ];
}
