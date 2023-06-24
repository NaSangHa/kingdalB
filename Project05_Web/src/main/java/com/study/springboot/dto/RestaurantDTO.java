package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class RestaurantDTO
{
	private String rid;
	private String rtitleimg;
	private String rlogo;
	private String rtitle;
	private String rcategory;
	private String rphone;
	private String rminprice;
	private String rpaymethod;
	private String rdeliverytime;
	private String rdeliverytip;
	private String ropentime;
	private String closetime;
	private String rlat;
	private String rlon;
	
	
}
