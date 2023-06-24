package com.study.springboot.controller;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.LikeDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.MenuOptionDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.dto.ReviewCardDTO;
import com.study.springboot.dto.StarDTO;
import com.study.springboot.oauth.WebSecurityConfig;
import com.study.springboot.service.IMemberService;
import com.study.springboot.service.IOrderService;
import com.study.springboot.service.IRestaurantService;
import com.study.springboot.util.AuthNumerService;
import com.study.springboot.util.MakeCategoryKor;



@Controller
public class RestaurantController
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
	// 카테고리 검색 페이지로 이동
	@RequestMapping("/restaurant/categorySearch")
	public String categorySearch(HttpServletRequest request, Model model)
	{	
		System.out.println("카테고리 검색 페이지로 이동");
		
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
		
		
		String category = request.getParameter("category");
		System.out.println("검색한 카테고리 : " + category);
		
		String category_kor = categoryChanger.koreanChanger(category);
		model.addAttribute("category", category);	
		model.addAttribute("category_kor", category_kor);
		
		// 카테고리로 식당 카드 가져오기
		List<RestaurantCardDTO> restaurantCards = restaurantService.getAllRestaurantCardByCategory(category);
		model.addAttribute("restaurantCards", restaurantCards);
		
		return "restaurant/categorySearch";
	}
	
	// 식당 세부정보 페이지로 이동
	@RequestMapping("/restaurant/restaurantDetail")
	public String restaurantDetail(HttpServletRequest request, Model model)
	{	
		System.out.println("식당 세부정보 페이지로 이동");
		
		String rid = request.getParameter("rid");
		System.out.println("식당 세부정보 rid : " + rid);
		
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
			model.addAttribute("likeBtn", "heart.png");
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
			
			// 4. 찜목록 여부 확인 (식당 세부정보 페이지에서만...)
			LikeDTO like = memberService.checkLike(id, rid);
			System.out.println("찜 여부 확인 : " + like);
			String likeBtn = "";
			if(like != null)
			{
				likeBtn = "like.png";
			}
			else if(like == null)
			{
				likeBtn = "like_not.png";
			}
			
			// 5. 주문진행상황 확인 후 가져오기
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
			model.addAttribute("likeBtn", likeBtn);				// 4
		}
		
		// 식당 카드 가져오기
		RestaurantCardDTO restaurantCard = restaurantService.getOneRestaurantCardByRid(rid);
		model.addAttribute("restaurantCard", restaurantCard);
		
		// 식당 별점 정보 가져오기
		StarDTO star = restaurantService.getStarInfoByRid(rid);
		model.addAttribute("star", star);
		
		// 식당 메뉴 리스트 가져오기
		Map<String, List<MenuDTO>> menus = restaurantService.getAllMenuByRid(rid);
		model.addAttribute("menus", menus);
		
		return "restaurant/restaurantDetail";
	}
	
	// 메뉴 옵션 보기
	@RequestMapping("/restaurant/showMenuOption")
	public @ResponseBody String showMenuOption(HttpServletRequest request, Model model)
	{	
		System.out.println("메뉴 옵션 보기");

		JSONObject obj = new JSONObject();
		
		String rid = request.getParameter("rid");
		String mid = request.getParameter("mid");
		
		System.out.println("메뉴 옵션 보기 rid : " + rid);
		System.out.println("메뉴 옵션 보기 mid : " + mid);
		
		// 메뉴 옵션 카테고리 가져오기
		Map<String, List<MenuOptionDTO>> menuOptions_map = restaurantService.showMenuOption(rid, mid);
		
		String content = ""
				+ "                <!-- 옵션선택 박스 -->"
				+ "                <div class=\"col optionListWrap \">"
				+ "                    <div class=\"col optionCloseBtn text-end \">"
				+ "                        <img src=\"/upload/close.png\" alt=\"\" onclick=\"removeOptionWindow()\">"
				+ "                    </div>"
				+ "                    <form action=\"\" name=\"menuOptionForm"+mid+"\" id=\"menuOptionForm"+mid+"\">";
		
	    Iterator<String> keys = menuOptions_map.keySet().iterator();
        while (keys.hasNext())
        {
          String key = keys.next();
          // System.out.println("KEY : " + key);
          
          content += ""
          		+ "                    <!-- 반복구간1 -->"
          		+ "                        <div class=\"col optionList\">"
          		+ "                            <div class=\"optionTitle \">"+key+"</div>";
          
          List<MenuOptionDTO> menuOptions = menuOptions_map.get(key);
          for(MenuOptionDTO menuOption : menuOptions)
          {
        	  String moid = menuOption.getMoid();
        	  String moptioncategory = menuOption.getMoptioncategory();
        	  String moptiontitle = menuOption.getMoptiontitle();
        	  String moptionprice = menuOption.getMoptionprice();
        	  
        	  content += ""
        	  		+ "                            <!-- 반복구간2 -->"
        	  		+ "                            <div class=\"row optionContent \">"
        	  		+ "                                <div class=\"col \">"
        	  		+ "                                    <input class=\"form-check-input\" type=\"checkbox\" value=\""+moptionprice+"#"+moptiontitle+"\" name=\"menuOption"+moid+"\" id=\"menuOption"+moid+"\" onchange=\"optionListener('"+rid+"', '"+mid+"')\">"            
        	  		+ "                                    <label class=\"form-check-label\" for=\"menuOption"+moid+"\">"+moptiontitle+"</label>"
        	  		+ "                                </div>"
        	  		+ "                                <div class=\"col text-end\">"
        	  		+ "                                    <label for=\"menuOption"+moid+"\">+"+moptionprice+" 원</label>"
        	  		+ "                                </div>"
        	  		+ "                            </div>"
        	  		+ "                            <!-- ---------------- -->";
          }
          
          content += ""
          		+ "                        </div>"
          		+ "                    <!-- --------------- -->";
          
          
        }
        content += ""
        		+ "                    </form>"
        		+ "                </div>";
        
		MenuDTO menu = restaurantService.getOneMenuByMid(mid);
		String mprice_str = menu.getMprice();
		int mprice = Integer.valueOf(mprice_str);
		
		obj.put("content", content);
		obj.put("orignalMid", mid);
		obj.put("orignalPrice", mprice);
        
        
        
		return obj.toJSONString();
	}

	// 옵션 상태값 확인
	@RequestMapping("/restaurant/optionListener")
	public @ResponseBody String optionListener(HttpServletRequest request, Model model)
	{	
		JSONObject obj = new JSONObject();

		System.out.println("옵션 상태값 확인");

		String rid = request.getParameter("rid");
		String mid = request.getParameter("mid");
		
		
		ArrayList<String> results = new ArrayList<>(); 
		
		System.out.println("rid : " + rid);
		System.out.println("mid : " + mid);
		
		MenuDTO menu = restaurantService.getOneMenuByMid(mid);
		String mprice_str = menu.getMprice();
		int mprice = Integer.valueOf(mprice_str);
		
		
		int totalPrice = mprice;
		String addOption = "옵션 : ";
		List<MenuOptionDTO> menuOptions = restaurantService.getAllMenuOptionByRm(rid, mid);
		for(MenuOptionDTO menuOption : menuOptions)
		{
			String moid = menuOption.getMoid();
			System.out.println(moid);
			
			String selectedOption = request.getParameter("menuOption" + moid);
			System.out.println(selectedOption);
			
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
		obj.put("totalPrice", totalPrice);
		obj.put("addOption", addOption);
		
		obj.put("orignalMid", mid);
		obj.put("orignalPrice", mprice);
		
		return obj.toJSONString();
	}

	// 리뷰 페이지 가져오기
	@RequestMapping("/restaurant/showReviewList")
	public @ResponseBody String showReviewList(HttpServletRequest request, Model model)
	{	
		JSONObject obj = new JSONObject();

		System.out.println("리뷰 페이지 가져오기");

		String rid = request.getParameter("rid");
		
		
		List<ReviewCardDTO> reviewCards = restaurantService.getAllReviewCardByRid(rid);
		
		String content = "";
		for(ReviewCardDTO reviewCard : reviewCards)
		{
			if(reviewCard.getRvimg().equals(""))
			{
				System.out.println("리뷰 사진이 없습니다.");
				
				content += ""
						+ "<!-- 반복구간 -->"
						+ "<div class=\"col reviewWrap \">"
						+ "    <!-- 작성자정보, 별점, 메뉴 -->"
						+ "    <div class=\"col row align-items-center reviewHead \">"
						+ "        <!-- 작성자프로필 -->"
						+ "        <div class=\"col-1 \">"
						+ "            <div class=\"reviewWriterProfile\"><img src=\"/upload/"+reviewCard.getRvwriterprofileimg()+"\" alt=\"\"></div>"
						+ "        </div>"
						+ "        <!-- 닉네임,작성일자 -->"
						+ "        <div class=\"col-3 \">"
						+ "            <div class=\"reviewWriterName\">"+reviewCard.getRvwritername()+"</div>"
						+ "            <div class=\"reviewDate\">"+reviewCard.getRvdate()+"</div>"
						+ "        </div>"
						+ "        <!-- 준 별점 -->"
						+ "        <div class=\"col-2 reviewStar \"><img src=\"/upload/star"+reviewCard.getRvgrade()+".png\" alt=\"\"></div>"
						+ "        <!-- 메뉴 -->"
						+ "        <div class=\"col text-end reviewMenu \"><img src=\"/upload/menu.png\" alt=\"\" onclick=\"\"></div>"
						+ "    </div>"
						+ "    <div class=\"col row \">"
						+ "        <div class=\"col reviewContent \">"+reviewCard.getRvcontent()+"</div>"
						+ "    </div>"
						+ "</div>"
						+ "<!-- ------------------ -->";
			}
			else
			{
				System.out.println("리뷰 사진이 있습니다.");
				
				content += ""
						+ "<!-- 반복구간 -->"
						+ "<div class=\"col reviewWrap \">"
						+ "    <!-- 작성자정보, 별점, 메뉴 -->"
						+ "    <div class=\"col row align-items-center reviewHead \">"
						+ "        <!-- 작성자프로필 -->"
						+ "        <div class=\"col-1 \">"
						+ "            <div class=\"reviewWriterProfile\"><img src=\"/upload/"+reviewCard.getRvwriterprofileimg()+"\" alt=\"\"></div>"
						+ "        </div>"
						+ "        <!-- 닉네임,작성일자 -->"
						+ "        <div class=\"col-3 \">"
						+ "            <div class=\"reviewWriterName\">"+reviewCard.getRvwritername()+"</div>"
						+ "            <div class=\"reviewDate\">"+reviewCard.getRvdate()+"</div>"
						+ "        </div>"
						+ "        <!-- 준 별점 -->"
						+ "        <div class=\"col-2 reviewStar \"><img src=\"/upload/star"+reviewCard.getRvgrade()+".png\" alt=\"\"></div>"
						+ "        <!-- 메뉴 -->"
						+ "        <div class=\"col text-end reviewMenu \"><img src=\"/upload/menu.png\" alt=\"\" onclick=\"\"></div>"
						+ "    </div>"
						+ "    <div class=\"col row \">"
						+ "        <div class=\"col-4 reviewImg\"><img src=\"/upload/"+reviewCard.getRvimg()+"\" alt=\"\"></div>"
						+ "        <div class=\"col reviewContent \">"+reviewCard.getRvcontent()+"</div>"
						+ "    </div>"
						+ "</div>"
						+ "<!-- ------------------ -->";
			}
			
		}
		
		obj.put("content", content);
		System.out.println(content);
		
		
		return obj.toJSONString();
//		return "리뷰 페이지 가져오기";
	}
	
	// 메뉴 페이지 가져오기
	@RequestMapping("/restaurant/showMenuList")
	public @ResponseBody String showMenuList(HttpServletRequest request, Model model)
	{	
		
		System.out.println("메뉴 페이지 가져오기");
		
		JSONObject obj = new JSONObject();
		String rid = request.getParameter("rid");
		
		HttpSession session = null;
		session = request.getSession();
		String id = "";
		// 로그인 정보 확인
		if(session.getAttribute("loginInfo") == null)
		{
			id = "";
		}
		else
		{
			id = (String)session.getAttribute("loginInfo");
		}
		
		
		
		// 식당 메뉴 리스트 가져오기
		Map<String, List<MenuDTO>> menus_map = restaurantService.getAllMenuByRid(rid);
		
		String content = "";
		Iterator<String> keys = menus_map.keySet().iterator();
        while (keys.hasNext())
        {
        	String key = keys.next();
        	
        	content += ""
        			+ "                    <!-- 반복구간1 -->"
        			+ "	                    <div class=\"col menuCategoryTitle \">"+key+"</div>";
        	
        	List<MenuDTO> menus = menus_map.get(key);
        	for(MenuDTO menu : menus)
        	{
        		content += ""
        				+ "	                    <!-- 반복구간2 -->"
        				+ "		                    <div class=\"col row align-items-center menuCard\" id=\"menu"+menu.getMid()+"\" onclick=\"showMenuOption('"+rid+"', '"+menu.getMid()+"')\">"
        				+ "		                        <!-- 메뉴사진 -->"
        				+ "		                        <div class=\"col menuImg\">"
        				+ "		                            <img src=\"/upload/"+menu.getMimg()+"\" alt=\"\">"
        				+ "		                        </div>"
        				+ "		                        <!-- 메뉴정보 -->"
        				+ "		                        <div class=\"col\">"
        				+ "		                            <div class=\"col text-end menuName\">"+menu.getMtitle()+"</div>"
        				+ "		                            <div class=\"col text-end optionName\" id=\"optionName"+menu.getMid()+"\"></div>"
        				+ "		                            <div class=\"col row text-end priceName\">"
        				+ "		                                <div class=\"col \"><span id=\"menuPrice"+menu.getMid()+"\">"+menu.getMprice()+"</span>원</div>"
        				+ "		                                <div class=\"col-3 addMenuBtn\" id=\"addMenuBtn"+menu.getMid()+"\" onclick=\"checkCartOtherRestaurant('"+id+"','"+rid+"', '"+menu.getMid()+"')\">"
        				+ "		                                	담기"
        				+ "		                                </div>"
        				+ "		                            </div>"
        				+ "		                        </div>"
        				+ "		                    </div>"
        				+ "		                    "
        				+ "	                    <!------------------------------- Modal ---------------------------------->"
        				+ "						<div class=\"modal fade\" id=\"confirmCartDouble"+menu.getMid()+"\" tabindex=\"-1\" aria-labelledby=\"exampleModalLabel\" aria-hidden=\"true\">"
        				+ "						  <div class=\"modal-dialog\">"
        				+ "						    <div class=\"modal-content\">"
        				+ "						      <div class=\"modal-header\">"
        				+ "						        <h5 class=\"modal-title\" id=\"exampleModalLabel\">알림</h5>"
        				+ "						        <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>"
        				+ "						      </div>"
        				+ "					          <div class=\"modal-body\">"
        				+ "					          	<div class=\"col text-center cdContent1\">장바구니에는 같은 가게의 메뉴만 담을 수 있습니다.</div>"
        				+ "					            <div class=\"col text-center cdContent2\">선택하신 메뉴를 장바구니에 담을 경우</div> "
        				+ "					            <div class=\"col text-center cdContent2\">이전에 담은 메뉴가 삭제됩니다.</div>"
        				+ "					          </div>"
        				+ "					          <div class=\"modal-footer\">"
        				+ "					            <button type=\"button\" class=\"btn btn-secondary\" data-bs-dismiss=\"modal\">취소</button>"
        				+ "					            <button type=\"button\" class=\"btn btn-primary chOkBtn\" onclick=\"resetCart('"+rid+"', '"+menu.getMid()+"')\">담기</button>"
        				+ "					          </div>"
        				+ "						    </div>"
        				+ "						  </div>"
        				+ "						</div>"
        				+ "						<!------------------------------- Modal ---------------------------------->"
        				+ "						"
        				+ "	                    <!-- ------------반복2 끝 -->";
        	}
        	
        	content += ""
        			+ "                    <!-- ---------반복 1 끝 -->";
        			
        }
		
        obj.put("content", content);
        
		return obj.toJSONString();
//		return "메뉴 페이지 가져오기";
	}
	
}

