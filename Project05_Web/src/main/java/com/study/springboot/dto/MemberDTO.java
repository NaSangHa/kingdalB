package com.study.springboot.dto;

import lombok.Data;

@Data
public class MemberDTO
{
	private String id;
	private String type;
	private String email;
	private String pw;
	private String nickname;
	private String phone;
	private String profileimg;
	private String authority;
	private String enabled;
	
}
