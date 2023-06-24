package com.study.springboot.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class DeliveryStatusDTO
{
	private String orderid;
	private String id;
	private String status;
	private Timestamp step1;
	private Timestamp step2;
	private Timestamp step3;
	
}
