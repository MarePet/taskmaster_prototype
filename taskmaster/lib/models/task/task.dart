import 'package:equatable/equatable.dart';
import 'package:taskmaster/models/categories/category_model.dart';
import 'package:taskmaster/models/user/user.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? stage;
  final int creatorId;
  List<User>? assignedUsers;
  List<CategoryModel>? assignedCategories;
  // List<CategoryModel> selectedCategories = List.empty(growable: true);

  Task(this.id, this.title, this.description, this.stage, this.creatorId,);
  Task.createTask(this.id, this.title, this.description, this.stage, this.creatorId, this.assignedUsers, this.assignedCategories);

  Task copyWith({
    final int? id,
    final String? title,
    final String? description,
    final String? stage,
    final int? creatorId,
    final List<User>? assignedUsers,
    final List<CategoryModel>? assignedCategories
  }
  ) {
    return Task.createTask(
        id ?? this.id,
        title ?? this.title,
        description ?? this.description,
        stage ?? this.stage,
        creatorId ?? this.creatorId,
        assignedUsers ?? this.assignedUsers,
        assignedCategories ?? this.assignedCategories
        );
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
       int.parse(json['task_id']),
       json['title'],
       json['description'],
       json['stage'],
       int.parse(json['creator_id']),
  );

  Map<String, dynamic> toJson() => {
        'task_id': id.toString(),
        'title': title,
        'description': description,
        'stage': stage,
        'creator_id': creatorId.toString()
      };

  @override
  List<Object?> get props => [id, title, description, stage, creatorId];

  // static List<Task> tasks = [
  //   Task(
  //     1,
  //     'Build a New eCommerce App',
  //     'Nulla facilisi. Cras lacinia aliquam magna, a rutrum mi aliquet eu. Donec interdum tortor lacinia ipsum dapibus pretium.',
  //     Stage.stages[0],
  //     const NetworkImage(
  //       'https://images.unsplash.com/photo-1660748054768-33282c43c318?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1277&q=80',
  //     ),
  //   ),
  //   Task(
  //     2,
  //     'Create a New Flutter Package',
  //     'Nulla facilisi. Cras lacinia aliquam magna, a rutrum mi aliquet eu. Donec interdum tortor lacinia ipsum dapibus pretium.',
  //     Stage.stages[0],
  //     const NetworkImage(
  //       'https://images.unsplash.com/photo-1660796988367-04c82284be53?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2670&q=80',
  //     ),
  //   ),
  //   Task(
  //       3,
  //       'Create a Flutter Course',
  //       'Nulla facilisi. Cras lacinia aliquam magna, a rutrum mi aliquet eu. Donec interdum tortor lacinia ipsum dapibus pretium.',
  //       Stage.stages[0],
  //       null),
  //   Task(
  //     4,
  //     'Prepare a New Flutter Video',
  //     'Nulla facilisi. Cras lacinia aliquam magna, a rutrum mi aliquet eu. Donec interdum tortor lacinia ipsum dapibus pretium.',
  //     Stage.stages[0],
  //     const NetworkImage(
  //       'https://images.unsplash.com/photo-1661541471551-5d31299e4f31?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1364&q=80',
  //     ),
  //   ),
  //   Task(
  //     5,
  //     'Build a Taxi App with Flutter',
  //     'Nulla facilisi. Cras lacinia aliquam magna, a rutrum mi aliquet eu. Donec interdum tortor lacinia ipsum dapibus pretium.',
  //     Stage.stages[1],
  //     const NetworkImage(
  //       'https://images.unsplash.com/photo-1661565882741-0b9934df7f3a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2670&q=80',
  //     ),
  //   ),
  //   Task(
  //     6,
  //     'Build a Web Responsive App',
  //     'Nulla facilisi. Cras lacinia aliquam magna, a rutrum mi aliquet eu. Donec interdum tortor lacinia ipsum dapibus pretium.',
  //     Stage.stages[2],
  //     const NetworkImage(
  //       'https://images.unsplash.com/photo-1661615343330-7819752217fe?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80',
  //     ),
  //   ),
  // ];
}
