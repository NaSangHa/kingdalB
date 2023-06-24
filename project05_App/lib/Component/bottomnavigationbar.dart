import 'package:flutter/material.dart';
import 'package:project05/Like/like_screen.dart';
import 'package:project05/Main/main_screen.dart';
import 'package:project05/MyInfo/myinfo.dart';
import 'package:project05/OrderHistory/orderhistory_screen.dart';
import 'package:project05/constants.dart';

BottomNavigationBar BottomNavBar(BuildContext context, index, id) {
  return BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: kPrimaryColor,                    // 선택된 메뉴창
        selectedLabelStyle: const TextStyle(fontSize: 14),    // 선택된 메뉴 글자 크기 
        unselectedItemColor : Colors.grey,                 // 선택 안된 메뉴창
        unselectedLabelStyle: const TextStyle(fontSize: 14),  // 선택 안된 메뉴창 글자 크기
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (index) {
          print("$index 버튼");
          if (index == 0)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Main(bottomNavIndex: index, loginId: id,)), 
            );
          }
          if (index == 1)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Like(bottomNavIndex: index, loginId: id,)), 
            );
          }
          if(index == 2)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderHistory(bottomNavIndex: index, loginId: id,)), 
            );
          }
          if(index == 3)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyInfo(bottomNavIndex: index, loginId: id,)), 
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: '주문내역',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '내정보',
          ),
        ],  
    );
}