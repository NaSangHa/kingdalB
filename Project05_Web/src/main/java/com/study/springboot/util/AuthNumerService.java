package com.study.springboot.util;

import java.util.Random;

import org.springframework.stereotype.Service;

@Service
public class AuthNumerService
{
    public String randomNumber() 
    {
    	Random random = new Random();
		int num1 = random.nextInt(10);
		int num2 = random.nextInt(10);
		int num3 = random.nextInt(10);
		int num4 = random.nextInt(10);
		
		
		String str1 = String.valueOf(num1);
		String str2 = String.valueOf(num2);
		String str3 = String.valueOf(num3);
		String str4 = String.valueOf(num4);
		
		String authNumber = str1+str2+str3+str4;
		
		return authNumber;
    }

}

