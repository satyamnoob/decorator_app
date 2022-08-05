import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth.dart';
import '../../services/loading.dart';
import '../../shared/constants.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isOtp = false;
  String? _verificationId = "";

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _formSubmission() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneController.text}',
        verificationCompleted: (phoneAuthCredential) async {
          _verificationId = phoneAuthCredential.verificationId;
          await _auth.signInWithCredential(phoneAuthCredential);
          print("In phone verification completed");
        },
        verificationFailed: (error) async {
          setState(() {
            _isLoading = false;
            _isOtp = true;
          });
          print(error.toString());
        },
        codeSent: (verificationId, forceResendingToken) async {
          setState(() {
            _isLoading = false;
            _isOtp = true;
          });
          try {
            print("In Code Sent");
            final phoneAuthCredential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: _otpController.text.trim(),
            );
            UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);
            print(userCredential.user);
          } catch (e) {
            print(e.toString());
          }
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          setState(() {
            _isOtp = false;
            _isLoading = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Loading()
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "DE",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 60,
                        ),
                      ),
                      Text(
                        "CO",
                        style: GoogleFonts.sourceSansPro(
                          fontSize: 60,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        !_isOtp
                            ? TextFormField(
                                decoration: inputDecoration.copyWith(
                                  hintText: 'Phone Number',
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter phone number";
                                  } else if (!RegExp(r"^(?:[+0]9)?[0-9]{10}$")
                                      .hasMatch(value)) {
                                    return "Enter a valid phone number";
                                  } else {
                                    return null;
                                  }
                                },
                              )
                            : TextFormField(
                                decoration: inputDecoration.copyWith(
                                  hintText: 'Otp',
                                  prefixIcon: const Icon(
                                    Icons.numbers,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter otp";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        !_isOtp
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.redAccent),
                                  ),
                                  onPressed: () {
                                    _formSubmission();
                                  },
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.redAccent),
                                  ),
                                  onPressed: () async {
                                    _formSubmission();
                                  },
                                  child: Text(
                                    'Verify Otp',
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
