<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판</title>
<script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>

<style>
* {
	box-sizing: border-box;
}

div {
	border: 1px solid black;
}

.container {
	width: 1000px;
	margin: auto;
}

.header {
	text-align: center;
}

.naviMenu {
	overflow: hidden;
	width: 100%;
}

div[class^=navi] {
	float: left;
	text-align: center;
}

.navi1 {
	width: 5%;
}

.navi2 {
	width: 60%;
}

.navi3 {
	width: 14%;
}

.navi4 {
	width: 12%;
}

.navi5 {
	width: 9%;
}

.list {
	height: 300px;
	overflow-y: auto;
}

.footer>div:first-child {
	text-align: center;
}

.footer>div:nth-child(2) {
	text-align: right;
}

a {
	text-decoration: none;
}

#noContents {
	text-align: center;
	line-height: 300px;
	border: none;
	display: none;
}

#yesContents {
	overflow: hidden;
	width: 100%;
	margin: 0%;
	padding: 0%;
}

.listWrap {
	width: 100%;
	overflow: hidden;
}

.listWrap div {
	font-size: small;
	overflow: hidden;
	height: 23.6px;
}
</style>
</head>
<body>
	<div class="container">
		<div class="header">
		
			<h3>자유게시판</h3>
		</div>
		<div class="main">
			<div class="list">
				<div class="navi1">번호</div>
				<div class="navi2">제목</div>
				<div class="navi3">작성자</div>
				<div class="navi4">작성일</div>
				<div class="navi5">조회</div>
				<c:choose>
					<c:when test="${not empty list }">
						<c:forEach var="list" items="${list}">
							<div class="listWrap">
								<div class="navi1" id="seq">
									${list.seq } <input type="hidden" class="seq" name="seq"
										value="${list.seq }">
								</div>
								<div class="navi2">
									<a href="/board/detail?seq=${list.seq }"
										id="getIn">${list.title }</a>
								</div>
								<div class="navi3">${list.writer }</div>
								<div class="navi4">${list.writeDate }</div>
								<div class="navi5" id="count">
									${list.viewCount } <input type="hidden" name="view_count"
										value="${list.viewCount }">
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						출력할 내용이 없습니다.
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="footer">
			<div class="page">${navi }</div>
			<div>
				<a href="/"><button type="button">메인으로</button></a> <a
					href="/board/write"><button type="button">작성하기</button></a>
			</div>
		</div>
	</div>
</body>
<script>
	//$(function(){
	//$(".getIn").on("click",function(){
	//$("#form").attr("action", "/viewCount.board");
	//$("#form").submit();
	//})
	//})
	//	let title = document.getElementsByClassName("title");
	//let seq = document.getElementsByClassName("seq");
	//window.onload = function() {
	//for (let i = 0; i < title.length; i++) {
	//title[i].addEventListener("click", function() {
	//$("#form").attr("action", "/viewCount.board");
	//$("#form").submit();
	//})
	//}
	//}
</script>
</html>