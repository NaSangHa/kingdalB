package com.study.springboot.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dao.IAddressDAO;
import com.study.springboot.dao.ICartDAO;
import com.study.springboot.dao.IDeliveryStatusDAO;
import com.study.springboot.dao.ILikeDAO;
import com.study.springboot.dao.IMemberDAO;
import com.study.springboot.dao.IMenuDAO;
import com.study.springboot.dao.IMenuOptionDAO;
import com.study.springboot.dao.IOrderHistoryDAO;
import com.study.springboot.dao.IOrderHistoryDetailDAO;
import com.study.springboot.dao.IRestaurantDAO;
import com.study.springboot.dao.IReviewDAO;
import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.CartDTO;
import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.LikeDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.MenuOptionDTO;
import com.study.springboot.dto.OrderHistoryCardDTO;
import com.study.springboot.dto.OrderHistoryDTO;
import com.study.springboot.dto.OrderHistoryDetailDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.dto.RestaurantDTO;
import com.study.springboot.dto.ReviewDTO;
import com.study.springboot.oauth.WebSecurityConfig;
import com.study.springboot.service.IMemberService;
import com.study.springboot.service.IOrderService;
import com.study.springboot.service.IRestaurantService;
import com.study.springboot.util.AuthNumerService;
import com.study.springboot.util.MakeCategoryKor;



@Controller
public class FlutterController
{
	@Autowired
	IMemberService memberService;
	@Autowired
	IOrderService orderService;
	@Autowired
	IRestaurantService restaurantService;
	
	@Autowired
	IAddressDAO addressdao;
	@Autowired
	ICartDAO cartdao;
	@Autowired
	IDeliveryStatusDAO deliverystatusdao;
	@Autowired
	ILikeDAO likedao;
	@Autowired
	IMemberDAO memberdao;
	@Autowired
	IMenuDAO menudao;
	@Autowired
	IMenuOptionDAO menuoptiondao;
	@Autowired
	IOrderHistoryDAO orderhistorydao;
	@Autowired
	IOrderHistoryDetailDAO orderhistorydetaildao;
	@Autowired
	IRestaurantDAO restaurantdao;
	@Autowired
	IReviewDAO reviewdao;
	
	@Autowired
	MakeCategoryKor categoryChanger;
	@Autowired
	AuthNumerService authorNumberService;
	String randomAuthoNumber;
	
	@Autowired
	WebSecurityConfig pwEncoder;
	
	@RequestMapping("/flutter")
	public @ResponseBody String test(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : 테스트");
		JSONObject obj = new JSONObject();
		
		String email = request.getParameter("email");
		String pw = request.getParameter("pw");
	
		System.out.println("==== 받아온 정보 ====");
		System.out.println("email : " + email );
		System.out.println("pw : " + pw );
		System.out.println("=====================");
		
		obj.put("result", "success");
		
		return obj.toJSONString();
	}
	
	
	// [회원]------------------------------------------------------------------------------------------------------------------------------
	// 이메일+타입으로 MemeberDTO 가져오기
	@RequestMapping("/flutter/getOneMemberByET")
	public @ResponseBody String getOneMemberByET(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getOneMemberByET");
		JSONObject obj = new JSONObject();
		
		String email = request.getParameter("email");
		String type =  request.getParameter("type");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("email : " + email );
		System.out.println("type : " + type );
		System.out.println("=====================");
		
		MemberDTO member = memberService.getOneMemberByET(email, type);
		
		obj.put("id", member.getId());
		obj.put("type", member.getType());
		obj.put("email", member.getEmail());
		obj.put("pw", member.getPw());
		obj.put("nickname", member.getNickname());
		obj.put("phone", member.getPhone());
		obj.put("profileimg", member.getProfileimg());
		obj.put("authority", member.getAuthority());
		obj.put("enabled", member.getEnabled());
		
		
		
		return obj.toJSONString();
	}
	
	// SNS 로그인
	@RequestMapping("/flutter/snsLogin")
	public @ResponseBody String snsLogin(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : snsLogin");
		JSONObject obj = new JSONObject();
		
		String email = request.getParameter("email");
		String type =  request.getParameter("type");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("email : " + email );
		System.out.println("type : " + type );
		System.out.println("=====================");
		
		MemberDTO member = memberService.getOneMemberByET(email, type);
		if(member == null) 
		{
			System.out.println("가입되어 있지 않은 SNS 회원 입니다.");
			obj.put("result", "fail");
			obj.put("desc", "가입되어 있지 않은 회원 입니다.");
			
			return obj.toJSONString();
		}
		else
		{
			System.out.println("가입되어있는 SNS 회원 입니다.");
			obj.put("result", "success");
			obj.put("desc", member.getId());
			
			return obj.toJSONString();
		}
	}
	// [회원]------------------------------------------------------------------------------------------------------------------------------
	@RequestMapping("/flutter/getMyInfo")
	public @ResponseBody String getMyInfo(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getMyInfo");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		JSONObject obj1 = new JSONObject();
		int myReview = memberService.getMyReviewCntById(id);
		int myLike = memberService.getLikeCntById(id);
		int myRecentOrder = memberService.getRecentOrderCntById(id);
		
		MemberDTO member = memberService.getOneMemberById(id);
		
		obj1.put("id", member.getId());
		obj1.put("nickname", member.getNickname());
		obj1.put("profileimg", member.getProfileimg());
		obj1.put("myReview", String.valueOf(myReview));
		obj1.put("myLike", String.valueOf(myLike));
		obj1.put("myRecentOrder", String.valueOf(myRecentOrder));

		
		obj.put("result", obj1);
		return obj.toJSONString();
	}
	
	
	
	
	// [식당]------------------------------------------------------------------------------------------------------------------------------
	// 인기 TOP 식당
	@RequestMapping("/flutter/getHot5Restaurant")
	public @ResponseBody String getHot5Restaurant(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getHot5Restaurant");
		JSONObject obj = new JSONObject();
		
		List<JSONObject> restaurantCards = new ArrayList<>();
		
		String[] hotRestaurantRid_arr = restaurantService.getHotRestaurantRid();
		
		for(String rid : hotRestaurantRid_arr)
		{
			JSONObject obj1 = new JSONObject();
			
			RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
			
			obj1.put("rid", restaurantCard.getRid());
			obj1.put("rtitleimg", restaurantCard.getRtitleimg());
			obj1.put("rlogo", restaurantCard.getRlogo());
			obj1.put("rtitle", restaurantCard.getRtitle());
			obj1.put("avgstar", String.valueOf(restaurantCard.getAvgstar()));
			
			obj1.put("totalreview", String.valueOf(restaurantCard.getTotalreview()));
			obj1.put("rdeliverytime1", restaurantCard.getRdeliverytime1());
			obj1.put("rdeliverytime2", restaurantCard.getRdeliverytime2());
			obj1.put("rminprice", restaurantCard.getRminprice());
			obj1.put("rpaymethod", restaurantCard.getRpaymethod());
			
			obj1.put("rdeliverytip1", restaurantCard.getRdeliverytip1());
			obj1.put("rdeliverytip2", restaurantCard.getRdeliverytip2());
			
			
			
			restaurantCards.add(obj1);
		}
		
		obj.put("result", restaurantCards);
		
		return obj.toJSONString();
	}
	
	// 카테고리별 RestaurantCardDTO 가져오기
	@RequestMapping("/flutter/getRestaurantCardByRcategory")
	public @ResponseBody String getRestaurantCardByRcategory(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getRestaurantCardByRcategory");
		JSONObject obj = new JSONObject();
		
		String rcategory = request.getParameter("rcategory");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("rcategory : " + rcategory );
		System.out.println("=====================");
		
		List<JSONObject> restaurantCards_json = new ArrayList<>();
		
		List<RestaurantCardDTO> restaurantCards = restaurantService.getAllRestaurantCardByCategory(rcategory);
		for(RestaurantCardDTO restaurantCard : restaurantCards)
		{
			JSONObject obj1 = new JSONObject();
			
			obj1.put("rid", restaurantCard.getRid());
			obj1.put("rtitleimg", restaurantCard.getRtitleimg());
			obj1.put("rlogo", restaurantCard.getRlogo());
			obj1.put("rtitle", restaurantCard.getRtitle());
			obj1.put("avgstar", String.valueOf(restaurantCard.getAvgstar()));
			
			obj1.put("totalreview", String.valueOf(restaurantCard.getTotalreview()));
			obj1.put("rdeliverytime1", restaurantCard.getRdeliverytime1());
			obj1.put("rdeliverytime2", restaurantCard.getRdeliverytime2());
			obj1.put("rminprice", restaurantCard.getRminprice());
			obj1.put("rpaymethod", restaurantCard.getRpaymethod());
			
			obj1.put("rdeliverytip1", restaurantCard.getRdeliverytip1());
			obj1.put("rdeliverytip2", restaurantCard.getRdeliverytip2());
			
			restaurantCards_json.add(obj1);
		}
		
		obj.put("result", restaurantCards_json);
		
		return obj.toJSONString();
	}
	
	// rid로 식당 카드 가져오기
	@RequestMapping("/flutter/getOneRestaurantCardByRid")
	public @ResponseBody String getOneRestaurantCardByRid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getOneRestaurantCardByRid");
		JSONObject obj = new JSONObject();
		
		String rid = request.getParameter("rid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("rid : " + rid );
		System.out.println("=====================");
		
		List<JSONObject> restaurantCards_json = new ArrayList<>();
		
		RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
		
		JSONObject obj1 = new JSONObject();
		
		obj1.put("rid", restaurantCard.getRid());
		obj1.put("rtitleimg", restaurantCard.getRtitleimg());
		obj1.put("rlogo", restaurantCard.getRlogo());
		obj1.put("rtitle", restaurantCard.getRtitle());
		obj1.put("avgstar", String.valueOf(restaurantCard.getAvgstar()));
		
		obj1.put("totalreview", String.valueOf(restaurantCard.getTotalreview()));
		obj1.put("rdeliverytime1", restaurantCard.getRdeliverytime1());
		obj1.put("rdeliverytime2", restaurantCard.getRdeliverytime2());
		obj1.put("rminprice", restaurantCard.getRminprice());
		obj1.put("rpaymethod", restaurantCard.getRpaymethod());
		
		obj1.put("rdeliverytip1", restaurantCard.getRdeliverytip1());
		obj1.put("rdeliverytip2", restaurantCard.getRdeliverytip2());
		
		restaurantCards_json.add(obj1);
		
		obj.put("result", restaurantCards_json);
		
		return obj.toJSONString();
	}
	
	// rid로 카테고리별 메뉴 가져오기
	@RequestMapping("/flutter/getAllMenuByRid")
	public @ResponseBody String getAllMenuByRid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllMenuByRid");
		JSONObject obj = new JSONObject();
		
		String rid = request.getParameter("rid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("rid : " + rid );
		System.out.println("=====================");
		
		List<JSONObject> result_json = new ArrayList<>();
		
		String[] mcategories = menudao.getAllMCategory(rid);
		for(String mcategory : mcategories)
		{
			JSONObject obj1 = new JSONObject();
			obj1.put("mcategory", mcategory);
			
			List<JSONObject> result_json2 = new ArrayList<>();
			
			List<MenuDTO> menus = menudao.getAllMenuByCategory(rid, mcategory);
			for(MenuDTO menu : menus)
			{
				JSONObject obj2 = new JSONObject();
				obj2.put("rid", menu.getRid());
				obj2.put("mid", menu.getMid());
				obj2.put("mimg", menu.getMimg());
				obj2.put("mtitle", menu.getMtitle());
				obj2.put("mprice", menu.getMprice());
				obj2.put("mcategory", menu.getMcategory());
				
				result_json2.add(obj2);
				
			}
			
			obj1.put("menus", result_json2);
			
			
			result_json.add(obj1);
			
		}
		
		obj.put("result", result_json);
		
		return obj.toJSONString();
	}
	
	// mid로 메뉴 가져오기
	@RequestMapping("/flutter/getOneMenuByMid")
	public @ResponseBody String getOneMenuByMid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllMenuByRid");
		JSONObject obj = new JSONObject();
		
		String mid = request.getParameter("mid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("mid : " + mid );
		System.out.println("=====================");
		
		List<JSONObject> result_json = new ArrayList<>();
		
		JSONObject obj1 = new JSONObject();
		
		MenuDTO menu = menudao.getOneMenuByMid(mid);
		obj1.put("rid", menu.getRid());
		obj1.put("mid", menu.getMid());
		obj1.put("mimg", menu.getMimg());
		obj1.put("mtitle", menu.getMtitle());
		obj1.put("mprice", menu.getMprice());
		obj1.put("mcategory", menu.getMcategory());
		
		result_json.add(obj1);
		
		obj.put("result", result_json);
		return obj.toJSONString();
	}
	
	// mid로 메뉴 카테고리별 옵션 가져오기
	@RequestMapping("/flutter/getAllMenuOptionByMid")
	public @ResponseBody String getAllMenuOptionByMid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllMenuOptionByMid");
		JSONObject obj = new JSONObject();
		
		String mid = request.getParameter("mid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("mid : " + mid );
		System.out.println("=====================");
		
		List<JSONObject> result_json = new ArrayList<>();
		
		String[] moptioncategories = menuoptiondao.getMenuOptionCategoryByMid(mid);
		for(String moptioncategory : moptioncategories)
		{
			JSONObject obj1 = new JSONObject();
			obj1.put("moptioncategory", moptioncategory);
			
			List<JSONObject> result_json2 = new ArrayList<>();
			
			List<MenuOptionDTO> menuOptions = menuoptiondao.getAllMenuOptionByMOC(mid, moptioncategory);
			for(MenuOptionDTO menuOption : menuOptions)
			{
				JSONObject obj2 = new JSONObject();
				obj2.put("rid", menuOption.getRid());
				obj2.put("mid", menuOption.getMid());
				obj2.put("moid", menuOption.getMoid());
				obj2.put("moptioncategory", menuOption.getMoptioncategory());
				obj2.put("moptiontitle", menuOption.getMoptiontitle());
				obj2.put("moptionprice", menuOption.getMoptionprice());
				
				result_json2.add(obj2);
				
			}
			
			obj1.put("menuOptions", result_json2);
			
			result_json.add(obj1);
		}
		
		obj.put("result", result_json);
		
		return obj.toJSONString();
	}
	
	// 좋아요 식당 확인
	@RequestMapping("/flutter/checkLikeRestaurant")
	public @ResponseBody String checkLikeRestaurant(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : checkLikeRestaurant");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String rid = request.getParameter("rid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("rid : " + rid );
		System.out.println("=====================");
		
		if(likedao.checkLike(id, rid) != null)
		{
			System.out.println("좋아하는 식당 입니다.");
			obj.put("result", "success");			
		}
		else
		{
			System.out.println("좋아하지 않은 식당 입니다.");
			obj.put("result", "fail");
		}
		
		
		return obj.toJSONString();
	}
	
	// 좋아요 버튼 입력
	@RequestMapping("/flutter/updateLike")
	public @ResponseBody String updateLike(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : checkLikeRestaurant");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String rid = request.getParameter("rid");
		String like = request.getParameter("like");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("rid : " + rid );
		System.out.println("like : " + like );
		System.out.println("=====================");
		
		if(like.equals("no"))
		{
			System.out.println("좋아요를 해제 합니다.");
			likedao.deleteLike(id, rid);
		}
		else
		{
			System.out.println("좋아요 등록합니다.");
			likedao.insertLike(id, rid);
		}
		
		obj.put("result", "success");
		
		return obj.toJSONString();
	}
	
	// [리뷰]------------------------------------------------------------------------------------------------------------------------------
	@RequestMapping("/flutter/getAllReviewCardByRid")
	public @ResponseBody String getAllReviewCardByRid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllReviewCardByRid");
		JSONObject obj = new JSONObject();
		
		String rid = request.getParameter("rid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("rid : " + rid );
		System.out.println("=====================");
		
		List<JSONObject> result_json = new ArrayList<>();
		
		List<ReviewDTO> reviews = reviewdao.getAllReviewCardByRid(rid);
		for(ReviewDTO review : reviews)
		{
			JSONObject obj1 = new JSONObject();
			obj1.put("rvgrade", review.getRvgrade());
			obj1.put("rvdate", review.getRvdate().toString().substring(0, 10));
			obj1.put("rvcontent", review.getRvcontent());
			obj1.put("rvid", review.getRvid());
			obj1.put("rid", review.getRid());
			obj1.put("rvwriter", review.getRvwriter());

			String rvimg = "";
			if(review.getRvimg() == null)
			{
				rvimg = "rvimgEmpty.png";
			}
			else
			{
				rvimg = review.getRvimg();
			}
			obj1.put("rvimg", rvimg);
			String writer = review.getRvwriter();
			
			MemberDTO member = memberdao.getOneMemberById(writer);
			
			obj1.put("profileimg", member.getProfileimg());
			obj1.put("nickname", member.getNickname());
			
			result_json.add(obj1);
		}
		
		obj.put("result", result_json);
		
		return obj.toJSONString();
	}
	
	
	// [주소]------------------------------------------------------------------------------------------------------------------------------
	// id로 주소 가져오기
	@RequestMapping("/flutter/getAllAddressById")
	public @ResponseBody String getAllAddressById(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllAddressById");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		List<JSONObject> addresses_json = new ArrayList<>();
		
		List<AddressDTO> addresses = memberService.getAllAddressById(id);
		for(AddressDTO address : addresses)
		{
			JSONObject obj1 = new JSONObject();
			
			obj1.put("id", address.getId());
			obj1.put("aid", address.getAid());
			obj1.put("addrtype", address.getAddrtype());
			obj1.put("addrtitle", address.getAddrtitle());
			obj1.put("mainaddr", address.getMainaddr());
			obj1.put("subaddr", address.getSubaddr());
			obj1.put("lat", address.getLat());
			obj1.put("lon", address.getLon());
			obj1.put("adapt", address.getAdapt());
			
			addresses_json.add(obj1);
		}
		
		obj.put("result", addresses_json);
		
		return obj.toJSONString();
	}
	
	// 적용 주소 바꾸기
	@RequestMapping("/flutter/updateAdaptAddressByAid")
	public @ResponseBody String updateAdaptAddressByAid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllAddressById");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String aid = request.getParameter("aid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("aid : " + aid );
		System.out.println("=====================");
		
		memberService.updateAdaptAddress(id, aid);
		
		obj.put("result", "success");
		
		return obj.toJSONString();
	}
	
	// 새로운 주소 추가하기
	@RequestMapping("/flutter/insertNewAddress")
	public @ResponseBody String insertNewAddress(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllAddressById");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String mainaddr = request.getParameter("mainaddr");
		String subaddr = request.getParameter("subaddr");
		String lat = request.getParameter("lat");
		String lon = request.getParameter("lon");
		
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("mainaddr : " + mainaddr );
		System.out.println("subaddr : " + subaddr );
		System.out.println("lat : " + lat );
		System.out.println("lon : " + lon );
		System.out.println("=====================");

		
		addressdao.upadteAllAddressAdaptZero(id);
		addressdao.insertAddress2(id, mainaddr, mainaddr, subaddr, lat, lon);
		obj.put("result", "success");
		
		return obj.toJSONString();
	}

	
	
	// [카트]------------------------------------------------------------------------------------------------------------------------------
	// 카트에 식당 중복 체크
	@RequestMapping("/flutter/checkCartRestaurantDouble")
	public @ResponseBody String checkCartRestaurantDouble(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : checkCartRestaurantDouble");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String rid = request.getParameter("rid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("rid : " + rid );
		System.out.println("=====================");
		
		List<CartDTO> carts = cartdao.checkCartOtherRestaurant(id, rid);
		if(carts.size() == 0)
		{
			obj.put("result", "success");			
		}
		else
		{
			obj.put("result", "fail");
		}
		
		
		return obj.toJSONString();
	}
	
	// 카트에 메뉴 넣기
	@RequestMapping("/flutter/insertMenuMyCart")
	public @ResponseBody String insertMenuMyCart(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : insertMenuMyCart");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String rid = request.getParameter("rid");
		String mid = request.getParameter("mid");
		String mtitle = request.getParameter("mtitle");
		String moption = request.getParameter("moption");
		String mprice = request.getParameter("mprice");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("rid : " + rid );
		System.out.println("mid : " + mid );
		System.out.println("mtitle : " + mtitle );
		System.out.println("moption : " + moption );
		System.out.println("mprice : " + mprice );
		System.out.println("=====================");
		
		
		cartdao.insertMenuCart(id, rid, mid, mtitle, moption, mprice);
		
		obj.put("result", "success");			
		
		return obj.toJSONString();
	}
	
	// 카트에 메뉴 넣기 - 기존 내용 제거
	@RequestMapping("/flutter/insertMenuMyCartWithClear")
	public @ResponseBody String insertMenuMyCartWithClear(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : insertMenuMyCartWithClear");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String rid = request.getParameter("rid");
		String mid = request.getParameter("mid");
		String mtitle = request.getParameter("mtitle");
		String moption = request.getParameter("moption");
		String mprice = request.getParameter("mprice");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("rid : " + rid );
		System.out.println("mid : " + mid );
		System.out.println("mtitle : " + mtitle );
		System.out.println("moption : " + moption );
		System.out.println("mprice : " + mprice );
		System.out.println("=====================");
		
		cartdao.deleteCartById(id);
		cartdao.insertMenuCart(id, rid, mid, mtitle, moption, mprice);
		
		obj.put("result", "success");			
		
		return obj.toJSONString();
	}
	
	// 카트 목록 가져오기
	@RequestMapping("/flutter/getAllCartById")
	public @ResponseBody String getAllCartById(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllCartById");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
 
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		List<JSONObject> json_list = new ArrayList<>();
		
		List<CartDTO> carts = cartdao.getAllCartById(id);
		for(CartDTO cart : carts)
		{
			JSONObject obj1 = new JSONObject();
			obj1.put("id", cart.getId());
			obj1.put("rid", cart.getRid());
			obj1.put("mid", cart.getMid());
			obj1.put("cid", cart.getCid());
			obj1.put("mtitle", cart.getMtitle());
			obj1.put("moption", cart.getMoption());
			obj1.put("mprice", cart.getMprice());
			
			MenuDTO menu = menudao.getOneMenuByMid(cart.getMid());
			obj1.put("mimg", menu.getMimg());
			
			json_list.add(obj1);
		}
		
		obj.put("result", json_list);			
		
		return obj.toJSONString();
	}
	
	// 카트에 있는 식당 정보가져오기
	@RequestMapping("/flutter/getRestaurantInMyCartById")
	public @ResponseBody String getRestaurantInMyCartById(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getRestaurantInMyCartById");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		List<JSONObject> json_list = new ArrayList<>();
		
		String rid = cartdao.getRestaurantRidInMyCart(id);
		
		RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
		JSONObject obj1 = new JSONObject();
		obj1.put("rid", restaurantCard.getRid());
		obj1.put("rlogo", restaurantCard.getRlogo());
		obj1.put("rtitle", restaurantCard.getRtitle());
		obj1.put("deliverytip", restaurantCard.getRdeliverytip2());
		
		json_list.add(obj1);
		
		obj.put("result", json_list);			
		
		return obj.toJSONString();
	}
	
	// cid로 카트 목록 지우기
	@RequestMapping("/flutter/deleteMenuInMyCartByCid")
	public @ResponseBody String deleteMenuInMyCartByCid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : deleteMenuInMyCartByCid");
		JSONObject obj = new JSONObject();
		
		String cid = request.getParameter("cid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("cid : " + cid );
		System.out.println("=====================");
		
		cartdao.deleteCartContentByCid(cid);
		
		obj.put("result", "success");			
		
		return obj.toJSONString();
	}
	
	// id로 카트 목록 지우기
	@RequestMapping("/flutter/deleteAllCartById")
	public @ResponseBody String deleteAllCartById(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : deleteAllCartById");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		cartdao.deleteCartById(id);
		
		obj.put("result", "success");			
		
		return obj.toJSONString();
	}
	
	// [찜목록]------------------------------------------------------------------------------------------------------------------------------
	@RequestMapping("/flutter/getAllLike")
	public @ResponseBody String getAllLike(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllLike");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		List<JSONObject> addresses_json = new ArrayList<>();
		
		List<LikeDTO> likes = likedao.getAllLikeById(id);
		for(LikeDTO like : likes)
		{
			JSONObject obj1 = new JSONObject();

			String rid = like.getRid();
			RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
			
			obj1.put("rid", restaurantCard.getRid());
			obj1.put("rtitleimg", restaurantCard.getRtitleimg());
			obj1.put("rlogo", restaurantCard.getRlogo());
			obj1.put("rtitle", restaurantCard.getRtitle());
			obj1.put("avgstar", String.valueOf(restaurantCard.getAvgstar()));
			
			obj1.put("totalreview", String.valueOf(restaurantCard.getTotalreview()));
			obj1.put("rdeliverytime1", restaurantCard.getRdeliverytime1());
			obj1.put("rdeliverytime2", restaurantCard.getRdeliverytime2());
			obj1.put("rminprice", restaurantCard.getRminprice());
			obj1.put("rpaymethod", restaurantCard.getRpaymethod());
			
			obj1.put("rdeliverytip1", restaurantCard.getRdeliverytip1());
			obj1.put("rdeliverytip2", restaurantCard.getRdeliverytip2());
			
			addresses_json.add(obj1);
		}
		
		
		obj.put("result", addresses_json);
		
		return obj.toJSONString();
	}

	// [주문내역]------------------------------------------------------------------------------------------------------------------------------
	// 주문내역 가져오기
	@RequestMapping("/flutter/getAllOrderHistoryById")
	public @ResponseBody String getAllOrderHistoryById(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getAllLike");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		List<JSONObject> addresses_json = new ArrayList<>();
		
		List<OrderHistoryCardDTO> orderHistoryCards = orderService.getOrderHistoryById(id);
		
		for(OrderHistoryCardDTO orderHistoryCard : orderHistoryCards)
		{
			JSONObject obj1 = new JSONObject();
			
			obj1.put("rid", orderHistoryCard.getRid());
			obj1.put("orderid", orderHistoryCard.getOrderid());
			obj1.put("orderdate", orderHistoryCard.getOrderdate());
			obj1.put("rlogo", orderHistoryCard.getRlogo());
			obj1.put("rtitle", orderHistoryCard.getRtitle());
			obj1.put("mainfood", orderHistoryCard.getMainfood());
			
			int totalprice = 0;
			int count_int = -1;
			List<OrderHistoryDetailDTO> orderHistoryDetails = orderhistorydetaildao.getOrderHistoryDetailByOid(orderHistoryCard.getOrderid());
			for(OrderHistoryDetailDTO orderHistoryDetail : orderHistoryDetails)
			{
				totalprice += Integer.valueOf(orderHistoryDetail.getPrice());
				count_int++;
			}
			
			if(count_int == 0)
			{
				obj1.put("count", "");
			}
			else
			{
				obj1.put("count", "외 " + String.valueOf(count_int));				
			}
			obj1.put("totalprice", String.valueOf(totalprice));
			
			addresses_json.add(obj1);
		}
		
		obj.put("result", addresses_json);
		
		return obj.toJSONString();
	}
	
	// 주문내역 상세 만들기
	@RequestMapping("/flutter/getOrderHistoryDetailCardByOrderid")
	public @ResponseBody String getOrderHistoryDetailCardByOrderid(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getOrderHistoryDetailCardByOrderid");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String orderid = request.getParameter("orderid");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("orderid : " + orderid );
		System.out.println("=====================");
		
		List<JSONObject> addresses_json = new ArrayList<>();
		
		JSONObject obj1 = new JSONObject();
		
		OrderHistoryDTO orderHistory = orderhistorydao.getOrderHistoryByOid(orderid);
		
		String rid = orderHistory.getRid();
		RestaurantDTO restaurant = restaurantdao.getRestaurantByRid(rid);
		
		obj1.put("rlogo", restaurant.getRlogo());
		obj1.put("rtitle", restaurant.getRtitle());
		
		obj1.put("orderdate", orderHistory.getOrderdate().toString().substring(0, 10));
		obj1.put("orderlocation", orderHistory.getOrderlocation());
		
		int orderprice = 0;
		List<JSONObject> addresses_json2 = new ArrayList<>();
		List<OrderHistoryDetailDTO> orderHistoryDetails = orderhistorydetaildao.getOrderHistoryDetailByOid(orderid);
		for(OrderHistoryDetailDTO orderHistoryDetail : orderHistoryDetails)
		{
			JSONObject obj2 = new JSONObject();
			obj2.put("mainfood", orderHistoryDetail.getMainfood());
			obj2.put("foodoption", orderHistoryDetail.getFoodoption());
			obj2.put("price", orderHistoryDetail.getPrice());
			
			orderprice += Integer.valueOf(orderHistoryDetail.getPrice());
			
			addresses_json2.add(obj2);
			
		}
		
		obj1.put("content", addresses_json2);
		obj1.put("orderprice", String.valueOf(orderprice));
		obj1.put("deliverytip", orderHistory.getDeliverytip());
		
		int totalprice = orderprice + Integer.valueOf(orderHistory.getDeliverytip());
		obj1.put("totalprice", String.valueOf(totalprice));
		
		
		
		addresses_json.add(obj1);
		
	
		obj.put("result", addresses_json);
		
		return obj.toJSONString();
	}
	
	// OrderHistory에 추가 + deliveryStatus
	@RequestMapping("/flutter/insertOrderHistory")
	public @ResponseBody String insertOrderHistory(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : insertOrderHistory");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		String ordertype = request.getParameter("ordertype");
		String deliverytip = request.getParameter("deliverytip");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("ordertype : " + ordertype );
		System.out.println("deliverytip : " + deliverytip );
		System.out.println("=====================");
		
		String rid = cartdao.getRestaurantRidInMyCart(id);
		AddressDTO address = addressdao.getAdaptAddressById(id);
		String orderlocation = address.getMainaddr() + " " + address.getSubaddr();
		
		// OrderHistory DB에 추가
		orderhistorydao.insertOrderHistory(id, rid, ordertype, orderlocation, deliverytip);

		// OrderHistoryDetail DB에 추가
		OrderHistoryDTO orderHistory = orderhistorydao.getRecentOrderHistoryByid(id, rid);
		String orderid = orderHistory.getOrderid();
		
		List<CartDTO> carts = cartdao.getAllCartById(id);
		for(CartDTO cart : carts)
		{
			String mainfood = cart.getMtitle();
			String foodOption = cart.getMoption();
			String quantity = "1";
			String price = cart.getMprice();
			
			orderhistorydetaildao.insertOrderHistoryDetail(orderid, mainfood, foodOption, quantity, price);
			
		}
		
		deliverystatusdao.insertInitDeliveryStatus(orderid, id);
		
		
		
		obj.put("result", "success");
		
		return obj.toJSONString();
	}
	
	
	// [주문 현황]------------------------------------------------------------------------------------------------------------------------------
	@RequestMapping("/flutter/getDeliveryStatus")
	public @ResponseBody String getDeliveryStatus(HttpServletRequest request, HttpServletResponse response, Model model)
	{	
		System.out.println("Flutter 접속 : getDeliveryStatus");
		JSONObject obj = new JSONObject();
		
		String id = request.getParameter("id");
		
		System.out.println("==== 받아온 정보 ====");
		System.out.println("id : " + id );
		System.out.println("=====================");
		
		JSONObject obj1 = new JSONObject();
		
		DeliveryStatusDTO deliveryStatus = deliverystatusdao.getDeliveryStatusById(id);
		
		System.out.println("status : " + deliveryStatus.getStatus());
		if((deliveryStatus.getStep2() == null) && (deliveryStatus.getStep3() == null))
		{
			obj1.put("step1", deliveryStatus.getStep1().toString().substring(11, 16));
			obj1.put("step2", "");
			obj1.put("step3", "");
			obj1.put("status", deliveryStatus.getStatus());
			obj1.put("statusImg", "InDelivery1.png");
		}
		
		if((deliveryStatus.getStep2() != null) && (deliveryStatus.getStep3() == null))
		{
			obj1.put("step1", deliveryStatus.getStep1().toString().substring(11, 16));
			obj1.put("step2", deliveryStatus.getStep2().toString().substring(11, 16));
			obj1.put("step3", "");
			obj1.put("status", deliveryStatus.getStatus());
			obj1.put("statusImg", "InDelivery2.png");
		}
		
		obj.put("result", obj1);
		
		return obj.toJSONString();
	}
}

