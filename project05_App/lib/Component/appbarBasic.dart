import 'package:flutter/material.dart';

AppBar AppbarBasic(BuildContext context, String title, ) {
  return AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        title: Text(title, style: TextStyle(fontSize: 16,),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print('뒤로가기');
            Navigator.pop(context);
          },
        ),
  );
}