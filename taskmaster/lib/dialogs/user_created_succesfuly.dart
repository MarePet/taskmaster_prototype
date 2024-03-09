import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> userCreatedSuccefulyDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Succes', 
  content: 'User has been created!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}