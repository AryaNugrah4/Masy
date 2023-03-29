import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masy/admin/screen/history_list/history_add_screen.dart';
import 'package:masy/admin/screen/menu/menu_widget.dart';
import 'package:masy/shared/style.dart';
import 'package:open_file/open_file.dart';
import 'package:shimmer/shimmer.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({Key? key}) : super(key: key);

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  bool _isLoading = true;
  int _totalHistorys = 0;
  final db = FirebaseFirestore.instance;

  Future countDocumentsInCollection() async {
    QuerySnapshot querySnapshot = await db.collection('history').get();
    int count = querySnapshot.size;
    setState(() {
      _totalHistorys = count;
      _isLoading = false;
    });
  }

  Future exportHistoryToExcel(context) async {
    PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted) return;

    Directory? directory = await getExternalStorageDirectory();
    String fileName = "historyLog.xlsx";
    String filePath = "${directory!.path}/$fileName";

    try {
      QuerySnapshot querySnapshot = await db.collection('history').get();
      var workbook = Excel.createExcel();
      var sheet = workbook['Sheet1'];
      // Add headers to worksheet
      sheet.appendRow(['ID', 'Email', 'Log']);
      // Add data to worksheet
      for (var document in querySnapshot.docs) {
        dynamic documentData = document.data();
        var row = [
          documentData!['id'].toString(),
          documentData['email'].toString(),
          documentData['log'].toString(),
        ];
        sheet.appendRow(row);
      }
      // Save the file
      File file = File(filePath);
      file.writeAsBytesSync(workbook.save()!);
      // awesome dialog file saved successfully
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: 'Berhasil mendownload file!',
        titleTextStyle: popUpWarningTitle,
        desc: 'File tersimpan di folder Download di perangkat anda.',
        descTextStyle: popUpWarningDesc,
        buttonsTextStyle: whiteOnBtnSmall,
        buttonsBorderRadius: BorderRadius.circular(6.r),
        btnOkColor: mainColor,
        showCloseIcon: false,
        btnCancelColor: mainColor,
        btnCancelText: 'Buka File',
        btnCancelOnPress: () async {
          final result = await OpenFile.open(filePath);
          if (result.type == ResultType.noAppToOpen ||
              result.type == ResultType.fileNotFound ||
              result.type == ResultType.permissionDenied) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.bottomSlide,
              title: 'Gagal membuka file!',
              desc: result.message,
              btnOkOnPress: () {},
              btnOkColor: mainColor,
              btnOkText: 'Tutup',
              buttonsBorderRadius: BorderRadius.circular(6.r),
            ).show();
          }
        },
        btnOkText: 'Kembali Ke Home',
        btnOkOnPress: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/menu-panel', (route) => false);
        },
      ).show();
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    countDocumentsInCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accent,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "History List",
          style: appBarTitleWhite,
        ),
        centerTitle: true,
        elevation: 0,
        leading: const MenuWidget(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 20.h, left: 30.w, right: 21.w, bottom: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                          ),
                        )
                      : Text(
                          "$_totalHistorys Histories",
                          style: officerCount,
                        ),
                  TextButton(
                      onPressed: () async {
                        await exportHistoryToExcel(context);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent, elevation: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.file_open_rounded,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Export",
                            style: forgotPassword,
                          ),
                        ],
                      )),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                "You can manage Histories here",
                style: officerTitleBig,
              ),
              SizedBox(height: 10.h),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const HistoryAddScreen()));
              //   },
              //   child: Container(
              //     width: 306.w,
              //     height: 50.h,
              //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              //     decoration: BoxDecoration(
              //       color: mainColor.withOpacity(0.05),
              //       borderRadius: BorderRadius.circular(7.r),
              //     ),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Container(
              //               width: 40.w,
              //               height: 40.h,
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10.r),
              //                 color: secondaryColor.withOpacity(0.50),
              //               ),
              //               child: Center(
              //                 child: Icon(
              //                   Icons.add_rounded,
              //                   color: accent,
              //                 ),
              //               ),
              //             ),
              //             SizedBox(
              //               width: 10.w,
              //             ),
              //             Text(
              //               'Add a new History',
              //               style: officerAdd,
              //             ),
              //           ],
              //         ),
              //         Icon(
              //           Icons.arrow_forward_ios_rounded,
              //           color: secondaryColor,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // SizedBox(height: 35.h),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection('history').snapshots(),
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
                      children: snapshot.data!.docs.map((data) {
                        return Column(
                          children: [
                            SizedBox(
                              width: 306.w,
                              height: 70.h,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(4.r)),
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(13.r),
                                            child: Image.asset(
                                              "assets/default.png",
                                              width: 50.w,
                                              height: 50.h,
                                              fit: BoxFit.cover,
                                            )),
                                        SizedBox(
                                          width: 7.w,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // user['fullname'],
                                              data['email'],
                                              style: officerName,
                                            ),
                                            SizedBox(
                                              width: 200.w,
                                              child: Text(
                                                // user['role'],
                                                // "Pengaduan 'Jalan Bolong' baru saja ditambahkan",
                                                data['log'],
                                                style: officerRole,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoryAddScreen(
                                                        isEdit: true,
                                                        log: data['log'],
                                                        email: data['email'],
                                                        logId: data.id,
                                                      )));

                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => HistoryEditScreen(
                                          //             users: Users.fromJson(user.data() as Map<String, dynamic>))));
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: mainColor,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            )
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const HistoryAddScreen()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
          width: 1.sw,
          height: 72.h,
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: secondaryColor.withOpacity(0.50),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: accent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Add a new History',
                    style: officerAdd,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: secondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
