import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// const kPrimaryColor = Color.fromRGBO(223, 48, 48, 1);
const kPrimaryColor = Color.fromRGBO(239, 108, 0, 1);
const kPrimaryColorAlpha = Color.fromRGBO(239, 108, 0, 0.5);
const kStarColor = Color.fromRGBO(255, 193, 7, 1);

// const imgIPAddress = "http://192.168.0.7:8081/upload/";
const imgIPAddress = "http://192.168.0.35:8081/upload/";

const IPHome = "http://192.168.0.7:8081/flutter";
const IPAcademy = "http://192.168.0.35:8081/flutter";

Widget Hr () {
  return Container(
    decoration: BoxDecoration(color: Colors.grey.shade500),
    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
    height: 1,
  );
}

int priceConverter(String price) {
  String price_str = price.replaceAll(",", "");
  int price_int = int.parse(price_str);
  return price_int;
}

// 스프링 커넥터
dynamic springConnecter({String? requestMapping, String? parameter}) async {
  
  // 학원 IP
  var url = Uri.parse("http://192.168.0.35:8081$requestMapping?$parameter");
  // 집 IP
  // var url = Uri.parse("http://192.168.0.7:8081$requestMapping?$parameter");
  
  http.Response response = await http.post(
    url, 
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );

  var statusCode = response.statusCode;
  var responseBody = utf8.decode(response.bodyBytes);  // for한글
  
  return responseBody; 
}

// 스낵바
callSnackBar(BuildContext context, {String? msg}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        alignment: Alignment.center,
        height: 30,
        child: Text(msg!, style: const TextStyle(color: Colors.white,),)
      ),
      backgroundColor: kPrimaryColor,
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      // action: SnackBarAction(
      //   label: "Undo",
      //   textColor: Colors.black,
      //   onPressed: () {},
      // ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20),
      //   side: BorderSide(color: Colors.red, width: 2)
      // ),
    )
  );
}