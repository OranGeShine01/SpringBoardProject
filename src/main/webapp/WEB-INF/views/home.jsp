<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<title>Index</title>
</head>
<style>
* {
	box-sizing: border-box;
}

.container {
	width: 400px;
	margin: auto;
}

div.id {
	width: 20%;
	float: left;
}

div.pw {
	width: 20%;
	float: left;
}

.logintitle {
	border: 3px double;
	text-align: center;
	font-weight: bold;
	font-size: 18px;
}

.buttonbox {
	text-align: center;
}

.check {
	text-align: center;
}

.box {
	border: 3px double;
}

.idbox {
	border: 3px double;
}

.pwbox {
	border: 3px double;
}

.profile {
	margin: auto;
	height : 100px;
	width : 300px;
	overflow: hidden;
}

.control{
	width:70%;
	line-height:100px;
}
.control input{
	width:100%;
	height:100%;
}


.profile div {
	float : left;
	height : 100%;
}

.thumbnail {
	width:30%;
	padding:5px;	
}
.thumbnail img{
	width:100%;height:100%;
}


</style>

<body>

	<c:choose>
		<c:when test="${loginID != null}">
			<div class="profile">
				<div class="thumbnail">
					<c:choose>
						<c:when test="${profileImg!=null }">
							<img src="/upload/${profileImg }" width="100" id="profile">		
						</c:when>
						<c:otherwise>
							<img src="/images/no_profile.jpg" width="100" id="profile">
						</c:otherwise>
					</c:choose>
										
				</div>
				<div class="control">
					
					<input type=file name="profile" id="profile_img" accept=".png, .jpg, .jpeg, .gif">
				</div>
				
				<script>
					function fileToBase64(file){
			        	const reader = new FileReader();
			        	reader.readAsDataURL(file)
			          	reader.onload = () => {
			            	$("#profile").attr("src", reader.result);   // base64
			          	}
			      	}
					
					$("#profile_img").on("change", function(){
						
						if($("#profile_img").val()==""){
							$("#profile").attr("src","/images/no_profile.jpg");
						}
						
						// 이미지파일 확장자 추출
						let ext = $("#profile_img").val().split(".").pop().toLowerCase();
						
						let accept = ["png", "jpg", "jpeg", "gif"];
						
						let result = $.inArray(ext,accept); // 첫번째 인자값이 두번째 인자 배열 안에 존재한다면 index, 아니면 -1을 반환
						
						if (result==-1) {
							alert("이미지 파일만 사용 가능합니다.");
							$("#profile_img").val("");
						}
						
						fileToBase64(document.getElementById("profile_img").files[0]);
					});
					
					
					
				</script>
			</div>
			<table border=1 align=center>
				<tr>
					<th colspan=3>${loginID }님 안녕하세요.
				</tr>
				<tr>
				<td><a href="/board/list?cpage=1"><button id="toBoard" type="button">자유게시판</button></a></td>
				<td><a href="/member/mypage"><button id ="mypage">마이페이지</button></a></td>
				<td><a href="/member/logout"><button type="button">로그아웃</button></a></td>
				<td><button id="memberOut">회원탈퇴</button></td>
				</tr>
				
				
				
				<script>
					let memberOut = document.getElementById("memberOut");
					memberOut.addEventListener("click", function() {
						if (confirm("정말 탈퇴하겠습니까?")) {
							location.href = "/member/delete";
						}
					});
				</script>
			</table>
		</c:when>
		<c:otherwise>
			<form action="/member/login" method="post">
				<div class="container">
					<div class="loginbox">

						<div class="logintitle">Login Box</div>
						<div class="idbox">
							<div class="id">아이디 :</div>
							<div class="idinput">
								<input type="text" name="id" placeholder="input your id"
									style="width: 80%;">
							</div>
						</div>
						<div class="pwbox">
							<div class="pw">패스워드 :</div>
							<div class="pwinput">
								<input type="password" name="pw"
									placeholder="input your password" style="width: 80%;">
							</div>
						</div>
						<div class="box">
							<div class="buttonbox">
								<button>로그인</button>
								<a href="/member/toSignup"><button type=button>회원가입</button></a>
							</div>
							<div class="check">
								<input type="checkbox">ID 기억하기
							</div>
						</div>
					</div>
				</div>
			</form>
		</c:otherwise>
	</c:choose>

</body>

</html>