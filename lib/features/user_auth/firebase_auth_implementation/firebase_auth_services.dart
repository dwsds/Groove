import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices{

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailandPassword(String email, String password) async{
    try{
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return null;
  }

  Future<User?> signInWithEmailandPassword(String email, String password) async{
    try{
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch  (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return null;
  }


}