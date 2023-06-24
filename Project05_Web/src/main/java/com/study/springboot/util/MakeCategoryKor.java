package com.study.springboot.util;

import org.springframework.stereotype.Service;

@Service
public class MakeCategoryKor
{
	public String koreanChanger(String category)
	{
		if(category.equals("korean"))
		{
			return "한식";
		}
		else if(category.equals("japenese"))
		{
			return "일식";
		}
		else if(category.equals("chinese"))
		{
			return "중식";
		}
		else if(category.equals("west"))
		{
			return "양식";
		}
		else if(category.equals("snack"))
		{
			return "분식";
		}
		else if(category.equals("chicken"))
		{
			return "치킨";
		}
		else if(category.equals("hamburger"))
		{
			return "햄버거";
		}
		else if(category.equals("pizza"))
		{
			return "피자";
		}
		else if(category.equals("cafe"))
		{
			return "카페";
		}
		else
		{
			return "입력값이 잘못 되었습니다.";
		}
	}
}
