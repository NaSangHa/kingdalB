import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project05/constants.dart';
import 'package:project05/Login/login_screen.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '37707a4c2d84f614db50305e6431071d');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Login(),
    );
  }
}

// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => Main()), 
// );

// boxShadow: [
//   BoxShadow(
//     color: Colors.grey.withOpacity(0.3),
//     spreadRadius: 1,
//     blurRadius: 5,
//     offset: Offset(0, 8), // changes position of shadow
//   ),
// ],