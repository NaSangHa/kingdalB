package com.study.springboot.service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.study.springboot.dao.IAddressDAO;
import com.study.springboot.dao.IDeliveryStatusDAO;
import com.study.springboot.dao.ILikeDAO;
import com.study.springboot.dao.IMemberDAO;
import com.study.springboot.dao.IOrderHistoryDAO;
import com.study.springboot.dao.IOrderHistoryDetailDAO;
import com.study.springboot.dao.IRestaurantDAO;
import com.study.springboot.dao.IReviewDAO;
import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.OrderHistoryCardDTO;
import com.study.springboot.dto.OrderHistoryDTO;
import com.study.springboot.dto.OrderHistoryDetailDTO;
import com.study.springboot.dto.RestaurantDTO;

@Service
public class OrderService implements IOrderService
{
	@Autowired
	IMemberDAO memberdao;
	@Autowired
	IAddressDAO addressdao;
	@Autowired
	IOrderHistoryDAO orderhistorydao;
	@Autowired
	IOrderHistoryDetailDAO orderhistorydetaildao;
	@Autowired
	ILikeDAO likedao;
	@Autowired
	IReviewDAO reviewdao;
	@Autowired
	IRestaurantDAO restaurantdao;
	@Autowired
	IDeliveryStatusDAO deliverystatusdao;
	
	
	
	@Override
	public List<OrderHistoryCardDTO> getOrderHistoryById(String id)
	{
		ArrayList<OrderHistoryCardDTO> orderHistoryCards = new ArrayList<>();
		
		List<OrderHistoryDTO> orderHistories = orderhistorydao.getAllOrderHistoryById(id);
		
		for(OrderHistoryDTO orderHistory : orderHistories)
		{
			String rid = orderHistory.getRid();
			String orderid = orderHistory.getOrderid();
			Timestamp orderdate_ts = orderHistory.getOrderdate();
			String orderdate = String.valueOf(orderdate_ts);
			orderdate = orderdate.substring(0, 10);
			
			
			RestaurantDTO restaurant = restaurantdao.getRestaurantByRid(rid);
			String rlogo = restaurant.getRlogo();
			String rtitle = restaurant.getRtitle();
			
			String mainFood = "";
			List<OrderHistoryDetailDTO> orderHistoryDetails = orderhistorydetaildao.getOrderHistoryDetailByOid(orderid);
			for(OrderHistoryDetailDTO orderHistoryDetail : orderHistoryDetails)
			{
				mainFood = orderHistoryDetail.getMainfood();
				break;
			}
			
			System.out.println("===== 주문내역 카드에 넣을 정보 =====");
			System.out.println("rid : " + rid);
			System.out.println("orderid : " + orderid);
			System.out.println("orderdate : " + orderdate);
			System.out.println("rlogo : " + rlogo);
			System.out.println("rtitle : " + rtitle);
			System.out.println("mainFood : " + mainFood);
			System.out.println("=====================================");
			
			
			OrderHistoryCardDTO orderHistoryCard = new OrderHistoryCardDTO();
			orderHistoryCard.setRid(rid);
			orderHistoryCard.setOrderid(orderid);
			orderHistoryCard.setOrderdate(orderdate);
			orderHistoryCard.setRlogo(rlogo);
			orderHistoryCard.setRtitle(rtitle);
			orderHistoryCard.setMainfood(mainFood);
			
			orderHistoryCards.add(orderHistoryCard);
			
		}
		
		
		return orderHistoryCards;
	}
	
	@Override
	public void deleteOrderHistoryByOid(String orderid)
	{
		orderhistorydao.deleteOrderHistoryByOid(orderid);
		orderhistorydetaildao.deleteOrderHistoryDetailByOid(orderid);
	}
	
	@Override
	public OrderHistoryDTO getOrderHistoryByOid(String orderid)
	{
		OrderHistoryDTO orderHistory = orderhistorydao.getOrderHistoryByOid(orderid);
		
		return orderHistory;
	}
	
	@Override
	public void insertOrderHistory(String id, String rid, String ordertype, String orderlocation, String deliverytip)
	{
		orderhistorydao.insertOrderHistory(id, rid, ordertype, orderlocation, deliverytip);
	}
	
	@Override
	public OrderHistoryDTO getRecentOrderHistoryByid(String id, String rid)
	{
		OrderHistoryDTO orderHistory = orderhistorydao.getRecentOrderHistoryByid(id, rid);
		
		return orderHistory;
	}
	
	@Override
	public void insertOrderHistoryDetail(String orderid, String mainfood, String foodoption, String quantity, String price)
	{
		orderhistorydetaildao.insertOrderHistoryDetail(orderid, mainfood, foodoption, quantity, price);
	}
	
	//-------------------------------------------------------------------------------------------------------------
	@Override
	public List<OrderHistoryDetailDTO> getOrderHistoryDetailByOid(String orderid)
	{
		List<OrderHistoryDetailDTO> orderHistoryDetails = orderhistorydetaildao.getOrderHistoryDetailByOid(orderid);
		
		return orderHistoryDetails;
	}
	
	//--------------------------------------------------------------------------------------------------------------
	@Override
	public RestaurantDTO getRestaurantByRid(String rid)
	{
		RestaurantDTO restaurant = restaurantdao.getRestaurantByRid(rid);
		
		return restaurant;
	}


	//--------------------------------------------------------------------------------------------------------------
	@Override
	public void insertInitDeliveryStatus(String orderid, String id)
	{
		deliverystatusdao.insertInitDeliveryStatus(orderid, id);
	}
	
	@Override
	public DeliveryStatusDTO getDeliveryStatusById(String id)
	{
		DeliveryStatusDTO deliveryStatus = deliverystatusdao.getDeliveryStatusById(id);
		
		return deliveryStatus;
	}
}

















