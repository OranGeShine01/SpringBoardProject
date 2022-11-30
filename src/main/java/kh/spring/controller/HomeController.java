package kh.spring.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kh.spring.dao.MembersDAO;

@Controller
public class HomeController {
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	private MembersDAO dao;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) throws Exception {
		if ((String)session.getAttribute("loginID")!=null) {
			String profileImg = dao.mypage(session.getAttribute("loginID").toString()).getProfileImg();
			model.addAttribute("profileImg", profileImg);
		} 
		return "home";
		
	}
	
	@ExceptionHandler(Exception.class)
	public String excetionHandler(Exception e) {
		e.printStackTrace();
		return "error";
	}
	
}
