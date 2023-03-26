import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masy/services/history.dart';
import 'package:masy/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class HistoryAddScreen extends StatefulWidget {
  final bool? isEdit;
  final String? log;
  final String? logId;
  final String? email;
  const HistoryAddScreen({Key? key, this.isEdit, this.log, this.logId, this.email}) : super(key: key);

  @override
  State<HistoryAddScreen> createState() => _HistoryAddScreenState();
}

class _HistoryAddScreenState extends State<HistoryAddScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _logController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.isEdit == true ? _logController.text = widget.log.toString() : _logController.text = "";
    widget.isEdit == true ? _emailController.text = widget.email.toString() : _emailController.text = "";
  }

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
          widget.isEdit == true ? "Edit History" : "Add History",
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
                "assets/img-signup.png",
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
                        widget.isEdit == true
                            ? TextFormField(
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
                              )
                            : Container(),
                        widget.isEdit == true
                            ? SizedBox(
                                height: 21.h,
                              )
                            : Container(),
                        TextFormField(
                          controller: _logController,
                          style: inputLogin,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Log required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Log",
                            hintStyle: hintLogin,
                            prefixIcon: Icon(
                              Icons.description,
                              color: black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 21.h,
                        ),
                        SizedBox(
                          width: 315.w,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                            ),
                            onPressed: () async {
                              await submitHandler();
                            },
                            child: Text(
                              widget.isEdit == true ? "Edit" : "Add",
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

  Future submitHandler() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        widget.isEdit == true
            ? await historyUpdate(widget.logId.toString(), _logController.text, _emailController.text)
            : await historyAdd(_logController.text, auth.currentUser?.email.toString());
        if (mounted) {
          buildSuccessEditDialog(context).show();
        }
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        _logController.text = "";
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
    title: 'Berhasil menambahkan history!',
    titleTextStyle: popUpWarningTitle,
    desc: 'Kamu sudah berhasil menambahkan history',
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
