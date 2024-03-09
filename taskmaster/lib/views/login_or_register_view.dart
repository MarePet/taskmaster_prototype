import 'package:flutter/material.dart';
import 'package:taskmaster/components/body.dart';
import 'package:taskmaster/components/menu.dart';


class LoginOrRegisterView extends StatefulWidget {
  const LoginOrRegisterView({super.key});

  @override
  State<LoginOrRegisterView> createState() => _LoginOrRegisterViewState();
}

class _LoginOrRegisterViewState extends State<LoginOrRegisterView> {

  bool _loginActive = true;

  void _handleLoginTap() {
    setState(() {
      _loginActive = true;
      
    });
  }

  void _handleRegisterTap() {
    setState(() {
      _loginActive = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
        children:   [
           Menu(
            loginActive: _loginActive,
            onLoginTap: _handleLoginTap,
            onRegisterTap: _handleRegisterTap,
           ),
            Body(loginActive: _loginActive),
        ],
      )
    );
  }
}



