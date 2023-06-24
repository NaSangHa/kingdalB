package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class OrderHistoryCardDTO
{
	private String rid;
	private String orderid;
	private String orderdate;
	private String rlogo;
	private String rtitle;
	private String mainfood;
	
}
