// 선택 된 메뉴 원래 가격
var orgPrice;
var orgMid;

// 찜 버튼
function likeBtnClick(rid) {
	event.stopPropagation();
	
	var imgSrc = $("#likeBtn").attr("src");
	var queryString = "rid=" + rid;
	
	if(imgSrc == "/upload/heart.png")
	{
		alert("로그인 해주세요.");
		location.href="/login/login";
		return
		
	}
	if(imgSrc == "/upload/like.png")
	{
		$.ajax({
			url : '/member/like/deleteLike',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {
				
				$("#likeBtn").attr("src", "/upload/like_not.png");
			}
		});	
		
	}
	if(imgSrc == "/upload/like_not.png")
	{
		$.ajax({
			url : '/member/like/insertLike',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {
				
				$("#likeBtn").attr("src", "/upload/like.png");
			}
		});			
	}
	
	
}

// 메뉴 리스트 가져오기
function showMenuList(rid) {
	// alert("메뉴 리스트를 가져옵니다.");
	
	var queryString = "rid=" + rid
	
	$.ajax({
		url : '/restaurant/showMenuList',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			$(".menuListWrap").html(result.content);
			$(".restaurantMenuBtn").removeClass("restaurantMenuBtn_select");
			$("#menuTitleBtn").addClass("restaurantMenuBtn_select");
						
		
		}
	});	
}


// 옵션 보기
function showMenuOption(rid, mid) {
	
	var queryString = "rid=" + rid + "&mid=" + mid;
	
	// 테두리 변경
	$(".menuCard").removeClass("menuCard_select");
	$("#menu"+mid).addClass("menuCard_select");
	
	// 담기버튼 추가
	$(".addMenuBtn").css("display", "none");
	$("#addMenuBtn"+mid).css("display", "block");
	
	// 기존 메뉴 초기화
	$(".optionListWrap").remove();
	$(".optionName").text("");
	$("#menuPrice"+orgMid).text(orgPrice);
	
	$.ajax({
		url : '/restaurant/showMenuOption',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			orgPrice = result.orignalPrice
			orgMid = result.orignalMid
			
			$("#menu"+mid).after(result.content);
					
		}
	});	

}

// 옵션 창 닫기
function removeOptionWindow() {
	$(".optionListWrap").remove();
	$(".menuCard").removeClass("menuCard_select");
	$(".addMenuBtn").css("display", "none");
	$(".optionName").text("");
	$("#menuPrice"+orgMid).text(orgPrice);
}


// 옵션 입력값 체크
function optionListener(rid, mid) {

	var queryString = "rid=" + rid + "&mid=" + mid + "&" + $('#menuOptionForm'+mid).serialize();
	
	$.ajax({
		url : '/restaurant/optionListener',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			//alert(result.totalPrice);
			//alert(result.addOption);
	
			$("#optionName"+mid).text(result.addOption);
			$("#menuPrice"+mid).text(result.totalPrice);
							
		}
	});	
}

// 카트에 식당 중복 체크
function checkCartOtherRestaurant(loginInfo, rid, mid) {
	event.stopPropagation();
	
	if(loginInfo == "")
	{
		alert("로그인 해주세요.")
		location.href="/login/login";
		return
	}
	
	var queryString = "rid=" + rid + "&mid=" + mid;
	
	$.ajax({
		url : '/order/checkCartOtherRestaurant',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			if(result.errorMsg != "")
			{
				$('#confirmCartDouble'+mid).modal('show');
				return
			}
			else
			{
				insertMenuCart(rid, mid)
			}
		
		}
	});	
}
// 장바구니 초기화
function resetCart(rid, mid) {
	
	var queryString = "rid=" + rid + "&mid=" + mid
	
	$.ajax({
		url : '/order/deleteCart',
		type : 'POST',
		data : '',
		dataType : 'text',
		success : function(json) {
			
			//var result = JSON.parse(json);
	
			insertMenuCart(rid, mid)
			
		}
	});	
}

// 장바구니에 담기
function insertMenuCart(rid, mid) {
	
	// alert(rid + "번 식당, " + mid + " 번 메뉴 카트에 담기")
	
	var queryString = "rid=" + rid + "&mid=" + mid + "&" + $('#menuOptionForm'+mid).serialize();
	
	$.ajax({
		url : '/order/insertMenuCart',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			//var result = JSON.parse(json);
			
			alert(json);
			$('#confirmCartDouble'+mid).modal('hide');
		
		}
	});	
}

// ---------------------------------------------------------------------------------------
// 리뷰 리스트 가져오기
function showReviewList(rid) {
	
	var queryString = "rid=" + rid
	
	$.ajax({
		url : '/restaurant/showReviewList',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			// alert(json);
			$(".menuListWrap").html(result.content);
			$(".restaurantMenuBtn").removeClass("restaurantMenuBtn_select");
			$("#reviewTitleBtn").addClass("restaurantMenuBtn_select");
			
		
		}
	});	
	
}
