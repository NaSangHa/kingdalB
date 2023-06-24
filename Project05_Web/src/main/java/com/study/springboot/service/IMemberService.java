package com.study.springboot.service;

import java.util.List;

import org.springframework.stereotype.Component;

import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.CartContentDTO;
import com.study.springboot.dto.CartDTO;
import com.study.springboot.dto.LikeDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.RestaurantDTO;

@Component
public interface IMemberService
{	
	// 멤버
	public MemberDTO getOneMemberByET(String email, String type);
	public MemberDTO getOneMemberById(String id);
	public void insertMember(String type, String email, String pw, String nickname, String phone);
	public void updateNicknameById(String id, String nickname);
	public void updateMyInfoNickName(String id, String nickname);
	public void updateMyInfoProfileImg(String id, String profileimg);
	public void updatePassword(String id, String pw);
	
	// 주소
	public AddressDTO getAdaptAddressById(String id);
	public List<AddressDTO> getAllAddressById(String id);
	public void updateAdaptAddress(String id, String aid);
	public AddressDTO getAddressByAid(String aid);
	public void insertAddress(String id, String addrtitle, String mainaddr, String subaddr);
	public void deleteAddressByAid(String aid);
	
	
	// 주문 히스토리
	public int getRecentOrderCntById(String id);
	
	// 찜목록
	public int getLikeCntById(String id);
	public LikeDTO checkLike(String id, String rid);
	
	// 리뷰
	public int getMyReviewCntById(String id);
	
	// 카트
	public List<CartDTO> checkCartOtherRestaurant(String id, String rid);
	public void insertMenuCart(String id, String rid, String mid, String mtitle, String moption, String mprice);
	public void deleteCartById(String id);
	public RestaurantDTO getRestaurantRidInMyCart(String id);
	public List<CartContentDTO> getAllCartContentInMyCart(String id);
	public void deleteCartContentByCid(String cid);
	
}
