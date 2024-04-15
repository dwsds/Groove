import 'package:debug_it/features/user_auth/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase_auth_implementation/firebase_auth_services.dart';
import 'login_page.dart';
import 'package:debug_it/features/user_auth/presentation/widgets/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 30,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.orangeAccent,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey.shade200,
                    fontFamily: 'heading',
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              child: FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              child: FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 50,
              child: FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
            ),

            SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontFamily: 'subheading',fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            // Display error message if it's not empty
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.orangeAccent,fontFamily: 'text' ),
              ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 15,color: Colors.grey.shade300,fontFamily: 'text'),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Color(0xFFA27FEA),fontFamily: 'text',fontSize: 17),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signUpWithEmailandPassword(email, password);

      if (user == null) {
        setState(() {
          _errorMessage = "User creation failed. Please try again.";
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: user),
          ),
        );
      }
    } catch (error) {
      setState(() {
        if (error is FirebaseAuthException) {
          _errorMessage = _mapFirebaseErrorToMessage(error.code);
        } else {
          _errorMessage = "An error occurred: $error";
        }
      });
    }
  }

  String _mapFirebaseErrorToMessage(String errorCode) {
    switch (errorCode) {
      case "email-already-in-use":
        return "Email is already in use. Please use a different email.";
      case "weak-password":
        return "Password is too weak. Please use a stronger password.";
      default:
        return "An error occurred: $errorCode";
    }
  }
}