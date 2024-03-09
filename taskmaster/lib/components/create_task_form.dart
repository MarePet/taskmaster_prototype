import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/models/user/user.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';
import 'package:http/http.dart' as http;
import 'package:taskmaster/models/categories/category_model.dart';


class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({
    super.key,
    required this.newUserAsigned,
    required this.newCategoryAsigned,
    required this.submitForm,
  });
  
  final newUserAsigned;
  final newCategoryAsigned;
  final submitForm;

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  CurrentUser _currentUser = CurrentUser();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String? _errorTitleText;
  String? _errorDescText;

  List<User> users = List.empty(growable: true);
  List<CategoryModel> categories = List.empty(growable: true);

  User? selectedUser;
  CategoryModel? selectedCategory;

  bool _validateTitleField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorTitleText = "All fields are required.";
      });
      return false;
    } else {
      setState(() {
        _errorTitleText = null;
      });
      return true;
    }
  }

  bool _validateDescField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorDescText = "All fields are required.";
      });
      return false;
    } else {
      setState(() {
        _errorDescText = null;
      });
      return true;
    }
  }
  void _getAllCategories() async {
    try {
      var response = await http.post(
        Uri.parse(API.returnCategories),
      );
      if(response.statusCode == 200){
        List<dynamic> categoriesJson = jsonDecode(response.body);
        for (var categoryJson in categoriesJson) {
          CategoryModel category = CategoryModel.fromJson(categoryJson);
          setState(() {
            categories.add(category);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
  void _getAllUsersByOwnerId() async {
    await _currentUser.getUserInfo();
    try {
      var response =
          await http.post(Uri.parse(API.returnUsersByOwnerId), body: {
        'owner_id': _currentUser.user.userId.toString(),
      });
      if (response.statusCode == 200) {
        List<dynamic> usersJson = jsonDecode(response.body);
        for (var userJson in usersJson) {
          User user = User.fromJson(userJson);
          setState(() {
            users.add(user);
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
    _getAllUsersByOwnerId();
    _getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) => _errorTitleText,
            onChanged: _validateTitleField,
            controller: _titleController,
            decoration: InputDecoration(
              errorText: _errorTitleText,
              hintText: 'Enter task title',
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
            validator: (value) => _errorDescText,
            onChanged: _validateDescField,
            controller: _descController,
            decoration: InputDecoration(
              errorText: _errorDescText,
              hintText: 'Enter task description',
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
          DropdownButtonFormField2<User>(
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
              'Select user',
              style: TextStyle(fontSize: 14),
            ),
            items: users
                .map((user) => DropdownMenuItem<User>(
                      value: user,
                      child: Text(
                        user.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select user.';
              }
              return null;
            },
            onChanged: (value) {
              selectedUser = value;
            },
            onSaved: (value) {
              selectedUser = value;
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
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              setState(() {
                widget.newUserAsigned(selectedUser);
              });
            },
            child: const Text('Assign user'),
          ),
          const SizedBox(
            height: 40,
          ),
          DropdownButtonFormField2<CategoryModel>(
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
              'Select category',
              style: TextStyle(fontSize: 14),
            ),
            items: categories
                .map((category) => DropdownMenuItem<CategoryModel>(
                      value: category,
                      child: Text(
                        category.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select category.';
              }
              return null;
            },
            onChanged: (value) {
              selectedCategory = value;
            },
            onSaved: (value) {
              selectedCategory = value;
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
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              setState(() {
                widget.newCategoryAsigned(selectedCategory);
              });
            },
            child: const Text('Assign category'),
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
                if(_validateDescField(_descController.text) && _validateTitleField(_titleController.text)){
                   widget.submitForm(_titleController.text,_descController.text);
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Create new task'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
