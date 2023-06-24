package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.ReviewDTO;

@Mapper
public interface IReviewDAO
{
	public List<ReviewDTO> getMyReviewCntById(String id);
	public double getAvgStarByRid(String rid);
	public int getTotalReviewByRid(String rid);
	public int getStarCntByRG(String rid, String grade);
	public List<ReviewDTO> getAllReviewCardByRid(String rid);
	public String[] getHotRestaurantRid();
}
