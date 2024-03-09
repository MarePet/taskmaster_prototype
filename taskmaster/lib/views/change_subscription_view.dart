import 'package:flutter/material.dart';
import 'package:taskmaster/components/change_sub_form.dart';
import 'package:taskmaster/components/screen_title.dart';
import 'package:taskmaster/components/sidebar.dart';

class ChangeSubscription extends StatefulWidget {
  const ChangeSubscription({super.key});

  @override
  State<ChangeSubscription> createState() => _ChangeSubscriptionState();
}

class _ChangeSubscriptionState extends State<ChangeSubscription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.grey.shade100,
            child: const Row(children: [
              Sidebar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenTitle("Change your subscription"),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 50, horizontal: 50),
                    child: SizedBox(
                      width: 600,
                      child: ChangeSubForm(),
                    ),
                  ),
                ],
              ),
            ])));
  }
}