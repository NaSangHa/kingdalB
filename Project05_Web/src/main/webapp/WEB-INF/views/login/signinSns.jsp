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
    <link rel="stylesheet" type="text/css" href="/css/SigninSns.css">
	<title></title>

<style>
</style>
<script>
	$(document).ready(function() {	
		
	});
	
	// 인증번호 전송 전 전화번호 체크
	function phoneCheck() {
		
		var queryString = $('#signinSnsForm').serialize();
		
		$.ajax({
			url : '/login/authorNumberProcess',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {	
				
				var result = JSON.parse(json);

				$('#phoneError').text(result.phone);
			
				if(result.phone == "")
				{
					sendAuthorNumber();
				}
				
			}
		});
	}
	
	// 인증번호 전송
	function sendAuthorNumber() {
		
		var queryString = $('#signinSnsForm').serialize();
		
		$.ajax({
			url : '/login/sendAuthorNumber',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {
				alert(json);
			}
		});
	}
	
	
	// 회원가입 입력 폼 체크
	function formCheck() {
		
		var queryString = $('#signinSnsForm').serialize();
		
		$.ajax({
			url : '/login/signinSnsProcess',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {	
				
				var result = JSON.parse(json);

				$('#authorNumberError').text(result.authorNumber);
				
				if(result.authorNumber == "")
				{
					alert("회원가입 성공");
					signinSnsOk();
				}

			}
		});
	}
	
	// 회원가입 진행 
	function signinSnsOk() {
		
		var queryString = $('#signinSnsForm').serialize();
		
		$.ajax({
			url : '/login/signinSnsOk',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {
				location.href="/login/login";
			}
		});
		
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
                    <div class="text-start leftNavContent ">${userAddress }</div>
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

    <!-- SNS 회원가입 타이틀 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col">
                <div class="col text-center pageTitle ">SNS 회원가입</div>
                <div class="col text-center pageSubTitle ">추가 정보를 입력해주세요.</div>
            </div>
        </div>
    </div>

    <!-- 입력 폼 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center  ">
            <div class="col-4 ">
                <form name="signinSnsForm" id="signinSnsForm">
                    <input type="hidden" id="email" name="email" value="${snsEmail }">
                    <input type="hidden" id="type" name="type" value="${snsType }">
                    <input type="hidden" id="pw" name="pw" value="1234">
                    <!-- 이메일 -->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="email" class="form-label formLabel">이메일</label>
                            <div class="emailText">${snsEmail }</div>
                        </div>
                    </div>
                    <!-- 전화번호 확인 -->
                    <div class="col ">
                        <div class="mb-3">
                            <label for="phone" class="form-label formLabel">전화번호</label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="숫자만 입력해주세요." >
                            <div class="errorText" id="phoneError"></div>
                        </div>
                    </div>
                    <!-- 인증번호 -->
                    <div class="col row align-items-center ">
                        <div class="col ">
                            <div class="mb-3">
                                <label for="authorNumber" class="form-label formLabel">인증번호</label>
                                <input type="text" class="form-control" id="authorNumber" name="authorNumber" placeholder="인증번호 4자리" >
                                <div class="errorText" id="authorNumberError"></div>
                            </div>
                        </div>
                        <div class="col-4 ">
                            <div class="authorSendBtn" onclick="phoneCheck()">인증번호 전송</div>
                            <div class="errorText"></div>
                        </div>
                    </div>
                </form>
                <!-- 회원가입 버튼 -->
                <div class="col ">
                    <div class="SigninBtn" onclick="formCheck()">회원가입</div>
                </div>
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