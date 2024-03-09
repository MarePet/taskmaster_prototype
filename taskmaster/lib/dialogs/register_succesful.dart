import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> registerSuccesfulDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Sign up', 
  content: 'Signup succesful!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}