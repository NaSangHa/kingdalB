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
    <link rel="stylesheet" type="text/css" href="/css/cart.css">
    <!-- js 링크 (주소 API) -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
    <script type="text/javascript" src="/js/addressAPI.js"></script>
    <script type="text/javascript" src="/js/cart.js"></script>
    <!-- BootPay -->
	<script src="https://cdn.bootpay.co.kr/js/bootpay-3.3.1.min.js" type="application/javascript"></script>
    
	<title></title>
	
	<script>
		$(document).ready(function() {
			
			if("${deliveryStatus}" != "")
			{
				// alert("배달 정보가 있습니다.");
				$("#alertDelivery").css("display", "block");
			}
			
			if("${restaurant.rlogo }" == "")
			{
				$("#cartArea").remove();
				$("#emptyCotent").css("display", "block")
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
                        <div class="text-center rightNavProfileImg"><img src="/upload/${loginMember.profileimg }" alt=""></div>
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
    
    <!-- 장바구니 타이틀 -->
    <div class="container-fluid ">
        <div class="row align-items-center justify-content-center ">
            <div class="col text-center pageTitle ">장바구니</div>
        </div>
    </div>

    <!-- 장바구니 내용 -->
    <div class="container-fluid ">
        <div class="row justify-content-center " id="cartArea">
            <!-- 왼쪽 -->
            <div class="col-3 orderContentWrap">
                <div class="col row align-items-center orderMethodWrap">
                    <div class="col currentOrderMethod"><span id="currentOrderMethod">배달</span>로 주문</div>
                    <div class="col-4 text-center secondOrderMethod" onclick="chageOrderMethod()"><span id="secondOrderMethod">포장</span>으로 변경</div>
                </div>
                <div class="orderAddressWrap">
                    <div class="orderAddresstitle">주소</div>
                    <div class="row orderAddress">
                        <button class="col text-start" id="userAddress_cart" data-bs-toggle="modal" data-bs-target="#addressModal">${userAddress }</button>
                        <div class="col-1 text-center orderAddressSelectBtn"><img src="/upload/bottom.png" alt=""></div>
                    </div>
                </div>
                <div class="row orderPriceWrap">
                    <div class="col orderPriceTitle">총 주문금액</div>
                    <div class="col text-end orderPrice" id="orderPrice">${orderPrice} 원</div>
                </div>
                <div class="row orderPriceWrap">
                    <div class="col orderPriceTitle">배달팁</div>
                    <div class="col text-end orderPrice" id="deliverytip">${deliverytip} 원</div>
                </div>
                <div class="row orderPriceWrap">
                    <div class="col orderPriceTitle">결제예정금액</div>
                    <div class="col text-end orderPrice orderFinalPrcie" id="totalprice">${totalprice} 원</div>
                </div>
                <div class="row align-items-center orderBtnWrap">
                    <div class="text-center orderBtn" id="orderBtn" onclick="pay('${restaurant.rid }')">${totalprice } 원 주문하기</div>
                </div>
            </div>

            <!-- 오른쪽 -->
            <div class="col-6">
                <!-- 식당로고, 이름 -->
                <div class="col row align-items-center cartRestaurantHead">
                    <div class="col-2 cartRestaurantLogo ">
                        <img src="/upload/${restaurant.rlogo }" alt="">
                    </div>
                    <div class="col cartRestaurantName ">${restaurant.rtitle }</div>
                </div>
                <!-- 반복구간 -->
                <c:forEach items="${cartContents}" var="dto">
                <div class="col row align-items-center cartFoodImgWrap" id="cartContent${dto.cid }" onclick="deleteCartContent('${dto.cid}')">
                    <div class="col-3 text-center cartFoodImg ">
                        <img src="/upload/${dto.mimg }" alt="">
                    </div>
                    <div class="col  cartFoodContentWrap">
                        <div class="row align-items-center">
                            <div class="col cartFoodName ">${dto.mtitle }</div>
                            <div class="col text-end cartFoodDel">
                                <img src="/upload/close.png" alt="" onclick="">
                            </div>
                        </div>
                        <div class="cartFoodOption">${dto.moption }</div>
                        <div class="row align-items-center">
                            <div class="col cartFoodCount">수량 : ${dto.mcount }</div>
                            <div class="col text-end cartFoodPrice">${dto.mprice_str }원</div>
                        </div>
                    </div>
                </div>
                </c:forEach>
                <!-- ---------------- -->
            </div>
        </div>
        
        <!-- Empty Content -->
        <div class="text-center emptyContent" id="emptyCotent">
            <img src="/upload/empty.png" alt="">
            <div>장바구니가 비어있어요</div>
        </div>
    </div>

    
    
    <div class="bottomSpace"></div>
	<!-- ---------------------------------------------------------------------------------------------------------------------------------------------------- -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-1.12.1.min.js"></script>
</body>
</html>