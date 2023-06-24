import 'package:flutter/material.dart';
import 'package:project05/constants.dart';

Widget FoodOption() {
  
  bool _chk1 = false;

  return Container(
    height: 300,
    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      // color: Colors.amber,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.grey.shade400)
    ),
    child: Column(
      children: [
        // 옵션 타이틀
        Container(
          decoration: BoxDecoration(color: Colors.amber),
          alignment: Alignment.centerLeft,
          child: Text("리뷰참여", style: TextStyle(fontSize: 25),),
        ),
        Container(
          child: Checkbox(
              value: _chk1,
              splashRadius: 50.0, // 눌렀을 때 이펙트
              onChanged: (bool? value) {
                print('Checkbox1 : $_chk1');
              }
            ),
        ),
      ],
    ),
  );
}