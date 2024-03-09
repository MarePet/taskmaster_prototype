import 'package:flutter/material.dart';
import 'package:taskmaster/dialogs/generic_dialog.dart';

Future<bool> updateSubOfUserDialogSuccess(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Success', 
  content: 'The subscription has been succesfuly updated!', 
  optionBuilder: () => {
    'OK' : true,
  }).then((value) => value ?? false);
}

Future<bool> updateSubOfUserDialogError(BuildContext context){
  return showGenericDialog<bool>(context: context, 
  title: 'Success', 
  content: 'The subscription has been succesfuly updated!', 
  optionBuilder: () => {
    'OK' : true,
  }).then((value) => value ?? false);
}