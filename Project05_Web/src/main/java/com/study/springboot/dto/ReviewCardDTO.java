package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReviewCardDTO
{
	private String rid;
	private String rvid;
	private String rvwriter;
	private String rvwriterprofileimg;
	private String rvwritername;
	private String rvdate; 
	private String rvgrade;
	private String rvimg;
	private String rvcontent;
	
	
}
