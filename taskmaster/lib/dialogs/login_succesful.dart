import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> loginSuccesfulDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Sign in', 
  content: 'Sign in succesful!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}