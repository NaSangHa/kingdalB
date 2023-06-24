package com.study.springboot.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dto.MemberDTO;
import com.study.springboot.oauth.WebSecurityConfig;
import com.study.springboot.service.IMemberService;
import com.study.springboot.util.AuthNumerService;
import com.study.springboot.util.EmailSenderService;
import com.study.springboot.util.SigninValidator;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;



@Controller
public class LoginController
{
	@Autowired
	IMemberService memberService;
	
	@Autowired
	AuthNumerService authorNumberService;
	String randomAuthoNumber;
	
	@Autowired
	WebSecurityConfig pwEncoder;
	
	@Autowired
	EmailSenderService emailSender;
	
	//----------------------------------------------------------------------------	
	// 로그인 페이지 이동
	@RequestMapping("/login/login")
	public String login(HttpServletRequest request, Model model)
	{	
		System.out.println("로그인 페이지로 이동");

		// 로그인 정보 확인
		HttpSession session = null;
		session = request.getSession();
		if(session.getAttribute("loginInfo") == null)
		{
			System.out.println("로그인 정보가 없습니다.");
			model.addAttribute("loginInfo", null);
		}

		return "login/login";
	}
	
	// 회원가입 페이지 이동
	@RequestMapping("/login/signin")
	public String signin(HttpServletRequest request, Model model)
	{	
		System.out.println("회원가입 페이지 이동");
		
		// 로그인 정보 확인
		HttpSession session = null;
		session = request.getSession();
		if(session.getAttribute("loginInfo") == null)
		{
			System.out.println("로그인 정보가 없습니다.");
			model.addAttribute("loginInfo", null);
		}
		
		return "login/signin";
	}			
	
	// 비밀번호 찾기 페이지로 이동
	@RequestMapping("/login/findPassword")
	public String findPassword(HttpServletRequest request, Model model)
	{	
		System.out.println("비밀번호 찾기 페이지 이동");
		
		// 로그인 정보 확인
		HttpSession session = null;
		session = request.getSession();
		if(session.getAttribute("loginInfo") == null)
		{
			System.out.println("로그인 정보가 없습니다.");
			model.addAttribute("loginInfo", null);
		}
		
		return "login/findPassword";
	}	
	
	// [인증번호]-----------------------------------------------------------------------------
	// 인증번호 전송 전 번호 체크
	@RequestMapping("/login/authorNumberProcess")
	public @ResponseBody String authorNumberProcess(HttpServletRequest request, Model model, @Validated MemberDTO member, BindingResult result)
	{	
		System.out.println("인증번호 전송 전 번호 체크");
		
		String phone = request.getParameter("phone");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("phone : " + phone);
		System.out.println("==============================");
		
		JSONObject obj = new JSONObject();
		obj.put("phone", "");
		
		// Validation 1
		if(result.hasErrors())
		{			
			if(result.getFieldError("phone") != null)
			{
				obj.put("phone", result.getFieldError("phone").getCode());
			}
		}
		
		return obj.toJSONString();
	}
	
	// 인증번호 전송 - SMS
	final DefaultMessageService messageService;
	
	public LoginController() {
        this.messageService = NurigoApp.INSTANCE.initialize("NCSKSP6THTVYE7CA", "AT9SIQKHPWJ8PCVZJLT2RQI5KNFMWEWP", "https://api.coolsms.co.kr");
    }
	
	@RequestMapping("/login/sendAuthorNumber")
    public @ResponseBody String sendAuthorNumber(HttpServletRequest request, Model model) 
	{	
		String phone = request.getParameter("phone");
		
		randomAuthoNumber =  authorNumberService.randomNumber();
		System.out.println("인증번호 : " + randomAuthoNumber);
		    		
        Message message = new Message();
        message.setFrom("01064854990");
        message.setTo(phone);
        message.setText("[킹달비] 인증번호 : " + randomAuthoNumber);

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        System.out.println(response);

        return "인증번호가 전송되었습니다";
    }
	
	
	
	// [일반 회원]----------------------------------------------------------------------------
	// 일반 로그인 - 성공
	@RequestMapping("/login/loginOk")
	public String loginOk(HttpServletRequest request, Model model)
	{	
		String email = request.getParameter("email");
		String status;
		if(request.getParameter("status") == null)
		{
			status = "";			
		}
		else
		{
			status = request.getParameter("status");
		}
		String socialLoginType = "normal";
		
		System.out.println("일반 로그인 성공");
		System.out.println("로그인 성공! 로그인 된 Email : " + email);
		System.out.println("로그인 성공! 로그인 된 type : " + socialLoginType);
		System.out.println("로그인 성공! 로그인 된 status : " + status);
		
		if(status.equals("flutter"))
		{
			System.out.println("플루터로 로그인 했습니다.");
			return "redirect:/flutter/login";
		}

		
		MemberDTO member = memberService.getOneMemberByET(email, socialLoginType);
		String id = member.getId();
		
		// 로그인 정보 확인
		HttpSession session = null;
		session = request.getSession();
		session.setAttribute("loginInfo", id);
		
		return "redirect:/main";
	}
	
	// 일반 회원가입 - Validation
	@RequestMapping("/login/signinProcess")
	public @ResponseBody String signinProcess(HttpServletRequest request, Model model, @Validated MemberDTO member, BindingResult result)
	{	
		System.out.println("회원가입 폼 체크 이동");
		
		String email = request.getParameter("email");
		String pw = request.getParameter("pw");
		String pwCheck = request.getParameter("pwCheck");
		String phone = request.getParameter("phone");
		String authorNumber = request.getParameter("authorNumber");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("email : " + email);
		System.out.println("pw : " + pw);
		System.out.println("pwCheck : " + pwCheck);
		System.out.println("phone : " + phone);
		System.out.println("authorNumber : " + authorNumber);
		System.out.println("==============================");
		
		
		JSONObject obj = new JSONObject();
		obj.put("email", "");
		obj.put("pw", "");
		obj.put("phone", "");
		obj.put("authorNumber", "");
		
		
		// Validation 1
		if(result.hasErrors())
		{			
			if(result.getFieldError("email") != null)
			{
				obj.put("email", result.getFieldError("email").getCode());
			}
			if(result.getFieldError("pw") != null)
			{
				obj.put("pw", result.getFieldError("pw").getCode());
			}
			if(result.getFieldError("phone") != null)
			{
				obj.put("phone", result.getFieldError("phone").getCode());
			}
		}
		
		// Validation 2
		if(!pw.equals(pwCheck))
		{
			obj.put("pw", "비밀번호가 일치하지 않습니다.");
		}
		if(!authorNumber.equals(randomAuthoNumber))
		{
			obj.put("authorNumber", "인증번호가 일치하지 않습니다.");
		}
		if(authorNumber.length() == 0)
		{
			obj.put("authorNumber", "필수 정보입니다.");
		}
		
		// Validation 3 (아이디 중복확인)
		MemberDTO emailDobbleCheck = memberService.getOneMemberByET(email, "normal");
		if(emailDobbleCheck != null)
		{
			obj.put("email", "이미 사용중인 이메일입니다.");
		}
		
		return obj.toJSONString();
	}
	
	@InitBinder
	protected void initBinder(WebDataBinder binder)
	{
		binder.setValidator(new SigninValidator());
	}
	
	// 일반 회원가입 - 성공 
	@RequestMapping("/login/signinOk")
    public @ResponseBody String signinOk(HttpServletRequest request, Model model) 
	{	
		System.out.println("회원가입 진행");
		
		String type = "normal";
		String email = request.getParameter("email");
		String pw = request.getParameter("pw");
		pw = pwEncoder.passwordEncoder().encode(pw);
		String nickname = "kingdal" + authorNumberService.randomNumber();
		String phone = request.getParameter("phone");
		
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("type : " + type);
		System.out.println("email : " + email);
		System.out.println("pw : " + pw);
		System.out.println("nickname : " + nickname);
		System.out.println("phone : " + phone);
		System.out.println("==============================");
		
		// 회원가입 - MemberDB
		memberService.insertMember(type, email, pw, nickname, phone);	
		
        return "일반 회원가입";
    }
	
	
	// [SNS 회원]---------------------------------------------------------------------------
	// SNS 로그인 - 여부확인
	@RequestMapping("/login/socialInfoCheck")
	public String socialLoginInfo(HttpServletRequest request, Model model)
	{			
		System.out.println("소셜 로그인 성공");
		HttpSession session = null;
		session = request.getSession();
		System.out.println("소셜회원 정보" + session.getAttribute("loginInfo"));
		
		// 가입 안 되어 있으면 추가 정보 입력 후 가입 진행
		if(session.getAttribute("loginInfo") == null)
		{
			String snsEmail = (String)session.getAttribute("snsEmail");
			String snsType = (String)session.getAttribute("snsType");
			
			System.out.println("추가 정보 입력 할 SNS EMail : " + snsEmail);
			System.out.println("추가 정보 입력 할 SNS Type : " + snsType);

			model.addAttribute("snsEmail", snsEmail);
			model.addAttribute("snsType", snsType);
			model.addAttribute("userAddress", "어디로 배달할까요?");
			return "login/signinSns";
		}
		// 가입 되어 있으면 로그인 진행
		else
		{			
			return "redirect:/main";
		}
		
	}
	
	// SNS 회원가입 - Validation
	@RequestMapping("/login/signinSnsProcess")
	public @ResponseBody String signinSnsProcess(HttpServletRequest request, Model model, @Validated MemberDTO member, BindingResult result)
	{	
		System.out.println("SNS 회원가입 폼 체크 이동");
		
		String type = request.getParameter("type");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String authorNumber = request.getParameter("authorNumber");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("type : " + type);
		System.out.println("email : " + email);
		System.out.println("phone : " + phone);
		System.out.println("authorNumber : " + authorNumber);
		System.out.println("==============================");
		
		
		JSONObject obj = new JSONObject();
		obj.put("email", "");
		obj.put("pw", "");
		obj.put("phone", "");
		obj.put("authorNumber", "");
		
		
		// Validation
		if(!authorNumber.equals(randomAuthoNumber))
		{
			obj.put("authorNumber", "인증번호가 일치하지 않습니다.");
		}
		if(authorNumber.length() == 0)
		{
			obj.put("authorNumber", "필수 정보입니다.");
		}
		
		return obj.toJSONString();
	}
		
	// SNS 회원가입  - 성공
	@RequestMapping("/login/signinSnsOk")
    public @ResponseBody String signinSnsOk(HttpServletRequest request, Model model) 
	{	
		System.out.println("SNS 회원가입 진행");
		
		String type = request.getParameter("type");
		String email = request.getParameter("email");
		String pw = "123456";
		pw = pwEncoder.passwordEncoder().encode(pw);
		String nickname = "kingdal" + authorNumberService.randomNumber();
		String phone = request.getParameter("phone");
		
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("type : " + type);
		System.out.println("email : " + email);
		System.out.println("nickname : " + nickname);
		System.out.println("phone : " + phone);
		System.out.println("==============================");
		
		// 회원가입 - MemberDB
		memberService.insertMember(type, email, pw, nickname, phone);	
		
        return "SNS 회원가입";
    }

	// [비밀번호 찾기]---------------------------------------------------------------------------------------
	// 비밀번호 찾기 - 폼체크
	@RequestMapping("/login/findPasswordProcess")
    public @ResponseBody String findPasswordProcess(HttpServletRequest request, Model model) 
	{	
		System.out.println("비밀번호 찾기 과정-폼체크");
		JSONObject obj = new JSONObject();
				
		String email = request.getParameter("email");
		String authorNumber = request.getParameter("authorNumber");
		String pw = request.getParameter("pw");
		String pwCheck = request.getParameter("pw");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("email : " + email);
		System.out.println("authorNumber : " + authorNumber);
		System.out.println("pw : " + pw);
		System.out.println("pwCheck : " + pwCheck);
		System.out.println("==============================");
		
		MemberDTO member = memberService.getOneMemberByET(email, "normal");
		System.out.println("member : " + member);
		
		obj.put("errorMsg", "");
		
		if(member == null)
		{
			System.out.println("입력에 해당한 회원 정보가 없습니다.");
			obj.put("errorMsg", "사용자 정보를 확인해주세요.");
			return obj.toJSONString();
		}
		
        return obj.toJSONString();
    }
	
	// 비밀번호 찾기 - 인증번호 전송
	@RequestMapping("/login/sendAuthorNumber_findPassword")
	public @ResponseBody String sendAuthorNumber_findPassword(HttpServletRequest request, Model model) 
	{	
		System.out.println("비밀번호 찾기 과정-인증번호전송");
		JSONObject obj = new JSONObject();
		
		String email = request.getParameter("email");
		String authorNumber = request.getParameter("authorNumber");
		String pw = request.getParameter("pw");
		String pwCheck = request.getParameter("pw");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("email : " + email);
		System.out.println("authorNumber : " + authorNumber);
		System.out.println("pw : " + pw);
		System.out.println("pwCheck : " + pwCheck);
		System.out.println("==============================");
		
		// 인증번호 생성
		randomAuthoNumber = authorNumberService.randomNumber();
		
		String subject = "[킹달비] 비밀번호 찾기";
		String body = "비밀번호 찾기 인증번호 : " + randomAuthoNumber;
		
		emailSender.sendSimpleEmail(email, subject, body);
		System.out.println("비밀번호 찾기 인증번호 : " + randomAuthoNumber);
		
		obj.put("success", "인증번호가 메일로 전송되었습니다.");
		
		
		
		return obj.toJSONString();
	}
	
	// 비밀번호 찾기 - 인증번호 확인
	@RequestMapping("/login/confrimAuthorNumber")
	public @ResponseBody String confrimAuthorNumber(HttpServletRequest request, Model model) 
	{	
		System.out.println("비밀번호 찾기 과정-인증번호확인");
		JSONObject obj = new JSONObject();
		
		String email = request.getParameter("email");
		String authorNumber = request.getParameter("authorNumber");
		String pw = request.getParameter("pw");
		String pwCheck = request.getParameter("pw");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("email : " + email);
		System.out.println("authorNumber : " + authorNumber);
		System.out.println("pw : " + pw);
		System.out.println("pwCheck : " + pwCheck);
		System.out.println("==============================");
		
		// 인증번호 생성
		// randomAuthoNumber = authorNumberService.randomNumber();
		obj.put("result", "fail");
		obj.put("desc", "");
		
		if(authorNumber.equals(randomAuthoNumber))
		{
			System.out.println("인증번호가 일치합니다.");
			obj.put("result", "success");
			obj.put("desc", "확인되었습니다.");
			return obj.toJSONString();
		}
		
		return obj.toJSONString();
	}
	
	// 비밀번호 찾기 - 비밀번호 변경
	@RequestMapping("/login/updatePassword")
	public @ResponseBody String updatePassword(HttpServletRequest request, Model model) 
	{	
		System.out.println("비밀번호 찾기 과정-비밀번호 변경");
		JSONObject obj = new JSONObject();
		
		String email = request.getParameter("email");
		String authorNumber = request.getParameter("authorNumber");
		String pw = request.getParameter("pw");
		String pwCheck = request.getParameter("pw");
		
		System.out.println("===== 폼에서 받아온 정보 =====");
		System.out.println("email : " + email);
		System.out.println("authorNumber : " + authorNumber);
		System.out.println("pw : " + pw);
		System.out.println("pwCheck : " + pwCheck);
		System.out.println("==============================");
		
		MemberDTO member = memberService.getOneMemberByET(email, "normal");
		String id = member.getId();
		pw = pwEncoder.passwordEncoder().encode(pw);
		memberService.updatePassword(id, pw);
		
		obj.put("result", "비밀번호가 변경되었습니다.");
		
		return obj.toJSONString();
	}
	
}
