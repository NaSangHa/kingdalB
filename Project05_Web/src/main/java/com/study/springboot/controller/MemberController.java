package com.study.springboot.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.study.springboot.dto.AddressDTO;
import com.study.springboot.dto.CartContentDTO;
import com.study.springboot.dto.CartDTO;
import com.study.springboot.dto.DeliveryStatusDTO;
import com.study.springboot.dto.MemberDTO;
import com.study.springboot.dto.MenuDTO;
import com.study.springboot.dto.OrderHistoryCardDTO;
import com.study.springboot.dto.OrderHistoryDTO;
import com.study.springboot.dto.OrderHistoryDetailDTO;
import com.study.springboot.dto.RestaurantCardDTO;
import com.study.springboot.dto.RestaurantDTO;
import com.study.springboot.oauth.WebSecurityConfig;
import com.study.springboot.service.IMemberService;
import com.study.springboot.service.IOrderService;
import com.study.springboot.service.IRestaurantService;
import com.study.springboot.util.AuthNumerService;



@Controller
public class MemberController
{
	@Autowired
	IMemberService memberService;
	@Autowired
	IOrderService orderService;
	@Autowired
	IRestaurantService restaurantService;
	
	@Value("${upload.path}")
	private String uploadPath;	
	
	@Autowired
	AuthNumerService authorNumberService;
	String randomAuthoNumber;
	
	@Autowired
	WebSecurityConfig pwEncoder;
	
	
	//----------------------------------------------------------------------------	
	// 적용중인 주소 변경
	@RequestMapping("/member/updateAdaptAddr")
	public @ResponseBody String updateAdaptAddr(HttpServletRequest request, Model model)
	{	
		System.out.println("적용중인 주소 변경");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		String aid = request.getParameter("aid");
		
		System.out.println("id : " + id);
		System.out.println("aid : " + aid);
		
		memberService.updateAdaptAddress(id, aid);
		AddressDTO address = memberService.getAddressByAid(aid);
		String userAddress = address.getMainaddr() + " " + address.getSubaddr();

		return userAddress;
	}
	
	// 주소 추가
	@RequestMapping("/member/insertAddress")
	public @ResponseBody String insertAddress(HttpServletRequest request, Model model)
	{	
		System.out.println("주소 추가");
		
		
		String mainaddr = request.getParameter("addr1");
		String subaddr = request.getParameter("addr2");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		System.out.println("id : " + id);
		System.out.println("mainaddr : " + mainaddr);
		System.out.println("subaddr : " + subaddr);
	
		memberService.insertAddress(id, mainaddr, mainaddr, subaddr);
		AddressDTO address = memberService.getAdaptAddressById(id);
		
		JSONObject obj = new JSONObject();
		
		String addressList = ""
				+ "<div class=\"col row align-items-center addressListWrap \" onclick=\"updateAdaptAddr('" + address.getAid() + "')\">"
				+ "                            <div class=\"col-1 \">"
				+ "                                <div class=\"addressIcon\">"
				+ "                                    <img src=\"/upload/" + address.getAddrtype() + ".png\" alt=\"\">"
				+ "                                </div>"
				+ "                            </div>"
				+ "                            <div class=\"col addressContentWrap \">"
				+ "                                <div class=\"addressTitle\">" + address.getAddrtitle() + "</div>"
				+ "                                <div class=\"addressContent\">"+ address.getMainaddr() + " " + address.getSubaddr() +"</div>"
				+ "                            </div>"
				+ "                            <div class=\"col-2 text-center addressAdapt \" id=\"addressAdapt" + address.getAid() + "\">"
				+ "	                            <c:set var=\"adapt\" value=\""+address.getAdapt()+"\" />"
				+ "	                            <c:if test=\"${adapt eq 1}\">"
				+ "	                            	적용중"
				+ "	                            </c:if>"
				+ "                            </div>"
				+ "                        </div>";
		String navAddress = address.getMainaddr() + " " + address.getSubaddr();
		
		obj.put("addressList", addressList);
		obj.put("navAddress", navAddress);
		
		return obj.toJSONString();
	}
		
	// 내정보 페이지로 이동
	@RequestMapping("/member/myinfo")
	public String myinfo(HttpServletRequest request, Model model)
	{	
		System.out.println("내정보 페이지로 이동");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		// 1. 프로필 사진, 닉네임 가져오기
		MemberDTO member = memberService.getOneMemberById(id);
		
		// 2. 활성화 된 주소 가져오기
		AddressDTO adaptAddress = memberService.getAdaptAddressById(id);
		String userAddress = adaptAddress.getMainaddr() + " " + adaptAddress.getSubaddr();
		
		// 3. 주소 리스트 가져오기
		List<AddressDTO> addresses = memberService.getAllAddressById(id);
		
		model.addAttribute("loginMember", member);			// 1
		model.addAttribute("userAddress", userAddress);		// 2
		model.addAttribute("addresses", addresses);			// 3
		
		// 4. 주문진행상황 확인 후 가져오기
		DeliveryStatusDTO deliveryStatus = orderService.getDeliveryStatusById(id);
		System.out.println("deliveryStatus : " + deliveryStatus);
		if(deliveryStatus != null)
		{
			if(deliveryStatus.getStep2() == null)
			{
				model.addAttribute("deliveryMsg", "주문완료! 음식이 맛있게 조리중이에요");
			}
			else
			{
				model.addAttribute("deliveryMsg", "배달시작! 얼른 갈게요~");
			}
			model.addAttribute("deliveryStatus", deliveryStatus);
		}
		
		// 최근 주문 갯수
		int recentOrderCnt = memberService.getRecentOrderCntById(id);
		System.out.println("recentOrderCnt : " + recentOrderCnt);
		model.addAttribute("recentOrderCnt", recentOrderCnt);		
		
		// 찜목록
		int likeCnt = memberService.getLikeCntById(id);
		System.out.println("likeCnt : " + likeCnt);
		model.addAttribute("likeCnt", likeCnt);	
		
		// 내가 쓴 리뷰
		int myReviewCnt = memberService.getMyReviewCntById(id);
		System.out.println("myReviewCnt : " + myReviewCnt);
		model.addAttribute("myReviewCnt", myReviewCnt);	
		
		
		
		return "member/myinfo";
	}
	
	// 내정보 - 닉네임 변경 폼 가져오기
	@RequestMapping("/member/getNicknameForm")
	public @ResponseBody String getNicknameForm(HttpServletRequest request, Model model)
	{	
		System.out.println("닉네임 변경 폼 가져오기");
		
		String nickname = request.getParameter("nickname");
		
		String content = ""
				+ "<form name=\"modifyMyInfoForm\" id=\"modifyMyInfoForm\">"
				+ "    <div class=\"col row justify-content-center porfileimgInput\">"
				+ "        <div class=\"col-3\">"
				+ "            <input class=\"form-control form-control-sm\" id=\"profileimg\" name=\"profileimg\" type=\"file\" onchange=\"changeimg(event)\">"
				+ "        </div>"
				+ "    </div>"
				+ "    <div class=\"col row align-items-center justify-content-center\">"
				+ "        <div class=\"col-3 \">"
				+ "            <input type=\"text\" name=\"nickname\" id=\"nickname\" class=\"text-center nicknameModifyField\" value=\""+nickname+"\">"
				+ "        </div>"
				+ "        <div class=\"col-1 nicknameModifyBtn\" onclick=\"modifyMyInfo()\">수정</div>"
				+ "    </div>"
				+ "</form>";
		
		
		
		return content;
	}
	
	// 파일 업로드1
	@RequestMapping(value="/member/modifyMyInfo", method=RequestMethod.POST)
	public @ResponseBody String uploadAction(HttpServletRequest request, Model model)
	{
		System.out.println("파일 업로드 시작");
		
		JSONObject obj = new JSONObject();
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		String nickname = request.getParameter("nickname");
			
		
		// 뷰로 전달할 정보를 저장하기 위한 Map타입의 변수
		Map returnObj = new HashMap();
		
		String saveFileName = "";
		
		try {
			// 서버의 물리적경로 가져오기
			String path = ResourceUtils.getFile(uploadPath).toPath().toString();
			
			System.out.println("[파일 업로드] 서버의 물리적 경로 : " + path);

			MultipartHttpServletRequest mhsr = (MultipartHttpServletRequest) request;
			System.out.println("[파일 업로드] mhsr : " + mhsr);
			
			// 업로드폼의 file속성 필드의 이름을 모두 읽음
			Iterator<String> itr = mhsr.getFileNames();
			MultipartFile mfile = null;			
			String fileName = "";		
			
			// 파일 하나의 정보를 저장하기 위한 List타입의 변수(원본파일명, 저장된파일명 등)
			List resultList = new ArrayList();
										
			// 업로드폼의 file속성의 필드의 갯수만큼 반복
			while (itr.hasNext()) {
				
				// userfile1, userfile2....출력됨
				fileName = (String)itr.next();
				System.out.println("filename : " + fileName);	
				
				// 서버로 업로드된 임시파일명 가져옴
				mfile = mhsr.getFile(fileName);
				System.out.println("mfile : " + mfile);  //CommonsMultipartFile@1366c0b 형태임
				
				// 한글깨짐방지 처리 후 업로드된 파일명을 가져온다.
				String originalName = 
					//mfile.getOriginalFilename();
				    new String(mfile.getOriginalFilename().getBytes(),"UTF-8"); // Linux
				System.out.println("upload : " + originalName);
				
				// 파일명이 공백이라면 while문의 처음으로 돌아간다.
				if("".equals(originalName)){
					continue;
				}
				//System.out.println("originalName:"+originalName);

				// 파일명에서 확장자 가져오기
//						String ext = originalName.substring(originalName.lastIndexOf('.'));
				
				// 파일명을 UUID로 생성된값으로 변경함.
//						String saveFileName = getUuid() + ext;
				saveFileName = getUuid() + "." + originalName;
				
				// 설정한 경로에 파일저장
				File serverFullName = new File(path + File.separator + saveFileName);
				
				// 업로드한 파일을 지정한 파일에 저장한다.
				mfile.transferTo(serverFullName);
				
				Map file = new HashMap();
				file.put("originalName", originalName);    //원본파일명
				file.put("saveFileName", saveFileName);    //저장된파일명
				file.put("serverFullName", serverFullName);//서버에 저장된 전체경로 및 파일명
				
				// 위 파일의 정보를 담은 Map을 List에 저장
				resultList.add(file);
			}
			returnObj.put("files", resultList);
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		// Form에서 들어온 정보 확인
		System.out.println("===== 입력한 정보 ====");
		System.out.println("nickname : " + nickname);
		System.out.println("업로드 할 파일 명 : " + saveFileName);
		System.out.println("======================");
		
		
		String content = ""
				+ ""+nickname+"<img src=\"/upload/modify.png\" alt=\"\" onclick=\"getNicknameForm('"+nickname+"')\">";
		obj.put("profileimg", saveFileName);
		obj.put("content", content);
		
		
		
		
		if(saveFileName.equals(""))
		{
			memberService.updateMyInfoNickName(id, nickname);
			obj.put("result", "1");
			return obj.toJSONString();
		}
		else
		{
			memberService.updateMyInfoNickName(id, nickname);
			memberService.updateMyInfoProfileImg(id, saveFileName);
			obj.put("result", "2");
			return obj.toJSONString();
		}
		
	}
	
	// 파일 업로드2
	public static String getUuid(){
		String uuid = UUID.randomUUID().toString();
		//System.out.println(uuid);		
		uuid = uuid.replaceAll("-", "");
		//System.out.println("생성된UUID:"+ uuid);
		return uuid;
	}
	
	// 내정보 - 닉네임 변경 하기
	@RequestMapping("/member/updateNickname")
	public @ResponseBody String updateNickname(HttpServletRequest request, Model model)
	{	
		System.out.println("닉네임 변경하기");
		
		String nickname = request.getParameter("nickname");
		
		// 닉네임 변경하기
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		memberService.updateNicknameById(id, nickname);
		
		String content = ""
				+ ""+nickname+"<img src=\"/upload/modify.png\" alt=\"\" onclick=\"getNicknameForm('"+nickname+"')\">";
		
		return content;
	}
	
	// 내정보 - 내정보관리 페이지 가져오기
	@RequestMapping("/member/getMyInfoPage")
	public @ResponseBody String getMyInfoPage(HttpServletRequest request, Model model)
	{	
		System.out.println("내정보 페이지 가져오기");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		MemberDTO member = memberService.getOneMemberById(id);
		
		String content = ""
				+ "<div class=\"col row justify-content-end myInfoContentHead\">"
				+ "    <div class=\"col text-start myInfoContentTitle\">내정보</div>"
				+ "</div>"
				+ "<div class=\"col  myInfoEmailWrap\">"
				+ "    <div class=\"col text-start myInfoEmailTitle\">이메일</div>"
				+ "    <div class=\"col text-start myInfoEmailContent\">"+member.getEmail()+"</div>"
				+ "</div>"
				+ "<div class=\"col  myInfoPhoneWrap\">"
				+ "    <div class=\"col text-start myInfoPhoneTitle\">전화번호</div>"
				+ "    <div class=\"col row align-items-center myInfoPhoneContent\">"
				+ "        <div class=\"col text-start \">"+member.getPhone()+"</div>"
				+ "        <div class=\"col-1 text-center myInfoPhoneModify \" onclick=\"\"><!-- 수정 --></div>"
				+ "    </div>"
				+ "</div>"
				+ "<div class=\"col row justify-content-end resignMemberWrap\">"
				+ "    <div class=\"col-2 text-center resignMemberBtn\">회원탈퇴</div>"
				+ "</div>";
		
		return content;
	}
	
	// 내정보 - 주소관리 페이지 가져오기
	@RequestMapping("/member/getManageAddressPage")
	public @ResponseBody String getManageAddressPage(HttpServletRequest request, Model model)
	{	
		System.out.println("주소 페이지 가져오기");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		List<AddressDTO> addresses = memberService.getAllAddressById(id);
		
		String contentHead = ""
				+ "<div class=\"col row justify-content-end myInfoContentHead\">"
				+ "    <div class=\"col text-start myInfoContentTitle\">주소관리</div>"
				+ "    <button class=\"addAddress\" data-bs-toggle=\"modal\" data-bs-target=\"#myinfoAddressModal\">주소 추가</button>"
				+ "</div>";
		
		String content = "";
		for(AddressDTO address : addresses)
		{
			String adapt = "";
			if(address.getAdapt().equals("1"))
			{
				adapt = "적용중";
			}
			content += ""
					+ "<!-- 반복구간 -->"
					+ "<div class=\"col row align-items-center addressWrap \" id=\"addrCard"+address.getAid()+"\">"
					+ "    <div class=\"col-1 addressDelBtn \" onclick=\"deleteAddress('"+address.getAid()+"')\"><img src=\"/upload/close.png\" alt=\"\"></div>"
					+ "    <div class=\"col-1 addressIcon \"><img src=\"/upload/"+address.getAddrtype()+".png\" alt=\"\"></div>"
					+ "    <div class=\"col\">"
					+ "        <div class=\"addressTitle\">"+address.getAddrtitle()+"</div>"
					+ "        <div class=\"addressDetail\">"+address.getMainaddr()+" "+address.getSubaddr()+"</div>"
					+ "    </div>"
					+ "    <div class=\"col-2 adapt\" id=\"adapt"+address.getAid()+"\">"
					+ "	        "+adapt+""
					+ "    </div>"
					+ "</div>"
					+ "<!-- ------------------ -->";
		}
		String modal = ""
				+ "<!-- Modal -->"
				+ "<div class=\"modal fade\" id=\"myinfoAddressModal\" tabindex=\"-1\" aria-labelledby=\"exampleModalLabel\" aria-hidden=\"true\">"
				+ "    <div class=\"modal-dialog modal-lg\">"
				+ "        <div class=\"modal-content\">"
				+ "            <!-- 모달 헤드 -->"
				+ "            <div class=\"modal-header\">"
				+ "                <div class=\"modalHead\" id=\"exampleModalLabel\">주소 등록</div>"
				+ "                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>"
				+ "            </div>"
				+ "            <!-- 모달 바디 -->"
				+ "            <div class=\"modal-body\">"
				+ "                <div class=\"container-fluid\">"
				+ "                    <!-- 주소 검색 -->"
				+ "                    <div class=\"row align-items-center \">"
				+ "                        <form name=\"myInfoAddressForm\" id=\"myInfoAddressForm\">"
				+ "                            <div class=\"col\">"
				+ "                                <div class=\"col row align-items-center addressSearchdWrap\" onclick=\"addressSearch_myInfo()\">"
				+ "                                    <div class=\"col-1 text-center \"><div class=\"text-center addressSearchIcon\">"
				+ "                                        <img src=\"/upload/search.png\" alt=\"\"></div>"
				+ "                                    </div>"
				+ "                                    <div class=\"col addressSearchContent\">지번, 도로명, 건물명으로 검색</div>"
				+ "                                </div>"
				+ "                                <div class=\"col row align-items-center addressInputWrap \">"
				+ "                                    <div class=\"col-2 addressInputTitle\">주소지이름</div>"
				+ "                                    <input type=\"text\" class=\"col addressInput\" id=\"addr0_myInfo\" name=\"addr0_myInfo\" placeholder=\"주소지 이름을 입력해주세요.\">"
				+ "                                </div>"
				+ "                                <div class=\"col row align-items-center addressInputWrap \">"
				+ "                                    <div class=\"col-2 addressInputTitle\">주소</div>"
				+ "                                    <input type=\"text\" class=\"col addressInput\" id=\"addr1_myInfo\" name=\"addr1_myInfo\" placeholder=\"주소를 입력해주세요.\">"
				+ "                                </div>"
				+ "                                <div class=\"col row align-items-center addressInputWrap \">"
				+ "                                    <div class=\"col-2 addressInputTitle\">상세주소</div>"
				+ "                                    <input type=\"text\" class=\"col addressInput\" id=\"addr2_myInfo\" name=\"addr2_myInfo\" placeholder=\"상세 주소를 입력해주세요.\">"
				+ "                                </div>"
				+ "                                <div class=\"col row justify-content-end\">"
				+ "                                    <div class=\"text-center addAddressBtn \" onclick=\"addressFormCheck_myInfo()\">추가</div>"
				+ "                                </div>"
				+ "                            </div>"
				+ "                        </form>"
				+ "                    </div>"
				+ "                </div>"
				+ "            </div>"
				+ "        </div>"
				+ "    </div>"
				+ "</div> ";
		
		return contentHead+content+modal;
	}

	// 내정보 - 주문내역 페이지 가져오기
	@RequestMapping("/member/getOrderHistoryPage")
	public @ResponseBody String getOrderHistoryPage(HttpServletRequest request, Model model)
	{	
		System.out.println("주문내역 페이지 가져오기");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		String contentHead = ""
				+ "<!-- 내용 타이틀 -->"
				+ "<div class=\"col row justify-content-end myInfoContentHead\">"
				+ "    <div class=\"col text-start myInfoContentTitle\">주문내역</div>"
				+ "</div>";

		
		List<OrderHistoryCardDTO> orderhistoryCards = orderService.getOrderHistoryById(id);
		
		String content = "";
		for(OrderHistoryCardDTO orderhistoryCard : orderhistoryCards)
		{
			content += ""
					+ "<!-- 반복구간 -->"
					+ "<div class=\"col align-items-center orderHistoryWrap \" id=\"orderHistoryCard"+orderhistoryCard.getOrderid()+"\">"
					+ "    <div class=\"col row align-items-center orderHistoryHead\">"
					+ "        <div class=\"col text-start orderDate \">"+orderhistoryCard.getOrderdate()+"</div>"
					+ "        <div class=\"col-2 row justify-content-center \">"
					+ "            <button class=\"orderDetailBt\" data-bs-toggle=\"modal\" data-bs-target=\"#orderhistoryModal\" onclick=\"getOrderDetailModal('"+orderhistoryCard.getOrderid()+"')\">주문상세</button>"
					+ "        </div>"
					+ "        <div class=\"col-1 orderHistoryDelBtn \">"
					+ "            <img src=\"/upload/close.png\" alt=\"\" onclick=\"deleteOrderHistory('"+orderhistoryCard.getOrderid()+"')\">"
					+ "        </div>"
					+ "    </div> "
					+ "    <div class=\"col row\">"
					+ "        <div class=\"col-2  \">"
					+ "            <div class=\"orderRestaurantLogo\"><img src=\"/upload/"+orderhistoryCard.getRlogo()+"\" alt=\"\"></div>"
					+ "        </div>"
					+ "        <div class=\"col \">"
					+ "            <div class=\"text-start orderRestaurantName \" onclick=\"\">"+orderhistoryCard.getRtitle()+" ></div>"
					+ "            <div class=\"text-start orderContent\">"+orderhistoryCard.getMainfood()+"</div>"
					+ "        </div>"
					+ "    </div>"
					+ "</div>"
					+ "<!-- --------------------------- -->";			
		}
		
		String modal = ""
				+ "<div class=\"modal fade\" id=\"orderhistoryModal\" tabindex=\"-1\" aria-labelledby=\"exampleModalLabel\" aria-hidden=\"true\">"
				+ "    <div class=\"modal-dialog modal-lg\">"
				+ "        <div class=\"modal-content\">"
				+ "            <!-- 모달 헤드 -->"
				+ "            <div class=\"modal-header\">"
				+ "                <div class=\"modalHead\" id=\"exampleModalLabel\">주문상세</div>"
				+ "                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"modal\" aria-label=\"Close\"></button>"
				+ "            </div>"
				+ "            <!-- 모달 바디 -->"
				+ "            <div class=\"modal-body\" id=\"orderhistoryModalBody\">"
				+ "            </div>"
				+ "        </div>"
				+ "    </div>"
				+ "</div> ";
		
			
		
		
		String result = contentHead + content + modal;
		
		return result;
	}
	
	// 내 정보 주소 추가
	@RequestMapping("/member/insertAddress_myInfo")
	public @ResponseBody String insertAddress_myInfo(HttpServletRequest request, Model model)
	{	
		System.out.println("내정보 주소 추가");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		JSONObject obj = new JSONObject();

		String addrtitle = request.getParameter("addr0_myInfo");
		String mainaddr = request.getParameter("addr1_myInfo");
		String subaddr = request.getParameter("addr2_myInfo");
		
		System.out.println("id : " + id);
		System.out.println("addrtitle : " + addrtitle);
		System.out.println("mainaddr : " + mainaddr);
		System.out.println("subaddr : " + subaddr);
		
		if(addrtitle.equals("")) 
		{
			memberService.insertAddress(id, mainaddr, mainaddr, subaddr);			
		}
		if(!addrtitle.equals(""))
		{
			memberService.insertAddress(id, addrtitle, mainaddr, subaddr);
		}
		
		AddressDTO address = memberService.getAdaptAddressById(id);
				
		String addressList = ""
				+ "<!-- 반복구간 -->"
				+ "<div class=\"col row align-items-center addressWrap \" id=\"addrCard"+address.getAid()+"\">"
				+ "    <div class=\"col-1 addressDelBtn \" onclick=\"deleteAddress('"+address.getAid()+"')\"><img src=\"/upload/close.png\" alt=\"\"></div>"
				+ "    <div class=\"col-1 addressIcon \"><img src=\"/upload/"+address.getAddrtype()+".png\" alt=\"\"></div>"
				+ "    <div class=\"col\">"
				+ "        <div class=\"addressTitle\">"+address.getAddrtitle()+"</div>"
				+ "        <div class=\"addressDetail\">"+address.getMainaddr()+" "+address.getSubaddr()+"</div>"
				+ "    </div>"
				+ "    <div class=\"col-2 adapt\" id=\"adapt"+address.getAid()+"\">"
				+ "	        적용중"
				+ "    </div>"
				+ "</div>"
				+ "<!-- ------------------ -->";

		
		// Nav 수정
		String navAddress = address.getMainaddr() + " " + address.getSubaddr();
		
		String navAddressList = ""
				+ "<div class=\"col row align-items-center addressListWrap \" id=\"modalAddress"+address.getAid()+"\" onclick=\"updateAdaptAddr('"+address.getAid()+"')\">"
				+ "    <div class=\"col-1 \">"
				+ "        <div class=\"addressIcon\">"
				+ "            <img src=\"/upload/"+address.getAddrtype()+".png\" alt=\"\">"
				+ "        </div>"
				+ "    </div>"
				+ "    <div class=\"col addressContentWrap \">"
				+ "        <div class=\"addressTitle\">"+address.getAddrtitle()+"</div>"
				+ "        <div class=\"addressContent\">"+address.getMainaddr()+" "+address.getSubaddr()+"</div>"
				+ "    </div>"
				+ "    <div class=\"col-2 text-center addressAdapt \" id=\"addressAdapt"+address.getAid()+"\">"
				+ "     	적용중"
				+ "    </div>"
				+ "</div>";
		obj.put("addressList", addressList);
		obj.put("navAddress", navAddress);
		obj.put("navAddressList", navAddressList);
		
		return obj.toJSONString();
	}
	
	// 내정보 - 주소 삭제
	@RequestMapping("/member/deleteAddress")
	public @ResponseBody String deleteAddress(HttpServletRequest request, Model model)
	{	
		System.out.println("내정보 주소 삭제");
		String aid = request.getParameter("aid");
		
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		System.out.println("id : " + id);
		System.out.println("aid : " + aid);
		
		AddressDTO address = memberService.getAdaptAddressById(id);
		if(address.getAid().equals(aid)) {
			
			return "적용중인 주소는 삭제가 불가능 합니다. (적용을 해제해 주세요)";
		}
		
		memberService.deleteAddressByAid(aid);
		
		
		return "";
	}
	
	// 내정보 - 주문내역 삭제
	@RequestMapping("/member/deleteOrderHistory")
	public @ResponseBody String deleteOrderHistory(HttpServletRequest request, Model model)
	{	
		System.out.println("주문내역 삭제");
		String orderid = request.getParameter("orderid");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		orderService.deleteOrderHistoryByOid(orderid);
		
		return "삭제되었습니다.";
	}
	
	// 내정보 = 주문상세 모달 가져오기
	@RequestMapping("/member/getOrderDetailModal")
	public @ResponseBody String getOrderDetailModal(HttpServletRequest request, Model model)
	{	
		System.out.println("주문상세 모달 가져오기");
		String orderid = request.getParameter("orderid");
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		
		OrderHistoryDTO orderHistory = orderService.getOrderHistoryByOid(orderid);
		String rid = orderHistory.getRid();
		Timestamp orderdate_ts = orderHistory.getOrderdate();
		String orderdate = String.valueOf(orderdate_ts);
		orderdate = orderdate.substring(0, 10);
		String orderlocation = orderHistory.getOrderlocation();
		String deliveryTip_str = orderHistory.getDeliverytip();
		int deliveryTip = Integer.valueOf(deliveryTip_str);
		
		RestaurantDTO restaurant = orderService.getRestaurantByRid(rid);
		String rlogo = restaurant.getRlogo();
		String rtitle = restaurant.getRtitle();
		
		String content1 = ""
				+ "<div class=\"col text-center  ohModalHeader\">영수증</div>"
				+ "<div class=\"col row align-items-center ohRestaurantTitle \">"
				+ "    <div class=\"col-2 text-center ohRestaurantLogo\">"
				+ "        <img src=\"/upload/"+rlogo+"\" alt=\"\">"
				+ "    </div>"
				+ "    <div class=\"col text-start ohRestaurantLogo\">"+rtitle+"</div>"
				+ "</div>"
				+ "<div class=\"col text-start ohOederDate \">주문 일시 : "+orderdate+"</div>"
				+ "<div class=\"col text-start ohOederLocation \">배달주소 : "+orderlocation+"</div>";
		
		
		String content2 = "";
		int orderPrice = 0;
		List<OrderHistoryDetailDTO> orderHistoryDetails = orderService.getOrderHistoryDetailByOid(orderid);
		for(OrderHistoryDetailDTO orderHistoryDetail : orderHistoryDetails)
		{
			String mainFood = orderHistoryDetail.getMainfood();
			String foodOption = orderHistoryDetail.getFoodoption();
			String price = orderHistoryDetail.getPrice();
			int price_int = Integer.valueOf(price);
			orderPrice += price_int;
			
			content2 += ""
					+ "<!-- 반복 구간 -->"
					+ "<div class=\"col ohFoodWrap \">"
					+ "    <div class=\"col text-start ohFoodTitle\">"+mainFood+"</div>"
					+ "    <div class=\"col row align-items-center \">"
					+ "        <div class=\"col text-start ohFoodOption \">옵션 : "+foodOption+"</div>"
					+ "        <div class=\"col-2 text-center ohFoodPrice \">"+price+" 원</div>"
					+ "    </div>"
					+ "</div>"
					+ "<!-- ---------- -->";
		}
		
		int totalPrice = orderPrice + deliveryTip;
		String content3 = ""
				+ "<div class=\"col text-start ohPriceTitle \">결제금액</div>"
				+ "<div class=\"col row ohPriceContentWrap \">"
				+ "    <div class=\"col text-center ohPriceContent \">주문금액</div>"
				+ "    <div class=\"col-5 ohPriceContent2 text-end \">"+orderPrice+" 원</div>"
				+ "</div>"
				+ "<div class=\"col row ohPriceContentWrap \">"
				+ "    <div class=\"col text-center ohPriceContent \">배달팁</div>"
				+ "    <div class=\"col-5 ohPriceContent2 text-end \">"+deliveryTip_str+" 원</div>"
				+ "</div>"
				+ "<div class=\"ohdivdier\"></div>"
				+ "<div class=\"col row ohPriceContentWrap \">"
				+ "    <div class=\"col text-center ohPriceContent \">총 결제금액</div>"
				+ "    <div class=\"col-5 ohPriceContent2 text-end \">"+totalPrice+" 원</div>"
				+ "</div>"
				+ "<div class=\"ohBottomSpace\"></div>";
		
		String result = content1 + content2 + content3;
		
		return result;
	}

	//---------------------------------------------------------------------------------
	// 찜목록 페이지로 이동
	@RequestMapping("/member/like")
	public String like(HttpServletRequest request, Model model)
	{	
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		// 1. 프로필 사진, 닉네임 가져오기
		MemberDTO member = memberService.getOneMemberById(id);
		
		// 2. 활성화 된 주소 가져오기
		AddressDTO adaptAddress = memberService.getAdaptAddressById(id);
		String userAddress = adaptAddress.getMainaddr() + " " + adaptAddress.getSubaddr();
		
		// 3. 주소 리스트 가져오기
		List<AddressDTO> addresses = memberService.getAllAddressById(id);
		
		model.addAttribute("loginMember", member);			// 1
		model.addAttribute("userAddress", userAddress);		// 2
		model.addAttribute("addresses", addresses);			// 3
		
		// 4. 주문진행상황 확인 후 가져오기
		DeliveryStatusDTO deliveryStatus = orderService.getDeliveryStatusById(id);
		System.out.println("deliveryStatus : " + deliveryStatus);
		if(deliveryStatus != null)
		{
			if(deliveryStatus.getStep2() == null)
			{
				model.addAttribute("deliveryMsg", "주문완료! 음식이 맛있게 조리중이에요");
			}
			else
			{
				model.addAttribute("deliveryMsg", "배달시작! 얼른 갈게요~");
			}
			model.addAttribute("deliveryStatus", deliveryStatus);
		}
		
		
		// 식당 카드
		List<RestaurantCardDTO> restaurantCards = restaurantService.getAllLikeRestaurantCardById(id);
		
		model.addAttribute("restaurantCards", restaurantCards);
		
		return "member/like";
	}
	
	// 찜 - 목록 해제
	@RequestMapping("/member/like/deleteLike")
	public @ResponseBody String deleteLike(HttpServletRequest request, Model model)
	{	
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		String rid = request.getParameter("rid");
		System.out.println("rid : " + rid);
		
		restaurantService.deleteLike(id, rid);
		
		return "좋아요을 해제합니다.";
	}
	
	// 찜  -목록 추가
	@RequestMapping("/member/like/insertLike")
	public @ResponseBody String insertLike(HttpServletRequest request, Model model)
	{	
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		String rid = request.getParameter("rid");
		System.out.println("rid : " + rid);
		
		restaurantService.insertLike(id, rid);
		
		return "좋아요을 추가합니다.";
	}	

	//---------------------------------------------------------------------------------
	
	// 장바구니 페이로 이동
	@RequestMapping("/member/cart")
	public String cart(HttpServletRequest request, Model model)
	{	
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		// 1. 프로필 사진, 닉네임 가져오기
		MemberDTO member = memberService.getOneMemberById(id);
		
		// 2. 활성화 된 주소 가져오기
		AddressDTO adaptAddress = memberService.getAdaptAddressById(id);
		String userAddress = adaptAddress.getMainaddr() + " " + adaptAddress.getSubaddr();
		
		// 3. 주소 리스트 가져오기
		List<AddressDTO> addresses = memberService.getAllAddressById(id);
		
		model.addAttribute("loginMember", member);			// 1
		model.addAttribute("userAddress", userAddress);		// 2
		model.addAttribute("addresses", addresses);			// 3
		
		// 4. 주문진행상황 확인 후 가져오기
		DeliveryStatusDTO deliveryStatus = orderService.getDeliveryStatusById(id);
		System.out.println("deliveryStatus : " + deliveryStatus);
		if(deliveryStatus != null)
		{
			if(deliveryStatus.getStep2() == null)
			{
				model.addAttribute("deliveryMsg", "주문완료! 음식이 맛있게 조리중이에요");
			}
			else
			{
				model.addAttribute("deliveryMsg", "배달시작! 얼른 갈게요~");
			}
			model.addAttribute("deliveryStatus", deliveryStatus);
		}
		
		// 내 장바구니에 있는 식당 가져오기
		RestaurantDTO restaurant = memberService.getRestaurantRidInMyCart(id);
		System.out.println(restaurant);
		model.addAttribute("restaurant", restaurant);	
		
		// 내 장바구니에 있는 메뉴 가져오기
		List<CartContentDTO> cartContents = memberService.getAllCartContentInMyCart(id);
		model.addAttribute("cartContents", cartContents);	
		
		// 총 주문 금액
		int orderPrice = 0;
		for(CartContentDTO cartContent : cartContents)
		{
			int mprice = cartContent.getMprice();
			orderPrice += mprice;
		}
		String orderPrice_str = String.format("%,d", orderPrice);
		model.addAttribute("orderPrice", orderPrice_str);
		
		// 배달팁
		String rdeliverytip = restaurant.getRdeliverytip();
		int deliverytip = Integer.valueOf(rdeliverytip.split("#")[1]);
		String deliverytip_str = String.format("%,d", deliverytip);
		model.addAttribute("deliverytip", deliverytip_str);
		
		// 결제 예정 금액
		int totalprice = orderPrice+deliverytip;
		String totalprice_str = String.format("%,d", totalprice);
		model.addAttribute("totalprice", totalprice_str);
		return "member/cart";
	}
	
	// 장바구니 컨텐츠 제거
	@RequestMapping("/member/deleteCartContent")
	public @ResponseBody String deleteCartContent(HttpServletRequest request, Model model)
	{	
		System.out.println("장바구니 컨텐츠 제거");
		JSONObject obj = new JSONObject();
		
		String cid = request.getParameter("cid");
		
		System.out.println("cid : " + cid);
		
		memberService.deleteCartContentByCid(cid);
		
		HttpSession session = null;
		session = request.getSession();
		String id = (String)session.getAttribute("loginInfo");
		System.out.println("로그인 된 아이디 : " + id);
		
		// 내 장바구니에 있는 식당 가져오기
		RestaurantDTO restaurant = memberService.getRestaurantRidInMyCart(id);
		System.out.println(restaurant);
		model.addAttribute("restaurant", restaurant);	
		
		// 내 장바구니에 있는 메뉴 가져오기
		List<CartContentDTO> cartContents = memberService.getAllCartContentInMyCart(id);
		model.addAttribute("cartContents", cartContents);	
		
		// 총 주문 금액
		int orderPrice = 0;
		for(CartContentDTO cartContent : cartContents)
		{
			int mprice = cartContent.getMprice();
			orderPrice += mprice;
		}
		String orderPrice_str = String.format("%,d", orderPrice);
		
		// 배달팁
		String rdeliverytip = restaurant.getRdeliverytip();
		int deliverytip = Integer.valueOf(rdeliverytip.split("#")[1]);
		String deliverytip_str = String.format("%,d", deliverytip);
		
		// 결제 예정 금액
		int totalprice = orderPrice+deliverytip;
		String totalprice_str = String.format("%,d", totalprice);
		
		obj.put("orderPrice", orderPrice_str);
		obj.put("totalprice", totalprice_str);
		
		return obj.toJSONString();
		
		
	}
	
	
	



}
