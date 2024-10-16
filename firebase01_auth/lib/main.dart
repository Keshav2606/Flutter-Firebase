import 'package:firebase01_auth/firebase_options.dart';
import 'package:firebase01_auth/pages/home_page.dart';
import 'package:firebase01_auth/pages/login_page.dart';
// import 'package:firebase01_auth/pages/login_page.dart';
// import 'package:firebase01_auth/pages/phone_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();

    getLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }

  void getLoggedInStatus() async {
    var pref = await SharedPreferences.getInstance();

    isLoggedIn = pref.getBool('isLoggedIn')!;
  }
}
