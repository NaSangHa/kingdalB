package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO
{
	public MemberDTO getOneMemberByET(String email, String type);
	public MemberDTO getOneMemberById(String id);
	public void insertMember(String type, String email, String pw, String nickname, String phone);
	public void updateNicknameById(String id, String nickname);
	public void updateMyInfoNickName(String id, String nickname); 
	public void updateMyInfoProfileImg(String id, String profileimg); 
	public void updatePassword(String id, String pw);
}
