import 'package:flutter/material.dart';
import '../service/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: const Text('Food ReStore')
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.blue.withAlpha(50),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  //Greet Message
                  child: FutureBuilder(
                    future: Provider.of(context)!.auth.getCurrentUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return
                          getUsername("${snapshot.data}");
                      } else {
                        return Text("Welcome back, Guest");
                      }
                    },
                  ),
                ),
              ),
            ),
            //App Logo
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue.withAlpha(50),
                child: Image.asset(
                  'assets/images/logo.png',
                  scale: 3.2,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            //Menu Buttons
            Expanded(
              flex: 8,
              child: GridView.count(
                primary: false,
                crossAxisCount: 2,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  //Request
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed('/request');
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          color: Colors.blueAccent,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/request-icon.png',
                            scale: 5,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'New Request',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Activity
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(
                        '/activity',
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          color: Colors.lightBlueAccent,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/activity-icon.png',
                            scale: 5,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'Activity Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //History
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(
                        '/history',
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          color: Colors.lightBlueAccent,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/history-icon.png',
                            scale: 5,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'Past Request',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Profile
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(
                        '/profile',
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          color: Colors.lightBlue,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/profile-icon.png',
                            scale: 5,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: const EdgeInsets.all(15.0),
                          child: const Text(
                            'My Profile',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  //Get Username to display
  Widget getUsername(String data) =>
      Text(
        'Welcome back, ' + data,
        style: TextStyle(fontSize: 15),
      );
}

