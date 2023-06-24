package com.study.springboot.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.springboot.dao.IAddressDAO;
import com.study.springboot.dao.ICartDAO;
import com.study.springboot.dao.ILikeDAO;
import com.study.springboot.dao.IMemberDAO;
import com.study.springboot.dao.IMenuDAO;
import com.study.springboot.dao.IOrderHistoryDAO;
import com.study.springboot.dao.IRestaurantDAO;
import com.study.springboot.dao.IReviewDAO;
import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.CartContentDTO;
import com.study.springboot.dto.CartDTO;
import com.study.springboot.dto.LikeDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.OrderHistoryDTO;
import com.study.springboot.dto.RestaurantDTO;
import com.study.springboot.dto.ReviewDTO;

@Service
public class MemberService implements IMemberService
{
	@Autowired
	IMemberDAO memberdao;
	@Autowired
	IAddressDAO addressdao;
	@Autowired
	IOrderHistoryDAO orderhistorydao;
	@Autowired
	ILikeDAO likedao;
	@Autowired
	IReviewDAO reviewdao;
	@Autowired
	ICartDAO cartdao;
	@Autowired
	IRestaurantDAO restaurantdao;
	@Autowired
	IMenuDAO menudao;
	
	
	
	
	
	//--------------------------------------------------------------------------------------------------------------
	@Override
	public MemberDTO getOneMemberByET(String email, String type)
	{
		MemberDTO member = memberdao.getOneMemberByET(email, type);
		
		return member; 
	}
	
	@Override
	public MemberDTO getOneMemberById(String id)
	{
		MemberDTO member = memberdao.getOneMemberById(id);
		
		return member;
	}
	
	@Override
	public void insertMember(String type, String email, String pw, String nickname, String phone)
	{
		// MemberDB
		memberdao.insertMember(type, email, pw, nickname, phone);
		
		// AddressDB
		MemberDTO member = memberdao.getOneMemberByET(email, type);
		String id = member.getId();
		addressdao.insertInitAddres(id, "home", "집", "1");
		addressdao.insertInitAddres(id, "company", "회사", "0");
		
	}
	
	@Override
	public void updateNicknameById(String id, String nickname)
	{
		memberdao.updateNicknameById(id, nickname);
	}
	
	@Override
	public void updateMyInfoNickName(String id, String nickname)
	{
		memberdao.updateMyInfoNickName(id, nickname);
	}
	
	@Override
	public void updateMyInfoProfileImg(String id, String profileimg)
	{
		memberdao.updateMyInfoProfileImg(id, profileimg);
	}
	
	@Override
	public void updatePassword(String id, String pw)
	{
		memberdao.updatePassword(id, pw);
	}
	//---------------------------------------------------------------------------------------------------------------
	@Override
	public AddressDTO getAdaptAddressById(String id)
	{
		AddressDTO address = addressdao.getAdaptAddressById(id);
		
		return address;
	}
	
	@Override
	public List<AddressDTO> getAllAddressById(String id)
	{
		List<AddressDTO> addresses = addressdao.getAllAddressById(id);
		
		return addresses;
	}
	
	@Override
	public void updateAdaptAddress(String id, String aid)
	{
		addressdao.updateAdaptAddress(id, aid);
		addressdao.updateAdaptElseAddress(id, aid);	
	}
	
	@Override
	public AddressDTO getAddressByAid(String aid)
	{
		AddressDTO address = addressdao.getAddressByAid(aid);
		
		return address;
	}
	
	@Override
	public void insertAddress(String id, String addrtitle, String mainaddr, String subaddr)
	{
		addressdao.upadteAllAddressAdaptZero(id);
		addressdao.insertAddress(id, addrtitle, mainaddr, subaddr);
	}
	
	@Override
	public void deleteAddressByAid(String aid)
	{
		addressdao.deleteAddressByAid(aid);
	}
	
	
	//---------------------------------------------------------------------------------------------------------------
	@Override
	public int getRecentOrderCntById(String id)
	{
		List<OrderHistoryDTO> orderhistory = orderhistorydao.getRecentOrderCntById(id);
		
		int result = orderhistory.size();
		
		return result;
	}
	
	//---------------------------------------------------------------------------------------------------------------
	@Override
	public int getLikeCntById(String id)
	{
		List<LikeDTO> like = likedao.getAllLikeById(id);
		
		int result = like.size();
		
		return result;
	}
	
	@Override
	public LikeDTO checkLike(String id, String rid)
	{
		LikeDTO like = likedao.checkLike(id, rid);
		
		return like;
	}
	
	//---------------------------------------------------------------------------------------------------------------
	@Override
	public int getMyReviewCntById(String id)
	{
		List<ReviewDTO> reviews = reviewdao.getMyReviewCntById(id);
		
		int result = reviews.size();
		
		return result;
	}
	
	//---------------------------------------------------------------------------------------------------------------
	@Override
	public List<CartDTO> checkCartOtherRestaurant(String id, String rid)
	{
		List<CartDTO> carts = cartdao.checkCartOtherRestaurant(id, rid);
		
		return carts;
	}
	
	@Override
	public void insertMenuCart(String id, String rid, String mid, String mtitle, String moption, String mprice)
	{
		cartdao.insertMenuCart(id, rid, mid, mtitle, moption, mprice);
	}
	
	@Override
	public void deleteCartById(String id)
	{
		cartdao.deleteCartById(id);
	}
	
	@Override
	public RestaurantDTO getRestaurantRidInMyCart(String id)
	{
		
		if(cartdao.getRestaurantRidInMyCart(id) == null)
		{
			System.out.println("장바구니가 비어 있습니다.");
			RestaurantDTO restaurant = new RestaurantDTO();
			
			restaurant.setRlogo("");
			restaurant.setRtitle("");
			restaurant.setRid("");
			restaurant.setRdeliverytip("0#1");
			
			return restaurant;
		}
		
		String rid = cartdao.getRestaurantRidInMyCart(id);
		
		RestaurantDTO restaurant = restaurantdao.getRestaurantByRid(rid);
		
		return restaurant;
		
	}
	
	@Override
	public List<CartContentDTO> getAllCartContentInMyCart(String id)
	{
		ArrayList<CartContentDTO> cartContents = new ArrayList<>();
		
		List<CartDTO> carts = cartdao.getAllCartById(id);
		
		for(CartDTO cart : carts)
		{
			String mid = cart.getMid();
			String cid = cart.getCid();
			MenuDTO menu = menudao.getOneMenuByMid(mid);
			String mtitle = menu.getMtitle();
			String mimg = menu.getMimg();
			
			String moption = cart.getMoption();
			String mprice_str0 = cart.getMprice();
			int mprice = Integer.valueOf(mprice_str0);
			String mprice_str = String.format("%,d", mprice);
			
			int mcount = 1;
			
			CartContentDTO cartContent = new CartContentDTO();
			cartContent.setMid(mid);
			cartContent.setCid(cid);
			cartContent.setMtitle(mtitle);
			cartContent.setMimg(mimg);
			cartContent.setMoption(moption);
			cartContent.setMcount(mcount);
			cartContent.setMprice(mprice);
			cartContent.setMprice_str(mprice_str);
			
			
			System.out.println("== 장바구니 컨텐츠에 들어가는 정보 ==");
			System.out.println("mid : " + mid);
			System.out.println("mtitle : " + mtitle);
			System.out.println("mimg : " + mimg);
			System.out.println("moption : " + moption);
			System.out.println("mcount : " + mcount);
			System.out.println("mprice : " + mprice);
			System.out.println("mprice_str : " + mprice_str);
			System.out.println("=====================================");
			
			cartContents.add(cartContent);
			
		}
		
		return cartContents;
	}

	@Override
	public void deleteCartContentByCid(String cid)
	{
		cartdao.deleteCartContentByCid(cid);
	}
	
}

