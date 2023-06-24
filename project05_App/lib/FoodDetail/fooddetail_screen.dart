import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project05/FoodDetail/Widget/foodoption.dart';
import 'package:project05/Component/appbarLocation.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/MyCart/cart_screen.dart';
import 'package:project05/constants.dart';

class FoodDeatil extends StatefulWidget {
  const FoodDeatil({
    Key? key,
    required this.bottomNavIndex,
    required this.loginId,
    required this.rid,
    required this.mid,
    }) : super(key: key);

    final int bottomNavIndex;
    final String loginId;
    final String rid;
    final String mid;
    

  @override
  State<FoodDeatil> createState() => _FoodDeatilState();

  
}

class _FoodDeatilState extends State<FoodDeatil> {

  @override
  void initState() {
    super.initState();
    print("초기값 확인 : id = ${widget.loginId} / rid = ${widget.rid} / mid = ${widget.mid}");

    getOneMenuByMid();
    getAllMenuOptionByMid();
    // 주소
    getAllAddressById();
    
    setState(() { });
  }

  var menu_list = [];
  var menuOption_list = [];
  // 내 주소
  var myAddressList = [];
  var currentAddressTitle = "";
  // 구글 위치 찾기
  late Position _currentPosition;
  String currentAddress = '';
  String lat = '';
  String lon = '';

  // 체크박스 여부
  List<List<bool>> chk = [];
  // 기본 음식 가격
  var totalPrice = 0;
  List<String> moption_list = [];
  var mtitle = "";

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
          // 메뉴
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: menu_list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {

                var MenuDTO = menu_list[index];

                return Column(
                  children: [
                    // 음식 사진
                    Container(
                      // decoration: BoxDecoration(color: Colors.amber),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      height: 200,
                      child: Image.network(
                        "$imgIPAddress${MenuDTO['mimg']}"
                      ),
                    ),
                    // 이름
                    Container(
                      // decoration: BoxDecoration(color: Colors.amber),
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Text("${MenuDTO['mtitle']}", style: TextStyle(fontSize: 25),)
                    ),
                    // 기본 가격
                    Container(
                      // decoration: BoxDecoration(color: Colors.amber),
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("가격", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text("${MenuDTO['mprice']} 원", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            )
          ),    
          // 메뉴 옵션
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: menuOption_list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                
                var MenuOption_json = menuOption_list[index];
                var MenuOptionDTO_list = MenuOption_json['menuOptions'];
                
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                        // decoration: BoxDecoration(color: Colors.amber),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text("${MenuOption_json['moptioncategory']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      // 옵션 List
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: MenuOptionDTO_list.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index2) {
                          
                          var MenuOptionDTO = MenuOptionDTO_list[index2];

                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: Row(
                              children: [
                                // 체크박스
                                Container(
                                  child: Checkbox(
                                      value: chk[index][index2],
                                      activeColor: kPrimaryColor,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          chk[index][index2] = value!;
                                          print(chk[index][index2]);
                                          if(chk[index][index2])
                                          {
                                            totalPrice += int.parse(MenuOptionDTO['moptionprice']);
                                            moption_list.add(MenuOptionDTO['moptiontitle']);
                                            print('$moption_list');
                                          }
                                          else{
                                            totalPrice -= int.parse(MenuOptionDTO['moptionprice']);
                                            moption_list.remove(MenuOptionDTO['moptiontitle']);
                                            print('$moption_list');
                                          }
                                        });
                                      }
                                    ),
                                ),
                                // 옵션 내용
                                Container(
                                  child: Text("${MenuOptionDTO['moptiontitle']}", style: TextStyle(fontSize: 18),),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // decoration: BoxDecoration(color: Colors.amber),
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text("+ ${MenuOptionDTO['moptionprice']} 원", style: TextStyle(fontSize: 18),),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      )
                    ],
                  ),
                );
              }
            )
          ),
          // 하단여백
          Container(
            height: 100,
          )
        ],
      ),
      // 주문 금액 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () async {
          print("주문합니다.");
          // 장바구니 식당 중복 체크
          dynamic json = await springConnecter(requestMapping: "/flutter/checkCartRestaurantDouble", parameter: "id=${widget.loginId}&rid=${widget.rid}");
          var result = jsonDecode(json)['result'];
          if(result == 'success')
          {
            print("음식을 담을 수 있습니다.");
            var moption = "옵션 : ";
            for(var item in moption_list)
            {
              moption += item + " / ";
            }
            await springConnecter(requestMapping: "/flutter/insertMenuMyCart", parameter: "id=${widget.loginId}&rid=${widget.rid}&mid=${widget.mid}&mtitle=${mtitle}&moption=$moption&mprice=$totalPrice");
            callSnackBar(context, msg: "장바구니에 담겼습니다.");
          }
          else
          {
            print("음식을 담을 수 없습니다.");
            showAlertDialog_restaurantDouble(context);
          }
          
        },
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10)
          ),
          height: 65, width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$totalPrice원 담기", style: TextStyle(fontSize: 20, color: Colors.white),),
              Text("최소 주문금액 10,000원", style: TextStyle(fontSize: 12, color: Colors.white),),
            ],
          ),
        ),
      )
    );
  }

  // 식당 중복 알림창
  Future showAlertDialog_restaurantDouble(BuildContext context) async {
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
              height: 100,  // 생성되는 창의 높이
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("장바구니에는 같은 가게의 메뉴만 담을 수 있습니다.", style: TextStyle(fontSize: 18, color: kPrimaryColor),),
                  SizedBox(height: 10,),
                  Text("선택하신 메뉴를 장바구에 담을 경우 이전에 담은 메뉴가 삭제됩니다.", style: TextStyle(fontSize: 12, color: Colors.grey.shade500),),
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
                        print("메뉴를 담습니다.");
                        var moption = "옵션 : ";
                        for(var item in moption_list)
                        {
                          moption += item + " / ";
                        }
                        await springConnecter(requestMapping: "/flutter/insertMenuMyCartWithClear", parameter: "id=${widget.loginId}&rid=${widget.rid}&mid=${widget.mid}&mtitle=${mtitle}&moption=$moption&mprice=$totalPrice");
                        callSnackBar(context, msg: "장바구니에 담겼습니다.");
                        Navigator.pop(context, 'Ok');   // 창 없에기
                      },
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.green),
                        alignment: Alignment.center,
                        height: 35,
                        child: Text("담기", style: TextStyle(fontWeight: FontWeight.bold)),
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
  
  // 식당 메뉴정보 가져오기
  void getOneMenuByMid() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getOneMenuByMid", parameter: "mid=${widget.mid}");
    print(jsonDecode(json)['result']);
    menu_list = jsonDecode(json)['result'];
    print(jsonDecode(json)['result'][0]['mprice']);
    totalPrice = int.parse(jsonDecode(json)['result'][0]['mprice']);
    mtitle = jsonDecode(json)['result'][0]['mtitle'];
    setState(() {});
  }

  // 식당 메뉴 옵셥정보 가져오기
  void getAllMenuOptionByMid() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getAllMenuOptionByMid", parameter: "mid=${widget.mid}");
    // print(jsonDecode(json)['result']);
    menuOption_list = jsonDecode(json)['result'];
    
    // 체크박스 만들기
    print(menuOption_list);
    for(dynamic item in menuOption_list )
    {
      List menuOptions = item['menuOptions'];
      print(menuOptions.length);
      List<bool> chk_maker = [];
      for(dynamic item2 in menuOptions)
      {
        print(item2['moptiontitle']);
        chk_maker.add(false);
      }
      chk.add(chk_maker);
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