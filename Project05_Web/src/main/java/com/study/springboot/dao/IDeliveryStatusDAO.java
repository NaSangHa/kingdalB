package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.LikeDTO;

@Mapper
public interface IDeliveryStatusDAO
{
	public void insertInitDeliveryStatus(String orderid, String id);
	public DeliveryStatusDTO getDeliveryStatusById(String id);
}
