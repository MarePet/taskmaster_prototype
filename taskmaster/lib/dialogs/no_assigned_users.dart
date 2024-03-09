import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';


Future<bool> noAssignedUsersDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Error', 
  content: 'You need to assign atleast ONE user!', 
  optionBuilder: () => {
    'Ok' : true
  }).then((value) => value ?? false);
}