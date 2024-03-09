import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taskmaster/api_connection/api_connection.dart';
import 'package:taskmaster/dialogs/login_error.dart';
import 'package:taskmaster/dialogs/login_succesful.dart';
import 'package:taskmaster/models/user/user.dart';
import 'package:taskmaster/models/user/userPrefs/user_prefs.dart';
import 'package:taskmaster/views/main_view.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  bool _isPasswordVisible = false;

  //VALIDATION
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _emailErrorText;
  String? _errorPassText;

  void loginUser() async {
    try {
      var response = await http.post(Uri.parse(API.login), body: {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim()
      });
      if (response.statusCode == 200) {
        var responseBodyOfLogin = jsonDecode(response.body);
        if (responseBodyOfLogin['success']) {
          User user = User.fromJson(responseBodyOfLogin['userData']);
          await RememberUserPrefs.storerUserInfo(user);
          Future.delayed(const Duration(milliseconds: 2000), () {
            Get.to(() => MainView());
          });
          loginSuccesfulDialog(context);
        } else {
         loginErrorDialog(context); 
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _validateEmailField(String value) {
    if (value.isEmpty) {
      setState(() {
        _emailErrorText = "Enter your e-mail!";
      });
    } else {
      setState(() {
        _emailErrorText = null;
      });
    }
  }

  void _validatePassField(String value) {
    if (value.isEmpty) {
      setState(() {
        _errorPassText = "Enter your password!";
      });
    } else {
      setState(() {
        _errorPassText = null;
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      loginUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) => _emailErrorText,
            onChanged: _validateEmailField,
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
                child: const Text('Sing in'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
