import 'package:firebase01_auth/UIHelper/ui_helper.dart';
import 'package:firebase01_auth/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  TextEditingController phoneController = TextEditingController();

  verifyPhone(String phone) async {
    if (phone.length != 10) {
      return UIHelper.customDialogBox(
          context, "Enter a valid Phone No. to verify");
    } else {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 $phone',
        verificationCompleted: (PhoneAuthCredential credential) async {
          FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        },
        verificationFailed: (FirebaseAuthException e) {
          UIHelper.customDialogBox(context, 'Phone No. verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          TextEditingController otpController = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Column(
                    children: [
                      const Text('Enter OTP sent to your Mobile'),
                      const SizedBox(
                        height: 11,
                      ),
                      TextFormField(
                        controller: otpController,
                        decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16))),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Verify OTP'))
                    ],
                  ),
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Auth'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  label: const Text('Phone No.'),
                  hintText: 'Enter your Phone No.',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    verifyPhone(phoneController.text);
                  },
                  child: const Text('Verify Phone'))
            ],
          ),
        ),
      ),
    );
  }
}
