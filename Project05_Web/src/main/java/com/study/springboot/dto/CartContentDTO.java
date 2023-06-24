package com.study.springboot.dto;

import lombok.Data;

@Data
public class CartContentDTO
{
	private String rid;
	private String mid;
	private String cid;
	private String mtitle;
	private String mimg;
	private String moption;
	private int mcount;
	private int mprice;
	private String mprice_str;
	
}
