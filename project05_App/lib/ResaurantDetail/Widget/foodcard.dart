import 'package:flutter/material.dart';
import 'package:project05/constants.dart';

Widget FoodCard(BuildContext context) {
  return InkWell(
    onTap: () {
      print("음식 카드 눌림");
    },
    child: Container(
      decoration: BoxDecoration(
        // color: Colors.amber,
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300))
      ),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
      height: 100,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Text("후라이드", style: TextStyle(fontSize: 20),)
                ),
                Container(
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Text("20,000원", style: TextStyle(fontSize: 15),)
                ),
              ],
            )
          ),
          Container(
            // decoration: BoxDecoration(color: Colors.red),
            width: 100, height: 100,
            child: Image.asset(
              "./assets/images/food_sample.png", 
              fit: BoxFit.cover,
            )
          )
        ],
      ),
    ),
  );
}