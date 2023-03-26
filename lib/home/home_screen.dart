import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:masy/models/user.dart';
import 'package:masy/shared/style.dart';
import 'package:masy/widget/boxshadow.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String? _username;

  currentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    var checkUsers = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final users = Users.fromJson(checkUsers.data()!);
    setState(() {
      _username = users.username;
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
    return Scaffold(
      backgroundColor: accent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 39.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang,',
                        style: homeWelcome,
                      ),
                      SizedBox(
                        width: 240.w,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: isLoading
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 140.w,
                                          height: 25.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5.r),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    _username!,
                                    style: homeUser,
                                    textAlign: TextAlign.left,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: const AssetImage("assets/default.png"),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              SizedBox(
                height: 26.h,
              ),
              Container(
                width: 314.w,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10.r),
                  // image: const DecorationImage(
                  //   image: AssetImage("assets/bg-img-home-users.png"),
                  //   alignment: Alignment.bottomCenter,
                  // ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.h, top: 5.h, left: 15.w, right: 5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        alignment: Alignment.topLeft,
                        image: const AssetImage("assets/img-home-users.png"),
                        width: 220.w,
                        height: 130.h,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Laporkanlah!!",
                        style: homeTitle,
                      ),
                      Text(
                        // "Mari bersama-sama membangun\nIndonesia\nmenjadi lebih baik\ndengan\nmelaporkan\npengaduanmu!",
                        "Mari bersama - sama membangun indonesia menjadi lebih baik lagi, \ndengan melaporkan pengaduanmu kepada kami!",
                        style: homeSubtitle,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 26.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/complaint");
                      // print(currentId);
                    },
                    child: Container(
                      width: 142.w,
                      height: 94.h,
                      padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.r),
                        boxShadow: [
                          mainBoxShadow,
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/ic-report.png",
                              width: 25.w,
                              height: 25.h,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Pengaduan",
                            style: homeItem,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/history");
                    },
                    child: Container(
                      width: 142.w,
                      height: 94.h,
                      padding: EdgeInsets.only(top: 13.h, bottom: 13.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.r),
                        boxShadow: [
                          mainBoxShadow,
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: HexColor('#D5D84E'),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/ic-history.png",
                              width: 25.w,
                              height: 25.h,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Riwayat",
                            style: homeItem,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
