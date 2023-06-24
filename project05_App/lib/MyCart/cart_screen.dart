import 'dart:convert';
import 'dart:io';

import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/material.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/DeliveryStatus/deliverystatus_screen.dart';
import 'package:project05/Main/main_screen.dart';
import 'package:project05/constants.dart';
// goelocation
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// 부트페이
import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/payload.dart';

class MyCart extends StatefulWidget {
  const MyCart({
    Key? key,
    required this.loginId,
    }) : super(key: key);

    final String loginId;

  @override
  State<MyCart> createState() => _MyCartState();
}


class _MyCartState extends State<MyCart> {

  @override
  void initState() {
    super.initState();
    print("초기값 확인 : id = ${widget.loginId}");

    getAllCartById();
    getRestaurantInMyCartById();
    // 주소
    getAllAddressById();
    
    _radioValue = 1;
    
  }

  var cart_list = [];
  var rlogo = "";
  var rtitle = "";
  var deliverytip = 0;
  var orderprice = 0;
  // 내 주소
  var myAddressList = [];
  var currentAddressTitle = "";
  
  // 구글 위치 찾기
  late Position _currentPosition;
  String currentAddress = '';
  String lat = '';
  String lon = '';
  
  //부트페이
  Payload payload = Payload();
  String _data = ""; // 서버승인을 위해 사용되기 위한 변수

  String webApplicationId = '632164d0cf9f6d001f6ce586';
  String androidApplicationId = '632164d0cf9f6d001f6ce587';
  String iosApplicationId = '632164d0cf9f6d001f6ce588';

  String get applicationId {
    return Bootpay().applicationId(
      webApplicationId,
      androidApplicationId,
      iosApplicationId
    );
  }

  // 배달, 포장 Radio
  var _radioValue = 0;
  var ordertype = '배달';


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
          // 장바구니에 담긴 식당 이름/사진
          Container(
            // decoration: BoxDecoration(color: Colors.amber),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                Image.network(
                  "$imgIPAddress$rlogo",
                  height: 50,
                ),
                SizedBox(width: 10,),
                Text("$rtitle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: kPrimaryColor,
                  title: Text('배달', style: TextStyle(color: Colors.black),),
                  groupValue: _radioValue,
                  value: 1,
                  selected: true,
                  onChanged: (int? value) {
                    setState(() {
                      _radioValue = value!;
                      ordertype = '배달';
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  activeColor: kPrimaryColor,
                  title: Text('포장', style: TextStyle(color: Colors.black),),
                  groupValue: _radioValue,
                  value: 2,
                  selected: true,
                  onChanged: (int? value) {
                    setState(() {
                      _radioValue = value!;
                      ordertype = '포장';
                    });
                  },
                ),
              ),
            ],
          ),
          // 담긴 음식 정보
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: cart_list.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {

                var CartDTO = cart_list[index];
                
                return Container(
                  // decoration: BoxDecoration(color: Colors.amber),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Column(
                    children: [
                      // 음식 타이틀
                      Container(
                        alignment: Alignment.centerLeft, 
                        child: Row(
                          children: [
                            Expanded(child: Text("${CartDTO['mtitle']}", style: TextStyle(fontSize: 20,))),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () async {
                                print("해당 음식을 삭제합니다.");
                                cart_list.removeAt(index);
                                dynamic json = await springConnecter(requestMapping: "/flutter/deleteMenuInMyCartByCid", parameter: "id=${widget.loginId}&cid=${CartDTO['cid']}");
                                setState(() {
                                  orderprice -= int.parse('${CartDTO['mprice']}');
                                });
                              },
                            )
                          ],
                        )
                      ),
                      // 음식 사진, 옵션, 가격
                      Container(
                        child: Row(
                          children: [
                            // 음식 사진
                            Image.network(
                              '$imgIPAddress${CartDTO['mimg']}',
                              height: 100,
                            ),
                            // 옵셕, 가격
                            Expanded(
                              child: Container(
                                // decoration: BoxDecoration(color: Colors.blue),
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("옵션"),
                                    SizedBox(height: 5,),
                                    Text("${CartDTO['moption']}", style: TextStyle(fontSize: 10),),
                                    SizedBox(height: 10,),
                                    Container(
                                      // decoration: BoxDecoration(color: Colors.red),
                                      width: double.infinity,
                                      alignment: Alignment.centerRight,
                                      child: Text("${CartDTO['mprice']}원", style: TextStyle(fontSize: 20),)
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),      
                      )
                    ],
                  ),
                );
              }
            )
          ),
          // 총주문금액, 배달팁, 결제예정금액
          Container(
            // decoration: BoxDecoration(color: Colors.blue),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children: [
                // 총 주문금액
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        alignment: Alignment.centerLeft,
                        child: Text("총 주문금액", style: TextStyle(fontSize: 20),)
                      )
                    ),
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        alignment: Alignment.centerRight,
                        child: Text("$orderprice원", style: TextStyle(fontSize: 20),)
                      )
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                // 배달팁
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        alignment: Alignment.centerLeft,
                        child: Text("배달팁", style: TextStyle(fontSize: 20),)
                      )
                    ),
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        alignment: Alignment.centerRight,
                        child: Text("$deliverytip원", style: TextStyle(fontSize: 20),)
                      )
                    ),
                  ],
                ),
                // 구분선
                Container(
                  decoration: BoxDecoration(color: Colors.grey.shade500),
                  margin: EdgeInsets.fromLTRB(5, 8, 5, 8),
                  height: 1,
                ),
                // 총 주문금액
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        alignment: Alignment.centerLeft,
                        child: Text("결제예정금액", style: TextStyle(fontSize: 20),)
                      )
                    ),
                    Expanded(
                      child: Container(
                        // decoration: BoxDecoration(color: Colors.red),
                        alignment: Alignment.centerRight,
                        child: Text("${orderprice + deliverytip}원", style: TextStyle(fontSize: 20, color: kPrimaryColor, fontWeight: FontWeight.bold),)
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 하단 여백
          Container(
            height: 120,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () {
          print("주문 시작");
          if(cart_list.length > 1)
          {
            print("메뉴의 갯수가 2개 이상입니다.");
            print(cart_list[0]['mtitle']);
            var itemName = '${cart_list[0]['mtitle']} 외 ${cart_list.length - 1}';
            var itemPrice = orderprice + deliverytip;
            print('$itemName / $itemPrice');
            bootpayReqeustDataInit(itemName: itemName, itmePrice: itemPrice.toDouble() );
          }
          else
          {
            print("메뉴의 갯수가 1개입니다.");
            print(cart_list);
            var itemName = '${cart_list[0]['mtitle']}';
            var itemPrice = orderprice + deliverytip;
            print('$itemName / $itemPrice');
            bootpayReqeustDataInit(itemName: itemName, itmePrice: itemPrice.toDouble() );
          }
          goBootpayTest(context);
          
          // Navigator.pushReplacement(
          //   context,
          //   PageRouteBuilder(
          //     pageBuilder: (context, anim1, anim2) => DeliveryStatus(loginId: widget.loginId,),
          //     transitionDuration: const Duration(seconds: 0),
          //   ),
          // );
          print("테스트3");
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
              Text("$ordertype 주문하기    ${orderprice + deliverytip}원", style: TextStyle(fontSize: 20, color: Colors.white),),
            ],
          ),
        ),
      )
    );
  }

  // 내 카트 목록 가져오기
  void getAllCartById() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getAllCartById", parameter: "id=${widget.loginId}");
    var data = jsonDecode(json);
    cart_list = data['result'];
    for(var item in cart_list)
    {
      orderprice += int.parse(item['mprice']);
    }
    print(cart_list);
    setState(() {});
  }

  // 내 카트 식당 정보 가져오기
  void getRestaurantInMyCartById() async {
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantInMyCartById", parameter: "id=${widget.loginId}");
    var data = jsonDecode(json);
    var restaurant_list = data['result'];
    var data1 = restaurant_list[0];
    rlogo = data1['rlogo'];
    rtitle = data1['rtitle'];
    deliverytip = int.parse(data1['deliverytip']);

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

  // 부트페이 Init
  bootpayReqeustDataInit({String? itemName, double? itmePrice}) {
    
    // Item item1 = Item();
    // item1.name = "미키 '마우스"; // 주문정보에 담길 상품명
    // item1.qty = 1; // 해당 상품의 주문 수량
    // item1.id = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    // item1.price = 500; // 상품의 가격

    // Item item2 = Item();
    // item2.name = "키보드"; // 주문정보에 담길 상품명
    // item2.qty = 1; // 해당 상품의 주문 수량
    // item2.id = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
    // item2.price = 500; // 상품의 가격
    // List<Item> itemList = [item1, item2];

    payload.webApplicationId = webApplicationId; // web application id
    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id


    payload.pg = '';
    payload.method = '';
    // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
    payload.orderName = "$itemName"; //결제할 상품명
    
    // payload.price = itmePrice; 
    payload.price = 1000;         // 테스트용


    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함


    // payload.params = {
    //   "callbackParam1" : "value12",
    //   "callbackParam2" : "value34",
    //   "callbackParam3" : "value56",
    //   "callbackParam4" : "value78",
    // }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    // payload.items = itemList; // 상품정보 배열

    User user = User(); // 구매자 정보
    user.username = "사용자 이름";
    user.email = "user1234@gmail.com";
    user.area = "서울";
    user.phone = "010-4033-4678";
    user.addr = '서울시 동작구 상도로 222';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';
    // extra.openType = 'popup';

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    payload.extra?.openType = "iframe";
  }

  //버튼클릭시 부트페이 결제요청 실행
  void goBootpayTest(BuildContext context) {
    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      // onCloseHardware: () {
      //   print('------- onCloseHardware');
      // },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 비동기 승인 하고자 할 때
            checkQtyFromServer(data);
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        // checkQtyFromServer(data);
        return true;
      },
      onDone: (String data) async {
        print('------- onDone: $data');

        // orderHistory DB에 추가
        dynamic json1 = await springConnecter(requestMapping: "/flutter/insertOrderHistory", parameter: "id=${widget.loginId}&ordertype=$ordertype&deliverytip=$deliverytip");
        var data1 = jsonDecode(json1);
        dynamic json2 = await springConnecter(requestMapping: "/flutter/deleteAllCartById", parameter: "id=${widget.loginId}");
        var data2 = jsonDecode(json2);

        if((data1['result'] ==  'success') && (data2['result'] ==  'success'))
        {
          print("결제에 성공했습니다.");
        }
        print("테스트1");
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => DeliveryStatus(loginId: widget.loginId,),
            transitionDuration: const Duration(seconds: 0),
          ),
        );

      },
    );      
    print("테스트2");
  } 
}