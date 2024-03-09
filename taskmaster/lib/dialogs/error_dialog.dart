import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> showErrorDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Error', 
  content: 'All fields are required', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}