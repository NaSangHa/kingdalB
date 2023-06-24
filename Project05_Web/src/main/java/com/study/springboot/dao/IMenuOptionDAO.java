package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.MenuOptionDTO;

@Mapper
public interface IMenuOptionDAO
{
	public List<MenuOptionDTO> getMenuOptionByRMid(String rid, String mid);
	public String[] getMenuOptionCategoryByRM(String rid, String mid);
	public String[] getMenuOptionCategoryByMid(String mid);
	public List<MenuOptionDTO> getAllMenuOptionByCategory(String rid, String mid, String moptioncategory);
	public List<MenuOptionDTO> getAllMenuOptionByMOC(String mid, String moptioncategory);
}
