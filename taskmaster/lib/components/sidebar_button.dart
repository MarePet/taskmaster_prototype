import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarButton extends StatelessWidget {
  const SidebarButton({
    super.key,
    required this.btnName,
    required this.view, 
    required this.icon,
  });

  final Widget Function() view;
  final String btnName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        style: TextButton.styleFrom(
          fixedSize: const Size(180, 90),
          
        ),
        onPressed: () {
          Get.to(view);
        },
        icon: Icon(
          icon,          color: const Color(0xFF3A86FF).withAlpha(155),
          size: 30,
        ),
        label:  Text(
          btnName,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
