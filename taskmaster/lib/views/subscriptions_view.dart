import 'package:flutter/material.dart';
import 'package:taskmaster/components/screen_title.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';
import 'package:taskmaster/views/change_subscription_view.dart';
import 'package:taskmaster/views/update_subscriptions_view.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});
  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  CurrentUser _currentUser = new CurrentUser();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _currentUser.getUserInfo(), 
    builder: (context,snaoshot) {
      if (_currentUser.user.userRole == "Superadmin") {
      return UpdateSubscriptions();
    } else if (_currentUser.user.userRole == "Subscriber") {
      return ChangeSubscription();
    } else {
      return const ScreenTitle(
          "You dont have the required permission to alter subscriptions");
    }
    });
  }
}
