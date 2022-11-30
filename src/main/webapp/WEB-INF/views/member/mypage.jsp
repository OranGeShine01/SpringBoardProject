<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지</title>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js">
</script>
<script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>

<script>
	$(function() {
		// 회원정보 수정 버튼 클릭시 정보 수정 활성화
		
		
		$("#updateBtn").on("click", function(){
			$("input").removeAttr("readonly");
			$("#updateBtn, #back").css("display", "none");
			$("#btnSearch, #pw1, #pw2").removeAttr("disabled");
			
			
			let confirmBtn = $("<button>");
			confirmBtn.attr("type", "button")
			confirmBtn.text("수정완료");
		
			let cancelBtn = $("<button>");
			cancelBtn.attr("type", "button");
			cancelBtn.text("취소");
			cancelBtn.on("click", function(){location.reload();});
		
			$(".buttonBox").append(confirmBtn);
			$(".buttonBox").append(cancelBtn);
			
			// 수정완료 버튼
			confirmBtn.on("click", function(){
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
					alert("수정 완료!"); 
					form.submit();					
				}
			});
			
		})
		
		// 우편번호 찾기
		document.getElementById("btnSearch").onclick = function() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							document.getElementById('postcode').value = data.zonecode;
							document.getElementById("address1").value = data.jibunAddress;
						}
					}).open();
		};
	})
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
	width: 1000px;
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
.buttonBox {
	text-align: center;
}
.profile {
	margin: auto;
	height : 100px;
	width : 500px;
	overflow: hidden;
}
.profile div {
	float : left;
	height : 100%;
}

.thumbnail {
	width:100px;
	padding:5px;	
}
.thumbnail img{
	width:100%;height:100%;
}
</style>
<body>
	<div class="container">
		<form action="/member/update" id="form" method="post" enctype="multipart/form-data">
		<div class="profile">
				<div class="thumbnail">
					<img src="/images/no_profile.jpg" width="100" id="profile">					
				</div>
				<div class="control">
					<input type=file name="profileImg" id="profile_img" accept=".png, .jpg, .jpeg, .gif">
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
		<div class="title">회원 정보</div>
		<div class="idbox">
			<div class="name">아이디</div>
			<div>
				<input type="text" name="id" id="id" value = "${members.id }" disabled>
			</div>
		</div>
		<div class="pwbox">
			<div class="name">패스워드</div>
			<div>
				<input type="text" id="pw1" disabled>
			</div>
		</div>
		<div class="pwbox1">
			<div class="name">패스워드 확인</div>
			<div class="resultbox">
				<input type="text" id="pw2" name="pw" disabled>
				<span id="same"></span>
				<div id="result"></div>
			</div>
		</div>
		<div class="namebox">
			<div class="name">이름</div>
			<div>
				<input type="text" id="name" name="name" value = "${members.name }"readonly>
				<span id="nameFilter"></span>
			</div>
		</div>
		<div class="phonebox">
			<div class="name">전화번호</div>
			<div>
				<input type="text" id="phone" name="phone" value = "${members.phone }"readonly>
			</div>
		</div>
		<div class="emailbox">
			<div class="name">이메일</div>
			<div>
				<input type="text" id="email" name="email" value = "${members.email }"readonly>
				<span id="emailFilter"></span>
			</div>
		</div>
		<div class="numbox1">
			<div class="name">우편번호</div>
			<div>
				<input type="text" id="postcode" name="zipcode" value = "${members.zipcode }"readonly>
				<button id="btnSearch" type="button" disabled>우편번호 찾기</button>
			</div>
		</div>
		<div class="addressbox1">
			<div class="name">주소1</div>
			<div>
				<input type="text" id="address1" name="address1" value = "${members.address1 }"readonly>
			</div>
		</div>
		<div class="addressbox2">
			<div class="name">주소2</div>
			<div>
				<input type="text" id="address2" name="address2" value = "${members.address2 }"readonly>
			</div>
		</div>
		<div class="buttonBox">
			<button id="updateBtn" type="button">회원 정보 수정</button>
			<a href="/"><button type="button" id="back">back</button></a>
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
		let address1 = document.getElementById("address1");
		let address2 = document.getElementById("address2");
		
		// 회원가입을 위한 정보입력이 제대로됐는지 판별하는 배열 (아이디, 비밀번호, 비밀번호확인일치, 이름, 전화번호, 이메일)
		var join = [true, false, false, true, true, true];
		let joinCheck = ["아이디 중복확인", "비밀번호 양식", "비밀번호 불일치", "이름 양식", "전화번호 양식", "이메일 양식"];
		
		// 비밀번호 유효성 검사
		
		id.addEventListener("change",function(){
			join[0] = false;
			let idMsg = document.getElementById("idMsg");
			idMsg.innerHTML = "아이디 중복확인을 진행해주세요.";
			
		})
		
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
		
		
		
	</script>
</body>
</html>