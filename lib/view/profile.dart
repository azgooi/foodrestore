import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../service/route.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Center(
                child: Image.asset(
                  'assets/images/profile-user.png',
                  alignment: Alignment.center,
                  scale: 3.2,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            FutureBuilder(
                future: Provider.of(context)!.auth.getCurrentUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return
                      buildUserInfoDisplay("Name", "${snapshot.data}");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
            ),
            SizedBox(
              height: 5,
            ),
            FutureBuilder(
              future: Provider.of(context)!.auth.getCurrentEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return
                    buildUserInfoDisplay("E-mail", "${snapshot.data}");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(
              height: 5,
            ),
            FutureBuilder(
              future: Provider.of(context)!.auth.getCreatedDate(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return
                    buildUserInfoDisplay("Created", "${snapshot.data}");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.redAccent,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () async{
                try{
                  AuthService auth = Provider.of(context)!.auth;
                  await auth.signOut();
                  Navigator.of(context).pushNamed('/');
                } catch (e){
                  print (e);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'SIGN OUT',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  //Display User Info Widget
  Widget buildUserInfoDisplay(String title, String data) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          )
                      )
                  ),
                  child: Center(
                          child: Text(
                            data,
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                            ),
                          ),
                        )
              )
            ],
          )
      );
}