import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/models/subscription/subscription.dart';
import 'package:http/http.dart' as http;

class UpdateSubForm extends StatefulWidget {
  const UpdateSubForm({super.key});

  @override
  State<UpdateSubForm> createState() => _UpdateSubFormState();
}

class _UpdateSubFormState extends State<UpdateSubForm> {
  final _formKey = GlobalKey<FormState>();

  //SUBSCRIPTION
  Subscription? selectedSubscription;
  List<Subscription> subscriptions = List.empty(growable: true);

  //VALIDATION
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _maxUsersController = TextEditingController();

  String? _errorNameText;
  String? _errorPriceText;
  String? _errorMaxUsersText;

  @override
  void initState() {
    super.initState();
    _getAllSubscriptions();
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

  bool _validateNameField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorNameText = "All fields are required";
      });
      return false;
    } else {
      setState(() {
        _errorNameText = null;
      });
    }
    return true;
  }

  bool _validatePriceField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorPriceText = "All fields are required";
      });
      return false;
    } else {
      setState(() {
        _errorPriceText = null;
      });
    }
    return true;
  }

  bool _validateMaxUsersField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorMaxUsersText = "All fields are required";
      });
      return false;
    } else if (int.tryParse(value) == null) {
      _errorMaxUsersText = "Field must be an integer";
    } else {
      setState(() {
        _errorMaxUsersText = null;
      });
    }
    return true;
  }

  void _updateSubscription() async {
    Subscription subscription = Subscription(
        subId: selectedSubscription!.subId,
        name: _nameController.text,
        price: _priceController.text,
        maxUsers: int.parse(_maxUsersController.text));
    try {
      var response = await http.post(Uri.parse(API.updateSubscription),
          body: subscription.toJson());
      if (response.statusCode == 200) {
        var responseBodyOfUpdateSub = jsonDecode(response.body);
        if (responseBodyOfUpdateSub['success']) {
          setState(() {
            _nameController.clear();
            _priceController.clear();
            _maxUsersController.clear();
          });
        }
        else{
          print('Error while update: ' + response.body);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _validateNameField(_nameController.text) &&
        _validatePriceField(_priceController.text) &&
        _validateMaxUsersField(_maxUsersController.text)) {
      _updateSubscription();
    }
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
              setState(() {
                selectedSubscription = value;
                _nameController.text = value!.name;
                _priceController.text = value.price;
                _maxUsersController.text = value.maxUsers.toString();
              });
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
          TextFormField(
            validator: (value) => _errorNameText,
            onChanged: _validateNameField,
            controller: _nameController,
            decoration: InputDecoration(
              errorText: _errorNameText,
              hintText: 'Enter new name',
              fillColor: (Colors.blueGrey[50]!),
              filled: true,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          TextFormField(
            validator: (value) => _errorPriceText,
            onChanged: _validatePriceField,
            controller: _priceController,
            decoration: InputDecoration(
              errorText: _errorPriceText,
              hintText: 'Enter new price',
              fillColor: (Colors.blueGrey[50]!),
              filled: true,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            validator: (value) => _errorMaxUsersText,
            onChanged: _validateMaxUsersField,
            controller: _maxUsersController,
            decoration: InputDecoration(
              errorText: _errorMaxUsersText,
              hintText: 'Enter new maximum number of users',
              fillColor: (Colors.blueGrey[50]!),
              filled: true,
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.blueGrey[50]!)),
                borderRadius: BorderRadius.circular(15),
              ),
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
              onPressed: _submitForm,
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Update subscription'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
