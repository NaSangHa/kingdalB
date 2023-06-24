package com.study.springboot.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.MenuOptionDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.dto.ReviewCardDTO;
import com.study.springboot.dto.StarDTO;

@Component
public interface IRestaurantService
{	
	public String[] getHotRestaurantRid();
	public List<RestaurantCardDTO> getAllLikeRestaurantCardById(String id);
	public void deleteLike(String id, String rid);
	public void insertLike(String id, String rid);
	
	public List<RestaurantCardDTO> getAllRestaurantCardByCategory(String category);
	public RestaurantCardDTO getOneRestaurantCardByRid(String rid);
	
	public StarDTO getStarInfoByRid(String rid);
	
	public Map<String, List<MenuDTO>> getAllMenuByRid(String rid);
	public MenuDTO getOneMenuByMid(String mid);
	
	public Map<String, List<MenuOptionDTO>> showMenuOption(String rid, String mid);
	public List<MenuOptionDTO> getAllMenuOptionByRm(String rid, String mid);
	
	public List<ReviewCardDTO> getAllReviewCardByRid(String rid);
}
