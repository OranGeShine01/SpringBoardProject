package kh.spring.controller;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/file/")
public class FilesController {
	
	@Autowired
	private HttpSession session;
	
	@RequestMapping("list")
	public String list() {
		return "/file";
	}
		
	@RequestMapping("download")
	public void download(String oriName, String sysName, HttpServletResponse resp) throws Exception {
		String realPath = session.getServletContext().getRealPath("upload");
		File targetFile = new File(realPath + "/" + sysName);
		// 파일 위치 + 다운받을 이름 대상 특정
		
		oriName = new String(oriName.getBytes("utf8"), "ISO-8859-1");
		resp.setHeader("content-disposition", "attachment;filename=\"" + oriName +"\";");
		// 응답데이터가 첨부파일임을 알림, 다운로드 파일 이름 세팅
		
		try (DataInputStream dis = new DataInputStream(new FileInputStream(targetFile));
				DataOutputStream dos = new DataOutputStream(resp.getOutputStream());) {
			// Client에게 direct로 전송할 네트워크 Stream 개방
			
			byte[] fileContents = new byte[(int)targetFile.length()];
			dis.readFully(fileContents);
			dos.write(fileContents);
			dos.flush();			
		}
	}
}
