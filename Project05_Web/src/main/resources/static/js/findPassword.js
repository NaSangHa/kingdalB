function findPasswordProcess(){
	
	if($("#email").val().length == 0)
	{
		$("#errorText1").text("사용자 정보를 확인해주세요.")
		return;
	}
	
	var queryString = $('#findPasswordForm').serialize();
	
	$.ajax({
		url : '/login/findPasswordProcess',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			$("#errorText1").text(result.errorMsg);
			
			if(result.errorMsg == "")
			{
				sendAuthorNumber();
			}
			
		}
	});
}

function sendAuthorNumber() {
	
	var queryString = $('#findPasswordForm').serialize();
	
	$.ajax({
		url : '/login/sendAuthorNumber_findPassword',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(json) {
			
			var result = JSON.parse(json);
			
			alert(result.success);
			
		}
	});
}

function confrimAuthorNumber() {
	var queryString = $('#findPasswordForm').serialize();
	
	$.ajax({
		url : '/login/confrimAuthorNumber',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(data) {
			
			var json = JSON.parse(data);
			
			if(json.result == "success")
			{
				alert(json.desc);
				$("#errorText1").text(json.desc);
				$("#errorText1").css("color", "green")
				$("#nextArrow").css("display", "block")
				$("#findPasswordStep2Area").css("display", "block")
				$("#pw").focus();
				
			}
			
		}
	});
}

function updatePassword(){
	if($("#pw").val().length < 6)
	{
		$("#errorText2").text("비밀번호는 6자리 이상으로 입력해주세요");
		return
	}
	if($("#pw").val() != $("#pwCheck").val())
	{
		$("#errorText2").text("비밀번호가 일치하지 않습니다.");
		return
	}
	
	// alert("비밀번호를 변경할 수 있는 환경입니다.")
	
	var queryString = $('#findPasswordForm').serialize();
	
	$.ajax({
		url : '/login/updatePassword',
		type : 'POST',
		data : queryString,
		dataType : 'text',
		success : function(data) {
			
			var json = JSON.parse(data);
			
			alert(json.result);
			
			location.href="/login/login";
			
			
		}
	});
	
}

















