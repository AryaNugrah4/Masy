import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:masy/shared/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/user.dart';

class MenuScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const MenuScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool? isLoading;
  String fullname = 'Siapa saya';
  String? role;
  String uid = '';

  Future<String?> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  currentUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      await getSharedPrefs().then((value) async {
        setState(() {
          uid = '$value';
        });
      });
    } catch (e) {
      log(e.toString());
    }

    try {
      var checkUsers = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final users = Users.fromJson(checkUsers.data()!);

      setState(() {
        fullname = users.fullname!;
        role = users.role;
      });
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    currentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: mainColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: SizedBox(
                  width: 200.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isLoading!)
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 50.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                              ),
                            )
                          else
                            Text(
                              fullname,
                              style: usernameTitle,
                            ),
                          isLoading!
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 50.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                )
                              : Text(
                                  role!,
                                  style: itemTitle,
                                ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            ZoomDrawer.of(context)!.close();
                          },
                          icon: const Icon(Icons.close_rounded)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              buildMenuItem("Dashboard", Icons.dashboard_rounded, 0),
              buildMenuItem("Complaint List", Icons.newspaper_rounded, 1),
              buildMenuItem("Officer List", Icons.people_alt_rounded, 2),
              buildMenuItem("Logout", Icons.logout, 3),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(String title, IconData icon, int index) {
    return ListTile(
      leading: Icon(icon),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
      title: Text(
        title,
        style: itemTitle,
      ),
      onTap: () {
        if (index == 3) {
          ZoomDrawer.of(context)!.close();
          FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          ZoomDrawer.of(context)!.close();
          widget.setIndex(index);
        }
      },
    );
  }
}
