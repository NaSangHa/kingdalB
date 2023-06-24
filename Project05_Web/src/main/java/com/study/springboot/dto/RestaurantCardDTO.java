package com.study.springboot.dto;

import lombok.Data;

@Data
public class RestaurantCardDTO
{
	private String rid;
	private String rtitleimg;
	private String rlogo;
	private String rtitle;
	private double avgstar;
	
	private int totalreview;
	private String rdeliverytime1;
	private String rdeliverytime2;
	private String rminprice;
	private String rpaymethod;
	
	private String rdeliverytip1;
	private String rdeliverytip2;
	
	
}
