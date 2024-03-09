import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/dialogs/num_of_users_exceeded.dart';
import 'package:taskmaster/dialogs/user_created_succesfuly.dart';
import 'package:taskmaster/dialogs/user_not_created.dart';
import 'package:taskmaster/models/subscription/subscription.dart';
import 'package:taskmaster/models/user/user.dart';
import 'package:taskmaster/models/user/userPrefs/current_user.dart';

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key, required this.newUserCreated});
  final VoidCallback newUserCreated;

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {

  bool _isPasswordVisible = false;
  CurrentUser _currentUser = new CurrentUser();

  int? numberOfCreatedUsers;
  Subscription? _currentSubscription;



  //VALIDATION
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailErrorText;
  String? _errorFNameText;
  String? _errorLNameText;
  String? _errorPassText;

  final _formKey = GlobalKey<FormState>();

  

  bool _validateFNameField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorFNameText = "All fields are required.";
      });
       return false;
    } else {
      setState(() {
        _errorFNameText = null;
      });
      return true;
    }
  }

  bool _validateLNameField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorLNameText = "All fields are required.";
      });
      return false;
    } else {
      setState(() {
        _errorLNameText = null;
      });
      return true;
    }
  }

  bool _validatePassField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorPassText = "All fields are required.";
      });
      return false;
    } else if (value.length < 8) {
      setState(() {
        _errorPassText = "Password must atleast have 8 characters.";
      });
      return false;
    } else {
      setState(() {
        _errorPassText = null;
      });
      return true;
    }
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailErrorText = 'Email is required';
      });
      return false;
    } else if (!isEmailValid(value)) {
      setState(() {
        _emailErrorText = 'Enter a valid email address';
      });
      return false;
    } else {
      setState(() {
        _emailErrorText = null;
      });
      return true;
    }
  }

  bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _registerAndSaveUserRecord() async {
    await _currentUser.getUserInfo();
    User userModel = User.ownerUser(
        1,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _currentUser.user.userId,
        "'User'",
        null
        );
    try {
      var response = await http.post(
        Uri.parse(API.createUser),
        body: userModel.toJson(),
      );
      if (response.statusCode == 200) {
        var responseBodyOfSignUp = jsonDecode(response.body);
        if (responseBodyOfSignUp['success']) {
          setState(() {
            _firstNameController.clear();
            _lastNameController.clear();
            _emailController.clear();
            _passwordController.clear();
            widget.newUserCreated();
          });
          userCreatedSuccefulyDialog(context);
        } else {
          userNotCreatedDialog(context);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _validateUserEmail() async {
    try {
      var response = await http.post(Uri.parse(API.validateEmail), body: {
        'email': _emailController.text.trim(),
      });
      if (response.statusCode == 200) {
        //SUCCESS
        var responseBodyOfValidateEmail = jsonDecode(response.body);
        if (responseBodyOfValidateEmail['emailFound']) {
          js.context.callMethod("alert", <String>["Email already in use!"]);
        } else {
          _registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

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

  Future<Subscription?> _returnCurrentSubscription(int userId) async{
    var response = await http.post(
      Uri.parse(API.returnCurrentSubscription),
      body: {
        'user_id' : userId.toString()
      }
    );
    if(response.statusCode==200){
      var responseBodyOfCurrentSubscription = jsonDecode(response.body);
      if(responseBodyOfCurrentSubscription['success']){
        Subscription subscription = Subscription.fromJson(responseBodyOfCurrentSubscription['subData']);
        return subscription;
      }
      else{
        return null;
      }
    }else{
      return null;
    }
  }

  void _submitForm() async{
    await _currentUser.getUserInfo();
    if (_formKey.currentState!.validate() 
    && _validateEmail(_emailController.text) && _validatePassField(_passwordController.text) 
    && _validateFNameField(_firstNameController.text) && _validateLNameField(_lastNameController.text)) {
      numberOfCreatedUsers = await _returnNumberOfUsersCreated(_currentUser.user.userId);
      _currentSubscription = await _returnCurrentSubscription(_currentUser.user.userId);
      if(_currentSubscription == null){
         _validateUserEmail();
      }
      else if(numberOfCreatedUsers! < _currentSubscription!.maxUsers){
         _validateUserEmail();
      }else{
        numOfUsersExceededDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) => _errorFNameText,
            onChanged: _validateFNameField,
            controller: _firstNameController,
            decoration: InputDecoration(
              errorText: _errorFNameText,
              hintText: 'Enter users first name',
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
            validator: (value) => _errorLNameText,
            onChanged: _validateLNameField,
            controller: _lastNameController,
            decoration: InputDecoration(
              errorText: _errorLNameText,
              hintText: 'Enter users last name',
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
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _emailErrorText,
            onChanged: _validateEmail,
            controller: _emailController,
            decoration: InputDecoration(
              errorText: _emailErrorText,
              hintText: 'Enter users e-mail',
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
            validator: (value) => _errorPassText,
            onChanged: _validatePassField,
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              errorText: _errorPassText,
              hintText: 'Password',
              suffixIcon: GestureDetector(
                onTap: _togglePasswordVisibility,
                child: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blueGrey,
                ),
              ),
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
              onPressed: () {
                _submitForm();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Create new user'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}