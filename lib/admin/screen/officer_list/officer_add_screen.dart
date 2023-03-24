import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masy/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class OfficerAddScreen extends StatefulWidget {
  const OfficerAddScreen({Key? key}) : super(key: key);

  @override
  State<OfficerAddScreen> createState() => _OfficerAddScreenState();
}

class _OfficerAddScreenState extends State<OfficerAddScreen> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: black,
          ),
        ),
        title: Text(
          "Add Officer",
          style: appBarTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 45.h,
            ),
            Center(
              child: Image.asset(
                "assets/signup-img.png",
                width: 180.w,
                height: 180.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 7.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _fullnameController,
                          style: inputLogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Fullname required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Nama Lengkap",
                            hintStyle: hintLogin,
                            prefixIcon: Image.asset(
                              "assets/ic-fullname.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        TextFormField(
                          controller: _nikController,
                          style: inputLogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'NIK required';
                            } else if (value.length != 16) {
                              return 'NIK perlu 16 digit';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "NIK",
                            hintStyle: hintLogin,
                            prefixIcon: Image.asset(
                              "assets/ic-idcard.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        TextFormField(
                          controller: _phoneController,
                          style: inputLogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Telepon",
                            hintStyle: hintLogin,
                            prefixIcon: Image.asset(
                              "assets/ic-phonenumber.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          style: inputLogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: hintLogin,
                            prefixIcon: Image.asset(
                              "assets/ic-username.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        TextFormField(
                          controller: _emailController,
                          style: inputLogin,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
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
                                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
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
                          height: 25.h,
                        ),
                        SizedBox(
                          width: 315.w,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                            ),
                            onPressed: () async {
                              await signUp();
                            },
                            child: Text(
                              "Add",
                              style: loginBtn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        final create = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        final user = create.user;
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
          'id': user?.uid,
          'email': _emailController.text,
          'fullname': _fullnameController.text,
          'nik': int.parse(_nikController.text),
          'phone': _phoneController.text,
          'username': _usernameController.text,
          'role': "officer"
        });
        if (mounted) {
          buildSuccessEditDialog(context).show();
        }
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        _emailController.text = "";
        _passwordController.text = "";
      }
    }
  }
}

AwesomeDialog buildSuccessEditDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Berhasil menambahkan officer!',
    titleTextStyle: popUpWarningTitle,
    desc: 'Kamu sudah berhasil menambahkan officer',
    descTextStyle: popUpWarningDesc,
    buttonsTextStyle: whiteOnBtnSmall,
    buttonsBorderRadius: BorderRadius.circular(6.r),
    btnOkColor: mainColor,
    showCloseIcon: false,
    btnOkText: 'Kembali Ke Home',
    btnOkOnPress: () {
      Navigator.pushNamedAndRemoveUntil(context, '/menu-panel', (route) => false);
    },
  );
}
