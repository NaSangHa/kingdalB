package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.OrderHistoryDetailDTO;

@Mapper
public interface IOrderHistoryDetailDAO
{
	public List<OrderHistoryDetailDTO> getOrderHistoryDetailByOid(String orderid);
	public void deleteOrderHistoryDetailByOid(String orderid);
	public void insertOrderHistoryDetail(String orderid, String mainfood, String foodoption, String quantity, String price);
}
