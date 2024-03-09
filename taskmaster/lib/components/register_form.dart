import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/dialogs/register_error.dart';
import 'package:taskmaster/dialogs/register_succesful.dart';
import 'package:taskmaster/models/subscription/subscription.dart';
import 'package:taskmaster/models/user/user.dart';

class FormRegister extends StatefulWidget {
  const FormRegister({super.key});

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  bool _isPasswordVisible = false;

  //VALIDATION
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //SUBSCRIPTION
  Subscription? selectedSubscription;
  List<Subscription> subscriptions = List.empty(growable: true);

  String? _emailErrorText;
  String? _errorFNameText;
  String? _errorLNameText;
  String? _errorPassText;

  final _formKey = GlobalKey<FormState>();

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
      if(response.statusCode == 200){
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
    User userModel = User(
        1,
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        "'Subscriber'",
        selectedSubscription?.subId
        );
    try {
      var response = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJsonRegister(),
      );
      if (response.statusCode == 200) {
        var responseBodyOfSignUp = jsonDecode(response.body);
        if (responseBodyOfSignUp['success']) {
          setState(() {
            _firstNameController.clear();
            _lastNameController.clear();
            _emailController.clear();
            _passwordController.clear();
          });
          registerSuccesfulDialog(context);
        } else {
          registerErrorDialog(context);
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

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _validateEmail(_emailController.text) &&
        _validatePassField(_passwordController.text) &&
        _validateFNameField(_firstNameController.text) &&
        _validateLNameField(_lastNameController.text)) {
      _validateUserEmail();
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
              hintText: 'Enter your first name',
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
              hintText: 'Enter your last name',
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
              hintText: 'Enter your e-mail',
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
              onPressed: _submitForm,
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: const Text('Register'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
