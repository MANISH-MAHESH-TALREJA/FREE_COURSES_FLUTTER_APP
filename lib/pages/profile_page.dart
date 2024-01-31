import 'package:avatar_glow/avatar_glow.dart';
import 'package:blog/pages/authentication_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/notification_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/pages/edit_profile.dart';
import 'package:blog/pages/notifications_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/theme_bloc.dart';
import '../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
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
          title: Text('YOUR PROFILE', style: TextStyle(color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,)),
          centerTitle: true,
          actions: [
            IconButton(
                icon: const Icon(Feather.bell, size: 20),
                onPressed: () => nextScreen(context, const NotificationsPage()))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
          children: [
            sb.isSignedIn == false ? const GuestUserUI() : const UserUI(),
            const Center(
              child: Text(
                "GENERAL SETTINGS",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
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
                  title: const Text('NOTIFICATIONS'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Feather.bell, size: 20, color: Colors.white),
                  ),
                  trailing: Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: context.watch<NotificationBLOC>().subscribed!,
                      onChanged: (boolean) {
                        context.read<NotificationBLOC>().fcmSubscribe(boolean);
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
                  title: const Text('CONTACT US'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Feather.mail, size: 20, color: Colors.white),
                  ),
                  trailing: const Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async => await launchUrl(Uri.parse(
                      'mailto:${Constants().supportEmail}?subject=ABOUT ${Constants().appName} APP&body=')),
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
                  title: const Text('RATE THIS APP'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Feather.star, size: 20, color: Colors.white),
                  ),
                  trailing: const Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async
                    {
                      var link = "https://play.google.com/store/apps/details?id=net.manish.blog";
                      launchUrl(Uri.parse(link));
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
                  title: const Text('DARK MODE'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(LineIcons.sun, size: 20, color: Colors.white),
                  ),
                  trailing:  Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: context.watch<ThemeBloc>().darkTheme!,
                      onChanged: (boolean) {
                        context.read<ThemeBloc>().toggleTheme();
                      }),
                  onTap: () async {
                    openToastLong("TOGGLE DARK THEME / LIGHT THEME");
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
                  title: const Text('PRIVACY POLICY'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Feather.lock, size: 20, color: Colors.white),
                  ),
                  trailing: const Icon(
                    Feather.chevron_right,
                    size: 20,
                  ),
                  onTap: () async {
                    if (await canLaunchUrl(Uri.parse(Constants().privacyPolicyUrl)))
                    {
                      launchUrl(Uri.parse(Constants().privacyPolicyUrl));
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
                  title: const Text('ABOUT US'),
                  leading: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(Feather.info, size: 20, color: Colors.white),
                  ),
                  trailing: const Icon(
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
                          title: const Center(
                            child:Text("ABOUT DEVELOPERS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00, color: Colors.green)),
                          ),
                          actions: [MaterialButton
                            (
                            child: const Text("CLOSE",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.00)),
                            onPressed: ()
                            {Navigator.of(context).pop();},
                          )],
                          content: const SingleChildScrollView(
                              child: Text("Developed By : \n\n   1. Abhishek Ojha\n   2. Manish Talreja\n\n     Free Online Courses is an app that will provide Free Udemy Courses, Video Courses to students.", style:TextStyle(fontFamily: 'Muli', fontWeight: FontWeight.normal))
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
  const GuestUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            AvatarGlow(
              glowColor: Colors.orange,
              glowCount: 2,
              glowRadiusFactor: 0.4,
              // endRadius: 90.0,
              //glowBorderRadius: BorderRadius.circular(90.0),
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              // repeatPauseDuration: Duration(milliseconds: 100),
              child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/emoji.png")),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "FREE ONLINE COURSES",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom:5.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: const Text('LOGIN'),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Feather.user, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => nextScreenPopup(
                  context,
                  const AuthenticationPage(
                    tag: 'POPUP',
                  )),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class UserUI extends StatefulWidget {
  const UserUI({super.key});

  @override
  State<UserUI> createState() => _UserUIState();
}

class _UserUIState extends State<UserUI> {
  _openDeleteDialog() {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you really want to delete your data?'),
            content: const Text('Your account information like profile data, bookmarks, etc will be erased from the app database and You will have to sign up again in the app to continue.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleDeleteAccount();
                },
                child: const Text('Yes, Delete My Account'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  _handleDeleteAccount () async
  {
    await context.read<AuthenticationBLOC>().deleteUserDataFromCloudDatabase()
        .then((_) async => await context.read<AuthenticationBLOC>().userSignOut())
        .then((_) => context.read<AuthenticationBLOC>().afterUserSignOut()).then((_){
      Future.delayed(const Duration(seconds: 1))
          .then((value) => nextScreenCloseOthers(context, const AuthenticationPage(
        tag: 'POPUP',
      )));
    });

  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<AuthenticationBLOC>();
    return Column(
      children: [
        Column(
          children: [
            AvatarGlow(
              glowColor: Colors.orange,
              glowCount: 2,
              glowRadiusFactor: 0.4,
              // endRadius: 90.0,
              //glowBorderRadius: BorderRadius.circular(90.0),
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              // repeatPauseDuration: const Duration(milliseconds: 100),
              child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(sb.imageUrl!)),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              sb.name!,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
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
                child: const Icon(Feather.mail, size: 20, color: Colors.white),
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
              title: Text("JOINED ON : ${sb.joiningDate!}"),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.green, borderRadius: BorderRadius.circular(5)),
                child: const Icon(LineIcons.dashcube, size: 20, color: Colors.white),
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
                title: const Text('EDIT PROFILE'),
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(Feather.edit_3, size: 20, color: Colors.white),
                ),
                trailing: const Icon(
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
                title: const Text('DELETE MY PROFILE & DATA'),
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(Feather.trash, size: 20, color: Colors.white),
                ),
                trailing: const Icon(
                  Feather.chevron_right,
                  size: 20,
                ),
                onTap: _openDeleteDialog,
                /*onTap: () => nextScreen(
                    context, EditProfile(name: sb.name!, imageUrl: sb.imageUrl!))*/
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
              title: const Text('REQUEST A COURSE'),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Feather.book, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () async => await launchUrl(Uri.parse(
                  'mailto:${"aayushmanojha4231@gmail.com"}?subject=REQUEST FOR AN COURSE ON ${Constants().appName} APP&body= HELLO AAYUSHMAN SIR,\n          MYSELF, '+sb.name!+", I JOINED FREE COURSES APP ON : "+sb.joiningDate!+". I WOULD LIKE TO REQUEST FOR A COURSE ON YOU APP NAMED AS ............\n\n\n\n\nTHANKING YOU SIR,\nWITH REGARDS,\n"+sb.name!+"\n"+sb.email!.toUpperCase())),
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
              title: const Text('LOGOUT'),
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Feather.log_out, size: 20, color: Colors.white),
              ),
              trailing: const Icon(
                Feather.chevron_right,
                size: 20,
              ),
              onTap: () => openLogoutDialog(context),
            ),
          ),
        ),
        const SizedBox(
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
            title: const Text('LOGOUT'),
            actions: [
              TextButton(
                child: const Text('NO'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () async {
                  Navigator.pop(context);
                  await context.read<AuthenticationBLOC>().removeSignIn();
                  if (!context.mounted)
                  {
                    return;
                  }
                  await context.read<AuthenticationBLOC>().userSignOut().then(
                      (value) => nextScreenCloseOthers(context, const AuthenticationPage()));
                },
              )
            ],
          );
        });
  }
}
