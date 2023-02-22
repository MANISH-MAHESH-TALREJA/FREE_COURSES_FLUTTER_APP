import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationBLOC extends ChangeNotifier
{
  AuthenticationBLOC()
  {
    checkSignIn();
    checkGuestUser();
  }

  final FacebookLogin _fbLogin = new FacebookLogin();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final String defaultUserImageUrl = 'https://manish-mahesh-talreja.000webhostapp.com/IMAGES/EMOJI.png';
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool _guestUser = false;
  bool get guestUser => _guestUser;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _hasError = false;
  bool get hasError => _hasError;
  String _errorCode;
  String get errorCode => _errorCode;
  String _name;
  String get name => _name;
  String _uid;
  String get uid => _uid;
  String _email;
  String get email => _email;
  String _imageUrl;
  String get imageUrl => _imageUrl;
  String _joiningDate;
  String get joiningDate => _joiningDate;
  String _signInProvider;
  String get signInProvider => _signInProvider;
  String timestamp;

  Future signInWithGoogle() async
  {
    // ignore: invalid_return_type_for_catch_error
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn().catchError((error) => print('ERROR OCCURRED : $error'));
    if (googleUser != null)
    {
      try
      {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        User userDetails = (await _firebaseAuth.signInWithCredential(credential)).user;
        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoURL;
        this._uid = userDetails.uid;
        this._signInProvider = 'GOOGLE';
        _hasError = false;
        notifyListeners();
      }
      catch (e)
      {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    }
    else
    {
      _hasError = true;
      notifyListeners();
    }
  }
  Future signInWithFacebook() async
  {
    User currentUser;
    // ignore: invalid_return_type_for_catch_error
    final FacebookLoginResult facebookLoginResult = await _fbLogin.logIn(['email', 'public_profile']).catchError((error) => print('ERROR : $error'));
    if (facebookLoginResult.status == FacebookLoginStatus.cancelledByUser)
    {
      _hasError = true;
      _errorCode = 'CANCEL';
      notifyListeners();
    }
    else if (facebookLoginResult.status == FacebookLoginStatus.error)
    {
      _hasError = true;
      notifyListeners();
    }
    else
    {
      try
      {
        if (facebookLoginResult.status == FacebookLoginStatus.loggedIn)
        {
          FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
          final AuthCredential credential = FacebookAuthProvider.credential(facebookAccessToken.token);
          final User user = (await _firebaseAuth.signInWithCredential(credential)).user;
          print(user.displayName);
          assert(user.email != null);
          assert(user.displayName != null);
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          currentUser = _firebaseAuth.currentUser;
          assert(user.uid == currentUser.uid);
          this._name = user.displayName;
          this._email = user.email;
          this._imageUrl = user.photoURL;
          this._uid = user.uid;
          this._signInProvider = 'FACEBOOK';
          _hasError = false;
          notifyListeners();
        }
      }
      catch (e)
      {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    }
  }
  Future<bool> checkUserExists() async
  {
    DocumentSnapshot snap = await fireStore.collection('USERS').doc(_uid).get();
    if (snap.exists)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  Future saveToFirebase() async
  {
    final DocumentReference ref = FirebaseFirestore.instance.collection('USERS').doc(_uid);
    var userData =
    {
      'NAME': _name,
      'EMAIL': _email,
      'UID': _uid,
      'IMAGE URL': _imageUrl,
      'JOINING DATE': _joiningDate,
      'LOVED YOUTUBE COURSES': [],
      'LOVED UDEMY COURSES': [],
      'BOOKMARKED YOUTUBE COURSES': [],
      'BOOKMARKED UDEMY COURSES': []
    };
    await ref.set(userData);
  }

  Future getJoiningDate() async
  {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd-MM-yyyy').format(now);
    _joiningDate = _date;
    notifyListeners();
  }

  Future saveDataToSP() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('NAME', _name);
    await sp.setString('EMAIL', _email);
    await sp.setString('IMAGE URL', _imageUrl);
    await sp.setString('UID', _uid);
    await sp.setString('JOINING DATE', _joiningDate);
    await sp.setString('SIGN IN PROVIDER', _signInProvider);
  }

  Future getDataFromSp() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('NAME');
    _email = sp.getString('EMAIL');
    _imageUrl = sp.getString('IMAGE URL');
    _uid = sp.getString('UID');
    _joiningDate = sp.getString('JOINING DATE');
    _signInProvider = sp.getString('SIGN IN PROVIDER');
    notifyListeners();
  }

  Future getUserDataFromFirebase(uid) async
  {
    await FirebaseFirestore.instance.collection('USERS').doc(uid).get().then((DocumentSnapshot snap)
    {
      Map<String, dynamic> d = snap.data();
      this._uid = d['UID'];
      this._name = d['NAME'];
      this._email = d['EMAIL'];
      this._imageUrl = d['IMAGE URL'];
      this._joiningDate = d['JOINING DATE'];
      print(_name);
    });
    notifyListeners();
  }

  Future setSignIn() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('SIGNED IN', true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future removeSignIn() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('SIGNED IN', false);
    _isSignedIn = false;
    notifyListeners();
  }

  void checkSignIn() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('SIGNED IN') ?? false;
    notifyListeners();
  }


  Future userSignOut() async
  {
    if (_signInProvider == 'FACEBOOK')
    {
      await _firebaseAuth.signOut();
      await _fbLogin.logOut();
    }
    else
    {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    }
    await clearAllData();
    _isSignedIn = false;
    _guestUser = false;
    notifyListeners();
  }

  Future setGuestUser() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('GUEST USER', true);
    _guestUser = true;
    notifyListeners();
  }

  void checkGuestUser() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('GUEST USER') ?? false;
    notifyListeners();
  }

  Future clearAllData() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

  Future guestSignOut() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('GUEST USER', false);
    _guestUser = false;
    notifyListeners();
  }

  Future updateUserProfile(String newName, String newImageUrl) async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    FirebaseFirestore.instance.collection('USERS').doc(_uid).update({'NAME': newName, 'IMAGE URL': newImageUrl});
    sp.setString('NAME', newName);
    sp.setString('IMAGE URL', newImageUrl);
    _name = newName;
    _imageUrl = newImageUrl;
    notifyListeners();
  }

  Future<int> getTotalUsersCount() async
  {
    final String fieldName = 'TOTAL';
    final DocumentReference ref = fireStore.collection('COUNT').doc('USERS COUNT');
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true)
    {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    }
    else
    {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseUserCount() async
  {
    await getTotalUsersCount().then((int documentCount) async
    {
      await fireStore.collection('COUNT').doc('USERS COUNT').update({'TOTAL': documentCount + 1});
    });
  }
}
