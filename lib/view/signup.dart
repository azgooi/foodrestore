import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/route.dart';
import '../service/auth_service.dart';

class SignupPage extends StatefulWidget {

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final formKey = GlobalKey<FormState>();
  late String _email, _name, _password;

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
                   'SIGN UP',
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
                   'Create an Account here',
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
                   height: 15,
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
                       'REGISTER',
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
                       '''Already have an account?''',
                       style: TextStyle(
                         color: Colors.black.withOpacity(0.5),
                         fontSize: 16.0,
                       ),
                     ),
                     TextButton(
                       onPressed: (){
                         Navigator.of(context).pushNamed('/login');
                       },
                       child: Text('Sign In now'),
                     )
                   ],
                 )
               ],
             ),
           ),
        ),
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
          decoration: buildSignUpInputDecoration('Email Address', Icons.email),
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
        keyboardType: TextInputType.name,
        validator: NameValidator.validate,
        decoration: buildSignUpInputDecoration('Username', Icons.person),
        onSaved: (value) => _name = value!,
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
        decoration: buildSignUpInputDecoration('Password', Icons.lock),
        onSaved: (value) => _password = value!,
      )
    );
    textFields.add(
      SizedBox(
        height: 20,
      )
    );

    return textFields;
  }

  //Decoration of the field
  InputDecoration buildSignUpInputDecoration(String label, IconData icon) {
    return InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
    );
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

  //Create account after validation
  void submit() async {
    if(validate()) {
      try {
        final auth = Provider.of(context)!.auth;
        await auth.createUserWithEmailAndPassword(_email, _name, _password);
        Navigator.of(context).pushNamed('/');
      } catch (e) {
        print (e);
      }
    }
  }

}
