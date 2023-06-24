package com.study.springboot.oauth2;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import lombok.Builder;
import lombok.Getter;

@Getter
public class OAuthAttributes {
	private Map<String, Object> attributes;
	private String nameAttributeKey;
	private String name;
	private String email;
	private String picture;
	
	@Builder
	public OAuthAttributes(Map<String, Object> attributes, String nameAttributeKey, String name, String email, String picture) 
	{
		this.attributes = attributes;
		this.nameAttributeKey = nameAttributeKey;
		this.name = name;
		this.email = email;
		this.picture = picture;
	}

	public static OAuthAttributes of(String registrationId, String userNameAttributeName, Map<String, Object> attributes) 
	{
		System.out.println("로그인 방식1 : " + registrationId);
//		System.out.println("로그인 방식2 : " + userNameAttributeName);
		
		if (registrationId.equals("google")) {
			System.out.println("구글 로그인 진행");
			return ofGoogle(userNameAttributeName, attributes);
		} else if  (registrationId.equals("facebook")) {
			System.out.println("페이스북 로그인 진행");
			return ofFacebook(userNameAttributeName, attributes);
		} else if  (registrationId.equals("kakao")) {
			System.out.println("카카오 로그인 진행");
			return ofKakao(userNameAttributeName, attributes);
		} else if  (registrationId.equals("naver")) {
			System.out.println("네이버 로그인 진행");
			return ofNaver(userNameAttributeName, attributes);
		}
		return ofGoogle(userNameAttributeName, attributes);
	}

		
	// 구글 로그인
	private static OAuthAttributes ofGoogle(String userNameAttributeName, Map<String, Object> attributes) 
	{
		return OAuthAttributes.builder()
				.name((String) attributes.get("name"))
				.email((String) attributes.get("email"))
				.picture((String) attributes.get("picture"))
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();
	}
	
	// 페이스북 로그인
	private static OAuthAttributes ofFacebook(String userNameAttributeName, Map<String, Object> attributes) 
	{
//		System.out.println(attributes);
		String sName = (String) attributes.get("name");
		String sEmail = (String) attributes.get("email");
		Map<String, Object> pic1 = (Map<String, Object>) attributes.get("picture");
		Map<String, Object> pic2 = (Map<String, Object>) pic1.get("data");
		String pic3 = (String) pic2.get("url");
		
		return OAuthAttributes.builder()
				.name(sName)
				.email(sEmail)
				.picture(pic3)
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();
	}

	// 카카오 로그인
	private static OAuthAttributes ofKakao(String userNameAttributeName, Map<String, Object> attributes) 
	{
//		System.out.println(attributes);
		Map<String, Object> obj1 = (Map<String, Object>) attributes.get("kakao_account");
		Map<String, Object> obj2 = (Map<String, Object>) obj1.get("profile");
		String sName = (String) obj2.get("nickname");
		String sPic = (String) obj2.get("thumbnail_image_url");
		String sEmail = (String) obj1.get("email");
		
		return OAuthAttributes.builder()
				.name(sName)
				.email(sEmail)
				.picture(sPic)
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();
	}

	// 네이버 로그인
	private static OAuthAttributes ofNaver(String userNameAttributeName, Map<String, Object> attributes) 
	{
//		System.out.println(attributes);
		Map<String, Object> obj1 = (Map<String, Object>) attributes.get("response");
		String sName = (String) obj1.get("name");
		String sPic = (String) obj1.get("profile_image");
		String sEmail = (String) obj1.get("email");

		return OAuthAttributes.builder()
				.name(sName)
				.email(sEmail)
				.picture(sPic)
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();
	}

}