package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.CartDTO;

@Mapper
public interface ICartDAO
{
	public List<CartDTO> checkCartOtherRestaurant(String id, String rid);
	public void insertMenuCart(String id, String rid, String mid, String mtitle, String moption, String mprice);
	public void deleteCartById(String id);
	public List<CartDTO> getAllCartById(String id);
	public String getRestaurantRidInMyCart(String id);
	public void deleteCartContentByCid(String cid);
}
