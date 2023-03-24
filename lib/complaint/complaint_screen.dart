import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:masy/services/complaint.dart';
import 'package:masy/shared/style.dart';
import 'package:masy/widget/boxshadow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Timestamp? _complaintDate;
  String imageUrl = '';
  bool _isImageUploaded = false;
  late File imageFile;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
            "Pengaduan",
            style: appBarTitle,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Judul",
                    style: inputLabelComplaint,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 280.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: HexColor('#CECECE')),
                        ),
                      ),
                      SizedBox(
                        height: 55.h,
                        width: 280.w,
                        child: TextFormField(
                          controller: _titleController,
                          style: inputComplaint,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Isi Judul';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.h,
                            ),
                            hintText: "ex: Jalan Berlubang",
                            hintStyle: hintComplaint,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Tanggal Pengaduan",
                    style: inputLabelComplaint,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 280.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: HexColor('#CECECE')),
                        ),
                      ),
                      SizedBox(
                        height: 55.h,
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: inputComplaint,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Isi Tanggal Pengaduan';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.h,
                            ),
                            hintText: "ex: dd-MM-yyyy",
                            hintStyle: hintComplaint,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 280.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                log(pickedDate.toString());
                                final complaintDate = Timestamp.fromDate(pickedDate);
                                String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                                log(formattedDate);

                                setState(() {
                                  _complaintDate = complaintDate;
                                  _dateController.text = formattedDate;
                                });
                              } else {
                                log("Date is not selected");
                              }
                            },
                            icon: const Icon(
                              FontAwesome.calendar,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Deskripsi",
                    style: inputLabelComplaint,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 280.w,
                        height: 130.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: HexColor('#CECECE')),
                        ),
                      ),
                      SizedBox(
                        height: 145.h,
                        width: 280.w,
                        child: TextFormField(
                          controller: _descController,
                          maxLines: 100,
                          style: inputComplaint,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Isi Deskripsi';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.h,
                            ),
                            hintText:
                                "ex: Lokasi di Jl. Moh Toha, terdapat\njalan berlubang yang dapat membahayakan\npengguna jalan raya...",
                            hintStyle: hintComplaint,
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Bukti Foto",
                    style: inputLabelComplaint,
                  ),
                  _isImageUploaded
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.r),
                                child: Image.file(
                                  imageFile,
                                  height: 130.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  SizedBox(
                    height: 6.h,
                  ),
                  Container(
                    width: 135.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: HexColor('#CECECE')),
                      borderRadius: BorderRadius.circular(5.r),
                      boxShadow: [mainBoxShadow],
                    ),
                    child: TextButton(
                      onPressed: () async {
                        //1. pick image
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                        log('${file?.path}');

                        if (file == null) return;

                        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

                        //upload image to storage
                        Reference referenceRoot = FirebaseStorage.instance.ref();
                        Reference referenceDir = referenceRoot.child('complaints');
                        Reference referenceImageUpload = referenceDir.child(fileName);
                        try {
                          await referenceImageUpload.putFile(File(file.path));
                          imageUrl = await referenceImageUpload.getDownloadURL();
                          log('image URL ::: $imageUrl');
                          setState(() {
                            _isImageUploaded = true;
                            imageFile = File(file.path);
                          });
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_rounded,
                            color: black,
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            _isImageUploaded ? 'Ubah' : 'Unggah',
                            style: uploadBtn,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  imageUrl.isEmpty
                      ? Text(
                          "Sertakan bukti foto",
                          style: subtitleImage,
                        )
                      : const SizedBox(),
                  _isImageUploaded
                      ? SizedBox(
                          height: 20.h,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 20.w),
          width: 1.sw,
          height: 74.h,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(offset: const Offset(0, -2), color: Colors.black.withOpacity(0.15), blurRadius: 10, spreadRadius: 0),
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_isImageUploaded != false && _complaintDate != null) {
                    try {
                      complaintAdd(_titleController.text, _complaintDate!, _descController.text, imageUrl, 0, uid);
                      _titleController.text = "";
                      _dateController.text = "";
                      _descController.text = "";
                      _isImageUploaded = false;
                      buildSuccessSubmitDialog(context).show();
                    } catch (e) {
                      log(e.toString());
                    }
                  } else {}
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(secondaryColor),
              ),
              child: Text(
                "Submit",
                style: whiteOnBtn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

AwesomeDialog buildSuccessSubmitDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Berhasil mengajukan pengaduan!',
    titleTextStyle: popUpWarningTitle,
    desc: 'Kamu sudah berhasil mengajukan pengaduanmu',
    descTextStyle: popUpWarningDesc,
    buttonsTextStyle: whiteOnBtnSmall,
    buttonsBorderRadius: BorderRadius.circular(6.r),
    btnOkColor: mainColor,
    showCloseIcon: false,
    btnOkText: 'Ok',
    btnOkOnPress: () {
      // Navigator.pushNamedAndRemoveUntil(context, '/botnavbar', (route) => false);
      Navigator.pop(context);
    },
  );
}
