import 'package:firebase01_auth/UIHelper/ui_helper.dart';
import 'package:firebase01_auth/pages/home_page.dart';
import 'package:firebase01_auth/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;

  login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return UIHelper.customDialogBox(context, "Enter all Required fields");
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
              
          var pref = await SharedPreferences.getInstance();
          isLoggedIn = true;
          pref.setBool('isLoggedIn', isLoggedIn);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      } on FirebaseAuthException catch (ex) {
        return UIHelper.customDialogBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 25),
          child: Container(
            width: 500,
            height: 500,
            padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 20),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 51,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        label: const Text('Email'),
                        hintText: 'Enter your Email id',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email can't be Empty";
                      } else {
                        if (value.contains('@')) {
                          return null;
                        } else {
                          return "Enter a valid Email Id";
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter your Password',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password can't be Empty";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 21,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          login(emailController.text, passwordController.text);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      child: const Text("Don't have an account? Signup"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
