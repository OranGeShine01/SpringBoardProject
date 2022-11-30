package kh.spring.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import kh.spring.dto.FilesDTO;

@Component
public class FilesDAO {
	
	@Autowired
	private DataSource ds;
	
	public int upload(FilesDTO dto) throws Exception {
		
		String sql = "insert into files values(files_seq.nextVal, ?, ?, ?)";
		
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setString(1, dto.getOriName());
			pstat.setString(2, dto.getSysName());
			pstat.setInt(3, dto.getFilesParentSeq());
			int result = pstat.executeUpdate();
			return result;
		}		
	}
	
}
