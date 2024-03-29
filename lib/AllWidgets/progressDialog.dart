import 'package:flutter/material.dart';


  class ProgressDialog extends StatelessWidget {
  String Message;

  // ignore: non_constant_identifier_names
  ProgressDialog({required this.Message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.yellow,
      child: Container(
        margin: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          ),
        child: Padding(
          padding:  EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),

              SizedBox(width: 26.0,),
              Text(Message,
              style: TextStyle(color: Colors.black,fontSize: 10.0),)
            ],
          ),
        ),
        ),
      );

  }
}
