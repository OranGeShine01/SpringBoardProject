package kh.spring.dao;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import kh.spring.dto.MembersDTO;

@Component
public class MembersDAO {	
	@Autowired
	private JdbcTemplate jdbc;

	public int insert(MembersDTO dto) {
		
		String sql = "insert into members values(?, ?, ?, ?, ?, ?, ?, ?, sysdate, null, ?)";
		return jdbc.update(sql, dto.getId(), dto.getPw(), dto.getName(), dto.getPhone(), dto.getEmail(), dto.getZipcode(), dto.getAddress1(), dto.getAddress2(), dto.getProfileImg());				
	}
	
	public int delete(String id) throws Exception {
	
		String sql = "delete from members where id=?";
		return jdbc.update(sql, id);
	}
	public int update(MembersDTO dto) throws Exception {
	
	String sql = "update members set pw = ?, email = ?, name = ?, phone = ?, zipcode = ?, address1 = ?, address2 = ?, profileImg=? where id=?";
	return jdbc.update(getSHA512(dto.getPw()), dto.getEmail(), 
			dto.getName(), dto.getPhone(), dto.getZipcode(), 
			dto.getAddress1(), dto.getAddress2(), dto.getProfileImg(), dto.getId());
		
	}

	public List<MembersDTO> selectAll() { // List를 Select할 경우 query
		String sql = "select * from members";
		return jdbc.query(sql, new RowMapper<MembersDTO>() {
			@Override
			public MembersDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
				MembersDTO dto = new MembersDTO();
				dto.setId(rs.getString("id"));
				dto.setEmail(rs.getString("email"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setZipcode(rs.getString("zipcode"));
				dto.setAddress1(rs.getString("address1"));
				dto.setAddress2(rs.getString("address2"));
				dto.setSignupDate(rs.getTimestamp("signup_date"));
				dto.setProfileImg(rs.getString("profileImg"));
				return dto;
			}
		});
	}	
	
	// list가 아닌 단일값을 select할 경우 queryForObject
	
	public boolean idCheck(String id) throws Exception {
		
		String sql = "select count(*) from members where id=?";
		if (jdbc.queryForObject(sql, Integer.class, id)==0) {
			return false;
		} else {
			return true;
		}
	}
	
//	실습용코드 - int값 하나와 같은 값 추출
//	public int selectCount() {
//		String sql = "select count(*) from message";
//		return jdbc.queryForObject(sql, Integer.class);		
//	}
//	
//	
	public boolean isLoginOk(String id, String pw) throws Exception {
		
		String sql = "select count(*) from members where id=? and pw=?";
		
		if (jdbc.queryForObject(sql, Integer.class, id, getSHA512(pw))==0) {
			return false;
		} else {
			return true;
		}	
	}
	

	
	public MembersDTO mypage(String id) throws Exception {
		
		String sql = "select * from members where id=?";
		
		return jdbc.queryForObject(sql, new RowMapper<MembersDTO>() {
			@Override
			public MembersDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
				MembersDTO dto = new MembersDTO();
				dto.setId(rs.getString("id"));
				dto.setEmail(rs.getString("email"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setZipcode(rs.getString("zipcode"));
				dto.setAddress1(rs.getString("address1"));
				dto.setAddress2(rs.getString("address2"));
				dto.setSignupDate(rs.getTimestamp("signup_date"));
				dto.setProfileImg(rs.getString("profileImg"));
				return dto;
			}
		});			
	}	

	public static String getSHA512(String input){

		String toReturn = null;
		try {
		    MessageDigest digest = MessageDigest.getInstance("SHA-512");
		    digest.reset();
		    digest.update(input.getBytes("utf8"));
		    toReturn = String.format("%0128x", new BigInteger(1, digest.digest()));
		} catch (Exception e) {
		    e.printStackTrace();
		}
		
		return toReturn;
	}
}
//	