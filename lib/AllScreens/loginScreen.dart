import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/registerationScreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';

import '../main.dart';
import 'mainscreen.dart';

class LoginScreen extends StatelessWidget {
 // const LoginScreen({Key? key}) : super(key: key);]\
  TextEditingController emailTextEditing = TextEditingController();
  TextEditingController passwordTextEditing = TextEditingController();
  static const String idScreen ="login";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0,),
              Image(image: AssetImage("images/logo.png"),
                width: 350.0,
                height: 350.0,
                alignment: Alignment.center ,
              ),
              SizedBox(height: 1.0,),
              Text("Login as a Rider",
              style:  TextStyle(fontSize: 24.0 , fontFamily: "Brand Bold"),
              textAlign: TextAlign.center,),
          Padding(padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 1.0,),
                TextFormField(
                  controller: emailTextEditing,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0
                      )
                  ),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 1.0,),
                TextFormField(
                  obscureText: true,
                  controller: passwordTextEditing,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0
                      )
                  ),
                  style: TextStyle(fontSize: 14),
                ),

                SizedBox(height: 10.0,),
                RaisedButton( 
                  color: Colors.yellow,
                  textColor: Colors.white,
                  child: Container(
                    height: 50,
                     child: Center(
                       child: Text(
                         "Login",
                         style: TextStyle(fontSize: 18.0,fontFamily: "Brand Blod"),
                       ),
                     ),           
                  ),
           shape: new RoundedRectangleBorder(
             borderRadius: new BorderRadius.circular(24.0)

           ),
                onPressed: (){
                  if (!(emailTextEditing.text.contains("@"))) {
                    displayToast("Email Address is not valid",context);
                  }
                  else if(passwordTextEditing.text.isEmpty){
                    displayToast("Password  is mamdatory ",context);
                  }
                  else {
                    loginAndAuthenticateUser(context);
                  }
                },
                )
              ],
            ),
          ),
    FlatButton(child: Text(
          "Do not have an Account? Register Here"
    ),
            onPressed: (){
      Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
 })
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> loginAndAuthenticateUser(BuildContext context) async {
    showDialog(context: context, barrierDismissible: false ,builder: (BuildContext ){
      return ProgressDialog(Message: "Authenticating, Please Wait...",);
    });
    final User? userCredential = (await auth.signInWithEmailAndPassword(
        email: emailTextEditing.text,
        password:passwordTextEditing.text
    ).catchError((error){
      Navigator.pop;
      displayToast("Error: "+ error.toString(), context);
    })
    ).user;
    if (userCredential != null){
      usersref.child(userCredential.uid).once().then((snap) async {
        if(snap != null){

          displayToast("You are logged-in Now", context);
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
        }
        else{

          Navigator.pop;
          auth.signOut();
          displayToast("No record exist for this user. Please create new account", context);
        }
      });

    }
    else{

      Navigator.pop;
      displayToast("Error Occured, can not be sign in ", context);
    }

  }

}

