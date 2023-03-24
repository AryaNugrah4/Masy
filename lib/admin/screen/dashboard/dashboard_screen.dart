import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masy/admin/screen/dashboard/chart_complaints.dart';
import 'package:masy/admin/screen/menu/menu_widget.dart';
import 'package:masy/shared/style.dart';

class DashboardScreen extends StatefulWidget {
  final String title;
  const DashboardScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double diajukanLength = 0;
  double diprosesLength = 0;
  double selesaiLength = 0;
  String diajukanPercentage = '0';
  String diprosesPercentage = '0';
  String selesaiPercentage = '0';
  @override
  void initState() {
    super.initState();
    getComplaints();
  }

  Future<void> getComplaints() async {
    try {
      var checkComplaints = await FirebaseFirestore.instance.collection('complaints').get();
      var complaints = checkComplaints.docs;
      for (var complaint in complaints) {
        if (complaint['status'] == 0) {
          diajukanLength++;
        } else if (complaint['status'] == 1) {
          diprosesLength++;
        } else if (complaint['status'] == 2) {
          selesaiLength++;
        }
      }
      setState(() {
        diajukanPercentage = (diajukanLength / complaints.length * 100).toStringAsFixed(0);
        diprosesPercentage = (diprosesLength / complaints.length * 100).toStringAsFixed(0);
        selesaiPercentage = (selesaiLength / complaints.length * 100).toStringAsFixed(0);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: accent,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
          leading: const MenuWidget(),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Complaints',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ChartComplaints(
                diajukanLength: diajukanLength,
                diprosesLength: diprosesLength,
                selesaiLength: selesaiLength,
                diajukanPercentage: diajukanPercentage,
                diprosesPercentage: diprosesPercentage,
                selesaiPercentage: selesaiPercentage,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notes', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(
                      'Total Pengaduan : ${(diajukanLength + diprosesLength + selesaiLength).toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Total Pengaduan Diajukan : ${diajukanLength.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Total Pengaduan Diproses : ${diprosesLength.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Total Pengaduan Selesai : ${selesaiLength.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            ],
          ),
        )

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const Text('Dashboard'),
        //     TextButton(
        //         onPressed: () {
        //           FirebaseAuth.instance.signOut();
        //           Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        //         },
        //         child: const Text('Logout')),
        //   ],
        // ),

        );
  }
}
