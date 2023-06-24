import 'package:flutter/material.dart';
import 'package:project05/constants.dart';


Widget OrderHistoryCard() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 8), // changes position of shadow
        ),
      ],
    ),
    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    child: Column(
      children: [
        // 주문날짜, 주문 상세, 메뉴
        Container(
          // decoration: BoxDecoration(color: Colors.amber),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              // 주문날짜
              Expanded(
                child: Text("08/05 (금)", style: TextStyle(fontSize: 18, color: Colors.grey.shade500),)
              ),
              // 주문상세
              InkWell(
                onTap: () {
                  print("주문상세 눌림");
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade500),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text("주문상세")
                ),
              ),
              // 메뉴
              InkWell(
                onTap: () {
                  print("메뉴 눌림");
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: Image.asset("./assets/images/menu.png", height: 20,)
                ),
              )
            ],
          )
        ),
        // 식당사진, 식당이름, 주문음식
        Container(
          // decoration: BoxDecoration(color: Colors.amber),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: [
              Image.asset("./assets/images/restauranttitleimg_sample.jpg", width: 75,),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  // decoration: BoxDecoration(color: Colors.red),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BHC 석관점", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("해바라기 후라이드 1개 21,500원", style: TextStyle(fontSize: 15, color: Colors.grey.shade500),),
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ],
    ),
  );
}