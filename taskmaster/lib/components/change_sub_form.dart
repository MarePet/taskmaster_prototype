import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/dialogs/num_of_users_exceeded.dart';
import 'package:taskmaster/dialogs/update_user_subscription.dart';
import 'package:taskmaster/models/subscription/subscription.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';
import 'package:http/http.dart' as http;

class ChangeSubForm extends StatefulWidget {
  const ChangeSubForm({super.key});

  @override
  State<ChangeSubForm> createState() => _ChangeSubFormState();
}

class _ChangeSubFormState extends State<ChangeSubForm> {
  final _formKey = GlobalKey<FormState>();

  CurrentUser _currentUser = new CurrentUser();

  Subscription? selectedSubscription;
  List<Subscription> subscriptions = List.empty(growable: true);

  Future<int?> _returnNumberOfUsersCreated(int userId) async {
    var response =
        await http.post(Uri.parse(API.returnNumberOfUsersCreated), body: {
      'user_id': userId.toString(),
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  void _updateSubscriptionOfUser(int userId, int subId) async {
    try {
      var response = await http.post(Uri.parse(API.updateUserSubscription),
          body: {'user_id': userId.toString(), 'sub_id': subId.toString()});
      if (response.statusCode == 200) {
        var responseBodyOfUpdateSub = jsonDecode(response.body);
        if (responseBodyOfUpdateSub['success']) {
          updateSubOfUserDialogSuccess(context);
        } else {
          updateSubOfUserDialogError(context);
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await _currentUser.getUserInfo();
      int? numberOfUsersCreated =
          await _returnNumberOfUsersCreated(_currentUser.user.userId);
      if (numberOfUsersCreated != null &&
          numberOfUsersCreated <= selectedSubscription!.maxUsers) {
        _updateSubscriptionOfUser(
            _currentUser.user.userId, selectedSubscription!.subId);
      } else {
        numOfUsersExceededDialog(context);
      }
    }
  }

  void _getAllSubscriptions() async {
    try {
      var response = await http.post(
        Uri.parse(API.returnSubscription),
      );
      if (response.statusCode == 200) {
        List<dynamic> subscriptionsFromJson = jsonDecode(response.body);
        for (var subJson in subscriptionsFromJson) {
          setState(() {
            Subscription sub = Subscription.fromJson(subJson);
            subscriptions.add(sub);
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
    _getAllSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField2<Subscription>(
            isExpanded: true,
            decoration: InputDecoration(
              // Add Horizontal padding using menuItemStyleData.padding so it matches
              // the menu padding when button's width is not specified.
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              // Add more decoration..
            ),
            hint: const Text(
              'Select subscription',
              style: TextStyle(fontSize: 14),
            ),
            items: subscriptions
                .map((subscription) => DropdownMenuItem<Subscription>(
                      value: subscription,
                      child: Text(
                        subscription.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select subscription.';
              }
              return null;
            },
            onChanged: (value) {
              selectedSubscription = value;
            },
            onSaved: (value) {
              selectedSubscription = value;
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: (Colors.deepPurple[100])!,
                    spreadRadius: 10,
                    blurRadius: 20)
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                _submitForm(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Change subscription'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
