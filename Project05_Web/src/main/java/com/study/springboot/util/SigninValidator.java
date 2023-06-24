package com.study.springboot.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import com.study.springboot.dto.MemberDTO;

public class SigninValidator implements Validator
{
	@Override
	public boolean supports(Class<?> arg0)
	{
		return MemberDTO.class.isAssignableFrom(arg0);
	}
	
	@Override
	public void validate(Object obj, Errors errors)
	{
		MemberDTO member = (MemberDTO)obj;
		
		
		// 이메일 공백 확인
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "email", "필수 정보입니다.");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "pw", "필수 정보입니다.");
		ValidationUtils.rejectIfEmptyOrWhitespace(errors, "phone", "필수 정보입니다.");
				
		
		// 이메일 형식 확인
		String email = member.getEmail();
		String eamilValid = "^[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\\.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$";
		Pattern pattern = Pattern.compile(eamilValid);
		Matcher matcher = pattern.matcher(email);
		if(!matcher.matches())
		{
			errors.rejectValue("email", "이메일 형식이 아닙니다.");
		}
//		/^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/
		// 전화번호 형식 확인
		String phone = member.getPhone();
		String phoneValid = "^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$";
		pattern = Pattern.compile(phoneValid);
		matcher = pattern.matcher(phone);
		if(!matcher.matches())
		{
			errors.rejectValue("phone", "전화번호 형식을 확인해주세요.(숫자만 입력 가능합니다.)");
		}
		if(phone.length() < 7)
		{
			errors.rejectValue("phone", "번호 형식이 아닙니다.");
		}
		
		// 전화번호 형식 확인
		String pw = member.getPw();
		if(pw.length() < 6)
		{
			errors.rejectValue("pw", "비밀번호는 6자리 이상으로 입력해주세요");
		}
		
	}


}
