import 'package:avatar_glow/avatar_glow.dart';
import 'package:blog/PAGES/AuthenticationPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/NotificationBLOC.dart';
import 'package:blog/BLOC/authentication_bloc.dart';
import 'package:blog/PAGES/EditProfile.dart';
import 'package:blog/PAGES/NotificationsPage.dart';
import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  openAboutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AboutDialog(
            applicationName: Constants().appName,
            applicationIcon: Image(
              image: AssetImage(Constants().splashIcon),
              height: 30,
              width: 30,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final sb = context.watch<AuthenticationBLOC>();
    return Scaffold(
        appBar: AppBar(
          title: Text('YOUR PROFILE'),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Feather.bell, size: 20),
                onPressed: () => nextScreen(context, NotificationsPage()))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
          children: [
            sb.isSignedIn == false ? GuestUserUI() : UserUI(),
            Center(
              child: Text(
                "GENERAL SETTINGS",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('NOTIFICATIONS'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Feather.bell, size: 20, color: Colors.white),
                  ),
                  trailing: Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: context.watch<NotificationBLOC>().subscribed!,
                      onChanged: (bool) {
                        context.read<NotificationBLOC>().fcmSubscribe(bool);
                      }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('CONTACT US'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Feather.mail, size: 20, color: Colors.white),
                  ),
                  trailing: Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async => await launch(
                      'mailto:${Constants().supportEmail}?subject=ABOUT ${Constants().appName} APP&body='),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('RATE THIS APP'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Feather.star, size: 20, color: Colors.white),
                  ),
                  trailing: Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async
                    {
                      var link = "https://play.google.com/store/apps/details?id=net.manish.blog";
                      if (canLaunch(link) != null)
                      {
                        launch(link);
                      }
                      else
                      {
                        throw 'UNABLE TO LAUNCH !!!';
                      }
                    }
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('PRIVACY POLICY'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Feather.lock, size: 20, color: Colors.white),
                  ),
                  trailing: Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async {
                    if (await canLaunch(Constants().privacyPolicyUrl))
                    {
                      launch(Constants().privacyPolicyUrl);
                    }
                    else
                    {
                      throw 'UNABLE TO LAUNCH !!!';
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text('ABOUT US'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(Feather.info, size: 20, color: Colors.white),
                  ),
                  trailing: Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async
                  {
                    showDialog
                      (
                      context: context,
                      builder: (BuildContext context)
                      {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          title: Center(
                            child:Text("ABOUT DEVELOPERS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00, color: Colors.green)),
                          ),
                          actions: [MaterialButton
                            (
                            child: Text("CLOSE",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.00)),
                            onPressed: ()
                            {Navigator.of(context).pop();},
                          )],
                          content: SingleChildScrollView(
                              child: Text("DEVELOPED BY : \n\n   1. AAYUSHMAN OJHA\n   2. MANISH TALREJA\n\n     FREE ONLINE COURSES IS AN APP THAT WILL PROVIDE FREE UDEMY COURSES, VIDEO COURSES TO STUDENTS.", style:TextStyle(fontFamily: 'Syndor', fontWeight: FontWeight.bold, color: Colors.pink, letterSpacing: 1))
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              AvatarGlow(
                glowColor: Colors.orange,
                endRadius: 90.0,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage("assets/images/emoji.png")),
              ),
              Text(
                "FREE ONLINE COURSES",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text('LOGIN'),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.user, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreenPopup(
                  context,
                  AuthenticationPage(
                    tag: 'POPUP',
                  )),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class UserUI extends StatelessWidget {
  const UserUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<AuthenticationBLOC>();
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              AvatarGlow(
                glowColor: Colors.orange,
                endRadius: 90.0,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: CachedNetworkImageProvider(sb.imageUrl!)),
              ),
              Text(
                sb.name!,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(sb.email!.toUpperCase(), maxLines: 1,),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.mail, size: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text("JOINED ON : "+sb.joiningDate!),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.green, borderRadius: BorderRadius.circular(5)),
                child: Icon(LineIcons.dashcube, size: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
                title: Text('EDIT PROFILE'),
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Feather.edit_3, size: 20, color: Colors.white),
                ),
                trailing: Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: () => nextScreen(
                    context, EditProfile(name: sb.name!, imageUrl: sb.imageUrl!))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text('REQUEST A COURSE'),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.book, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => await launch(
                  'mailto:${"aayushmanojha4231@gmail.com"}?subject=REQUEST FOR AN COURSE ON ${Constants().appName} APP&body= HELLO AAYUSHMAN SIR,\n          MYSELF, '+sb.name!+", I JOINED FREE COURSES APP ON : "+sb.joiningDate!+". I WOULD LIKE TO REQUEST FOR A COURSE ON YOU APP NAMED AS ............\n\n\n\n\nTHANKING YOU SIR,\nWITH REGARDS,\n"+sb.name!+"\n"+sb.email!.toUpperCase()),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text('LOGOUT'),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(Feather.log_out, size: 20, color: Colors.white),
              ),
              trailing: Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => openLogoutDialog(context),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void openLogoutDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('LOGOUT'),
            actions: [
              TextButton(
                child: Text('NO'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('YES'),
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<AuthenticationBLOC>().removeSignIn();
                  await context.read<AuthenticationBLOC>().userSignOut().then(
                      (value) => nextScreenCloseOthers(context, AuthenticationPage()));
                },
              )
            ],
          );
        });
  }
}
