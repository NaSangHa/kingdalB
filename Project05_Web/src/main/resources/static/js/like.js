function restaurantCardClick(rid) {
	
	location.href="/restaurant/restaurantDetail?rid="+rid;
}





function likeBtnClick(rid) {
	event.stopPropagation();
	
	var imgSrc = $("#likeBtn" + rid).attr("src");
	var queryString = "rid=" + rid;
	
	if(imgSrc == "/upload/like.png")
	{
		$.ajax({
			url : '/member/like/deleteLike',
			type : 'POST',
			data : queryString,
			dataType : 'text',
			success : function(json) {
				
				$("#likeBtn" + rid).attr("src", "/upload/like_not.png");
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
				
				$("#likeBtn" + rid).attr("src", "/upload/like.png");
			}
		});			
	}
	
	
}