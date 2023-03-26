import 'package:flutter/material.dart';
import 'package:masy/admin/screen/complaint_list/complaint_list_screen.dart';
import 'package:masy/admin/screen/dashboard/dashboard_screen.dart';
import 'package:masy/admin/screen/history_list/history_list_screen.dart';
import 'package:masy/admin/screen/menu/menu_screen.dart';
import 'package:masy/admin/screen/officer_list/officer_list_screen.dart';
import 'package:masy/shared/style.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PanelScreen extends StatefulWidget {
  const PanelScreen({Key? key}) : super(key: key);

  @override
  State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: MenuScreen(
        setIndex: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      mainScreen: currentScreen(),
      menuBackgroundColor: mainColor2,
      borderRadius: 20.5,
      angle: 0.0,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.fastOutSlowIn,
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return const DashboardScreen(title: "Dashboard");
      case 1:
        return const ComplaintListScreen();
      case 2:
        return const OfficerListScreen();
      case 3:
        return const HistoryListScreen();
      default:
        return const DashboardScreen(title: "Dashboard");
    }
  }
}
