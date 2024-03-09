import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.loginActive, required this.onLoginTap, required this.onRegisterTap});
  final bool loginActive;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuItem(title: 'Home', isActive: false, onMenuItemClicked: (){}),
              MenuItem(title: 'About us', isActive: false, onMenuItemClicked: (){}),
              MenuItem(title: 'Contact us', isActive: false, onMenuItemClicked: (){}),
              MenuItem(title: 'Help', isActive: false, onMenuItemClicked: (){}),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuItem(
                  title: 'Sign in',
                  isActive: widget.loginActive,
                  onMenuItemClicked: widget.onLoginTap,
                  ),
              MenuItem(
                  title: 'Register',
                  isActive: !widget.loginActive,
                  onMenuItemClicked: widget.onRegisterTap,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {super.key,
      required this.title,
      required this.isActive,
      required this.onMenuItemClicked});
  final String title;
  final bool isActive;
  final VoidCallback onMenuItemClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMenuItemClicked,
      child: Padding(
        padding: const EdgeInsets.only(right: 75),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.deepPurple : Colors.grey),
            ),
            const SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30)),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}


Widget _registerButton() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: (Colors.grey[200])!, spreadRadius: 10, blurRadius: 12)
        ]),
    child: const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    ),
  );
}
