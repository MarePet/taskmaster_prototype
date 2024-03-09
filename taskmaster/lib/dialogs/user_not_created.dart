import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> userNotCreatedDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Error', 
  content: 'Error while creating user!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}