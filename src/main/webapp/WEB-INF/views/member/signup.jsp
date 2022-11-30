<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입</title>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.6.1.js">
</script>
</head>
<style>
*{
	box-sizing : border-box;
}
div {
	border: 1px solid black;
}
.container {
	width: 500px;
	margin: auto;
}
.title {
	text-align: center;
}
.name {
	text-align: right;
	width: 30%;
	float: left;
}
.pwname {
	float: left;
}
.buttonbox {
	text-align: center;
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
.profile {
	margin: auto;
	height : 100px;
	width : 300px;
	overflow: hidden;
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
	<div class="container">
		<form action="/member/join" id="form" method="post">
		<div class="title">회원 가입 정보 입력</div>
		<div class="idbox">
			<div class="name">아이디</div>
			<div>
				<input type="text" name="id" id="id">
<!-- 				<button id="duplCheck" type="button">중복확인</button> -->
				<br><span id="idMsg"></span>
			</div>
		</div>
		<div class="pwbox">
			<div class="name">패스워드</div>
			<div>
				<input type="text" id="pw1">
			</div>
		</div>
		<div class="pwbox1">
			<div class="name">패스워드 확인</div>
			<div class="resultbox">
				<input type="text" id="pw2" name="pw">
				<span id="same"></span>
				<div id="result"></div>
			</div>
		</div>
		<div class="namebox">
			<div class="name">이름</div>
			<div>
				<input type="text" id="name" name="name">
				<span id="nameFilter"></span>
			</div>
		</div>
		<div class="phonebox">
			<div class="name">전화번호</div>
			<div>
				<input type="text" id="phone" name="phone">
				<span>- 제외, 숫자만 입력</span>
			</div>
		</div>
		<div class="emailbox">
			<div class="name">이메일</div>
			<div>
				<input type="text" id="email" name="email">
				<span id="emailFilter"></span>
			</div>
		</div>
		<div class="numbox1">
			<div class="name">우편번호</div>
			<div>
				<input type="text" id="postcode" name="zipcode">
				<button id="btnSearch" type="button">우편번호 찾기</button>
			</div>
		</div>
		<div class="addressbox1">
			<div class="name">주소1</div>
			<div>
				<input type="text" id="address1" name="address1">
			</div>
		</div>
		<div class="addressbox2">
			<div class="name">주소2</div>
			<div>
				<input type="text" id="address2" name="address2">
			</div>
		</div>
		<div class="profile">
				<div class="thumbnail">
					<img src="/images/no_profile.jpg" width="100" id="profile">					
				</div>
				<div class="control">
					<input type=file name="profile" id="profile_img" accept=".png, .jpg, .jpeg, .gif">
				</div>
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
		<div class="buttonbox">
			<button id="signUp" type="button">회원가입</button>
			<a href="/"><button type="button">back</button></a>
		</div>
		</form>
	</div>
	<script>
		// 변수 설정
		let id = document.getElementById("id");
		let duplCheck = document.getElementById("duplCheck");
		let pw1 = document.getElementById("pw1");
		let pw2 = document.getElementById("pw2");
		let same = document.getElementById("same");
		let result = document.getElementById("result");
		let name = document.getElementById("name");
		let phone = document.getElementById("phone");
		let email = document.getElementById("email");
		let signUp = document.getElementById("signUp");
		// 회원가입을 위한 정보입력이 제대로됐는지 판별하는 배열 (아이디, 비밀번호, 비밀번호확인일치, 이름, 전화번호, 이메일)
		var join = [false, false, false, false, false, false];
		let joinCheck = ["아이디 중복확인", "비밀번호 양식", "비밀번호 불일치", "이름 양식", "전화번호 양식", "이메일 양식"];
		
		
		
		//아이디 중복검사
		// duplCheck.addEventListener("click",function(){
		$("#id").on("input",function(){	
			
			let idRegex = /^\w{1,20}$/;
			if (id.value=="") {
				idMsg.innerHTML = "";
			} else if (idRegex.test(id.value)) {
				// window.open("/duplCheck.mem?id="+id.value,"","width=400,height=300");
				$.ajax({
					url:"/member/idCheck",
					data:{
						"id":id.value						
						}
				}).done(function(resp){
					
					console.log(resp);
					
					if (resp=="false") {
						join[0] = true;
						idMsg.innerHTML = "사용가능한 ID입니다."
					} else {
						join[0] = false;
						idMsg.innerHTML = "이미 존재하는 ID입니다."
					}
				})
			} else {
				join[0] = false;
				idMsg.innerHTML ="ID는 영문자, 숫자 및 _ 를 이용해서 20자 이하로 입력하세요.";
			}
		});
		
		
		
// 		id.addEventListener("change",function(){
// 			join[0] = false;
// 			let idMsg = document.getElementById("idMsg");
// 			idMsg.innerHTML = "아이디 중복확인을 진행해주세요.";
			
// 		})
		
		//비밀번호 유효성 검사//
		pw1.addEventListener("keyup", function() {
			let pwRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%]).{10,20}$/;
			if (!pwRegex.test(pw1.value)) {
					result.innerHTML = "대문자, 소문자, 숫자, 특수문자( !, @, #, $, %)가 각각 하나 이상 포함된 10~20글자로 입력해주세요";
	                join[1] = false;
			} else {
				result.innerHTML = "";
				join[1] = true;
			}
            
            if (pw1.value == "" || pw2.value == "") {
            	same.innerHTML = ""
            	join[2] = false;
            	
            } else if (pw1.value === pw2.value) {
                	same.innerHTML = "패스워드가 일치합니다."
                    join[2] = true;
            } else {
                	same.innerHTML = "패스워드가 일치하지 않습니다."
                	join[2] = false;
            }
		});
		
		pw2.addEventListener("keyup", function() {
			            
            if (pw1.value == "" || pw2.value == "") {
            	same.innerHTML = ""
            	join[2] = false;
            	
            } else if (pw1.value === pw2.value) {
                	same.innerHTML = "패스워드가 일치합니다."
                    join[2] = true;
            } else {
                	same.innerHTML = "패스워드가 일치하지 않습니다."
                	join[2] = false;
            }
		});
		
		
		name.addEventListener("keyup", function(){
			
			let nameFilter = document.getElementById("nameFilter");
			
			let nameRegex = /^[가-힣]{2,4}$/;
			if (nameRegex.test(name.value)) {
				nameFilter.innerHTML = "";
				join[3] = true;
			} else {
				nameFilter.innerHTML = "2~4글자의 한글로 입력하세요. (초과할 경우 앞 4글자까지만 입력)"
				join[3] = false;
			}			
		});
		
		phone.addEventListener("keyup", function(){
			
			let phRegex = /^\d{9,11}$/;

			if (phRegex.test(phone.value)) {
				join[4] = true;
			} else {
				join[4] = false;
			}			
		});
		
		email.addEventListener("keyup", function(){
						
			let emailFilter = document.getElementById("emailFilter");
			
			let emailRegex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
			if (email.value == "") {
				emailFilter.innerHTML = "";
				join[5] = false;
			}
			else if (emailRegex.test(email.value)) {
				emailFilter.innerHTML = "";
				join[5] = true;
			} else {
				emailFilter.innerHTML = "이메일 형식이 틀립니다.";
				join[5] = false;
			}			
		});
				
		document.getElementById("btnSearch").onclick = function() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							document.getElementById('postcode').value = data.zonecode;
							document.getElementById("address1").value = data.jibunAddress;
						}
					}).open();
		}
		signUp.addEventListener("click", function() {
			let confirm = true;
			for (let i=0; i<join.length; i++) {
				if (!join[i]) {
					confirm=false;
					alert(joinCheck[i] + " 오류 발생! 다시 확인해주세요. ");
					break;
				}				
			}
			if (confirm) {
				let form = document.getElementById("form");
				alert("가입 성공!"); 
				form.submit();					
			}
		});
		
	</script>
</body>
</html>