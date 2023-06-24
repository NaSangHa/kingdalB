import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project05/Component/MainViewModel.dart';
import 'package:project05/Component/kakao_login.dart';
import 'package:project05/Component/login_platform.dart';
import 'package:project05/Main/main_screen.dart';
import 'package:project05/Component/appbarLocation.dart';
import 'package:project05/Component/appbarBasic.dart';
import 'package:project05/Component/bottomnavigationbar.dart';
import 'package:project05/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email'
  ]
);



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();
    logout_google();
    print('구글 로그인 초기값 : $currentUser');
    // 구글 로그인
    // _googleSignIn.onCurrentUserChanged.listen((account) {
    //     print('account : $account');    
    //     currentUser = account;
    //  });
    // _googleSignIn.signInSilently();
    

  }
  
  // 구글 로그인
  GoogleSignInAccount? currentUser;
  var gmail = "";

  // 카카오 로그인
  final kakao = MainViewModel(KakaoLogin());

  // 네이버 로그인
  // LoginPlatform loginPlatform = LoginPlatform.none;
  // var naverMail = "";

  
  final emailText = TextEditingController();
  final pwText = TextEditingController();


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarBasic(context, "로그인"),
      body: ListView(
        children: [
          // 로고
          InkWell(
            onTap: () async {
              print("SNS 계정을 로그아웃 합니다.");
              // 구글 로그아웃
              logout_google();
              // 카카오 로그아웃
              await kakao.logout();
              // 네이버 로그아웃
              signOut();
            },
            child: Container(
              // decoration: BoxDecoration(color: Colors.amber),
              margin: EdgeInsets.fromLTRB(0, 75, 0, 20),
              child: Image.asset(
                "assets/images/logo2.png",
                height: 100,
              ),
            ),
          ),
          // 이메일
          Container(
            // decoration: BoxDecoration(color: Colors.amber),
            margin: EdgeInsets.fromLTRB(30, 10, 30, 20),
            child: TextField(
              controller: emailText,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "  test@example.com",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          // 비밀번호
          Container(
            // decoration: BoxDecoration(color: Colors.amber),
            margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: TextField(
              obscureText: true,
              controller: pwText,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "  Password",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          // 로그인버튼
          Container(
            // decoration: BoxDecoration(color: Colors.amber),
            margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
            height: 50,
            child: ElevatedButton(
              child: Text("로그인", style: TextStyle(fontSize: 18, color: Colors.white),),
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              ),
              onPressed: () async {
                
                print("로그인 버튼이 눌렸습니다.");
                
                String json = await springConnecter(requestMapping: "/j_spring_security_check", parameter: "email=${emailText.text}&pw=${pwText.text}&status=flutter");
                if(json == "")
                {
                  print("로그인되었습니다.");
                  String member_json = await springConnecter(requestMapping: "/flutter/getOneMemberByET", parameter: "email=${emailText.text}&type=normal&status=flutter");
                  String id = jsonDecode(member_json)['id'];
                  
                  print("id : $id" );
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Main(bottomNavIndex: 0, loginId: id,)), 
                  );
                }
                else
                {
                  callSnackBar(context, msg: "사용자 정보를 확인해주세요.");
                  print("로그인에 실패하였습니다.");
                }

              },
            ),
          ),
          // OR
          Container(
            height: 100,
            alignment: Alignment.center,
            child: Text("or", style: TextStyle(fontSize: 15),),
          ),
          // SNS 로그인
          Container(
            // decoration: BoxDecoration(color: Colors.amber),
            height: 75,
            child: Row(
              children: [
                Spacer(flex: 1,),
                // 구글
                Expanded(
                  flex: 3,
                  child: InkWell(
                    child: Image.asset("assets/images/sns_circle_google.png"),
                    splashColor: Colors.transparent,
                    onTap: () async {
                      print("구글 로그인 버튼 눌림");

                      // 구글 로그인
                      await login_google();
                      print('gmail : $gmail');
                      dynamic json = await springConnecter(requestMapping: "/flutter/snsLogin", parameter: "email=$gmail&type=google");
                      var data = jsonDecode(json);
                      if(data['result'] == 'success')
                      {
                        var id = data['desc'];
                        print('구글로 로그인 합니다.');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Main(bottomNavIndex: 0, loginId: id,)), 
                        );
                      }
                      else
                      {
                        print("가입되어 있지 않은 SNS회원 입니다.");
                      }
                      
                      
                      setState(() { });
                    },
                  )
                ),
                Spacer(flex: 1,),
                // 카카오
                Expanded(
                  flex: 3,
                  child: InkWell(
                    child: Image.asset("assets/images/sns_circle_kakao.png"),
                    splashColor: Colors.transparent,
                    onTap: () async {
                      print("카카오 로그인 버튼 눌림");

                      // 카카오 로그인
                      var loginResult =  await kakao.login();
                      var kakaoMail = kakao.user!.kakaoAccount!.email;
                      print('kakaoMail : $kakaoMail');
                      dynamic json = await springConnecter(requestMapping: "/flutter/snsLogin", parameter: "email=$kakaoMail&type=kakao");
                      var data = jsonDecode(json);
                      if(data['result'] == 'success')
                      {
                        var id = data['desc'];
                        print('카카오로 로그인 합니다.');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Main(bottomNavIndex: 0, loginId: id,)), 
                        );
                      }
                      else
                      {
                        print("가입되어 있지 않은 SNS회원 입니다.");
                      }


                    },
                  )
                ),
                Spacer(flex: 1,),
                // 네이버
                Expanded(
                  flex: 3,
                  child: InkWell(
                    child: Image.asset("assets/images/sns_circle_naver.png"),
                    splashColor: Colors.transparent,
                    onTap: () async {
                      print("네이버 로그인 버튼 눌림");
                      String naverMail = await signInWithNaver();
                      print("$naverMail");
                      
                      dynamic json = await springConnecter(requestMapping: "/flutter/snsLogin", parameter: "email=$naverMail&type=naver");
                      print('네이버 로그인 프로세스 : ${json}');
                      var data = jsonDecode(json);
                      if(data['result'] == 'success')
                      {
                        var id = data['desc'];
                        print('네이버로 로그인 합니다.');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Main(bottomNavIndex: 0, loginId: id,)), 
                        );
                        
                      }
                      else
                      {
                        print("가입되어 있지 않은 SNS회원 입니다.");
                      }

                    },
                  )
                ),
                Spacer(flex: 1,),
              ],
            )
          ),
          // 회원가입
          Container(
            // decoration: BoxDecoration(color: Colors.amber),
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(30, 50, 30, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("계정이 없으신가요?  "),
                InkWell(
                  child: Text("회원가입", style: TextStyle(fontSize: 20, color: kPrimaryColor,),),
                  onTap: () {
                    print("회원가입 버튼이 눌렸습니다");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => Signin()),
                    // );
                  },
                )
              ],
            )
          )
        ],
      )
    ); 
  }


  // 구글 - 로그인
  Future<void> login_google() async {
    await _googleSignIn.signIn();
    print('확인1 : ${_googleSignIn.currentUser!.email}');
    gmail = _googleSignIn.currentUser!.email;
    setState(() {});
    
  }
  // 구글 - 로그아웃
  void logout_google() {
    _googleSignIn.signOut();
    // _googleSignIn.disconnect();
    setState(() { });
  }

  // 네이버 - 로그인
  Future<String> signInWithNaver() async {
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      return '${result.account.email}';
    }
    return "";
    
  }

  // 네이버 - 로그아웃
  void signOut() async {
    FlutterNaverLogin.logOut();
  }
}