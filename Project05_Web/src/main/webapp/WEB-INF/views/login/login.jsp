<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!-- BootStrap-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <!-- JQuery -->
    <script src="http://code.jquery.com/jquery.js"></script>
    <!-- Google Font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <!-- css 링크 -->
    <link rel="stylesheet" type="text/css" href="/css/Navbar.css">
    <link rel="stylesheet" type="text/css" href="/css/Login.css">
	<title></title>
	
<style>
</style>
<script>
	$(document).ready(function() {	
		
	});
	
	function formCheck() {
		if(($("#email").val().length == 0) || ($("#pw").val().length == 0)) 
		{
			// alert("이메일 또는 비밀번호를 입력하지 않았습니다.");
			$("#errorText").text("사용자 정보를 확인해주세요.")
		}
		else
		{
			// submitForm();
			$("#loginForm").submit();
		}
	}
</script>
</head>
<body>
    <!-- 상단 네비게이션 바 -->
    <nav class="container-fluid">
        <div class="row align-items-center navWrap ">
            <!-- 주소 -->
            <div class="col-5 justify-content-start">
                <div class="leftNavMenu" onclick="">
                    <div class="text-end leftNavIcon "><img src="/upload/gps.png" alt=""></div>
                    <div class="text-start leftNavContent ">어디로 배달할까요?</div>
                    <div class="text-end leftNavIcon "><img src="/upload/bottom.png" alt=""></div>
                </div>
            </div>
            <!-- 로고 -->
            <div class="col-2 text-center ">
                <a href="/"><img src="/upload/logo2.png" class="navLogo" alt=""></a>
            </div>
            <!-- 로그인, 찜, 장바구니 -->
            <div class="col-5 text-center rightNavMenu ">
                <div class="col"></div>
                <div class="col-2 ">
                    <button class="rightNavMenuBtn" type="button" id="dropdownMenu2" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="text-center rightNavProfileImg"><img src="/upload/defaultprofile.png" alt=""></div>
                        <div class="text-center rightNavIconName ">로그인</div>    
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu2">
                    	
                        <li><button class="dropdown-item" type="button" onclick="location.href='/login/login'" id="loginBtn">로그인</button></li>
                        <li><button class="dropdown-item" type="button" onclick="location.href='/login/signin'" id="signinBtn">회원가입</button></li>
                    </ul>
                </div>
                <div class="col-2 ">
                    <a href="/member/like">
                        <div class="text-center "><img src="/upload/heart.png" class="rightNavIcon " alt=""></div>
                        <div class="text-center rightNavIconName ">찜</div>
                    </a>
                </div>
                <div class="col-2 ">
                    <a href="/member/cart">
                        <div class="text-center"><img src="/upload/cart.png" class="rightNavIcon " alt=""></div>
                        <div class="text-center rightNavIconName ">장바구니</div>
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- 로그인 타이틀 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col text-center pageTitle ">로그인</div>
        </div>
    </div>

    <!-- 입력 폼 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center  ">
            <div class="col-4 ">
            	<c:url value="/j_spring_security_check" var="loginUrl" />
                <form action="${loginUrl }" method="post" id="loginForm" name="loginForm">
                    <!-- 이메일 -->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="email" class="form-label formLabel">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="test@example.com" >
                        </div>
                    </div>
                    <!-- 비밀번호 -->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="pw" class="form-label formLabel">비밀번호</label>
                            <input type="password" class="form-control" id="pw" name="pw" placeholder="Password" >
                        </div>
                    </div>
                </form>
                <!-- 에러 메세지 -->
                <div class="col ">
                    <div class="errorText" id="errorText">${errormsg }</div>
                </div>
                <!-- 로그인 버트 -->
                <div class="col ">
                    <div class="loginBtn" onclick="formCheck()">로그인</div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 비밀번호 초기화 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center resetPasswordWrap">
            <div class="col-10 row justify-content-center">
                <div class="col-2 text-center restPasswordBtn" onclick="location.href='/login/findPassword'">
                    비밀번호 찾기
                </div>
            </div>
        </div>
    </div>
    
    <!-- SNS로그인 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center snsLoginBtnWrap">
            <div class="col-6 row">
                <div class="col snsLoginBtn " ><img src="/upload/sns_logo_google.png" alt="" onclick="location.href='/oauth2/authorization/google'"></div>
                <div class="col snsLoginBtn " ><img src="/upload/sns_logo_kakao.png" alt="" onclick="location.href='/oauth2/authorization/kakao'"></div>
                <div class="col snsLoginBtn " ><img src="/upload/sns_logo_naver.png" alt="" onclick="location.href='/oauth2/authorization/naver'"></div>
            </div>
        </div>
    </div>

    <!-- 회원가입 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center">
            <div class="col-6 signInWrap ">
                계정이 없다면? <span class="signInBtn" onclick="location.href='/login/signin'">회원가입</span>
            </div>
        </div>
    </div>
     
    
    <div class="bottomSpace"></div>
	<!-- ---------------------------------------------------------------------------------------------------------------------------------------------------- -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>
</body>
</html>