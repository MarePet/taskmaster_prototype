import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> loginErrorDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Sign in error', 
  content: 'Could not sign in!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}