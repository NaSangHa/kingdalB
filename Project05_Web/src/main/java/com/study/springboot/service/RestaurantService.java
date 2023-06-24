package com.study.springboot.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.springboot.dao.IAddressDAO;
import com.study.springboot.dao.ILikeDAO;
import com.study.springboot.dao.IMemberDAO;
import com.study.springboot.dao.IMenuDAO;
import com.study.springboot.dao.IMenuOptionDAO;
import com.study.springboot.dao.IOrderHistoryDAO;
import com.study.springboot.dao.IOrderHistoryDetailDAO;
import com.study.springboot.dao.IRestaurantDAO;
import com.study.springboot.dao.IReviewDAO;
import com.study.springboot.dto.LikeDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.MenuOptionDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.dto.RestaurantDTO;
import com.study.springboot.dto.ReviewCardDTO;
import com.study.springboot.dto.ReviewDTO;
import com.study.springboot.dto.StarDTO;

@Service
public class RestaurantService implements IRestaurantService
{
	@Autowired
	IMemberDAO memberdao;
	@Autowired
	IAddressDAO addressdao;
	@Autowired
	IOrderHistoryDAO orderhistorydao;
	@Autowired
	IOrderHistoryDetailDAO orderhistorydetaildao;
	@Autowired
	ILikeDAO likedao;
	@Autowired
	IReviewDAO reviewdao;
	@Autowired
	IRestaurantDAO restaurantdao;
	@Autowired
	IMenuDAO menudao;
	@Autowired
	IMenuOptionDAO menuoptiondao;
	
	// 인기 맛집 아이디 가져오기(별점순)
	@Override
	public String[] getHotRestaurantRid()
	{
		String[] hotRestaurantRid_arr = reviewdao.getHotRestaurantRid();
		
		return hotRestaurantRid_arr;
	}
	
	
	// 찜 - 식당카드 
	@Override
	public List<RestaurantCardDTO> getAllLikeRestaurantCardById(String id)
	{
		ArrayList<RestaurantCardDTO> restaurantCards = new ArrayList<>();
		
		List<LikeDTO> likes = likedao.getAllLikeById(id);
		for(LikeDTO like : likes)
		{
			String rid = like.getRid();
			
			RestaurantDTO restaurant = restaurantdao.getRestaurantByRid(rid);
			String rtitle = restaurant.getRtitle();
			String rtitleimg = restaurant.getRtitleimg();
			String rlogo = restaurant.getRlogo();
			
			double avgstar = 0.0;		// 별점 계산
			try
			{
				avgstar = reviewdao.getAvgStarByRid(rid);
				avgstar = Math.round(avgstar*10)/10.0;				
			}
			catch (Exception e)
			{
				avgstar = 0.0;
				System.out.println("리뷰가 없는 식당입니다.");
			}
			
			String rminprice = restaurant.getRminprice();
			String rpaymethod = restaurant.getRpaymethod();
			String[] rpaymethod_arr = rpaymethod.split("#");
			if(rpaymethod_arr.length == 1)
			{
				rpaymethod = rpaymethod_arr[0];
			}
			else if(rpaymethod_arr.length == 2)
			{
				rpaymethod = rpaymethod_arr[0] + " / " + rpaymethod_arr[1];
			}
			
			String rdeliverytime = restaurant.getRdeliverytime();
			String[] rdeliverytime_arr = rdeliverytime.split("#");
			String rdeliverytime1 = rdeliverytime_arr[0];
			String rdeliverytime2 = rdeliverytime_arr[1];
			
			String rdeliverytip = restaurant.getRdeliverytip();
			String[] rdeliverytip_arr = rdeliverytip.split("#");
			String rdeliverytip1 = rdeliverytip_arr[0];
			String rdeliverytip2 = rdeliverytip_arr[1];
			
			int totalReview = reviewdao.getTotalReviewByRid(rid);			
			
			System.out.println("===== 식당 카드에 넣을 정보 =====");
			System.out.println("rid : " + rid);
			System.out.println("rtitle : " + rtitle);
			System.out.println("rtitleimg : " + rtitleimg);
			System.out.println("rlogo : " + rlogo);
			System.out.println("avgstar : " + avgstar);
			System.out.println("rminprice : " + rminprice);
			System.out.println("rpaymethod : " + rpaymethod);
			System.out.println("rdeliverytime1 : " + rdeliverytime1);
			System.out.println("rdeliverytime2 : " + rdeliverytime2);
			System.out.println("rdeliverytip1 : " + rdeliverytip1);
			System.out.println("rdeliverytip2 : " + rdeliverytip2);
			System.out.println("totalReview : " + totalReview);
			System.out.println("===== ===================== =====");
			
			RestaurantCardDTO restaurantCard = new RestaurantCardDTO();
			restaurantCard.setRid(rid);
			restaurantCard.setRtitle(rtitle);
			restaurantCard.setRtitleimg(rtitleimg);
			restaurantCard.setRlogo(rlogo);
			restaurantCard.setAvgstar(avgstar);
			restaurantCard.setRminprice(rminprice);
			restaurantCard.setRpaymethod(rpaymethod);			
			restaurantCard.setRdeliverytime1(rdeliverytime1);
			restaurantCard.setRdeliverytime2(rdeliverytime2);
			restaurantCard.setRdeliverytip1(rdeliverytip1);
			restaurantCard.setRdeliverytip2(rdeliverytip2);
			restaurantCard.setTotalreview(totalReview);
			
			
			restaurantCards.add(restaurantCard);
				
		}
		
		return restaurantCards;
	}
	
	// 찜 - 찜목록 제거
	@Override
	public void deleteLike(String id, String rid)
	{
		likedao.deleteLike(id, rid);
	}
	
	// 찜 - 찜목록 추가
	@Override 
	public void insertLike(String id, String rid)
	{
		likedao.insertLike(id, rid);
	}
	
	// 카테고리별 식당 카드 가져오기
	@Override
	public List<RestaurantCardDTO> getAllRestaurantCardByCategory(String category)
	{
		ArrayList<RestaurantCardDTO> restaurantCards = new ArrayList<>();
		
		List<RestaurantDTO> restaurants = restaurantdao.getAllRestaurantByCategory(category);
		
		for(RestaurantDTO restaurant : restaurants)
		{
			String rid = restaurant.getRid();
			String rtitle = restaurant.getRtitle();
			String rtitleimg = restaurant.getRtitleimg();
			String rlogo = restaurant.getRlogo(); 
			
			double avgstar = 0.0;		// 별점 계산
			try
			{
				avgstar = reviewdao.getAvgStarByRid(rid);
				avgstar = Math.round(avgstar*10)/10.0;		
			}
			catch (Exception e)
			{
				avgstar = 0.0;
				System.out.println("리뷰가 없는 식당입니다.");
			}
			
			String rminprice = restaurant.getRminprice();
			String rpaymethod = restaurant.getRpaymethod();
			String[] rpaymethod_arr = rpaymethod.split("#");
			if(rpaymethod_arr.length == 1)
			{
				rpaymethod = rpaymethod_arr[0];
			}
			else if(rpaymethod_arr.length == 2)
			{
				rpaymethod = rpaymethod_arr[0] + " / " + rpaymethod_arr[1];
			}
			
			String rdeliverytime = restaurant.getRdeliverytime();
			String[] rdeliverytime_arr = rdeliverytime.split("#");
			String rdeliverytime1 = rdeliverytime_arr[0];
			String rdeliverytime2 = rdeliverytime_arr[1];
			
			String rdeliverytip = restaurant.getRdeliverytip();
			String[] rdeliverytip_arr = rdeliverytip.split("#");
			String rdeliverytip1 = rdeliverytip_arr[0];
			String rdeliverytip2 = rdeliverytip_arr[1];
			
			int totalReview = reviewdao.getTotalReviewByRid(rid);			
			
			System.out.println("===== 식당 카드에 넣을 정보 =====");
			System.out.println("rid : " + rid);
			System.out.println("rtitle : " + rtitle);
			System.out.println("rtitleimg : " + rtitleimg);
			System.out.println("rlogo : " + rlogo);
			System.out.println("avgstar : " + avgstar);
			System.out.println("rminprice : " + rminprice);
			System.out.println("rpaymethod : " + rpaymethod);			
			System.out.println("rdeliverytime1 : " + rdeliverytime1);
			System.out.println("rdeliverytime2 : " + rdeliverytime2);
			System.out.println("rdeliverytip1 : " + rdeliverytip1);
			System.out.println("rdeliverytip2 : " + rdeliverytip2);
			System.out.println("totalReview : " + totalReview);
			System.out.println("===== ===================== =====");
			
			RestaurantCardDTO restaurantCard = new RestaurantCardDTO();
			restaurantCard.setRid(rid);
			restaurantCard.setRtitle(rtitle);
			restaurantCard.setRtitleimg(rtitleimg);
			restaurantCard.setRlogo(rlogo);
			restaurantCard.setAvgstar(avgstar);
			restaurantCard.setRminprice(rminprice);
			restaurantCard.setRpaymethod(rpaymethod);			
			restaurantCard.setRdeliverytime1(rdeliverytime1);
			restaurantCard.setRdeliverytime2(rdeliverytime2);
			restaurantCard.setRdeliverytip1(rdeliverytip1);
			restaurantCard.setRdeliverytip2(rdeliverytip2);
			restaurantCard.setTotalreview(totalReview);
			
			restaurantCards.add(restaurantCard);
				
		}
		
		
		return restaurantCards;
	}

	// 식당 세부정보 페이지 - 식당카드 가져오기
	@Override
	public RestaurantCardDTO getOneRestaurantCardByRid(String rid)
	{
		RestaurantCardDTO restaurantCard = new RestaurantCardDTO();
		
		RestaurantDTO restaurant = restaurantdao.getRestaurantByRid(rid);
		String rtitleimg = restaurant.getRtitleimg();
		String rlogo = restaurant.getRlogo();
		String rtitle = restaurant.getRtitle();
		
		double avgstar = 0.0;		// 별점 계산
		try
		{
			avgstar = reviewdao.getAvgStarByRid(rid);
			avgstar = Math.round(avgstar*10)/10.0;				
		}
		catch (Exception e)
		{
			avgstar = 0.0;
			System.out.println("리뷰가 없는 식당입니다.");
		}
		
		String rminprice = restaurant.getRminprice();
		String rpaymethod = restaurant.getRpaymethod();
		String[] rpaymethod_arr = rpaymethod.split("#");
		if(rpaymethod_arr.length == 1)
		{
			rpaymethod = rpaymethod_arr[0];
		}
		else if(rpaymethod_arr.length == 2)
		{
			rpaymethod = rpaymethod_arr[0] + " / " + rpaymethod_arr[1];
		}
		
		String rdeliverytime = restaurant.getRdeliverytime();
		String[] rdeliverytime_arr = rdeliverytime.split("#");
		String rdeliverytime1 = rdeliverytime_arr[0];
		String rdeliverytime2 = rdeliverytime_arr[1];
		
		String rdeliverytip = restaurant.getRdeliverytip();
		String[] rdeliverytip_arr = rdeliverytip.split("#");
		String rdeliverytip1 = rdeliverytip_arr[0];
		String rdeliverytip2 = rdeliverytip_arr[1];
		
		int totalReview = reviewdao.getTotalReviewByRid(rid);
		
		restaurantCard.setRid(rid);
		restaurantCard.setRtitle(rtitle);
		restaurantCard.setRtitleimg(rtitleimg);
		restaurantCard.setRlogo(rlogo);
		restaurantCard.setAvgstar(avgstar);
		restaurantCard.setRminprice(rminprice);
		restaurantCard.setRpaymethod(rpaymethod);			
		restaurantCard.setRdeliverytime1(rdeliverytime1);
		restaurantCard.setRdeliverytime2(rdeliverytime2);
		restaurantCard.setRdeliverytip1(rdeliverytip1);
		restaurantCard.setRdeliverytip2(rdeliverytip2);
		restaurantCard.setTotalreview(totalReview);
		
		return restaurantCard;
	}
	
	// 식당 세부정보 페이지 - 식당 별점 정보가져오기
	@Override
	public StarDTO getStarInfoByRid(String rid)
	{
		double avgstar = 0.0;
		int star5 = 0;
		int star4 = 0;
		int star3 = 0;
		int star2 = 0;
		int star1 = 0;
		double ratio5 = 0.0;
		double ratio4 = 0.0;
		double ratio3 = 0.0;
		double ratio2 = 0.0;
		double ratio1 = 0.0;
		
		StarDTO star = new StarDTO();
		try
		{
			// 평균 별점 구하기
			avgstar = reviewdao.getAvgStarByRid(rid);
			avgstar = Math.round(avgstar*10)/10.0;
			
			// 각 등급 리뷰 갯수 구하기
			star5 = reviewdao.getStarCntByRG(rid, "5");
			star4 = reviewdao.getStarCntByRG(rid, "4");
			star3 = reviewdao.getStarCntByRG(rid, "3");
			star2 = reviewdao.getStarCntByRG(rid, "2");
			star1 = reviewdao.getStarCntByRG(rid, "1");
			
			// 각 등급 리뷰 비율 구하기
			int totalReviewCnt = reviewdao.getTotalReviewByRid(rid);
			System.out.println("totalReviewCnt : " + totalReviewCnt);
			System.out.println("star5/totalReviewCnt : " + star5/totalReviewCnt);
			ratio5 = ((double)star5/(double)totalReviewCnt)*100;
			ratio5 = Math.round(ratio5*10)/10.0;
			ratio4 = ((double)star4/(double)totalReviewCnt)*100;
			ratio4 = Math.round(ratio4*10)/10.0;
			ratio3 = ((double)star3/(double)totalReviewCnt)*100;
			ratio3 = Math.round(ratio3*10)/10.0;
			ratio2 = ((double)star2/(double)totalReviewCnt)*100;
			ratio2 = Math.round(ratio2*10)/10.0;
			ratio1 = ((double)star1/(double)totalReviewCnt)*100;
			ratio1 = Math.round(ratio1*10)/10.0;
			
			
			System.out.println("==== 별점DTO에 들어가는 정보 ====");
			System.out.println("avgstar : " + avgstar);
			System.out.println("totalReviewCnt : " + totalReviewCnt);
			System.out.println("star5 : " + star5);
			System.out.println("star4 : " + star4);
			System.out.println("star3 : " + star3);
			System.out.println("star2 : " + star2);
			System.out.println("star1 : " + star1);
			System.out.println("ratio5 : " + ratio5);
			System.out.println("ratio4 : " + ratio4);
			System.out.println("ratio3 : " + ratio3);
			System.out.println("ratio2 : " + ratio2);
			System.out.println("ratio1 : " + ratio1);
			System.out.println("=================================");
			
			star.setAvgstar(avgstar);
			star.setTotalreview(totalReviewCnt);
			star.setStar5(star5);
			star.setStar4(star4);
			star.setStar3(star3);
			star.setStar2(star2);
			star.setStar1(star1);
			star.setRatio5(ratio5);
			star.setRatio4(ratio4);
			star.setRatio3(ratio3);
			star.setRatio2(ratio2);
			star.setRatio1(ratio1);
		}
		catch (Exception e)
		{
			avgstar = 0.0;	
			System.out.println("리뷰가 없는 식당입니다.");
//			e.printStackTrace();
		}
		

		
		return star;
	}
	
	// 식당 모든 메뉴 가져오기
	public Map<String, List<MenuDTO>> getAllMenuByRid(String rid)
	{
		Map<String, List<MenuDTO>> menus = new HashMap<String, List<MenuDTO>>();
		
		// 모든 메뉴 카테고리 가져오기
		String[] categoryList = menudao.getAllMCategory(rid);
		for(String category : categoryList)
		{
			System.out.println("카테고리 리스트 : " + category);
			
			List<MenuDTO> menu_category = menudao.getAllMenuByCategory(rid, category);
			
			menus.put(category, menu_category);
		}
		
		return menus;
		
		
	}

	// 메뉴 정보가져오기 
	public MenuDTO getOneMenuByMid(String mid)
	{
		MenuDTO menu = menudao.getOneMenuByMid(mid);
		
		return menu;
	}

	// 해당 메뉴 옵션 가져오기
	public Map<String, List<MenuOptionDTO>> showMenuOption(String rid, String mid)
	{
		Map<String, List<MenuOptionDTO>> menuOptions = new HashMap<String, List<MenuOptionDTO>>();
		
		// 해당 식당, 해당 메뉴의 옵션 카테고리 가져오기
		String[] menuOptionCategories = menuoptiondao.getMenuOptionCategoryByRM(rid, mid);
		for(String moptioncategory : menuOptionCategories)
		{
			System.out.println(moptioncategory);
			
			List<MenuOptionDTO> menuoption_category = menuoptiondao.getAllMenuOptionByCategory(rid, mid, moptioncategory);
			menuOptions.put(moptioncategory, menuoption_category);
			
		}
		
		return menuOptions;
	}

	
	// rid, mid로 옵션 가져오기
	public List<MenuOptionDTO> getAllMenuOptionByRm(String rid, String mid)
	{
		List<MenuOptionDTO> menuOptions = menuoptiondao.getMenuOptionByRMid(rid, mid);
		
		return menuOptions;
	}

	// rid 로 모든 리뷰카드 가져오기
	@Override
	public List<ReviewCardDTO> getAllReviewCardByRid(String rid)
	{
		ArrayList<ReviewCardDTO> reviewCards = new ArrayList<>();
		
		List<ReviewDTO> reviews = reviewdao.getAllReviewCardByRid(rid);
		for(ReviewDTO review : reviews)
		{
			String rvid = review.getRvid();
			String rvdate = review.getRvdate().toString().substring(0, 10);
			String rvgrade = review.getRvgrade();
			String rvcontent = review.getRvcontent();
			String rvwriter = review.getRvwriter();
			
			String rvimg;
			if(review.getRvimg() == null)
			{
				rvimg = "";
			}
			else
			{
				rvimg = review.getRvimg();
			}

			
			MemberDTO member = memberdao.getOneMemberById(rvwriter);
			String rvwriterprofileimg = member.getProfileimg();
			String rvwritername = member.getNickname();
			
			
			System.out.println("================ 리뷰카드에 들어갈 정보 ==============");
			System.out.println("rid : " + rid);
			System.out.println("rvid : " + rvid);
			System.out.println("rvwriter : " + rvwriter);
			System.out.println("rvwriterprofileimg : " + rvwriterprofileimg);
			System.out.println("rvwritername : " + rvwritername);
			System.out.println("rvdate : " + rvdate);
			System.out.println("rvgrade : " + rvgrade);
			System.out.println("rvimg : " + rvimg);
			System.out.println("rvcontent : " + rvcontent);
			System.out.println("================ ====================== ==============");
			
			ReviewCardDTO reviewCard = new ReviewCardDTO();
			reviewCard.setRid(rid);
			reviewCard.setRvid(rvid);
			reviewCard.setRvwriter(rvwritername);
			reviewCard.setRvwriterprofileimg(rvwriterprofileimg);
			reviewCard.setRvwritername(rvwritername);
			reviewCard.setRvdate(rvdate);
			reviewCard.setRvgrade(rvgrade);
			reviewCard.setRvimg(rvimg);
			reviewCard.setRvcontent(rvcontent);
			
			reviewCards.add(reviewCard);
		}
		
		return reviewCards;
	}

}


















