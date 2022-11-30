package kh.spring.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.Queue;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import kh.spring.dto.BoardDTO;

@Component
public class BoardDAO {
	
	@Autowired
	private DataSource ds;

	public BoardDTO[] selectAll() throws Exception {
		
		String sql = "select * from board";
		
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			ResultSet rs = pstat.executeQuery();
						
			Queue<BoardDTO> queue = new LinkedList<>();
			BoardDTO[] list;
			
			while (rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setSeq(rs.getInt("seq"));
				dto.setWriter(rs.getString("writer"));
				dto.setContents(rs.getString("contents"));
				dto.setWriteDate(rs.getTimestamp("write_date"));
				dto.setViewCount(rs.getInt("view_count"));
				queue.add(dto);
			}
			
			int l = queue.size(); // length
			list = new BoardDTO[l];
			
			for (int i=0; i<=l; i++) {
				list[i] = queue.poll();
			}
			
			return list;
		}		
	}
	
	public int getRecordCount() throws Exception{
		String sql = "select count(*) from board";
		try(Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);ResultSet rs = pstat.executeQuery()){
			rs.next();
			return rs.getInt(1);
		}
	}
	
	public int viewCount(int seq) throws Exception{
		String sql = "update board set view_count = view_count+1 where seq = ?";
		try(Connection con = ds.getConnection(); 
				PreparedStatement pstat = con.prepareStatement(sql);){
			pstat.setInt(1, seq);
			int result = pstat.executeUpdate();
			return result;
		}
	}
	
	public BoardDTO[] selectByRange(int start, int end) throws Exception {
		String sql = "select * from (select board.*, row_number() over(order by seq desc) rn from board) where rn between ? and ?";
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setInt(1, start);
			pstat.setInt(2, end);
			
			ResultSet rs = pstat.executeQuery();
			Queue<BoardDTO> queue = new LinkedList<>();
			BoardDTO[] list;
			while (rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setSeq(rs.getInt("seq"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setContents(rs.getString("contents"));
				dto.setWriteDate(rs.getTimestamp("write_date"));
				dto.setViewCount(rs.getInt("view_count"));
				queue.add(dto);
			}
			
			int l = queue.size();
			list = new BoardDTO[l];
			for (int i=0; i<l; i++) {
				list[i] = queue.poll();
			}
			
			return list;
		}
	}
	
	public String getPageNavi(int currentPage, int rcpp, int ncpp) throws Exception {
		
		int recordTotalCount = this.getRecordCount();
		int pageTotalCount = 0;
		if (recordTotalCount % rcpp != 0) {
			pageTotalCount = recordTotalCount / rcpp + 1;
		} else {
			pageTotalCount = recordTotalCount / rcpp;
		}
		
		if (currentPage < 1) {
			currentPage = 1;
		} else if (currentPage > pageTotalCount) {
			currentPage = pageTotalCount;
		}
		
		// ↑ get방식을 통해 음수값을 받았을 때 대처하기 위함
				// 7 : 1~10;
				// 15 : 11~20;
				// 28 : 21~30페이지를 보게 되어야 함
		
		int startNavi = (currentPage - 1) / ncpp * ncpp + 1;
		int endNavi = startNavi + ncpp - 1;
		
		if (endNavi > pageTotalCount) {
			endNavi = pageTotalCount;
		}
		
		boolean needPrev = true;
		boolean needNext = true;
		
		if (startNavi==1) {
			needPrev = false;
		}
		if (endNavi == pageTotalCount) {
			needNext = false;
		}
		
		StringBuilder sb = new StringBuilder();
		
			if(needPrev) {
				sb.append("<a href='/board/list?cpage="+(startNavi-1)+"'> < </a>");
			}

			for(int i = startNavi;i<=endNavi;i++) {
				sb.append("<a href='/board/list?cpage="+i+"'>" +i+ "</a> ");
			}
		
			if(needNext) {
				sb.append("<a href='/board/list?cpage="+(endNavi+1)+"'> < </a>");
			}				
		return sb.toString();			
	}
	
	public int write(BoardDTO dto) throws Exception {
		String sql = "insert into board values(?, ?, ?, ?, sysdate, 0)";
		
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setInt(1, dto.getSeq());
			pstat.setString(2, dto.getWriter());
			pstat.setString(3, dto.getTitle());
			pstat.setString(4, dto.getContents());
			int result = pstat.executeUpdate();
			return result;
		}		
	}
	
	public BoardDTO selectSeq(int seq) throws Exception {
		String sql = "select * from board where seq=?";
		
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setInt(1, seq);
			ResultSet rs = pstat.executeQuery();
			rs.next();
			BoardDTO dto = new BoardDTO();			
			dto.setSeq(seq);
			dto.setWriter(rs.getString("writer"));
			dto.setTitle(rs.getString("title"));
			dto.setContents(rs.getString("contents"));
			dto.setWriteDate(rs.getTimestamp("write_date"));
			dto.setViewCount(rs.getInt("view_count"));
			return dto;
		}
	}
	
	public int delete(int seq) throws Exception {
		String sql = "delete from board where seq=?";
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setInt(1, seq);
			int result = pstat.executeUpdate();
			return result;			
		}
	}
	
	public int update(BoardDTO dto) throws Exception {
		String sql = "update board set title=?, contents=? where seq=?";
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {
			pstat.setString(1, dto.getTitle());
			pstat.setString(2, dto.getContents());
			pstat.setInt(3, dto.getSeq());
			
			int result = pstat.executeUpdate();
			return result;
		}
	}
	
	public int getSeq() throws Exception {
		String sql = "select board_seq.nextVal from dual";
		
		try (Connection con = ds.getConnection();
				PreparedStatement pstat = con.prepareStatement(sql);) {			
			ResultSet rs = pstat.executeQuery();
			rs.next();
			return rs.getInt(1);
		}
	}
	
}
