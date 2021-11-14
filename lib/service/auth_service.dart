import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User? user) => user!.uid,
  );

  // Get User UID
  Future<String> getCurrentUID() async {
    return _firebaseAuth.currentUser!.uid;
  }
  // Get User Name
  Future getCurrentUsername() async {
    return _firebaseAuth.currentUser!.displayName;
  }
  // Get User Email
  Future getCurrentEmail() async {
    return _firebaseAuth.currentUser!.email;
  }
  // Get Creation Date
  Future getCreatedDate() async {
    var date = _firebaseAuth.currentUser!.metadata.creationTime;
    return DateFormat('dd/MM/yyyy h:m:s').format(date!);
  }

  // Sign up
  Future<String> createUserWithEmailAndPassword(String email, String name, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    // Update user's display name
    _firebaseAuth.currentUser!.updateDisplayName(name);
    await _firebaseAuth.currentUser!.reload();

    return _firebaseAuth.currentUser!.uid;
  }

  // Sign in
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _firebaseAuth.currentUser!.uid;
  }

  // Sign out
  signOut(){
    return _firebaseAuth.signOut();
  }
}

// Form validator
class EmailValidator {
  static String? validate(String? value){
    if(value!.isEmpty){
      return "Email can't be empty";
    }
    return null;
  }
}
class NameValidator {
  static String? validate(String? value){
    if(value!.isEmpty) {
      return "Username can't be empty";
    }
    if(value.length < 2) {
      return "Username must be at least 2 characters long";
    }
    if(value.length > 30) {
      return "Username must be less than 30 characters long";
    }
    return null;
  }
}
class PasswordValidator {
  static String? validate(String? value){
    if(value!.isEmpty){
      return "Password can't be empty";
    }
    if(value.length < 4) {
      return "Password must be at least 4 characters long";
    }
    return null;
  }
}