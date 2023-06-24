package com.study.springboot.dto;

import lombok.Data;

@Data
public class StarDTO
{
	private String rid;
	private int totalreview;
	private double avgstar;
	private int star5;
	private int star4;
	private int star3;
	private int star2;
	private int star1;
	private double ratio5;
	private double ratio4;
	private double ratio3;
	private double ratio2;
	private double ratio1;
	
}
