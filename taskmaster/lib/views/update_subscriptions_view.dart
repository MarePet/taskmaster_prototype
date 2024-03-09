import 'package:flutter/material.dart';
import 'package:taskmaster/components/screen_title.dart';
import 'package:taskmaster/components/sidebar.dart';
import 'package:taskmaster/components/update_sub_form.dart';

class UpdateSubscriptions extends StatefulWidget {
  const UpdateSubscriptions({super.key});

  @override
  State<UpdateSubscriptions> createState() => _UpdateSubscriptionsState();
}

class _UpdateSubscriptionsState extends State<UpdateSubscriptions> {
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
                  ScreenTitle("Update existing subscriptions"),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 50, horizontal: 50),
                    child: SizedBox(
                      width: 600,
                      child: UpdateSubForm(),
                    ),
                  ),
                ],
              ),
            ])));
  }
}
