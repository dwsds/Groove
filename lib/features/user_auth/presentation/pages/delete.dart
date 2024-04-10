import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/presentation/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> _firebaseUser = Rx<User?>(null);
  String get user => _firebaseUser.value?.email ?? "";

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  void deleteAcc(String email, String pass, {VoidCallback? onDeleted}) async {
    User? user = _auth.currentUser;
    if (user != null) {
      AuthCredential credential =
      EmailAuthProvider.credential(email: email, password: pass);

      try {
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        onDeleted?.call(); // Call the callback function if provided
        Get.offAll(LoginPage());
        Get.snackbar("Success", "User Account deleted successfully",
            backgroundColor: Colors.green);
      } catch (error) {
        Get.snackbar("Error", "Failed to delete account",
            backgroundColor: Colors.red);
      }
    }
  }
}
class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseController _firebaseController = Get.put(FirebaseController());
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isAccountDeleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _isAccountDeleted
                ? Text(
              'Account deleted successfully!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18.0,
              ),
            )
                : Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    _firebaseController.deleteAcc(
                      _usernameController.text,
                      _passwordController.text,
                      onDeleted: () {
                        setState(() {
                          _isAccountDeleted = true;
                        });
                      },
                    );
                  },
                  child: Text('Delete Account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}