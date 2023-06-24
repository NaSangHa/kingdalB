package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class OrderHistoryDTO
{
	private String id;
	private String rid;
	private String ordertype;
	private String orderid;
	private Timestamp orderdate;
	private String orderlocation;
	private String deliverytip;
	
}
