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
    <link rel="stylesheet" type="text/css" href="/css/Footer.css">
    <link rel="stylesheet" type="text/css" href="/css/CategorySearch.css">
    <!-- js 링크 (주소 API) -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
    <script type="text/javascript" src="/js/addressAPI.js"></script>
    <script type="text/javascript" src="/js/categorySearch.js"></script>
    
	<title></title>
	
	<script>
		$(document).ready(function() {
			if("${deliveryStatus}" != "")
			{
				// alert("배달 정보가 있습니다.");
				$("#alertDelivery").css("display", "block");
			}
			
			$("#categoryIcon_${category }").addClass("categoryIcon_targer");
			
			if("${loginInfo}" == "")
			{
				$("#myInfoBtn").css("display", "none");
				$("#orderHistoryBtn").css("display", "none");
				$("#logoutBtn").css("display", "none");
				$("#addressModal").remove();
				
			}
			else
			{
				$("#loginBtn").css("display", "none");
				$("#signinBtn").css("display", "none");
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
                        <div class="text-center rightNavProfileImg"><img src="/upload/${loginMember.profileimg }${profileimg }" alt=""></div>
                        <div class="text-center rightNavIconName " onclick="">${loginMember.nickname }${nickname }</div>    
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu2">
                    	
                        <li><button class="dropdown-item" type="button" onclick="location.href='/login/login'" id="loginBtn">로그인</button></li>
                        <li><button class="dropdown-item" type="button" onclick="location.href='/login/signin'" id="signinBtn">회원가입</button></li>
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
                        <!-- ------------------------------------------------------------- -->
                    </div>
                </div>
            </div>
        </div>
    </div> 

	<!-- --------------------------------------------------------------------------------------------------------------------------------------------- -->

    <!-- 카테고리 -->
    <div class="container-fluid ">
        <div class="row align-items-center categoryWrap">
            <!-- 1. 한식 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=korean">
                    <div class="text-center "><img src="/upload/category_korean.png" id="categoryIcon_korean" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">한식</div>
                </a>
            </div>
            <!-- 2. 일식 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=japenese">
                    <div class="text-center "><img src="/upload/category_japenese.png" id="categoryIcon_japenese" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">일식</div>
                </a>
            </div>
            <!-- 3. 중식 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=chinese">
                    <div class="text-center "><img src="/upload/category_chinese.png" id="categoryIcon_chinese" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">중식</div>
                </a>
            </div>
            <!-- 4. 양식 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=west">
                    <div class="text-center "><img src="/upload/category_west.png" id="categoryIcon_west" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">양식</div>
                </a>
            </div>
            <!-- 5. 분식 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=snack">
                    <div class="text-center "><img src="/upload/category_snack.png" id="categoryIcon_snack" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">분식</div>
                </a>
            </div>
            <!-- 6. 치킨 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=chicken">
                    <div class="text-center "><img src="/upload/category_chicken.png" id="categoryIcon_chicken" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">치킨</div>
                </a>
            </div>
            <!-- 7. 햄버거 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=hamburger">
                    <div class="text-center "><img src="/upload/category_hamburger.png" id="categoryIcon_hamburger" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">햄버거</div>
                </a>
            </div>
            <!-- 8. 피자 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=pizza">
                    <div class="text-center "><img src="/upload/category_pizza.png" id="categoryIcon_pizza" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">피자</div>
                </a>
            </div>
            <!-- 9. 카페 -->
            <div class="col">
                <a href="/restaurant/categorySearch?category=cafe">
                    <div class="text-center "><img src="/upload/category_cafe.png" id="categoryIcon_cafe" class="categoryIcon" alt=""></div>
                    <div class="text-center categoryIconName ">카페</div>
                </a>
            </div>
        </div>
    </div>

    <!-- 카테고리 검색 결과 제목-->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center">
            <div class="col-5 align-items-center justify-content-center categorySearchTitle">
                <div class="categorySearchTitleImg "><img src="/upload/category_${category }.png" alt=""></div>
                <div class="categorySearchTitleText "><span>${category_kor }</span> 먹어볼까요?</div>
                
            </div>
        </div>
    </div>

    <!-- 카테고리 검색 결과 내용-->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center" >
            <!-- 반복구간 -->
             <c:forEach items="${restaurantCards}" var="dto">
            <div class="row col-5 categorySearchContentWrap " onclick="location.href='/restaurant/restaurantDetail?rid=${dto.rid}'">
                <!-- 왼쪽 -->
                <div class="col-4 categorySearchContentLogo text-center "><img src="/upload/${dto.rlogo }" alt=""></div>
                <!-- 오른쪽 -->
                <div class="col categorySearchContentLines">
                    <div class="row align-items-center  categorySearchContentLine1">
                        <div class="col categorySearchContentLine1_name">${dto.rtitle }</div>
                        <div class="col-4 categorySearchContentLine1_time">
                            <img src="/upload/clock.png" alt="">
                            ${dto.rdeliverytime1 }분~${dto.rdeliverytime2 }분
                        </div>
                    </div>
                    <div class="row categorySearchContentLine2 ">
                        <div class="col categorySearchContentLine2_star">
                            <img src="/upload/star.png" alt="">
                            ${dto.avgstar } (${dto.totalreview })
                        </div>
                        <div class="col categorySearchContentLine2_method">배달가능/포장가능</div>
                    </div>
                    <div class="row categorySearchContentLine3 ">
                        <div class="col">최소주문 ${dto.rminprice }원</div>
                        <div class="col">배달팁 ${dto.rdeliverytip1 }원~${dto.rdeliverytip2 }원</div>
                    </div>
                </div>
            </div>
            </c:forEach>
            <!-- --------------------------- -->
        </div>
    </div>

    <!-- 더보기 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center " >
            <div class="col-4 moreView " onclick="">
                더보기
                <img src="/upload/bottom.png" alt="">
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