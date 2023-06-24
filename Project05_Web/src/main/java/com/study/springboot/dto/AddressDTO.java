package com.study.springboot.dto;

import lombok.Data;

@Data
public class AddressDTO
{
	private String id;
	private String aid;
	private String addrtype;
	private String addrtitle;
	private String mainaddr;
	
	private String subaddr;
	private String lat;
	private String lon;
	private String adapt;
	
}
