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
    <link rel="stylesheet" type="text/css" href="/css/FindPassword.css">
    <!-- js 링크 -->
    <script type="text/javascript" src="/js/findPassword.js"></script>
	<title></title>
	
<style>
</style>
<script>
	$(document).ready(function() {	
		
	});
	
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

    <!-- 페이지 타이틀 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col text-center pageTitle ">비밀번호 찾기</div>
        </div>
    </div>

    <div class="container-fluid ">
        <form id="findPasswordForm" name="findPasswordForm">
            <div class="col row justify-content-center">
            
                <!-- 비밀번호 찾기 1단계 -->
                <div class="col-4 findPasswordStepArea" id="findPasswordStep1Area">
                    <!-- 스텝 타이틀 -->
                    <div class="col resetPasswordTitle">
                        <span>Step1 </span>가입하신 이메일로 본인 인증을 해주세요.
                    </div>
                    <!-- 이메일 -->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="email" class="form-label formLabel">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" placeholder="test@example.com" >
                        </div>
                    </div>
                    <!-- 인증번호 -->
                    <div class="col row align-items-center ">
                        <div class="col ">
                            <div class="mb-3">
                                <label for="authorNumber" class="form-label formLabel">인증번호</label>
                                <input type="text" class="form-control" id="authorNumber" name="authorNumber" placeholder="인증번호 4자리" onkeyup="confrimAuthorNumber()">
                            </div>
                        </div>
                        <div class="col-4 ">
                            <div class="text-center authorSendBtn " onclick="findPasswordProcess()">인증번호 전송</div>
                        </div>
                    </div>
                    <div class="col text-center errorText" id="errorText1"></div>
                </div>
                
                <div class="col-1 text-center nextArrow" id="nextArrow">
                    <img src="/upload/right.png" alt="">
                </div>
                
                <!-- 비밀번호 찾기 2단계 -->
                <div class="col-4 findPasswordStepArea" id="findPasswordStep2Area">
                    <!-- 스텝 타이틀 -->
                    <div class="col resetPasswordTitle">
                        <span>Step2 </span>변경하실 비밀번호를 입력해주세요.
                    </div>
                    <!-- 비밀번호 -->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="pw" class="form-label formLabel">비밀번호</label>
                            <input type="password" class="form-control" id="pw" name="pw" placeholder="6자리 이상으로 입력해주세요." >
                        </div>
                    </div>
                    <!-- 비밀번호 확인-->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="pwCheck" class="form-label formLabel">비밀번호</label>
                            <input type="password" class="form-control" id="pwCheck" name="pwCheck" placeholder="6자리 이상으로 입력해주세요." >
                        </div>
                    </div>
                    <div class="col text-center errorText" id="errorText2"></div>
                    <div class="col text-center completeBtnWrap ">
                        <div class="completeBtn" onclick="updatePassword()">변경</div>
                    </div>
                </div>
            
            </div>
        </form>
    </div>

    <div class="bottomSpace"></div>
	<!-- ---------------------------------------------------------------------------------------------------------------------------------------------------- -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>
</body>
</html>