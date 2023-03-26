import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masy/models/user.dart';
import 'package:masy/shared/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isUser;

  @override
  void initState() {
    super.initState();
    navigateToScreen();
  }

  Future<void> navigateToScreen() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      Timer(const Duration(seconds: 3), () async {
        if (user != null) {
          isUser = true;
        } else {
          isUser = false;
        }

        if (isUser == true) {
          String? role = await roleCheck();
          if (mounted) {
            if (role == 'public') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/botnavbar', (route) => false);
            } else if (role == 'officer' || role == 'admin') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/menu-panel', (route) => false);
            }
          }
        } else {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          }
        }
      });
    });
  }

  Future<String?> roleCheck() async {
    String? role;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    print(uid);
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final users = Users.fromJson(userDoc.data()!);
    role = users.role;
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image.asset(
            'assets/logo.png',
            width: 294.w,
            height: 294.h,
          )),
          Text(
            "Masy",
            style: titleSplash,
          ),
        ],
      ),
    );
  }
}
