import 'package:flutter/cupertino.dart';
import 'package:primo/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog(
      context: context,
      title: 'Password Reset',
      content: 'We have sent a password reset link. Please check email for more info',
      optionBuilder: ()=>{
        'OK' :null
      },
  );
}