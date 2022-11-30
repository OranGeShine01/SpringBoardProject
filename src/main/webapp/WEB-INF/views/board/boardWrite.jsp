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
<title>글보기</title>
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

#text {
	width: 100%;
	height: 300px;
}

#div1>button {
	float: right;
}

#div1 {
	height: 25px;
}
</style>
</head>
<body>
	<form action="/board/insert" id="form" method="post" enctype="multipart/form-data">
		<div class=container>
			<div>자유게시판 글 작성하기</div>
			<div>
				<input type="text" placeholder="글 제목을 입력하세요" id="title" name="title">
			</div>
			<div id="text">
				<textarea placeholder="글 내용을 입력하세요." id="contents" name="contents"
					style="width: 100%; height: 90%; resize: none;"></textarea>				
			</div>
			<div><input type=file name=files></div>
			<div><input type=file name=files></div>
			<div id="div1">
				<a href="/board/list?cpage=1"><button id="listBack" type=button>목록으로</button></a>
				<button id="writeConfirm" type=button>작성완료</button>
			</div>
		</div>
	</form>
	
	<script>
		// 변수설정
		let writeConfirm = document.getElementById("writeConfirm");
		let title = document.getElementById("title");
		let contents = document.getElementById("contents");
		
		// 글 작성 이벤트
		
		writeConfirm.addEventListener("click", function(){
						
			if (title.value.length!=0 && contents.value.length!=0) {
				let form = document.getElementById("form");
				form.submit();
			} else if (title.value.length==0) {
				alert("글 제목을 입력하세요.")
			} else if (contents.value.length==0) {
				alert("글 내용을 입력하세요.")
			}	
		});
		
	</script>
</body>
</html>