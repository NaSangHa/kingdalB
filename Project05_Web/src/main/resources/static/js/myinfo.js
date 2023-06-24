$(document).ready(function() {	
	$("#myInfo").addClass("selectMenu");
});


function getNicknameForm(nickname) {
	
	var queryString = "nickname=" + nickname; 
		
	$.ajax({
		url : '/member/getNicknameForm',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			$(".nickName").html(json);
			
		}
	});	
}

// 프로필 미리보기
function changeimg(event) {
	var reader = new FileReader();
	
    reader.onload = function(e) {
        $("#profileimgViewer").attr("src", e.target.result);
    }
    reader.readAsDataURL(event.target.files[0]);
}


function modifyMyInfo() {
	
	if($("#nickname").val().length == 0)
	{
		return;
	}
	 
	event.preventDefault();          
    var form = $('#modifyMyInfoForm')[0];  	    
    var data = new FormData(form);  	   
    
    $.ajax({             
    	type: "POST",          
        enctype: 'multipart/form-data',  
        url: "/member/modifyMyInfo",        
        data: data,          
        processData: false,    
        contentType: false,      
        cache: false,           
        timeout: 600000,       
        success: function (data) {
			
			
        	var json = JSON.parse(data);
        	
        	$(".nickName").html(json.content);
        	
        	if(json.result == "1")
        	{
				// alert("회원정보가 수정되었습니다.")
			}
			else
			{
				$("#navProfileimg").attr("src", "/upload/"+json.profileimg);
				// alert("회원정보가 수정되었습니다.")
			}
        	
        },     
	}); 	
}

function getMyInfoPage() {
	
	$.ajax({
		url : '/member/getMyInfoPage',
		type : 'POST',
		data : "",
		dataType : 'text',
		success : function(json) {
			
			$(".unSelectMenu").removeClass("selectMenu");
			$("#myInfo").addClass("selectMenu");
			
			$(".myInfoContentWrap").html(json);
		}
	});		
}

// -----------------------------------------------------------------------------------

function getManageAddressPage() {
	
	$.ajax({
		url : '/member/getManageAddressPage',
		type : 'POST',
		data : "",
		dataType : 'text',
		success : function(json) {
			
			$(".unSelectMenu").removeClass("selectMenu");
			$("#manageAddress").addClass("selectMenu");
			
			$(".myInfoContentWrap").html(json);
		}
	});		
}

function addressSearch_myInfo() {
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
            
            $("#addr1_myInfo").val(data.address);
            $("#addr2_myInfo").focus();            
        }
    }).open();
}

// 주소 추가 전 폼 체크
function addressFormCheck_myInfo() {
	
	if(($('#addr1_myInfo').val().length == 0) || ($('#addr2_myInfo').val().length == 0)) 
	{
	 	return
	}
	else
	{
		submitAddressForm_myInfo();
	}
	
}

function submitAddressForm_myInfo() {
		
	var queryString = $('#myInfoAddressForm').serialize();
	
	$.ajax({
		url : '/member/insertAddress_myInfo',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			$("#addr0_myInfo").val("");
			$("#addr1_myInfo").val("");
			$("#addr2_myInfo").val("");
			
			$(".adapt").text("")
			$(".myInfoContentHead").after(result.addressList);
			$("#userAddress").text(result.navAddress);
			$("#myinfoAddressModal").modal('hide');
			
			// Nav
			$(".addressAdapt").text("")
			$("#addAdressArea").after(result.navAddressList);
			
					
		}
	});	
}

function deleteAddress(aid) {
	
	var queryString = "aid="+aid;
	
	$.ajax({
		url : '/member/deleteAddress',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			if(json == "")
			{				
				$("#addrCard"+aid).remove()
				$("#modalAddress"+aid).remove()
				
			}
			else
			{
				alert(json);
			}
			
			
			
					
		}
	});		
}
//--------------------------------------------------------------------
function getOrderHistoryPage() {
	
	$.ajax({
		url : '/member/getOrderHistoryPage',
		type : 'POST',
		data : "",
		dataType : 'text',
		success : function(json) {
			
			$(".myInfoContentWrap").html(json);
			$(".unSelectMenu").removeClass("selectMenu");
			$("#orderHistory").addClass("selectMenu");
		}
	});		
}


function deleteOrderHistory(orderid)
{
	// alert(orderid + "번 주문내역을 삭제합니다.");
	
	var queryString = "orderid="+orderid;
	
	$.ajax({
		url : '/member/deleteOrderHistory',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			alert(json)
			$("#orderHistoryCard"+orderid).remove();
		}
	});	
}

function getOrderDetailModal(orderid){
	
	var queryString = "orderid=" + orderid;
	
	$.ajax({
		url : '/member/getOrderDetailModal',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			$("#orderhistoryModalBody").html(json);
			
		}
	});		
	
	
}













