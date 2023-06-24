import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/MyCart/cart_screen.dart';
import 'package:project05/OrderHistory/Widget/orderhistorycard.dart';
import 'package:project05/ResaurantDetail/restaurantdetail_screen.dart';
import 'package:project05/constants.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({
    Key? key,
    required this.bottomNavIndex,
    required this.loginId,
    }) : super(key: key);

    final int bottomNavIndex;
    final String loginId;

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  @override
  void initState() {
    super.initState();
    print("초기값 확인 : id = ${widget.loginId}");

    getAllOrderHistoryById();
    // 주소
    getAllAddressById();
  }

  var orderHistory_list = [];
  // 내 주소
  var myAddressList = [];
  var currentAddressTitle = "";
  // 구글 위치 찾기
  late Position _currentPosition;
  String currentAddress = '';
  String lat = '';
  String lon = '';


  @override
  Widget build(BuildContext context, ) {
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
      body: Container(
        child: ListView(
          children: [
            Container(height: 20,),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: orderHistory_list.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var OrderHistoryCardDTO = orderHistory_list[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: OrderHistoryCardDTO['rid'],)), 
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
                                  child: Text("${OrderHistoryCardDTO['orderdate']}", style: TextStyle(fontSize: 18, color: Colors.grey.shade500),)
                                ),
                                // 주문상세
                                InkWell(
                                  onTap: () async {
                                    print("주문상세 눌림");
                                    dynamic json = await springConnecter(requestMapping: "/flutter/getOrderHistoryDetailCardByOrderid", parameter: "id=${widget.loginId}&orderid=${OrderHistoryCardDTO['orderid']}");
                                    var data = jsonDecode(json);
                                    print(data['result']);
                                    showAlertDialog_orderhistory(context, data['result'][0]);
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
                                Image.network(
                                  "$imgIPAddress${OrderHistoryCardDTO['rlogo']}",
                                  width: 75,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    // decoration: BoxDecoration(color: Colors.red),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${OrderHistoryCardDTO['rtitle']} ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                        SizedBox(height: 5,),
                                        Text("${OrderHistoryCardDTO['mainfood']} ${OrderHistoryCardDTO['count']}  ${OrderHistoryCardDTO['totalprice']}원", style: TextStyle(fontSize: 15, color: Colors.grey.shade500),),
                                      ],
                                    ),
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(context, 2, widget.loginId),
    );
  }
  
  // 식당 중복 알림창
  Future showAlertDialog_orderhistory(BuildContext context, dynamic json) async {

    var OrderHistoryDTO = json;
    List OrderHistoryDeatilDTO_list = OrderHistoryDTO['content'];

    await showDialog(
      context: context,
      barrierDismissible: true,  // 모달 여부(false = 모달창)
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            title: Text('영수증', style: TextStyle(fontSize: 15),),
            content: Container(
              height: 500.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 식당 로고, 이름
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      children: [
                        Image.network(
                          '$imgIPAddress${OrderHistoryDTO['rlogo']}',
                          height: 35,
                        ),
                        SizedBox(width: 10,),
                        Text("${OrderHistoryDTO['rtitle']}"),
                      ],
                    )
                  ),
                  // 주문일시, 배달주소
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('주문일시', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                        Text('${OrderHistoryDTO['orderdate']}', style: TextStyle(fontSize: 15),),
                        SizedBox(height: 8,),
                        Text('배달주소', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                        Text('${OrderHistoryDTO['orderlocation']}', style: TextStyle(fontSize: 15),),
                      ],
                    ),
                  ),
                  // 구분선
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade500),
                    height: 1,
                  ),
                  // 주문 상세 내역
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: OrderHistoryDeatilDTO_list.length,
                    itemBuilder: (BuildContext context, int index) {
                      var OrderHistoryDeatilDTO = OrderHistoryDeatilDTO_list[index];
                      return ListTile(
                        title: Text('${OrderHistoryDeatilDTO['mainfood']}'),
                        subtitle: Text('${OrderHistoryDeatilDTO['foodoption']}'),
                        trailing: Text('${OrderHistoryDeatilDTO['price']} 원'),
                      );
                    },
                  ),
                  // 구분선
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade500),
                    height: 1,
                  ),
                  // 주문금액
                  Container(
                    // decoration: BoxDecoration(color: Colors.amber),
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container(
                          // decoration: BoxDecoration(color: Colors.red),
                          alignment: Alignment.center,
                          child: Text('주문금액', style: TextStyle(fontSize: 18),))
                        ),
                        Expanded(child: Container(
                          // decoration: BoxDecoration(color: Colors.blue),
                          alignment: Alignment.center,
                          child: Text('${OrderHistoryDTO['orderprice']} 원', style: TextStyle(fontSize: 18),))
                        ),
                      ],
                    ),
                  ),
                  // 배달팁
                  Container(
                    // decoration: BoxDecoration(color: Colors.amber),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container(
                          // decoration: BoxDecoration(color: Colors.red),
                          alignment: Alignment.center,
                          child: Text('배달팁', style: TextStyle(fontSize: 18),))
                        ),
                        Expanded(child: Container(
                          // decoration: BoxDecoration(color: Colors.blue),
                          alignment: Alignment.center,
                          child: Text('${OrderHistoryDTO['deliverytip']} 원', style: TextStyle(fontSize: 18),))
                        ),
                      ],
                    ),
                  ),
                  // 최종주문금액
                  Container(
                    // decoration: BoxDecoration(color: Colors.amber),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Container(
                          // decoration: BoxDecoration(color: Colors.red),
                          alignment: Alignment.center,
                          child: Text('최종주문금액', style: TextStyle(fontSize: 18, color: kPrimaryColor),))
                        ),
                        Expanded(child: Container(
                          // decoration: BoxDecoration(color: Colors.blue),
                          alignment: Alignment.center,
                          child: Text('${OrderHistoryDTO['totalprice']} 원', style: TextStyle(fontSize: 18, color: kPrimaryColor),))
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
            ],
          )
        );
      }
    );  
  }  
  
  // 내 주문내역 목록 불러오기
  void getAllOrderHistoryById() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getAllOrderHistoryById", parameter: "id=${widget.loginId}");
    var data = jsonDecode(json);
    orderHistory_list = data['result'];
    print(orderHistory_list);
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