import 'package:blog/PAGES/AuthenticationPage.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void openToast(context, message)
{
  Toast.show(message, textStyle: TextStyle(color: Colors.white), backgroundRadius: 20, duration: Toast.lengthShort);
}

void openToast1(context, message)
{
  Toast.show(message, textStyle: TextStyle(color: Colors.white), backgroundRadius: 20, duration: Toast.lengthLong);
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
                child: Text('OK'))
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
          title: Text('SIGN IN'),
          content: Text('SIGN IN TO EXPLORE COURSES'),
          actions: [
            TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                  nextScreenPopup(
                      context,
                      AuthenticationPage(
                        tag: 'POPUP',
                      ));
                },
                child: Text('SIGN IN')),
            TextButton(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: Text('CANCEL'))
          ],
        );
      });
}


void openSnackBar(_scaffoldKey, snackMessage)
{
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 30,
      child: Text(
        snackMessage,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'OK',
      textColor: Colors.blueAccent,
      onPressed: () {},
    ),
  ));
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
