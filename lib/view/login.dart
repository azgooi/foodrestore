import 'package:flutter/material.dart';
import '../service/route.dart';
import '../service/auth_service.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 50,
                    color: Colors.blue
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Welcome to Food ReStore',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent.withOpacity(0.8),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      submit();
                    },
                    color: Colors.blue,
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.black,
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '''Don't have an account?''',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text('Sign Up Now'),
                    )
                  ],
                )
              ],
            )
          )
        )
      )
    );
  }

  //Build the form fields
  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    textFields.add(
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: EmailValidator.validate,
        decoration: InputDecoration(
          labelText: 'Email Address',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.email),
        ),
        onSaved: (value) => _email = value!,
      )
    );
    textFields.add(
      SizedBox(
        height: 20,
      )
    );
    textFields.add(
      TextFormField(
        keyboardType: TextInputType.visiblePassword,
        validator: PasswordValidator.validate,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: Icon(Icons.remove_red_eye),
        ),
        onSaved: (value) => _password = value!,
      )
    );

    return textFields;
  }

  //Form validator
  bool validate() {
    final form = formKey.currentState;
    form!.save();
    if(form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  //Login account after validation
  void submit() async {
    if(validate()) {
      try {
        final auth = Provider.of(context)!.auth;
        await auth.signInWithEmailAndPassword(_email, _password);
        Navigator.of(context).pushNamed('/');
      } catch (e) {
        print(e);
      }
    }
  }
}
