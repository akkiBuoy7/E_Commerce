import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/pref_service.dart';
import '../utility/project_util.dart';
import 'model/user.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userNameText = TextEditingController();
  var passwordText = TextEditingController();
  var _userName = "";
  var _password = "";
  bool _isPassWordHidden = true;
  bool _isCheckedRememberMe = false;
  bool _isAdmin = false;
  var prefService = PrefService();

  String validateInput() {
    //final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
    if (_userName.isEmpty) {
      return 'Please enter user name';
    }
    if (_userName.length <= 4) {
      return "User name should be more than 4 characters";
    }
    if (_password.isEmpty) {
      return 'Please enter password';
    }
    // if (validCharacters.hasMatch(_password)) {
    //   return 'Enter valid alpha numeric password';
    // }
    return "";
  }

  void onTapping(TapDownDetails details) {
    setState(() {
      _isPassWordHidden = false;
    });
  }

  void outTapping(TapUpDetails details) {
    setState(() {
      _isPassWordHidden = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUserUsernamePassword();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                // <-- TextButton
                onPressed: () {
                  exit(0);
                  //Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 24.0,
                ),
                label: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 50, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Proceed with your",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w300),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: TextField(
                      controller: userNameText,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        suffixIcon: Icon(Icons.account_box),
                        label: Text("Username"),
                        suffixIconColor: Colors.grey,
                        focusColor: Colors.black,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: TextField(
                      controller: passwordText,
                      obscureText: _isPassWordHidden,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(color: Colors.red),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        suffixIcon: GestureDetector(
                            onTapDown: onTapping,
                            onTapUp: outTapping,
                            child: Icon(Icons.key_rounded)),
                        suffixIconColor: Colors.grey,
                        label: Text("Password"),
                        focusColor: Colors.black,
                      ),
                    ),
                  )),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _isCheckedRememberMe,
                      activeColor: Colors.red,
                      focusColor: Colors.red,
                      onChanged: (bool? value) {
                        _actionRememberMe(value!);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 7),
                  child: Text("Remember Me"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10,top: 10),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _isAdmin,
                      activeColor: Colors.red,
                      focusColor: Colors.red,
                      onChanged: (bool? value) {
                        _actionIsAdmin(value!);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 7),
                  child: Text("Is Admin"),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _userName = userNameText.text.toString();
                    _password = passwordText.text.toString();

                    if (validateInput() == "") {
                      Fluttertoast.showToast(
                          msg: "Successfully logged in", timeInSecForIosWeb: 1);
                      Navigator.popAndPushNamed(
                          context, ProjectUtil.PRODUCTS_LISTING_SCREEN_ROUTE);
                    } else {
                      String result = validateInput();
                      Fluttertoast.showToast(
                          msg: result, timeInSecForIosWeb: 1);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      textStyle:
                      MaterialStateProperty.all(TextStyle(fontSize: 15))),
                  child: const Text("Login"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _actionRememberMe(bool value) {
    _isCheckedRememberMe = value;

    if (_isCheckedRememberMe) {
      User user = User(userNameText.text, passwordText.text, value,_isAdmin);
      prefService.saveUser(user);
    }else{
      prefService.clearUser();
    }
    setState(() {
      _isCheckedRememberMe = value;
    });
  }


  _actionIsAdmin(bool value) {

    _isAdmin = value;

    User user = User(userNameText.text, passwordText.text, _isCheckedRememberMe,value);
    prefService.saveUser(user);

    setState(() {
      _isAdmin = value;
    });
  }

  //load email and password
  void _loadUserUsernamePassword() async {
    try {
      User userData = await prefService.getUser();
      var _name = userData.name??"";
      var _password = userData.password??"";
      var _remeberMe = userData.isRemember??false;
      var _isadmin = userData.isAdmin??false;

      if (_remeberMe) {
        setState(() {
          _isCheckedRememberMe = true;
        });
        userNameText.text = _name ?? "";
        passwordText.text = _password ?? "";
      }

      if (_isadmin) {
        setState(() {
          _isAdmin = true;
        });
      }

      print(_isAdmin);

    } catch (e) {
      print(e);
    }
  }
}
