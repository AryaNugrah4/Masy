import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masy/complaint/complaint_edit_screen.dart';
import 'package:masy/services/complaint.dart';
import 'package:masy/shared/style.dart';
import 'package:masy/widget/boxshadow.dart';
import 'package:readmore/readmore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatefulWidget {
  final dynamic complaint;

  const HistoryDetailScreen({Key? key, required this.complaint}) : super(key: key);

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    final dynamic complaint = widget.complaint;
    final db = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: accent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          complaint['status'] == 0
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComplaintEditScreen(
                                  complaint: complaint,
                                )));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Pengaduan telah diproses, tidak bisa diubah."),
                    ));
                  },
                  icon: Icon(
                    Icons.edit,
                    color: grayUnselect,
                  ),
                ),
          IconButton(
            onPressed: () {
              buildWarningDeleteDialog(
                context,
                complaint['id'],
                complaint['title'],
                auth.currentUser?.email.toString(),
              ).show();
            },
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.red,
            ),
          ),
        ],
        title: Text(
          "Detail Riwayat",
          style: appBarTitleWhite,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.contain,
            image: AssetImage("assets/detail-img.png"),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 17.h,
                ),
                Container(
                  width: 301.w,
                  padding: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.r), boxShadow: [
                    mainBoxShadow,
                  ]),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          topRight: Radius.circular(15.r),
                        ),
                        child: Image.network(
                          complaint['image'],
                          width: 301.w,
                          height: 174.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 13.h),
                      Text(
                        complaint['title'],
                        style: detailTitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Deskripsi",
                      style: itemTitleDetail,
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      if (complaint['status'] == 0) {
                        return Text(
                          "Diajukan",
                          style: itemStatusRed,
                        );
                      } else if (complaint['status'] == 1) {
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
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  DateFormat('dd MMMM yyyy').format(complaint['date'].toDate()),
                  style: itemDateDetail,
                ),
                SizedBox(
                  height: 5.h,
                ),
                ReadMoreText(
                  complaint['desc'],
                  style: itemDescDetail,
                  textAlign: TextAlign.justify,
                  trimLines: 4,
                  colorClickableText: secondaryColor,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle: descMoreDetail,
                ),
                SizedBox(
                  height: 18.h,
                ),
                Text(
                  "Tanggapan:",
                  style: itemTitleDetail,
                ),
                SizedBox(
                  height: 12.h,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: db.collection("complaints").doc(complaint['id']).collection("respond").snapshots(),
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
                          physics: const NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs.map((respond) {
                            return Column(
                              children: [
                                Container(
                                  width: 301.w,
                                  padding: EdgeInsets.only(top: 6.h, right: 7.w, bottom: 6.h, left: 10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.r),
                                    boxShadow: [
                                      mainBoxShadow,
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Petugas :",
                                            style: responderDetail,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          SizedBox(
                                              width: 215.w,
                                              child: Text(
                                                respond['desc'],
                                                style: responderDescDetail,
                                                textAlign: TextAlign.justify,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('dd-MM-yy hh:mm').format(respond['date'].toDate()),
                                            style: responderDateDetail,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            );
                          }).toList());
                    }
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

AwesomeDialog buildWarningDeleteDialog(BuildContext context, String id, String title, String? email) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Perhatian!',
    titleTextStyle: popUpWarningTitle,
    desc: 'Apakah anda yakin ingin menghapus laporan?',
    descTextStyle: popUpWarningDesc,
    buttonsTextStyle: whiteOnBtnSmall,
    buttonsBorderRadius: BorderRadius.circular(6.r),
    btnOkColor: red,
    btnCancelColor: mainColor,
    showCloseIcon: false,
    btnOkText: 'Ya',
    btnCancelText: 'Tidak',
    btnOkOnPress: () {
      try {
        complaintDelete(id, title, email);
        Navigator.pop(context);
      } catch (e) {
        log(e.toString());
      }
    },
    btnCancelOnPress: () {},
  );
}
