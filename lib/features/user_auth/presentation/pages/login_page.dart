import 'package:debug_it/features/user_auth/presentation/pages/api_music.dart';
import 'package:debug_it/features/user_auth/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'local_music.dart';
import 'package:debug_it/features/user_auth/presentation/pages/signup_page.dart';
import 'package:debug_it/features/user_auth/presentation/widgets/form_container_widget.dart';

import '../../firebase_auth_implementation/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  @override
  void dispose() {
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

      body:Padding(
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
                SizedBox(width: 10), // Add some space between the icon and text
                Text(
                  "Log In ",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey.shade200,
                    fontFamily: 'heading',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              height: 50, // Decrease the height of the container to make the text fields smaller
              child: FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
                textStyle: TextStyle(color: Colors.white, fontFamily: 'text'), // Add textStyle for the email field
              ),
            ),

            SizedBox(height: 15), // Add some spacing between text fields

            Container(
              height: 50, // Decrease the height of the container to make the text fields smaller
              child: FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
                textStyle: TextStyle(color: Colors.white, fontFamily: 'text'), // Add textStyle for the password field
              ),
            ),

            SizedBox(height: 20,),
            Center(
              child: GestureDetector(
                onTap: _signIn,
                child: Container(
                  width: 150,

                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontFamily: 'subheading', fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),


            // Display error message if it's not empty
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.orangeAccent,fontFamily: 'text' ),
              ),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?", style: TextStyle(fontSize: 15,color: Colors.grey.shade300,fontFamily: 'text'),),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignUpPage()), (route) => false);
                  },
                  child: Text("Sign Up",style: TextStyle(fontSize: 15,color: Color(0xFFA27FEA),fontFamily: 'text'),),
                )
              ],)
          ],
        ),
      ),
    );
  }
  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signInWithEmailandPassword(email, password);

      if (user == null) {
        setState(() {
          _errorMessage = "Incorrect credentials. Please try again.";
        });
      } else {
        print("User signed in successfully");
        // Navigate to the ApiPage with userID parameter
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: user),
          ),
        );
      }
    } catch (error) {
      setState(() {
        // Display specific error messages to the user
        if (error is FirebaseAuthException) {
          if (error.code == "user-not-found") {
            _errorMessage = "User with this email does not exist.";
          } else {
            _errorMessage = _mapFirebaseErrorToMessage(error.code);
          }
        } else {
          _errorMessage = "An error occurred: $error";
        }
      });
      print("An error occurred: $error");
    }
  }


  // Map Firebase error codes to user-friendly messages
  String _mapFirebaseErrorToMessage(String errorCode) {
    switch (errorCode) {
      case "user-not-found":
        return "Email does not exist in the database. Please check your email.";
      case "wrong-password":
        return "Wrong password. Please try again.";
    // Add more cases for other Firebase error codes as needed
      default:
        return "An error occurred: $errorCode";
    }
  }

}