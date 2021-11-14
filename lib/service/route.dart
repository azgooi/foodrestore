import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../view/signup.dart';
import '../view/login.dart';
import '../view/activity.dart';
import '../view/history.dart';
import '../view/profile.dart';
import '../view/new_request/request.dart';
import '../view/homepage.dart';
import '../models/Food.dart';

// Controller for home if user signed in
class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context)!.auth;
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            final bool signedIn = snapshot.hasData;
            //If signed in, homepage; else login page
            return signedIn ? HomePage() : LoginPage();
          }
          return CircularProgressIndicator();
        }
    );
  }
}

class Provider extends InheritedWidget {
  final AuthService auth;
  Provider({Key? key, required Widget child, required this.auth,}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Provider>();
}

// Generates route for the app
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // New Food object
    final newFood = new Food('','','','','',DateTime.now(),'','','','');

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeController());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupPage());
      case '/request':
        return MaterialPageRoute(builder: (_) => RequestPage(food: newFood));
      case '/activity':
        return MaterialPageRoute(builder: (_) => ActivityPage());
      case '/history':
        return MaterialPageRoute(builder: (_) => HistoryPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return _errorRoute();
    }
  }

  //Error Route Page
  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error Page'),
        ),
        body: Center(
          child: Text(
            'ERROR: PAGE NOT FOUND',
            style: TextStyle(fontSize: 50),
          ),
        ),
      );
    });
  }
}