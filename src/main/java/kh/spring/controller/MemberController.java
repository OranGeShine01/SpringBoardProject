package kh.spring.controller;

import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kh.spring.dao.MembersDAO;
import kh.spring.dto.MembersDTO;

@Controller
@RequestMapping("/member/")
public class MemberController {
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	private MembersDAO dao;
	
	@RequestMapping(value="login", method=RequestMethod.POST)
	public String login(String id, String pw) throws Exception {
		
		boolean result = dao.isLoginOk(id, pw);
		if (result) {
			session.setAttribute("loginID", id);									
		} 
		
		return "redirect:/";
		
	}
	
	@RequestMapping("toSignup")
	public String toSingup() {
		return "member/signup";
	}
	
	@ResponseBody
	@RequestMapping("idCheck")
	public String idCheck(String id) throws Exception {
		
		boolean result = dao.idCheck(id);
		return String.valueOf(result);		
	}
	
	@RequestMapping(value="join")
	public String join(MembersDTO dto, MultipartFile[] files) throws Exception {
			
			String realPath = session.getServletContext().getRealPath("upload");
			File filePath = new File(realPath);
			if (!filePath.exists()) {
				filePath.mkdir();
			}
			
			if (!files[0].getOriginalFilename().equals("")) {
				for(MultipartFile file : files) {
					if (file.getOriginalFilename().equals("")) {continue;}
					String oriName = file.getOriginalFilename();
					String sysName = UUID.randomUUID() + "_" + oriName;
					file.transferTo(new File(filePath + "/" + sysName));
					dto.setProfileImg(sysName);
				}
			} else {
				dto.setProfileImg("no-profile.jpg");
			}
			dao.insert(dto);
		
		return "redirect:/";		
	}
	
	@RequestMapping("logout")
	public String logout() {
		session.invalidate();
		return "redirect:/";
	}
	
	@RequestMapping("delete")
	public String delete() throws Exception {
		String id = session.getAttribute("loginID").toString();
		dao.delete(id);
		session.invalidate();
		return "redirect:/";
	}
	
	@RequestMapping("mypage")
	public String mypage(Model model) throws Exception {
		String id = session.getAttribute("loginID").toString();
		MembersDTO dto = dao.mypage(id);
		model.addAttribute("members", dto);
		return "member/mypage";		
	}
	
	@RequestMapping("update")
	public String update(MembersDTO dto, MultipartFile[] files) throws Exception {
		dto.setId(session.getAttribute("loginID").toString());
		String realPath = session.getServletContext().getRealPath("upload");
		File filePath = new File(realPath);
		if (!filePath.exists()) {
			filePath.mkdir();
		}
		
		if (!files[0].getOriginalFilename().equals("")) {
			for (MultipartFile file : files) {
				if (file.getOriginalFilename().equals("")) {continue;}
				String oriName = file.getOriginalFilename();
				String sysName = UUID.randomUUID() + "_" + oriName;
				file.transferTo(new File(filePath + "/" + sysName));
			}
		}
		
		int result = dao.update(dto);
		return "redirect:/";		
	}
	
	@RequestMapping("updateImg")
	public void updateImg(MembersDTO dto) throws Exception {
		dto.setId(session.getAttribute("loginID").toString());
		//dao.updateImg(dto);
		return;
	}
	
	@ExceptionHandler(Exception.class)
	public String excetionHandler(Exception e) {
		e.printStackTrace();
		return "error";
	}	
}
