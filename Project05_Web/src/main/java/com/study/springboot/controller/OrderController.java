package com.study.springboot.controller;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.CartContentDTO;
import com.study.springboot.dto.CartDTO;
import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.MenuOptionDTO;
import com.study.springboot.dto.OrderHistoryDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.oauth.WebSecurityConfig;
import com.study.springboot.service.IMemberService;
import com.study.springboot.service.IOrderService;
import com.study.springboot.service.IRestaurantService;
import com.study.springboot.util.AuthNumerService;
import com.study.springboot.util.MakeCategoryKor;



@Controller
public class OrderController
{
	@Autowired
	IMemberService memberService;
	@Autowired
	IOrderService orderService;
	@Autowired
	IRestaurantService restaurantService;
	
	@Autowired
	MakeCategoryKor categoryChanger;
	@Autowired
	AuthNumerService authorNumberService;
	String randomAuthoNumber;
	
	@Autowired
	WebSecurityConfig pwEncoder;
	
	
	//----------------------------------------------------------------------------	
	// 카트에 식당 중복 체크
	@RequestMapping("/order/checkCartOtherRestaurant")
	public @ResponseBody String checkCartOtherRestaurant(HttpServletRequest request, Model model)
	{	
		System.out.println("카트에 식당 중복체크");
		JSONObject obj = new JSONObject();

		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		String rid = request.getParameter("rid");
		String mid = request.getParameter("mid");
		
		List<CartDTO> carts = memberService.checkCartOtherRestaurant(id, rid);
		
		obj.put("errorMsg", "");
		
		if(carts.size() != 0)
		{
			obj.put("errorMsg", "장바구니에는 같은 식당 메뉴만 담을 수 있습니다.");
			
			return obj.toJSONString();
		}
		else
		{
			obj.put("errorMsg", "");
			
			return obj.toJSONString();
		}
		
		// memberService.insertMenuCart(id, rid, mid, mtitle, addOption, totalPrice_str);
	}
	
	// 메뉴 장바구니에 넣기
	@RequestMapping("/order/insertMenuCart")
	public @ResponseBody String insertMenuCart(HttpServletRequest request, Model model)
	{	
		System.out.println("메뉴 장바구니에 넣기");
		JSONObject obj = new JSONObject();

		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		String rid = request.getParameter("rid");
		String mid = request.getParameter("mid");
		
		ArrayList<String> results = new ArrayList<>(); 
		
		// 음식 기본가격 가져오기.
		MenuDTO menu = restaurantService.getOneMenuByMid(mid);
		String mtitle = menu.getMtitle();
		String mprice_str = menu.getMprice();
		int mprice = Integer.valueOf(mprice_str);
		
		int totalPrice = mprice;
		
		String addOption = "옵션 : ";
		List<MenuOptionDTO> menuOptions = restaurantService.getAllMenuOptionByRm(rid, mid);
		for(MenuOptionDTO menuOption : menuOptions)
		{
			String moid = menuOption.getMoid();
			System.out.println("moid : " + moid);
			
			String selectedOption = request.getParameter("menuOption" + moid);
			System.out.println("선택된 옵션 : " + selectedOption);
			
			try 
			{
				String price_str = selectedOption.split("#")[0];
				int price = Integer.valueOf(price_str);
				totalPrice += price;
				
				String optionTitle = selectedOption.split("#")[1];
				addOption += optionTitle + " / ";				
			}
			catch(Exception e)
			{
				System.out.println("null 값이기 때문에 에러 발생");
			}
			
		}
		
		String totalPrice_str = String.valueOf(totalPrice);
		
		System.out.println("===== 장바구니에 넣을 정보 =====");
		System.out.println("id : " + id);
		System.out.println("rid : " + rid);
		System.out.println("mid : " + mid);
		System.out.println("mtitle : " + mtitle);
		System.out.println("addOption : " + addOption);
		System.out.println("totalPrice : " + totalPrice_str);
		System.out.println("================================");
		
		 memberService.insertMenuCart(id, rid, mid, mtitle, addOption, totalPrice_str);
		
		return "장바구니에 추가되었습다.";
		
		
	}
	
	// 장바구니 초기화
	@RequestMapping("/order/deleteCart")
	public @ResponseBody String deleteCart(HttpServletRequest request, Model model)
	{	
		System.out.println("장바구니 초기화");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		memberService.deleteCartById(id);
		
		return "장바구니 초기화";
		
	}
	
	// 주문완료
	@RequestMapping("/order/orderSuccess")
	public @ResponseBody String paySuccess(HttpServletRequest request, Model model)
	{	
		System.out.println("주문완료");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		String rid = request.getParameter("rid");
		String ordertype = request.getParameter("ordertype");
		String deliverytip = request.getParameter("deliverytip");
		
		AddressDTO address = memberService.getAdaptAddressById(rid);
		String orderlocation = address.getMainaddr() + " " + address.getSubaddr(); 
		
		System.out.println("rid : " + rid);
		System.out.println("ordertype : " + ordertype);
		System.out.println("deliverytip : " + deliverytip);
		System.out.println("orderlocation : " + orderlocation);
		
		// orderHistory DB에 추가
		orderService.insertOrderHistory(id, rid, ordertype, orderlocation, deliverytip);
		
		OrderHistoryDTO orderHistory = orderService.getRecentOrderHistoryByid(id, rid);
		String orderid = orderHistory.getOrderid();
		
		// orderHistoryDetail DB에 추가
		List<CartContentDTO> carts = memberService.getAllCartContentInMyCart(id);
		for(CartContentDTO cart : carts)
		{
			String mainfood = cart.getMtitle();
			String foodOption = cart.getMoption();
			int quantity_int = cart.getMcount();
			String quantity = String.valueOf(quantity_int);
			int price_int = cart.getMprice();
			String price = String.valueOf(price_int);
			
			System.out.println("mainfood : " + mainfood);
			System.out.println("foodOption : " + foodOption);
			System.out.println("quantity : " + quantity);
			System.out.println("price : " + price);
			
			orderService.insertOrderHistoryDetail(orderid, mainfood, foodOption, quantity, price);
		}
		
		memberService.deleteCartById(id);
		
		// deliveryStatus DB에 추가
		orderService.insertInitDeliveryStatus(orderid, id);
		
		return "주문완료";
		
	}	
	
	// 주문현황 페이지로 이동
	@RequestMapping("/order/showDeliveryStatus")
	public String showDeliveryStatus(HttpServletRequest request, Model model)
	{	
		System.out.println("주문현황 페이지로 이동");
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		// 1. 프로필 사진, 닉네임 가져오기
		MemberDTO member = memberService.getOneMemberById(id);
		
		// 2. 활성화 된 주소 가져오기
		AddressDTO adaptAddress = memberService.getAdaptAddressById(id);
		String userAddress = adaptAddress.getMainaddr() + " " + adaptAddress.getSubaddr();
		
		// 3. 주소 리스트 가져오기
		List<AddressDTO> addresses = memberService.getAllAddressById(id);

		
		model.addAttribute("loginMember", member);			// 1
		model.addAttribute("userAddress", userAddress);		// 2
		model.addAttribute("addresses", addresses);			// 3
		
		// 4. 주문진행상황 확인 후 가져오기
		DeliveryStatusDTO deliveryStatus = orderService.getDeliveryStatusById(id);
		
		String orderid = deliveryStatus.getOrderid();
		Timestamp step1 = deliveryStatus.getStep1();
		Timestamp step2 = deliveryStatus.getStep2();
		Timestamp step3 = deliveryStatus.getStep3();
		
		// orderid로 rid 가져오기
		OrderHistoryDTO orderHistory = orderService.getOrderHistoryByOid(orderid);
		String rid = orderHistory.getRid();
		
		// rid 로 deliverytime 가져오기
		RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
		String deliverytime_str = restaurantCard.getRdeliverytime2();
		int deliverytime = Integer.valueOf(deliverytime_str);
		
		System.out.println("step1 : " + step1);
		System.out.println("step2 : " + step2);
		System.out.println("step3 : " + step3);
		System.out.println("deliverytime : " + deliverytime);
		
		String startTime = step1.toString().substring(10, 16);

		String middleTime;
		
		int deliveryBar = 5;
		if(step2 == null)
		{
			middleTime = "";
		}
		else
		{
			middleTime = step2.toString().substring(10, 16);
			deliveryBar = 50;
			
		}
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(step1);
		cal.add(Calendar.MINUTE, deliverytime);
		step1.setTime(cal.getTime().getTime());
		
		String endTime = step1.toString().substring(10, 16);
		
		System.out.println("startTime : " + startTime);
		System.out.println("middleTime : " + middleTime);
		System.out.println("endTime : " + endTime);
		
		model.addAttribute("deliveryBar", deliveryBar);		
		model.addAttribute("startTime", startTime);		
		model.addAttribute("middleTime", middleTime);		
		model.addAttribute("endTime", endTime);		
		
		
		
		return "member/deliveryStatus";
		
	}	

	
	
}
