import 'package:flutter/material.dart';
import 'package:project05/CategorySearch/categorysearch_screen.dart';


double menuIconSize = 65;     // 음식 아이콘 사이즈
double menuTextSize = 12;     // 음식 텍스트 사이즈
double menuTextInterver = 5;  // 음식사진 ~ 텍스트 간격


// 한식
InkWell Category_menu_kor (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/한식.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("한식", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("한식 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 0, loginId: id,)), 
      );
    },
  );
}

// 일식
InkWell Category_menu_jap (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/일식.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("일식", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("일식 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 1, loginId: id,)), 
      );
    },
  );
}

// 중식
InkWell Category_menu_chi (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/중식.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("중식", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("중식 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 2, loginId: id,)), 
      );
    },
  );
}

// 양식
InkWell Category_menu_west (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/양식.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("양식", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("양식 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 3, loginId: id,)), 
      );
    },
  );
}

// 분식
InkWell Category_menu_sanck (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/분식.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("분식", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("분식 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 4, loginId: id,)), 
      );
    },
  );
}

// 치킨
InkWell Category_menu_chicken (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/치킨.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("치킨", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("치킨 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 5, loginId: id,)), 
      );
    },
  );
}

// 햄버거
InkWell Category_menu_hamburger (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/햄버거.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("햄버거", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("햄버거 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 6, loginId: id,)), 
      );
    },
  );
}

// 피자
InkWell Category_menu_pizza (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/피자.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("피자", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("피자 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 7, loginId: id,)), 
      );
    },
  );
}

// 카페
InkWell Category_menu_cafe (BuildContext context, id) {
  return InkWell(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/카페.png",
            height: menuIconSize,
          ),
          SizedBox(height: menuTextInterver,),
          Text("카페", style: TextStyle(fontSize: menuTextSize),)
        ],
      ),
    ),
    onTap: () {
      print("카페 눌림");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySearch(categoryIndex: 8, loginId: id,)), 
      );
    },
  );
}