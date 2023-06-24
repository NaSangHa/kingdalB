package com.study.springboot.oauth2;

import java.util.Collections;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.study.springboot.dto.MemberDTO;
import com.study.springboot.service.IMemberService;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {
	
	@Autowired
	private HttpSession httpSession;
	@Autowired
	IMemberService memberService;
	
	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		OAuth2UserService delegate = new DefaultOAuth2UserService();
		OAuth2User oAuth2User = delegate.loadUser(userRequest);

		String registrationId = userRequest.getClientRegistration().getRegistrationId();
		String userNameAttributeName = userRequest.getClientRegistration()
				                                  .getProviderDetails()
				                                  .getUserInfoEndpoint()
				                                  .getUserNameAttributeName();

		OAuthAttributes attributes = OAuthAttributes.of(registrationId,
				                                        userNameAttributeName,
				                                        oAuth2User.getAttributes());

		SessionUser user = new SessionUser(attributes.getName(),
				                           attributes.getEmail(),
				                           attributes.getPicture(),
				                           registrationId);

		httpSession.setAttribute("user", user);
		System.out.println("이메일 : " + attributes.getEmail());
		System.out.println("로그인타입 : " + registrationId);
		
		
		MemberDTO member = memberService.getOneMemberByET(attributes.getEmail(), registrationId);
		System.out.println("상태 확인 : " + memberService.getOneMemberByET(attributes.getEmail(), registrationId));
		
		if(member == null)
		{
			System.out.println("가입되어있는 정보가 없습니다.");
			httpSession.setAttribute("loginInfo", null);
			httpSession.setAttribute("snsEmail", attributes.getEmail());
			httpSession.setAttribute("snsType", registrationId);
		}
		else
		{				
			System.out.println("가입되어있는 정보가 있습니다.");
			httpSession.setAttribute("loginInfo", member.getId());
		}	

		return new DefaultOAuth2User(Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
				                     attributes.getAttributes(),
				                     attributes.getNameAttributeKey());
	}
}