import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/internet_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/utility/general_utility_functions.dart';

class EditProfile extends StatefulWidget
{
  final String name;
  final String imageUrl;

  EditProfile({Key? key, required this.name, required this.imageUrl}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState(this.name, this.imageUrl);
}

class _EditProfileState extends State<EditProfile>
{
  _EditProfileState(this.name, this.imageUrl);

  String name;
  String imageUrl;
  String? fileName;
  bool loading = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var nameCtrl = TextEditingController();


  handleUpdateData() async
  {
    final InternetBLOC ib = Provider.of<InternetBLOC>(context, listen: false);
    final sb = context.read<AuthenticationBLOC>();
    await ib.checkInternet();
    if (ib.hasInternet == false)
    {
      openSnackBar(scaffoldKey, 'NO INTERNET');
    }
    else
    {
      if (formKey.currentState!.validate())
      {
        formKey.currentState!.save();
        setState(() => loading = true);
        await sb.updateUserProfile(nameCtrl.text, imageUrl).then((value)
        {
          openSnackBar(scaffoldKey, 'UPDATED SUCCESSFULLY');
          setState(() => loading = false);
        });
      }
    }
  }

  @override
  void initState()
  {
    super.initState();
    nameCtrl.text = name;
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('EDIT PROFILE'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.transparent,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[800]!),
                    color: Colors.grey[500],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.fill)),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Form(
                key: formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'ENTER NEW NAME',
                  ),
                  controller: nameCtrl,
                  validator: (value) {
                    if (value!.length == 0) return "NAME CAN'T BE EMPTY";
                    return null;
                  },
                )),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),),
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white))
                ),
                child: loading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text(
                        'UPDATE PROFILE',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                onPressed: () {
                  handleUpdateData();
                },
              ),
            ),
          ],
        ));
  }
}
