import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/constants.dart';

class DeliveryStatus extends StatefulWidget {
  const DeliveryStatus({
    Key? key,
    required this.loginId,
    }) : super(key: key);

    final String loginId;

  @override
  State<DeliveryStatus> createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus> {

  @override
  void initState() {
    super.initState();
    print("배달 현황 페이지로 왔습니다.");
    getDeliveryStatus();
    
  }

  var statusImg = "InDelivery1.png";
  var step1 = "";
  var step2 = "";
  var step3 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBasic(context, "배달 상황"),
      body: ListView(
        children: [
          // 배달 진행 표시
          Container(
            // decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                // 배달 진행 바
                Container(
                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Image.asset("./assets/images/$statusImg")
                ),
                // 배달 상태 텍스트
                Container(
                  // decoration: BoxDecoration(color: Colors.blue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          // decoration: BoxDecoration(color: Colors.amber[300]),
                          alignment: Alignment.center, 
                          child: Text("주문완료\n $step1")
                        )
                      ),
                      Expanded(
                        child: Container(
                          // decoration: BoxDecoration(color: Colors.amber[500]),
                          alignment: Alignment.center, 
                          child: Text("배달중\n $step2")
                        )
                      ),
                      Expanded(
                        child: Container(
                          // decoration: BoxDecoration(color: Colors.amber[700]),
                          alignment: Alignment.center, 
                          child: Text("도착예정\n $step3")
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // 지도
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Image.asset("./assets/images/InDelivery_sample.png"),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(context, 2, widget.loginId),
    );
  }

  // 배달 현황 알아오기
  void getDeliveryStatus() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getDeliveryStatus", parameter: "id=${widget.loginId}");
    var data = jsonDecode(json)['result'];
    statusImg = data['statusImg'];
    step1 = data['step1'];
    step2 = data['step2'];
    step3 = data['step3'];
    
    setState(() {});
  }
}