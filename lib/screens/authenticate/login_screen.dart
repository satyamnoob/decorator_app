import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth.dart';
import '../../services/loading.dart';
import '../../shared/constants.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleView;
  const LoginScreen({
    Key? key,
    required this.toggleView,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _formSubmission() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result = await _auth.signInUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      setState(() {
        _isLoading = false;
      });
      if(result is String) {
        showSnackbar(result);
      }
      else {
        print(result);
      }
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
                        TextFormField(
                          decoration: inputDecoration.copyWith(
                            hintText: 'Email',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.redAccent,
                            ),
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: inputDecoration.copyWith(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.redAccent,
                            ),
                          ),
                          obscureText: true,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a password";
                            } else if (value.length < 6) {
                              return "Enter a strong password";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: const Text('Register'),
                            ),
                          ],
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
