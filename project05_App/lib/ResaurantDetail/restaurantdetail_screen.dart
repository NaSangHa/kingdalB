import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project05/FoodDetail/fooddetail_screen.dart';
import 'package:project05/MyCart/cart_screen.dart';
import 'package:project05/ResaurantDetail/Widget/foodcard.dart';
import 'package:project05/Component/appbarLocation.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/Review/review_screen.dart';
import 'package:project05/constants.dart';

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({
    Key? key,
    required this.bottomNavIndex,
    required this.loginId,
    required this.rid
  }) : super(key: key);
  
  final int bottomNavIndex;
  final String loginId;
  final String rid;
  

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {

  @override
  void initState() {
    super.initState();
    print("초기값 확인 : id = ${widget.loginId} / rdi = ${widget.rid}");

    getOneResturantCardByRid();
    getAllMenuByRid();
    checkLikeRestaurant();
    // 주소
    getAllAddressById();

    setState(() { });
  }

  var restaurantCard_list = [];
  var menu_list = [];
  // 내 주소
  var myAddressList = [];
  var currentAddressTitle = "";
  // 구글 위치 찾기
  late Position _currentPosition;
  String currentAddress = '';
  String lat = '';
  String lon = '';

  // 식장 좋아요
  var likeimg = 'like_not.png';


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
          // 식당정보
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCard_list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var restaurantCardDTO = restaurantCard_list[index];
                return Column(
                  children: [
                    // 타이틀 사진
                    Stack(
                      children: [
                        Container(
                          // decoration: BoxDecoration(color: Colors.amber),
                          child: Image.network(
                            '$imgIPAddress${restaurantCardDTO['rtitleimg']}',
                            fit: BoxFit.fitWidth,
                          )
                        ),
                        InkWell(
                          onTap: () async {
                            print("좋아요 버튼");
                            if(likeimg == 'like.png')
                            {
                              likeimg = 'like_not.png';
                              await springConnecter(requestMapping: "/flutter/updateLike", parameter: "id=${widget.loginId}&rid=${widget.rid}&like=no");
                            }
                            else
                            {
                              likeimg = 'like.png';
                              await springConnecter(requestMapping: "/flutter/updateLike", parameter: "id=${widget.loginId}&rid=${widget.rid}&like=yes");
                            }
                            setState(() { });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: Image.asset(
                                "./assets/images/$likeimg",
                                height: 50
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 식당 이름
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      alignment: Alignment.center,
                      child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 25),),
                    ),
                    // 별점, 리뷰 정보
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 별점
                          Container(
                            child: Row(
                              children: [
                                Text("${restaurantCardDTO['avgstar']}", style: TextStyle(fontSize: 20),),
                                SizedBox(width: 5,),
                                Image.asset("./assets/images/star4.png", height: 20,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 식당 정보
                    Container(
                      // decoration: BoxDecoration(color: Colors.amber),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      height: 120,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              // decoration: BoxDecoration(color: Colors.blue),
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("최소주문금액", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("결제방법", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("배달시간", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("배달팁", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                ],
                              )
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              // decoration: BoxDecoration(color: Colors.red),
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("${restaurantCardDTO['rpaymethod']}", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                  Container(alignment: Alignment.centerLeft, margin: EdgeInsets.fromLTRB(0, 5, 0, 0), 
                                    child: Text("${restaurantCardDTO['rdeliverytip1']}원 ~ ${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 16, color: Colors.grey.shade700),)
                                  ),
                                ],
                              )
                            ),
                          ),
                        ],
                      ),
                    ),       
                    // 원산지정보, 리뷰
                    Container(
                      // decoration: BoxDecoration(color: Colors.amber),
                      alignment: Alignment.center,         
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              print("가게 원산지 정보 눌림");
                            },
                            child: Container(
                              height: 50, width: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: Colors.green,
                                border: Border.all(width: 1, color: Colors.grey.shade700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("가게/원산지 정보", style: TextStyle(fontSize: 14, color: Colors.grey.shade700),)
                            ),
                          ),
                          SizedBox(width: 60,),
                          InkWell(
                            onTap: () {
                              print("리뷰 눌림");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Review(bottomNavIndex: 0, loginId: widget.loginId, rid: '${restaurantCardDTO['rid']}',)), 
                              );
                            },
                            child: Container(
                              height: 50, width: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: Colors.green,
                                border: Border.all(width: 1, color: Colors.grey.shade700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("리뷰(${restaurantCardDTO['totalreview']})", style: TextStyle(fontSize: 14, color: Colors.grey.shade700),)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1, 
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 5), 
                      decoration: BoxDecoration(color: Colors.black),
                    ),
                  ],
                );
              }
            )
          ),
          // 메뉴
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: menu_list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                index = menu_list.length - 1 - index;
                var mcategory_list = menu_list[index]['menus'];

                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      alignment: Alignment.centerLeft,
                      child: Text("${menu_list[index]['mcategory']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: mcategory_list.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index2) {

                        var MenuDTO = mcategory_list[index2];

                        return InkWell(
                          onTap: () {
                            print("음식 카드 눌림");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FoodDeatil(bottomNavIndex: 0, loginId: widget.loginId,rid: MenuDTO['rid'] ,mid: MenuDTO['mid'],)), 
                            );
                            
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
                                        child: Text("${MenuDTO['mtitle']}", style: TextStyle(fontSize: 20),)
                                      ),
                                      Container(
                                        // decoration: BoxDecoration(color: Colors.blue),
                                        child: Text("${MenuDTO['mprice']}원", style: TextStyle(fontSize: 15),)
                                      ),
                                    ],
                                  )
                                ),
                                Container(
                                  // decoration: BoxDecoration(color: Colors.red),
                                  width: 100, height: 100,
                                  child: Image.network(
                                    "$imgIPAddress${MenuDTO['mimg']}", 
                                    fit: BoxFit.cover,
                                  )
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                );
              }
            )
          ),
          // 하단 여백
          Container(
            height: 30,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(context, 0, widget.loginId)
    );
  }


  // 식당정보 가져오기
  void getOneResturantCardByRid() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getOneRestaurantCardByRid", parameter: "rid=${widget.rid}");
    print(jsonDecode(json)['result']);
    restaurantCard_list = jsonDecode(json)['result'];
    setState(() {});
  }

  // 식당 메뉴정보 가져오기
  void getAllMenuByRid() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getAllMenuByRid", parameter: "rid=${widget.rid}");
    print(jsonDecode(json)['result']);
    menu_list = jsonDecode(json)['result'];
    setState(() {});
  }

  // 좋아요 확인
  void checkLikeRestaurant() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/checkLikeRestaurant", parameter: "id=${widget.loginId}&rid=${widget.rid}");
    var data = jsonDecode(json)['result'];
    if(data == 'success')
    {
      likeimg = 'like.png';
    }
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