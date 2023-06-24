package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.LikeDTO;

@Mapper
public interface ILikeDAO
{
	public List<LikeDTO> getAllLikeById(String id);
	public void deleteLike(String id, String rid);
	public void insertLike(String id, String rid);
	public LikeDTO checkLike(String id, String rid);


}
