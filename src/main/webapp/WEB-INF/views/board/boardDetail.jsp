<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.6.1.js">
</script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>글쓰기</title>
<style>
* {
	box-sizing: border-box;
}
div {
	border: 1px solid black;
}
.container {
	text-align: center;
	margin: auto;
	width: 60%;
	height: 100%;
}
#title {
	float: left;
	width: 100%;
}
.header {
	height:10%;
}
.header>div>div {
	float: left;
	width:25%;
}
#contents {
	width:100%;
	height:100%;
	resize: none;
}
#div1>button {
	float: right;
}
#delete, #update {
	display: none;
}
#updateConfirm {
	display: none;
}
#div1 {
	height: 25px;
}
</style>
<script>
	
	$(function() {
		if ("${loginID }" == "${detail.writer}") {
			$("#delete, #update").css("display", "inline");
		}

		$("#delete").on("click", function() {
			if (confirm("정말 삭제하시겠습니까?")) {
				let form = $("#form");
				form.attr("action", "/board/delete");
				form.submit();
			}
		})
		
		$("#update").on("click", function() {
			$("#update").css("display", "none");
			$("#updateConfirm").css("display", "inline");
			$("#title, #contents").removeAttr("readonly");
			
			$("#updateConfirm").on("click", function(){
				if (confirm("수정하시겠습니까?")) {
					let form = $("#form");
					form.attr("action", "/board/update");
					form.submit();
				}
			})
		})
	})
</script>
</head>
<body>
	
		<div class=container>
			<form id="form">
			<div>
				<div>제목</div>
				<input type = "text" id = "title" name = "title" value="${detail.title }" readonly>
			</div>
			<div class=header>
				<div>
					<div>번호</div>
					<div>작성자</div>
					<div>작성시간</div>
					<div>조회수</div>
				</div>
				<div>
					<div><input type="text" id = "seq" name="seq" readonly value="${detail.seq }"></div>
					<div>${detail.writer }</div>
					<div>${detail.writeDate }</div>
					<div>${detail.viewCount }</div>	
				</div>				
			</div>			
			<div id="text" style="width: 100%; height: 90%;">
				<textarea id="contents" name="contents" readonly>${detail.contents }</textarea>
			</div>
			</form>
			<div>
				<div>댓글</div>
				
			</div>
			<div id="div1">
				<button id="listBack" type=button><a href="/board/list?cpage=1">목록으로</a></button>
				<button id="delete" type="button">삭제하기</button>
				<button id="update" type="button">수정하기</button>
				<button id="updateConfirm" type="button">수정완료</button>
			</div>
		</div>
</body>
</html>