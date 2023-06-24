function deleteCartContent(cid) {
	
	var queryString = "cid=" + cid;
	
	$.ajax({
		url : '/member/deleteCartContent',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			$("#cartContent"+cid).remove();
			
			$("#orderPrice").text(result.orderPrice+" 원");
			$("#totalprice").text(result.orderPrice+" 원");
			$("#orderBtn").text(result.totalprice+" 원 주문하기");
		}
	});	
}

function chageOrderMethod() {
	var curMethod = $("#currentOrderMethod").text();
	var secMethod = $("#secondOrderMethod").text();
	
	$("#currentOrderMethod").text(secMethod);
	$("#secondOrderMethod").text(curMethod);
	
}

function pay(rid) {
  
  	 
  	var title = $(".cartRestaurantName").text();	// 주문식당 이름
  	var price = $("#totalprice").text();			//  최종 결제 금액
  	price = price.replace(" 원", "");
  	price = price.replace(",", "");
  	
  	var ordertype = $("#currentOrderMethod").text();	// 주문 타입
  	var deliverytip = $("#deliverytip").text();	// 주문 타입
  	deliverytip = deliverytip.replace(" 원", "");
  	deliverytip = deliverytip.replace(",", "");
  
    BootPay.request({
      price: price, //실제 결제되는 가격
 
      application_id: "632164d0cf9f6d001f6ce586",
 
      name: '후라이드 치킨', 		//결제창에서 보여질 이름
      pg: 'nicepay',
      //method: 'card', 					//결제수단, 입력하지 않으면 결제수단 선택부터 화면이 시작합니다.
      show_agree_window: 0, 			// 부트페이 정보 동의 창 보이기 여부
      items: [
          {
              item_name: title, //상품명
              qty: 1, 					//수량
              unique: '123', 			//해당 상품을 구분짓는 primary key
              price: price, 			//상품 단가
          }
      ],
      order_id: '고유order_id_1234', 	//고유 주문번호로, 생성하신 값을 보내주셔야 합니다.
  }).error(function (data) {
      //결제 진행시 에러가 발생하면 수행됩니다.
      console.log(data);
  }).cancel(function (data) {
      //결제가 취소되면 수행됩니다.
      console.log(data);
  }).close(function (data) {
      // 결제창이 닫힐때 수행됩니다. (성공,실패,취소에 상관없이 모두 수행됨)
      console.log(data);
  }).done(function (data) {
      //결제가 정상적으로 완료되면 수행됩니다
      //비즈니스 로직을 수행하기 전에 결제 유효성 검증을 하시길 추천합니다.
      orderSuccess(rid, ordertype, deliverytip);
      console.log(data);
  });    
  
}

function orderSuccess(rid, ordertype, deliverytip) {
	
	alert("결제가 정상적으로 처리 되었습니다.");
	
	var queryString = "rid=" + rid + "&ordertype=" + ordertype + "&deliverytip=" + deliverytip;
	
	$.ajax({
		url : '/order/orderSuccess',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			alert(json);
			
			location.href="/main"
		}
	});	
}

