 import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/loginScreen.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';
import 'package:rider_app/AllScreens/registerationScreen.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/appData.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  );
  runApp(MyApp());
}
 // ignore: deprecated_member_use
 DatabaseReference usersref = FirebaseDatabase.instance.reference().child("users");
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        title: 'Cargo Uber',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MainScreen.idScreen,
        routes: {
          RegisterationScreen.idScreen: (context)=> RegisterationScreen(),
          LoginScreen.idScreen: (context)=> LoginScreen(),
          MainScreen.idScreen: (context)=> MainScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


