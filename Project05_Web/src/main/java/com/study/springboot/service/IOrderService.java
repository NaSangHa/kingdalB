package com.study.springboot.service;

import java.util.List;

import org.springframework.stereotype.Component;

import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.OrderHistoryCardDTO;
import com.study.springboot.dto.OrderHistoryDTO;
import com.study.springboot.dto.OrderHistoryDetailDTO;
import com.study.springboot.dto.RestaurantDTO;

@Component
public interface IOrderService
{	
	public List<OrderHistoryCardDTO> getOrderHistoryById(String id);
	public void deleteOrderHistoryByOid(String orderid);
	public OrderHistoryDTO getOrderHistoryByOid(String orderid);
	public void insertOrderHistory(String id, String rid, String ordertype, String orderlocation, String deliverytip);
	public OrderHistoryDTO getRecentOrderHistoryByid(String id, String rid);
	public void insertOrderHistoryDetail(String orderid, String mainfood, String foodoption, String quantity, String price);
	
	
	public List<OrderHistoryDetailDTO> getOrderHistoryDetailByOid(String orderid);
	
	public RestaurantDTO getRestaurantByRid(String rid);
	
	public void insertInitDeliveryStatus(String orderid, String id);
	public DeliveryStatusDTO getDeliveryStatusById(String id);
	
}
