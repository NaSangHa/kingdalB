package com.study.springboot.oauth2;

import java.io.Serializable;

import lombok.Getter;

@Getter
//@Data
public class SessionUser implements Serializable 
{
	private static final long serialVersionUID = 1L;
	
	private String name;
	private String email;
	private String picture;
	private String logintype;


	public SessionUser(String name, String email, String picture, String logintype)
	{
		super();
		this.name = name;
		this.email = email;
		this.picture = picture;
		this.logintype = logintype;
	}
	
}