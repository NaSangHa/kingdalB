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
    <link rel="stylesheet" type="text/css" href="/css/MyInfo.css">
    <!-- js 링크 (주소 API) -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
    <script type="text/javascript" src="/js/addressAPI.js"></script>
    <script type="text/javascript" src="/js/myinfo.js"></script>
	<title></title>
	<script>
		$(document).ready(function() {
			if("${deliveryStatus}" != "")
			{
				// alert("배달 정보가 있습니다.");
				$("#alertDelivery").css("display", "block");
			}
		});
	</script>
</head>
<body>
    <!-- 주문 현황 -->
    <div class="container-fluid alertDeliveryWrap1" id="alertDelivery">
        <div class="row">
            <div class="col text-center alertDelivery">
                ${deliveryMsg }
                <span onclick="location.href='/order/showDeliveryStatus?orderid=${deliveryStatus.orderid }'">배달현황보기</span>
            </div>
        </div>
    </div>
    <!-- 상단 네비게이션 바 -->
    <nav class="container-fluid">
        <div class="row align-items-center navWrap ">
            <!-- 주소 -->
            <div class="col-5 justify-content-start">
                <button class="leftNavMenu " id="addressBtn" data-bs-toggle="modal" data-bs-target="#addressModal" >
                    <div class="text-end leftNavIcon "><img src="/upload/gps.png" alt=""></div>
                    <div class="text-start leftNavContent " id="userAddress">${userAddress }</div>
                    <div class="text-end leftNavIcon "><img src="/upload/bottom.png" alt=""></div>
                </button>
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
                        <div class="text-center rightNavProfileImg"><img src="/upload/${loginMember.profileimg }" id="navProfileimg"  alt=""></div>
                        <div class="text-center rightNavIconName " onclick="">${loginMember.nickname }</div>    
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu2">
                        <li><button class="dropdown-item" type="button" onclick="location.href='/member/myinfo'" id="myInfoBtn">내정보</button></li>
                        <li><button class="dropdown-item" type="button" onclick="location.href='/logout'" id="logoutBtn">로그아웃</button></li>
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
    
    <!-- Modal -->
    <div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- 모달 헤드 -->
                <div class="modal-header">
                    <div class="modalHead" id="exampleModalLabel">주소 설정</div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <!-- 모달 바디 -->
                <div class="modal-body">
                    <div class="container-fluid">
                        <!-- 주소 검색 -->
                        <div class="row align-items-center ">
                        	<form id="addressForm" name="addressForm">
	                            <div class="col">
	                                <div class="col row align-items-center addAddressTitleWrap ">
	                                    <div class="col addAddressTitle ">주소 등록</div>
	                                    <div class="text-center addAddressBtn " onclick="addressFormCheck()">추가</div>
	                                </div>
	                                <div class="col row align-items-center addressSearchdWrap" onclick="addressSearch()">
	                                    <div class="col-1 text-center "><div class="text-center addressSearchIcon">
	                                        <img src="/upload/search.png" alt=""></div>
	                                    </div>
	                                    <div class="col addressSearchContent">지번, 도로명, 건물명으로 검색</div>
	                                </div>
	                                <div class="col row align-items-center addressInputWrap ">
	                                    <div class="col-2 addressInputTitle">주소</div>
	                                    <input type="text" class="col addressInput" id="addr1" name="addr1" placeholder="주소를 입력해주세요.">
	                                </div>
	                                <div class="col row align-items-center addressInputWrap ">
	                                    <div class="col-2 addressInputTitle">상세주소</div>
	                                    <input type="text" class="col addressInput" id="addr2" name="addr2" placeholder="상세 주소를 입력해주세요.">
	                                </div>
	                            </div>
                            </form>
                        </div>
                        
                        <div class="boundaryLine"></div>
                        <div id="addAdressArea"></div>
                        <!------------------------------ 반복구간 (내 주소 리스트) ------------------------------>
                        <c:forEach items="${addresses}" var="dto">
						<div class="col row align-items-center addressListWrap " id="modalAddress${dto.aid }" onclick="updateAdaptAddr('${dto.aid}')">
						    <div class="col-1 ">
						        <div class="addressIcon">
						            <img src="/upload/${dto.addrtype }.png" alt="">
						        </div>
						    </div>
						    <div class="col addressContentWrap ">
						        <div class="addressTitle">${dto.addrtitle }</div>
						        <div class="addressContent">${dto.mainaddr } ${dto.subaddr }</div>
						    </div>
						    <div class="col-2 text-center addressAdapt " id="addressAdapt${dto.aid }">
						     <c:set var="adapt" value="${dto.adapt }" />
						     <c:if test="${adapt eq 1}">
						     	적용중
						     </c:if>
						    </div>
						</div>
                        </c:forEach>
                        <!------------------------------  ------------------------------>
                    </div>
                </div>
            </div>
        </div>
    </div>
	<!-- --------------------------------------------------------------------------------------------------------------------------------------------- -->
    
    <!-- 프로필 사진, 닉네임 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col-8 text-center profileWrap ">
                <div class="col">
                    <div class="profileImg"><img src="/upload/${loginMember.profileimg }" id="profileimgViewer" alt=""></div>
                </div>
                <div class="col nickName">
                    ${loginMember.nickname }<img src="/upload/modify.png" alt="" onclick="getNicknameForm('${loginMember.nickname }')">
                </div>
            </div>
        </div>
    </div>

    <!-- 최근배달, 찜목록, 내가쓴리뷰 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col-5 row text-center myHistoryWrap ">
                <div class="col recentDeliveryWrap " onclick="">
                    <div class="recentDelivery ">${recentOrderCnt }</div>
                    <div class="recentDeliveryTitle ">최근주문</div>
                </div>
                <div class="col recentDeliveryWrap " onclick="">
                    <div class="recentDelivery">${likeCnt }</div>
                    <div class="recentDeliveryTitle">찜목록</div>
                </div>
                <div class="col recentDeliveryWrap " onclick="">
                    <div class="recentDelivery">${myReviewCnt }</div>
                    <div class="recentDeliveryTitle">내가 쓴 리뷰</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 주소관리, 주문내역 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col-8 row text-center ">
                <!-- 메뉴선택창 -->
                <div class="col-4 menuListWrap ">
                    <div class="unSelectMenu" id="myInfo" onclick="getMyInfoPage()">내 정보 관리</div>
                    <div class="unSelectMenu" id="manageAddress" onclick="getManageAddressPage()">주소 관리</div>
                    <div class="unSelectMenu" id="orderHistory" onclick="getOrderHistoryPage()">주문 내역</div>
                </div>
                <!-- 내용 창 -->
                <div class="col-8 myInfoContentWrap ">
                    <div class="col row justify-content-end myInfoContentHead">
                        <div class="col text-start myInfoContentTitle">내정보</div>
                    </div>
                    <div class="col  myInfoEmailWrap">
                        <div class="col text-start myInfoEmailTitle">이메일</div>
                        <div class="col text-start myInfoEmailContent">${loginMember.email }</div>
                    </div>
                    <div class="col  myInfoPhoneWrap">
                        <div class="col text-start myInfoPhoneTitle">전화번호</div>
                        <div class="col row align-items-center myInfoPhoneContent">
                            <div class="col text-start ">${loginMember.phone }</div>
                            <div class="col-1 text-center myInfoPhoneModify " onclick=""><!-- 수정 --></div>
                        </div>
                    </div>
                    <div class="col row justify-content-end resignMemberWrap">
                        <div class="col-2 text-center resignMemberBtn">회원탈퇴</div>
                    </div>
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