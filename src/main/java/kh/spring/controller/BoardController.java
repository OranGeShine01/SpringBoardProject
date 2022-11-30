package kh.spring.controller;

import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import kh.spring.dao.BoardDAO;
import kh.spring.dao.FilesDAO;
//import kh.spring.dao.CommentsDAO;
import kh.spring.dto.BoardDTO;
import kh.spring.dto.FilesDTO;

@Controller
@RequestMapping("/board/")
public class BoardController {
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	private BoardDAO boardDao;
	
	@Autowired
	private FilesDAO filesDao;
	
	//@Autowired
	//private CommentsDAO commentsDao;
	
	@RequestMapping("list")
	public String list(int cpage, Model model) throws Exception {
		
		int rcpp=10;
		int ncpp=10;
		BoardDTO[] list = boardDao.selectByRange(((cpage-1)*rcpp+1), cpage*rcpp);
		String navi = boardDao.getPageNavi(cpage, rcpp, ncpp);
		
		
		model.addAttribute("navi", navi);
		model.addAttribute("list", list);
		
		return "board/boardList";
	}
	
	@RequestMapping("write")
	public String write() {
		return "board/boardWrite";
	}
	
	@RequestMapping("insert")
	public String insert(BoardDTO boardDto, MultipartFile[] files) throws Exception {
				
		boardDto.setWriter(session.getAttribute("loginID").toString());
		int seq = boardDao.getSeq();
		boardDto.setSeq(seq);
		boardDao.write(boardDto);
		
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
			}
		}
		
		return "redirect:/board/list?cpage=1";
	}
	
	@RequestMapping("detail")
	public String detail(BoardDTO dto, Model model) throws Exception {
		int result = boardDao.viewCount(dto.getSeq());
		dto = boardDao.selectSeq(dto.getSeq());
		//CommentsDTO[] commentsList = commentsDao.selectAll(dto.getSeq());
		model.addAttribute("detail", dto);
		//model.addAttribute("commentsList", commentsList);
		return "board/boardDetail";
	}
	
	@RequestMapping("delete")
	public String delete(int seq) throws Exception {
		int result = boardDao.delete(seq);
		return "redirect:/board/list?cpage=1";
	}
	
	@RequestMapping("update")
	public String update(BoardDTO dto, Model model) throws Exception {
		int result = boardDao.update(dto);
		return "redirect:/board/list?cpage=1";
	}
	
	@ExceptionHandler(Exception.class)
	public String excetionHandler(Exception e) {
		e.printStackTrace();
		return "error";
	}
}
