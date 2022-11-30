package kh.spring.dto;

public class FilesDTO {

	private int filesSeq;
	private String oriName;
	private String sysName;
	private int filesParentSeq;
	
	public FilesDTO() {}
	public FilesDTO(int filesSeq, String oriName, String sysName, int filesParentSeq) {
		super();
		this.filesSeq = filesSeq;
		this.oriName = oriName;
		this.sysName = sysName;
		this.filesParentSeq = filesParentSeq;
	}
	public int getFilesSeq() {
		return filesSeq;
	}
	public void setFilesSeq(int filesSeq) {
		this.filesSeq = filesSeq;
	}
	public String getOriName() {
		return oriName;
	}
	public void setOriName(String oriName) {
		this.oriName = oriName;
	}
	public String getSysName() {
		return sysName;
	}
	public void setSysName(String sysName) {
		this.sysName = sysName;
	}
	public int getFilesParentSeq() {
		return filesParentSeq;
	}
	public void setFilesParentSeq(int filesParentSeq) {
		this.filesParentSeq = filesParentSeq;
	}	
}
