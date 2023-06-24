package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.AddressDTO;

@Mapper
public interface IAddressDAO
{
	public AddressDTO getAdaptAddressById(String id);
	public void insertInitAddres(String id, String addrtype, String addrtitle, String adapt);
	public List<AddressDTO> getAllAddressById(String id);
	public void updateAdaptAddress(String id, String aid);
	public void updateAdaptElseAddress(String id, String aid);
	public AddressDTO getAddressByAid(String aid);
	public void insertAddress(String id, String addrtitle, String mainaddr, String subaddr);
	public void insertAddress2(String id, String addrtitle, String mainaddr, String subaddr, String lat, String lon);
	public void upadteAllAddressAdaptZero(String id);
	public void deleteAddressByAid(String aid);
}
