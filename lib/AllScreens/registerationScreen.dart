import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/main.dart';

class RegisterationScreen extends StatelessWidget {
  // const LoginScreen({Key? key}) : super(key: key);
static const String idScreen ="register";
    TextEditingController nameTextEditing = TextEditingController();
    TextEditingController emailTextEditing = TextEditingController();
    TextEditingController phoneTextEditing = TextEditingController();
    TextEditingController passwordTextEditing = TextEditingController();
 
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
              Text("Register as a Rider",
                style:  TextStyle(fontSize: 24.0 , fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,),
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextFormField(
                      controller: nameTextEditing,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
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
                      controller: phoneTextEditing,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
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
                      controller: passwordTextEditing,
                      obscureText: true,
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
                        if (nameTextEditing.text.length < 4) {
                          displayToast("name must be atleast 3 charater.",context);
                        }
                        else if(!(emailTextEditing.text.contains("@"))){
                          displayToast("Email Address is not valid",context);
                        }
                        else if(phoneTextEditing.text.isEmpty){
                          displayToast("Phone Number  is mamdatory ",context);
                        }
                        else if(passwordTextEditing.text.length<4){
                          displayToast("Password be above 3 code",context);
                        }
                        else {
                          registerNewUser(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              FlatButton(child: Text(
                  "Already have an Account? Login Here"
              ),
                  onPressed: (){

                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                  })
            ],
          ),
        ),
      ),
    );
  }
FirebaseAuth auth = FirebaseAuth.instance;
Future<void> registerNewUser(BuildContext context) async {
  showDialog(context: context, barrierDismissible: false ,builder: (BuildContext ){
    return ProgressDialog(Message: "Registering, Please Wait...",);
  });
  final User? userCredential = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailTextEditing.text,
      password:passwordTextEditing.text
  ).catchError((error){
    Navigator.pop;
    displayToast("Error: "+ error.toString(), context);
  })
  ).user;
  if (userCredential != null){
  Map userDataMap = {
    "name": nameTextEditing.text.trim(),
    "email": emailTextEditing.text.trim(),
    "phone": phoneTextEditing.text.trim(),
  };
  usersref.child(userCredential.uid).set(userDataMap);
  displayToast("Congratulations, Your Account Has Been Created", context);
  Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
  else{

    Navigator.pop;
displayToast("New User account hass not been created", context);
  }

}

}

void displayToast(String massage, BuildContext context) {
  Fluttertoast.showToast(msg:massage );
}

