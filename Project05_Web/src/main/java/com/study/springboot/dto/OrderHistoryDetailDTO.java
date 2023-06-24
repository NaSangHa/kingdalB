package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class OrderHistoryDetailDTO
{
	private String orderid;
	private String mainfood;
	private String foodoption;
	private String quantity;
	private String price;
	
	
}
