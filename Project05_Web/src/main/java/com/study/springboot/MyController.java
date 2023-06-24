package com.study.springboot;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.service.IMemberService;
import com.study.springboot.service.IOrderService;
import com.study.springboot.service.IRestaurantService;

@Controller
public class MyController
{
	@Autowired
	IMemberService memberService;
	@Autowired
	IRestaurantService restaurantService;
	@Autowired
	IOrderService orderService;
	
	@RequestMapping("/")
	public String root(HttpServletRequest request, Model model)
	{
		return "redirect:/main";
	}
	
	@RequestMapping("/main")
	public String main(HttpServletRequest request, Model model)
	{
		System.out.println("메인 입장");
		HttpSession session = null;
		session = request.getSession();
		
		// 로그인 정보 확인
		if(session.getAttribute("loginInfo") == null)
		{
			System.out.println("로그인 정보가 없습니다.");
			model.addAttribute("loginInfo", null);
			model.addAttribute("nickname", "로그인");
			model.addAttribute("profileimg", "defaultprofile.png");
			model.addAttribute("userAddress", "어디로 배달할까요?");
		}
		else
		{
			String id = (String)session.getAttribute("loginInfo");
			System.out.println("로그인 된 아이디 : " + id);
			
			// 1. 프로필 사진, 닉네임 가져오기
			MemberDTO member = memberService.getOneMemberById(id);
			
			// 2. 활성화 된 주소 가져오기
			AddressDTO adaptAddress = memberService.getAdaptAddressById(id);
			String userAddress = adaptAddress.getMainaddr() + " " + adaptAddress.getSubaddr();
			
			// 3. 주소 리스트 가져오기
			List<AddressDTO> addresses = memberService.getAllAddressById(id);
			
			// 4. 주문진행상황 확인 후 가져오기
			DeliveryStatusDTO deliveryStatus = orderService.getDeliveryStatusById(id);
			System.out.println("deliveryStatus : " + deliveryStatus);
			if(deliveryStatus != null)
			{
				if(deliveryStatus.getStep2() == null)
				{
					model.addAttribute("deliveryMsg", "주문완료! 음식이 맛있게 조리중이에요");
				}
				else
				{
					model.addAttribute("deliveryMsg", "배달시작! 얼른 갈게요~");
				}
				model.addAttribute("deliveryStatus", deliveryStatus);
			}
			
			model.addAttribute("loginMember", member);			// 1
			model.addAttribute("userAddress", userAddress);		// 2
			model.addAttribute("addresses", addresses);			// 3
		}
		
		List<RestaurantCardDTO> restaurantCards = new ArrayList<>();
		
		String[] hotRestaurantRid_arr = restaurantService.getHotRestaurantRid();
		for(String rid : hotRestaurantRid_arr)
		{
			System.out.println("인기 식당 Rid : " + rid);
			
			RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
			
			restaurantCards.add(restaurantCard);
		}
		
		model.addAttribute("restaurantCards", restaurantCards);	
		
		return "main";
	}
}
