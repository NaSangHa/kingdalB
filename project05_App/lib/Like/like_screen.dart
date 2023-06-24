import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/MyCart/cart_screen.dart';
import 'package:project05/ResaurantDetail/restaurantdetail_screen.dart';
import 'package:project05/constants.dart';

class Like extends StatefulWidget {
  const Like({
    Key? key,
    required this.bottomNavIndex,
    required this.loginId,
    }) : super(key: key);

    final int bottomNavIndex;
    final String loginId;

  @override
  State<Like> createState() => _LikeState();
}

class _LikeState extends State<Like> {

  @override
  void initState() {
    super.initState();

    getAllLike();
    // 주소
    getAllAddressById();

    setState(() { });
  }

  var like_list = [];
  // 내 주소
  var myAddressList = [];
  var currentAddressTitle = "";
  // 구글 위치 찾기
  late Position _currentPosition;
  String currentAddress = '';
  String lat = '';
  String lon = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              print("주소 설정");
              // 주소록 설정 모달
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, StateSetter bottomState) {
                      return Container(
                        height: 1000,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: ListView(
                          children: 
                            [
                              // 주소설정 타이틀
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: Text("주소설정", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),)
                              ),
                              // 주소검색
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                  children: [
                                    Image.asset("./assets/images/search.png", width: 20,),
                                    SizedBox(width: 10,),
                                    Text("지번, 도로명, 건물명으로 검색", style: TextStyle(fontSize: 12,),)
                                  ],
                                ),
                              ),
                              // 현재위치 설정
                              InkWell(
                                onTap: () async {
                                  await getMyLocation();
                                  print('현재 주소 : $currentAddress');
                                  if('$currentAddress' != '')
                                  {
                                    await showAlertDialog(context, '$currentAddress');
                                  }

                                },
                                child: Container(
                                  // decoration: BoxDecoration(color: Colors.amber),
                                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("./assets/images/gps.png", width: 20,),
                                      SizedBox(width: 5,),
                                      Text("현재 위치로 설정", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                ),
                              ),
                              // 구분선
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 3, 0, 20),
                                height: 1, color: Colors.grey.shade300,
                              ),
                              // 주소 리스트
                              Expanded(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: myAddressList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                    
                                    var AddressDTO = myAddressList[index];
                                    return InkWell(
                                      onTap: () async {
                                        print('${AddressDTO['addrtitle']} 눌림');
                                        for(int i=0; i < myAddressList.length; i++)
                                        {
                                          if(index == i)
                                          {
                                            print("이 주소로 변경합니다.");
                                            print(myAddressList[i]);
                                            print(myAddressList[i]['aid']);
                                            await springConnecter(requestMapping: "/flutter/updateAdaptAddressByAid", parameter: "id=${widget.loginId}&aid=${myAddressList[i]['aid']}");
                                            currentAddressTitle = myAddressList[i]['addrtitle'];
                                            myAddressList[i]['adapt'] = '1';
                                          }
                                          else
                                          {
                                            print("이 주소는 적용 x");
                                            print(myAddressList[i]);
                                            myAddressList[i]['adapt'] = '0';
                                          }
                                        }
                                        print('적용 후 : $myAddressList');
                                        bottomState(() { 
                                          setState(() { });
                                        });
                                      },
                                      child: Container(
                                        // decoration: BoxDecoration(color: Colors.amber),
                                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        child: Row(
                                          children: [
                                            Image.asset("./assets/images/${AddressDTO['addrtype']}.png", width: 30,),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("${AddressDTO['addrtitle']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 5,),
                                                  Text("${AddressDTO['mainaddr']} ${AddressDTO['subaddr']}", style: TextStyle(fontSize: 12, color: Colors.grey),),
                                                ],
                                              ),
                                            ),
                                            Image.asset("./assets/images/adapt${AddressDTO['adapt']}.png", width: 20,),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                )
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  }
                );
            },
            splashColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$currentAddressTitle", style: TextStyle(fontSize: 16,),),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          )
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print("뒤로가기");
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/images/cart.png"),
            onPressed: () {
              print('장바구니 눌림');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCart(loginId: widget.loginId,)), 
              );
            }
          ),
        ],
      ),
      body: ListView(
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: like_list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {

                var RestaurantCardDTO = like_list[index];

                return InkWell(
                  onTap: () {
                    print("식당카드 눌림");
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                              loginId: widget.loginId, 
                                                                              rid: RestaurantCardDTO['rid'],)), 
                    );
                  },
                  child: Container(
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
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 120,
                    child: Row(
                      children: [
                        Container(
                          width: 100, height: 100,
                          // decoration: BoxDecoration(color: Colors.green.shade700),
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Image.network(
                            "$imgIPAddress${RestaurantCardDTO['rlogo']}"
                            )
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            // decoration: BoxDecoration(color: Colors.green.shade300),
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 식당명
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("${RestaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
                                ),
                                // 별점, 포장가능
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Row(
                                    children: [
                                      // 별점
                                      Container(
                                        child: Row(
                                          children: [
                                            Image.asset("./assets/images/star.png", width: 18,),
                                            SizedBox(width: 5,),
                                            Text("${RestaurantCardDTO['avgstar']}"),
                                            Text("(${RestaurantCardDTO['totalreview']})")
                                          ]
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      // 포장가능
                                      Container(
                                        child: Text("${RestaurantCardDTO['rpaymethod']}"),
                                      )
                                    ],
                                  )
                                ),
                                // 최소주문, 배달팁
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  child: Row(
                                    children: [
                                      // 최소주문
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("최소주문", style: TextStyle(fontSize: 13, color: Colors.grey.shade700),),
                                            SizedBox(width: 5,),
                                            Text("${RestaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      // 배달팁
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text("배달팁", style: TextStyle(fontSize: 13, color: Colors.grey.shade700),),
                                            SizedBox(width: 5,),
                                            Text("${RestaurantCardDTO['rdeliverytip1']}원~${RestaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 예상배달시간
                                Container(
                                  child: Row(
                                    children: [
                                      Text("예상배달시간", style: TextStyle(fontSize: 13, color: Colors.grey.shade700),),
                                      SizedBox(width: 5,),
                                      Text("${RestaurantCardDTO['rdeliverytime1']}분~${RestaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
                                    ],
                                  ),
                                )
                              ],
                            )
                          )
                        ),
                      ],
                    ),
                  ),
                );
              }
            )
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(context, 1, widget.loginId),
    );
  }


  // 내 찜 목록 불러오기
  void getAllLike() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getAllLike", parameter: "id=${widget.loginId}");
    var data = jsonDecode(json);
    like_list = data['result'];
    print(like_list);
    setState(() {});
  }

  // 내 주소
  void getAllAddressById() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getAllAddressById", parameter: "id=${widget.loginId}");
    var data = jsonDecode(json);
    print(data);
    myAddressList = data['result'];
    List address_list = myAddressList;
    for(var item in address_list)
    {
      if(item['adapt'] == '1')
      {
        currentAddressTitle = item['addrtitle'];
      }
    }
    setState(() {});
  }
  // 현재 위치 구하기
  getMyLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: false)
      .then((Position position) {
        _currentPosition = position;
        setState(() {
          lat = '${position.latitude}';
          lon = '${position.longitude}';
        });
      })
      .catchError((e) {
        print(e);
      });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude,_currentPosition.longitude);
      Placemark place = placemarks[0];
      print(place);

      setState(() {
        if(Platform.isAndroid) {
          currentAddress = "${place.street}";
          currentAddress = currentAddress.substring(5);
        }
        else if(Platform.isIOS) {
          currentAddress = "${place.administrativeArea}" + "${place.locality}" +"${place.street}";
        }
      });
    } catch (e) {
      print(e);
    }      
  }

  // 현재 위치 설정 알람
  Future showAlertDialog(BuildContext context, String location) async {

    final subaddrText = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: true,  // 모달 여부(false = 모달창)
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            title: Text('알림', style: TextStyle(fontSize: 15),),
            content: Container(
              alignment: Alignment.center,
              height: 200,  // 생성되는 창의 높이
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("현재 주소",style: TextStyle(fontSize: 15,),),
                  SizedBox(height: 10,),
                  Text("$location",style: TextStyle(fontSize: 15, color: kPrimaryColor),),
                  SizedBox(height: 20,),
                  
                  Text("세부 주소",style: TextStyle(fontSize: 15,),),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: subaddrText,
                      decoration: const InputDecoration(
                        // labelText: "Email",
                        hintText: "세부 주소를 입력해주세요",
                        hintStyle: TextStyle(fontSize: 13),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("추가하시겠습니까?",style: TextStyle(fontSize: 15,),),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print("취소합니다.");
                        Navigator.pop(context, 'Ok');   // 창 없에기
                      },
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.amber),
                        alignment: Alignment.center,
                        height: 35,
                        child: Text("취소", style: TextStyle(),),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if('${subaddrText.text}' != "")
                        {
                          print("주소를 추가합니다. 메인 주소 : $location / 서브 주소 : ${subaddrText.text} / lat : $lat / lon : $lon");
                          await springConnecter(requestMapping: "/flutter/insertNewAddress", parameter: "id=${widget.loginId}&mainaddr=$location&subaddr=${subaddrText.text}&lat=$lat&lon=$lon");
                          getAllAddressById();
                          setState(() { });
                          Navigator.pop(context, 'Ok');   // 창 없에기
                        }
                      },
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.green),
                        alignment: Alignment.center,
                        height: 35,
                        child: Text("추가", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        );
      }
    );
  }
}