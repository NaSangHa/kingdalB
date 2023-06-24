package com.study.springboot.oauth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.CredentialsExpiredException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

@Configuration
public class CustomAuthenticationFailureHandler implements AuthenticationFailureHandler
{
	@Override
	public void onAuthenticationFailure(HttpServletRequest request,
										HttpServletResponse response,
										AuthenticationException exception)
	throws IOException, ServletException
	{
		String loginId = request.getParameter("email");
		String errormsg = "";
		
		if(exception instanceof BadCredentialsException)
		{
			errormsg = "사용자 정보를 다시 확인해주세요.";
		}
		else if (exception instanceof InternalAuthenticationServiceException)
		{
			errormsg = "사용자 정보를 다시 확인해주세요.";
		}
		else if (exception instanceof DisabledException)
		{
			
			errormsg = "계정이 비활성화 되어있습니다. 관리자에게 문의하세요.";
		}
		else if (exception instanceof CredentialsExpiredException)
		{
			
			errormsg = "비밀번호 유효기간이 만료되었습니다. 관리자에게 문의하세요.";
		}
		
		System.out.println("loginId : " + loginId);
		System.out.println("errormsg : " + errormsg);
		
		request.setAttribute("username", loginId);
		request.setAttribute("errormsg", errormsg);
		
		request.getRequestDispatcher("/login/login?error=true").forward(request, response);
	}
}
