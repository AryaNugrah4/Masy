import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masy/admin/screen/panel/panel_screen.dart';
import 'package:masy/complaint/complaint_screen.dart';
import 'package:masy/history/history_screen.dart';
import 'package:masy/home/home_screen.dart';
import 'package:masy/login/login_screen.dart';
import 'package:masy/login/signup_screen.dart';
import 'package:masy/login/splash_screen.dart';
import 'package:masy/widget/botnavbar.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MasyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MasyApp extends StatefulWidget {
  const MasyApp({Key? key}) : super(key: key);

  @override
  State<MasyApp> createState() => _MasyAppState();
}

class _MasyAppState extends State<MasyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          routes: <String, WidgetBuilder>{
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/botnavbar': (context) => const BotNavBar(),
            '/home': (context) => const HomeScreen(),
            '/complaint': (context) => const ComplaintScreen(),
            '/history': (context) => const HistoryScreen(),
            '/menu-panel': (context) => const PanelScreen(),
          },
        );
      },
    );
  }
}
