//package kh.spring.dao;
//
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.util.LinkedList;
//import java.util.Queue;
//
//import javax.sql.DataSource;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
//
//import kh.spring.dto.CommentsDTO;
//
//@Component
//public class CommentsDAO {
//		
//	@Autowired
//	private DataSource ds;
//		
//	public CommentsDTO[] selectAll(int parentSeq) throws Exception {
//		
//		String sql = "select * from comments where parentSeq=? order by 1 desc";
//		
//		try (Connection con = ds.getConnection();
//			PreparedStatement pstat = con.prepareStatement(sql);) {
//			pstat.setInt(1, parentSeq);
//			
//			ResultSet rs = pstat.executeQuery();
//			Queue<CommentsDTO> queue = new LinkedList<>();
//			while (rs.next()) {
//				CommentsDTO dto = new CommentsDTO();
//				dto.setSeq(rs.getInt("seq"));
//				dto.setWriter(rs.getString("writer"));
//				dto.setContents(rs.getString("contents"));
//				dto.setWriteDate(rs.getTimestamp("write_Date"));
//				dto.setParentSeq(parentSeq);
//				queue.add(dto);
//			}
//			
//			int l = queue.size();
//			CommentsDTO[] dto = new CommentsDTO[l];
//			for (int i=0; i<l; i++) {
//				dto[i] = queue.poll();
//			}
//			return dto;
//		}
//	}
//	
//}
