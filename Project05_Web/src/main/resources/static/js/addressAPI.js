
function addressSearch() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            
            $("#addr1").val(data.address);
            $("#addr2").focus();            
        }
    }).open();
}

// 적용중인 주소 변경
function updateAdaptAddr(aid) {
	
	var queryString = "aid="+aid;
		
	$.ajax({
		url : '/member/updateAdaptAddr',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			$(".addressAdapt").text("")
			$("#addressAdapt"+aid).text("적용중")
			$("#userAddress").text(json);
			$("#userAddress_cart").text(json);
			
			$(".adapt").text("")
			$("#adapt"+aid).text("적용중")
			
			
		}
	});
}

// 주소 추가 전 폼 체크
function addressFormCheck() {
	
	if(($('#addr1').val().length == 0) || ($('#addr2').val().length == 0)) 
	{
	 	alert("입력값을 확인해주세요.");
		return
	}
	else
	{
		submitAddressForm();
	}
	
}

function submitAddressForm() {
		
	var queryString = $('#addressForm').serialize();
	
	$.ajax({
		url : '/member/insertAddress',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			$("#addr1").val("");
			$("#addr2").val("");
			
			$(".addressAdapt").text("")
			$(result.addressList).appendTo("#addAdressArea");
			$("#userAddress").text(result.navAddress);
			$("#userAddress_cart").text(result.navAddress);
			
					
		}
	});	
}




















