import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:masy/shared/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final TextEditingController _emailController =
      TextEditingController(text: 'AkunAdmin@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'admin123');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: accent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/img-login.png",
                  width: 200.w,
                  height: 245.h,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 17.h,
                    ),
                    Text(
                      "Login",
                      style: loginTitle,
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                          
                            controller: _emailController,
                            style: inputLogin,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                              hintText: "Email",
                              hintStyle: hintLogin,
                              prefixIcon: Image.asset(
                                "assets/ic-at-sign.png",
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 21.h,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: inputLogin,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: hintLogin,
                              prefixIcon: Image.asset(
                                "assets/ic-lock.png",
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: forgotPassword,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          _isLoading
                              ? SizedBox(
                                  width: 315.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                    ),
                                    onPressed: () {},
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 315.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                    ),
                                    onPressed: () {
                                      login(_emailController.text,
                                          _passwordController.text);
                                    },
                                    child: Text(
                                      "Login",
                                      style: loginBtn,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum memiliki akun? ",
                            style: noAccLogin,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Text(
                              "Sign Up",
                              style: forgotPassword,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (credential.user != null) {
          final uid = credential.user!.uid;
          final user = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('uid', uid);

          if (user['role'] == 'officer' || user['role'] == 'admin') {
            String role = user['role'];
            if (mounted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/menu-panel', (route) => false);
              buildSnackBarSuccess(context, "Login Success as $role");
            }
          } else if (user['role'] == 'public') {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/botnavbar', (route) => false);
              buildSnackBarSuccess(context, "Login Success");
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          buildSnackBarError(context, "User not found");
        } else if (e.code == 'wrong-password') {
          buildSnackBarError(context, "Wrong Password");
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}

void buildSnackBarError(BuildContext context, String title) {
  final snackBar = SnackBar(
    content: Text(
      title,
      style: snackBarTitle,
    ),
    backgroundColor: HexColor('#FF6C6C'),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(20),
    elevation: 30,
    action: SnackBarAction(
      label: 'Dismiss',
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void buildSnackBarSuccess(BuildContext context, String title) {
  final snackBar = SnackBar(
    content: Text(
      title,
      style: snackBarTitle,
    ),
    backgroundColor: mainColor,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(20),
    elevation: 30,
    action: SnackBarAction(
      label: 'Dismiss',
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
