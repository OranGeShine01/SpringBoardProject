<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.1.js">
</script>
<meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
</head>
<body>
	<form action="/file/upload" method="post" enctype="multipart/form-data">
   		<input type="text" name="fileWriter">
   		<input type="text" name="message">
   		<input type="file" name="file">
   		<button>파일전송</button>
	</form>
</body>
</html>