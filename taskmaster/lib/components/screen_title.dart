import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle(this.title, {
    super.key,
  });
  
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20),
    child: Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
    ),
    );
  }
}