import 'package:blog/pages/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void openToast(context, message)
{
  Toast.show(message, textStyle: const TextStyle(color: Colors.white), backgroundRadius: 20, duration: Toast.lengthShort);
}

void openToastLong(message)
{
  Toast.show(message, textStyle: const TextStyle(color: Colors.white), backgroundRadius: 20, duration: Toast.lengthLong);
}

void openDialog(context, title, message)
{
  showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return AlertDialog(
          content: Text(message),
          title: Text(title),
          actions: <Widget>[
            TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      });
}

openSignInDialog(context)
{
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx)
      {
        return AlertDialog(
          title: const Text('SIGN IN'),
          content: const Text('SIGN IN TO EXPLORE COURSES'),
          actions: [
            TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  nextScreenPopup(
                      context,
                      const AuthenticationPage(
                        tag: 'POPUP',
                      ));
                },
                child: const Text('SIGN IN')),
            TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'))
          ],
        );
      });
}


void openSnackBar(BuildContext context, String snackMessage) {
  // 1. Define the SnackBar with the user's requested content and action.
  final snackBar = SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: Text(
        snackMessage,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.blueAccent,
      onPressed: () {
        // Explicitly hide the SnackBar when 'OK' is pressed
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
    // Set a duration for automatic dismissal if the user doesn't press 'OK'
    duration: const Duration(seconds: 5),
  );

  // 2. Use ScaffoldMessenger.of(context) to manage and display the SnackBar.
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar() // Hides any current SnackBar to ensure the new one displays
    ..showSnackBar(snackBar);
}



void nextScreen(context, page)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page)
{
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page)
{
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup(context, page)
{
  Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (context) => page));
}
