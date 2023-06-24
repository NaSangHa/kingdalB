package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.OrderHistoryDTO;

@Mapper
public interface IOrderHistoryDAO
{
	public List<OrderHistoryDTO> getRecentOrderCntById(String id);
	public List<OrderHistoryDTO> getAllOrderHistoryById(String id);
	public void deleteOrderHistoryByOid(String orderid);
	public OrderHistoryDTO getOrderHistoryByOid(String orderid);
	public void insertOrderHistory(String id, String rid, String ordertype, String orderlocation, String deliverytip);
	public OrderHistoryDTO getRecentOrderHistoryByid(String id, String rid);
}
