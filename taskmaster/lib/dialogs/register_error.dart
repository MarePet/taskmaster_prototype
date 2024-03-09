import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> registerErrorDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Sign up error', 
  content: 'Error during singup! Try again.', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}