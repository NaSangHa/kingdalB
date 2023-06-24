package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.RestaurantDTO;

@Mapper
public interface IRestaurantDAO
{
	public RestaurantDTO getRestaurantByRid(String rid);
	public List<RestaurantDTO> getAllRestaurantByCategory(String category);
}
