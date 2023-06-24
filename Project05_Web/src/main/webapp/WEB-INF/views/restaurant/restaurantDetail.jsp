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
    <link rel="stylesheet" type="text/css" href="/css/RestaurantDetail.css">
    <!-- js 링크 (주소 API) -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> 
    <script type="text/javascript" src="/js/addressAPI.js"></script>
    <script type="text/javascript" src="/js/restaurantDetail.js"></script>
    
	<title></title>
	
	<script>
		$(document).ready(function() {
			if("${deliveryStatus}" != "")
			{
				// alert("배달 정보가 있습니다.");
				$("#alertDelivery").css("display", "block");
			}
			
			$("#menuTitleBtn").addClass("restaurantMenuBtn_select");
			
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

    <div class="container-fluid ">
        <!-- 식당정보1 -로고, 대표사진, 별정 등..... -->
        <div class="row align-items-center justify-content-center">
            <div class="col-8 contentArea">
                <!-- 식당로고, 이름, 좋아요 -->
                <div class="row align-items-center justify-content-center">
                    <div class="col-2 restaurantLogo text-center "><img src="/upload/${restaurantCard.rlogo }" alt=""></div>
                    <div class="col restaurantName ">${restaurantCard.rtitle }</div>
                    <div class="col-1 restaurantLike "><img src="/upload/${likeBtn }" alt="" id="likeBtn" onclick="likeBtnClick('${restaurantCard.rid }')"></div>
                </div>
                <!-- 대표사진, 별점정보 -->
                <div class="row align-items-center justify-content-center restaurantTitleStartWrap ">
                    <!-- 대표사진 -->
                    <div class="col-6 restaurantTitleImg "><img src="/upload/${restaurantCard.rtitleimg }" alt=""></div>
                    <!-- 별점 -->
                    <div class="col text-center ">
                        <div class="col restaurantStar ">
                            <img src="/upload/star.png" alt="">
                            ${star.avgstar }
                        </div>
                        <div class="col row justify-content-center starGaugeWrap ">
                            5점 
                            <div class="col-5 starGaugeDefault " ><div class="starGauge" style="width: ${star.ratio5 }%;"></div></div>
                            <div class="col-1 text-start">${star.star5 }</div>
                        </div>
                        <div class="col row justify-content-center starGaugeWrap ">
                            4점 
                            <div class="col-5 starGaugeDefault " ><div class="starGauge" style="width: ${star.ratio4 }%;"></div></div>
                            <div class="col-1 text-start">${star.star4 }</div>
                        </div>
                        <div class="col row justify-content-center starGaugeWrap ">
                            3점 
                            <div class="col-5 starGaugeDefault " ><div class="starGauge" style="width: ${star.ratio3 }%;"></div></div>
                            <div class="col-1 text-start">${star.star3 }</div>
                        </div>
                        <div class="col row justify-content-center starGaugeWrap ">
                            2점 
                            <div class="col-5 starGaugeDefault " ><div class="starGauge" style="width: ${star.ratio2 }%;"></div></div>
                            <div class="col-1 text-start">${star.star2 }</div>
                        </div>
                        <div class="col row justify-content-center starGaugeWrap ">
                            1점 
                            <div class="col-5 starGaugeDefault " ><div class="starGauge" style="width: ${star.ratio1 }%;"></div></div>
                            <div class="col-1 text-start">${star.star1 }</div>
                        </div>
                    </div>
                </div>
                <!-- 가게정보 타이틀 -->
                <div class="col restaurantInfoTitle">
                    가게 정보
                </div>
                <!-- 가게정보 -->
                <div class="col restaurantInfoWrap ">
                    <div class="row">
                        <div class="col row  restaurantInfo">
                            <div class="col-3">최소주문금액</div>
                            <div class="col">${restaurantCard.rminprice }원</div>
                        </div>
                        <div class="col row  restaurantInfo">
                            <div class="col-3">결제 방법</div>
                            <div class="col">${restaurantCard.rpaymethod }</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col row  restaurantInfo">
                            <div class="col-3">배달시간</div>
                            <div class="col">${restaurantCard.rdeliverytime1 }분 ~ ${restaurantCard.rdeliverytime2 }분 소요예상</div>
                        </div>
                        <div class="col row  restaurantInfo">
                            <div class="col-3">배달팁</div>
                            <div class="col">${restaurantCard.rdeliverytip1 }원 ~ ${restaurantCard.rdeliverytip2 }원</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- 메뉴/리뷰 버튼 -->
        <div class="row align-items-center justify-content-center">
            <div class="col-8">
                <div class="row">
                    <div class="col text-center restaurantMenuBtn" id="menuTitleBtn" onclick="showMenuList('${restaurantCard.rid }')">메뉴</div>
                    <div class="col text-center restaurantMenuBtn" id="reviewTitleBtn" onclick="showReviewList('${restaurantCard.rid }')">리뷰</div>
                </div>
            </div>
        </div>

        <!-- 메뉴 리스트, 옵션 선택 -->
        <div class="row align-items-center justify-content-center">
            <div class="col-8 row " id="restaurantDetailContentArea">
                <!-- 메뉴리스트 -->
                <div class="col menuListWrap ">
                    <!-- 반복구간1 -->
                    <c:forEach items="${menus }" var="menus">
	                    <div class="col menuCategoryTitle ">${menus.key }</div>
	                    <!-- 반복구간2 -->
	                    <c:forEach items="${menus.value }" var="menu">
		                    <div class="col row align-items-center menuCard" id="menu${menu.mid }" onclick="showMenuOption('${menu.rid }', '${menu.mid }')">
		                        <!-- 메뉴사진 -->
		                        <div class="col menuImg">
		                            <img src="/upload/${menu.mimg }" alt="">
		                        </div>
		                        <!-- 메뉴정보 -->
		                        <div class="col">
		                            <div class="col text-end menuName">${menu.mtitle }</div>
		                            <div class="col text-end optionName" id="optionName${menu.mid }"></div>
		                            <div class="col row text-end priceName">
		                                <div class="col "><span id="menuPrice${menu.mid }">${menu.mprice }</span>원</div>
		                                <div class="col-3 addMenuBtn" id="addMenuBtn${menu.mid }" onclick="checkCartOtherRestaurant('${loginInfo}','${menu.rid }', '${menu.mid }')">
		                                	담기
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		                    
	                    <!------------------------------- Modal ---------------------------------->
						<div class="modal fade" id="confirmCartDouble${menu.mid }" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
						  <div class="modal-dialog">
						    <div class="modal-content">
						      <div class="modal-header">
						        <h5 class="modal-title" id="exampleModalLabel">알림</h5>
						        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						      </div>
					          <div class="modal-body">
					          	<div class="col text-center cdContent1">장바구니에는 같은 가게의 메뉴만 담을 수 있습니다.</div>
					            <div class="col text-center cdContent2">선택하신 메뉴를 장바구니에 담을 경우</div> 
					            <div class="col text-center cdContent2">이전에 담은 메뉴가 삭제됩니다.</div>
					          </div>
					          <div class="modal-footer">
					            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					            <button type="button" class="btn btn-primary chOkBtn" onclick="resetCart('${menu.rid }', '${menu.mid }')">담기</button>
					          </div>
						    </div>
						  </div>
						</div>
						<!------------------------------- Modal ---------------------------------->
						
	                    </c:forEach>
	                    <!-- ------------반복2 끝 -->
                    </c:forEach>
                    <!-- ---------반복 1 끝 -->
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