import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//Root of the application
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Run auth service on root
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food ReStore',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}