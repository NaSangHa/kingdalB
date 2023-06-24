import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:project05/Component/social_login.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try
    {
      bool isInstalled = await isKakaoTalkInstalled();
      // 카카오톡이 설치되어있으면
      if(isInstalled) 
      {
        try
        {
          print("카카오톡으로 로그인 합니다.");
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        }
        catch (e)
        {
          print("카카오 로그인 에러1");
          return false;
        }
      }
      // 카카오톡이 설치되어 있지 않으면
      else
      {
        try
        {
          print("카카오 계정으로 로그인 합니다.");
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        }
        catch (e)
        {
          print("카카오 로그인 에러2");
          return false;
        }
      }
    }
    catch(e)
    {
      print("카카오 로그인 에러3");
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try
    {
      await UserApi.instance.unlink();
      return true;
    }
    catch (error)
    {
      return false;
    }
  }

}