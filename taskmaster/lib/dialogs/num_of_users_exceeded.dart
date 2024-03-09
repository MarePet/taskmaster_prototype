import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> numOfUsersExceededDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Error', 
  content: 'You have exceeded the maximum number of users for this subscription!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}