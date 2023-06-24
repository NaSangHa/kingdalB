import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project05/CategorySearch/Widget/tabs.dart';
import 'package:project05/Component/appbarLocation.dart';
import 'package:project05/MyCart/cart_screen.dart';
import 'package:project05/ResaurantDetail/restaurantdetail_screen.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySearch extends StatefulWidget {
  const CategorySearch({
    Key? key,
    required this.categoryIndex,
    required this.loginId,
    }) : super(key: key);

    final int categoryIndex;
    final String loginId;

  @override
  State<CategorySearch> createState() => _CategorySearchState();
}

class _CategorySearchState extends State<CategorySearch> with SingleTickerProviderStateMixin, RestorationMixin {
  
  @override
  void initState() {
    super.initState();

    // TabBar
    _tabController = TabController(initialIndex: 1, length: 9,vsync: this,);
    _tabController!.addListener(() {
      setState(() {
        tabIndex.value = _tabController!.index;
      });
    });
    
    // 카테고리별 식당카드
    getRestaurantCard_korean();
    getRestaurantCard_japenese();
    getRestaurantCard_chinese();
    getRestaurantCard_west();
    getRestaurantCard_snack();
    getRestaurantCard_chicken();
    getRestaurantCard_hamburger();
    getRestaurantCard_pizza();
    getRestaurantCard_cafe();

    // 주소
    getAllAddressById();
    
    setState(() {
      
    });
    
  }

  // TapBar
  TabController? _tabController;
  
  late final RestorableInt tabIndex;  // Tapbar Inital Index

  @override
  String get restorationId => 'tab_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    tabIndex = RestorableInt(widget.categoryIndex);
    registerForRestoration(tabIndex, 'tab_index');
    _tabController!.index = tabIndex.value;
  }
  
  // 카테고리별 식당카드
  List restaurantCards_korean = [];
  List restaurantCards_japenese = [];
  List restaurantCards_chinese = [];
  List restaurantCards_west = [];
  List restaurantCards_snack = [];
  List restaurantCards_chicken = [];
  List restaurantCards_hamburger = [];
  List restaurantCards_pizza = [];
  List restaurantCards_cafe = [];

  // 내 주소
  var myAddressList = [];
  var currentAddressTitle = "";
  // 구글 위치 찾기
  late Position _currentPosition;
  String currentAddress = '';
  String lat = '';
  String lon = '';
  

  //---------------------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    
    // BottomNavigatioBar
    int bottomNav = 0;
    
    // 카테고리 리스트
    final tabs = [
      "한식", "일식", "중식", "양식", "분식", "치킨", "햄버거", "피자", "카페"
    ];

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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: kPrimaryColor,
          // 선택된 메뉴
          labelColor: Colors.black,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          // 선택되지 않은 메뉴
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 16),
          tabs: [
            TapButton("한식"),
            TapButton("일식"),
            TapButton("중식"),
            TapButton("양식"),
            TapButton("분식"),
            TapButton("치킨"),
            TapButton("햄버거"),
            TapButton("피자"),
            TapButton("카페"),
          ],
        ),        
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 한식
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_korean.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_korean[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 일식
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_japenese.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_japenese[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 중식
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_chinese.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_chinese[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 양식
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_west.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_west[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 분식
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_snack.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_snack[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 치킨
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_chicken.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_chicken[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 햄버거
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_hamburger.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_hamburger[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 피자
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_pizza.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_pizza[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantDetail(bottomNavIndex: 0, 
                                                                                 loginId: widget.loginId, 
                                                                                 rid: restaurantCardDTO['rid'],)), 
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 카페
          ListView(
            children: [
              ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: restaurantCards_cafe.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {

                  var restaurantCardDTO = restaurantCards_cafe[index];

                  return InkWell(
                    onTap: () {
                      print("식당카드 눌림");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => RestaurantDetail()), 
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 120,
                      child: Row(
                        children: [
                          Container(
                            width: 100, height: 100,
                            // decoration: BoxDecoration(color: Colors.green.shade700),
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Image.network(
                                imgIPAddress + "${restaurantCardDTO['rlogo']}",
                                fit: BoxFit.fill,
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
                                    child: Text("${restaurantCardDTO['rtitle']}", style: TextStyle(fontSize: 18),)
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
                                              Text("${restaurantCardDTO['avgstar']}"),
                                              Text("(${restaurantCardDTO['totalreview']})")
                                            ]
                                          ),
                                        ),
                                        SizedBox(width: 15,),
                                        // 포장가능
                                        Container(
                                          child: Text("${restaurantCardDTO['rpaymethod']}"),
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
                                              Text("${restaurantCardDTO['rminprice']}원", style: TextStyle(fontSize: 13),)
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
                                              Text("${restaurantCardDTO['rdeliverytip1']}원~${restaurantCardDTO['rdeliverytip2']}원", style: TextStyle(fontSize: 13),)
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
                                        Text("${restaurantCardDTO['rdeliverytime1']}분~${restaurantCardDTO['rdeliverytime2']}분", style: TextStyle(fontSize: 13),),
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
            ] 
          ),
          // 하단 여백
        ],
      ),
      
      bottomNavigationBar: BottomNavBar(context, bottomNav, widget.loginId),
    );
  }


  // 카테고리 검색 - 한식
  void getRestaurantCard_korean() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=korean");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_korean = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 일식
  void getRestaurantCard_japenese() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=japenese");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_japenese = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 중식
  void getRestaurantCard_chinese() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=chinese");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_chinese = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 양식
  void getRestaurantCard_west() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=west");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_west = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 분식
  void getRestaurantCard_snack() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=snack");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_snack = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 치킨
  void getRestaurantCard_chicken() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=chicken");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_chicken = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 햄버거
  void getRestaurantCard_hamburger() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=hamburger");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_hamburger = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 피자
  void getRestaurantCard_pizza() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=pizza");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_pizza = data['result'];
    setState(() { });
  }
  // 카테고리 검색 - 카페
  void getRestaurantCard_cafe() async {
    
    dynamic json = await springConnecter(requestMapping: "/flutter/getRestaurantCardByRcategory", parameter: "rcategory=cafe");
    var data = jsonDecode(json);
    print(data['result']);
    restaurantCards_cafe = data['result'];
    setState(() { });
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