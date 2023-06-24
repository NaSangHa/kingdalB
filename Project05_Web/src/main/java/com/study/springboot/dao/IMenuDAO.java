package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.MenuDTO;

@Mapper
public interface IMenuDAO
{
	public String[] getAllMCategory(String rid);
	public List<MenuDTO> getAllMenuByCategory(String rid, String mcategory);
	public MenuDTO getOneMenuByMid(String mid);

}
