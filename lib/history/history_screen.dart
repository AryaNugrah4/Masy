import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:masy/history/history_detail_screen.dart';
import 'package:masy/shared/style.dart';
import 'package:masy/widget/boxshadow.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  int tabIndex = 1;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

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
          "Riwayat",
          style: appBarTitle,
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          labelStyle: tabTitle,
          labelColor: secondaryColor,
          unselectedLabelStyle: unselectedTabTitle,
          unselectedLabelColor: HexColor('#757575'),
          tabs: const [
            Tab(
              child: Text("Diajukan"),
            ),
            Tab(
              child: Text("Diproses"),
            ),
            Tab(
              child: Text("Selesai"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: const BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    db.collection('complaints').where('status', isEqualTo: 0).where('idUser', isEqualTo: uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_not_supported, size: 50),
                          SizedBox(height: 10),
                          Text('No data available')
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: snapshot.data!.docs.map((complaints) {
                        return Column(
                          children: [
                            Container(
                              width: 332.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(
                                    color: HexColor('#B9B9B9'),
                                    width: 0.5.w,
                                  ),
                                  boxShadow: [mainBoxShadow]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 4.h, bottom: 5.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaints['title'],
                                          style: itemTitleHistory,
                                        ),
                                        LayoutBuilder(builder: (context, constraints) {
                                          if (complaints['status'] == 0) {
                                            return Text(
                                              "Diajukan",
                                              style: itemStatusRed,
                                            );
                                          } else if (complaints['status'] == 1) {
                                            return Text(
                                              "Diproses",
                                              style: itemStatusYellow,
                                            );
                                          } else {
                                            return Text(
                                              "Selesai",
                                              style: itemStatusGreen,
                                            );
                                          }
                                        }),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  FadeInImage(
                                    placeholder: const AssetImage('assets/woman-img.png'),
                                    image: NetworkImage(complaints['image']),
                                    width: 332.w,
                                    height: 113.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 70.w,
                                        height: 30.h,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: secondaryColor,
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => HistoryDetailScreen(
                                                          complaint: complaints,
                                                        )));
                                          },
                                          child: Text(
                                            "Lihat",
                                            style: itemSee,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 17.h,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    db.collection('complaints').where('status', isEqualTo: 1).where('idUser', isEqualTo: uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_not_supported, size: 50),
                          SizedBox(height: 10),
                          Text('No data available')
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: snapshot.data!.docs.map((complaints) {
                        return Column(
                          children: [
                            Container(
                              width: 332.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(
                                    color: HexColor('#B9B9B9'),
                                    width: 0.5.w,
                                  ),
                                  boxShadow: [mainBoxShadow]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 4.h, bottom: 5.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaints['title'],
                                          style: itemTitleHistory,
                                        ),
                                        LayoutBuilder(builder: (context, constraints) {
                                          if (complaints['status'] == 0) {
                                            return Text(
                                              "Diajukan",
                                              style: itemStatusRed,
                                            );
                                          } else if (complaints['status'] == 1) {
                                            return Text(
                                              "Diproses",
                                              style: itemStatusYellow,
                                            );
                                          } else {
                                            return Text(
                                              "Selesai",
                                              style: itemStatusGreen,
                                            );
                                          }
                                        }),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.network(
                                    complaints['image'],
                                    width: 332.w,
                                    height: 113.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 70.w,
                                        height: 30.h,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: secondaryColor,
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => HistoryDetailScreen(
                                                          complaint: complaints,
                                                        )));
                                          },
                                          child: Text(
                                            "Lihat",
                                            style: itemSee,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 17.h,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    db.collection('complaints').where('status', isEqualTo: 2).where('idUser', isEqualTo: uid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_not_supported, size: 50),
                          SizedBox(height: 10),
                          Text('No data available')
                        ],
                      ),
                    );
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      children: snapshot.data!.docs.map((complaints) {
                        return Column(
                          children: [
                            Container(
                              width: 332.w,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.r),
                                  border: Border.all(
                                    color: HexColor('#B9B9B9'),
                                    width: 0.5.w,
                                  ),
                                  boxShadow: [mainBoxShadow]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 4.h, bottom: 5.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          complaints['title'],
                                          style: itemTitleHistory,
                                        ),
                                        LayoutBuilder(builder: (context, constraints) {
                                          if (complaints['status'] == 0) {
                                            return Text(
                                              "Diajukan",
                                              style: itemStatusRed,
                                            );
                                          } else if (complaints['status'] == 1) {
                                            return Text(
                                              "Diproses",
                                              style: itemStatusYellow,
                                            );
                                          } else {
                                            return Text(
                                              "Selesai",
                                              style: itemStatusGreen,
                                            );
                                          }
                                        }),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image.network(
                                    complaints['image'],
                                    width: 332.w,
                                    height: 113.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 70.w,
                                        height: 30.h,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: secondaryColor,
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => HistoryDetailScreen(
                                                          complaint: complaints,
                                                        )));
                                          },
                                          child: Text(
                                            "Lihat",
                                            style: itemSee,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 17.h,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
