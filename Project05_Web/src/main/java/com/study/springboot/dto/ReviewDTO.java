package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReviewDTO
{
	private String rid;
	private String rvid;
	private String rvwriter; 
	private String rvcontent;
	private String rvimg;
	private String rvgrade;
	private Timestamp rvdate; 
	
	
}
