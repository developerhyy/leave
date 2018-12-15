<%
  /**
   * Copyright 2012 FuJian STARTNET-ICT Soft Co.,Ltd.
   * All right reserved.
   * V1.0.0  kek    2012/07/24  Created
   *
   * title: 消息提示页
   */
%>
<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:include flush="true" page="../common_inc.jsp"></jsp:include>
<html>
<head>
	<title>消息提示页</title>
	<jsp:include flush="true" page="../common_inc.jsp"></jsp:include>
	<script type="text/javascript" src="baseJs.js"></script>
	<style>
		body {
			margin: 0px;
			padding: 0px;
			background: #fff;
			overflow:hidden;
		}
		table {
			margin: 0px;
			padding: 0px;
			width: 50%;
		}
		.input_text {
			width: 100px;
			height: 25px;
			line-height: 25px;
			padding: 0 5px;
			border: 1px solid #3197b5;
			font-size: 14px;
			color: #333;
			background: #fff;
		}
		 
		 
		.category_title{
			border-bottom: 1px dotted #cdcdcd;
			padding-left:20px;
			text-align:left; 
			padding-top:10px;
		}
		 
		.font_style {
			 background-color: #FFEAEA;
			 border:1px solid #ff8484;
			 margin-left:10px;
			 padding:1px;
			 padding-left:4px;
			 height: 29px;
		}
		 
		.wrapper {
			background: white url(images/wrapper_bg.jpg) left top repeat-x;
			width:100%;
			height:500px;
		}
		 
		.tab_style {
			margin:20px 0 0 0;
			width: 640px;
			padding: 0 8px 50px 0;
			border: 4px solid #ECEFF1;
			background: white;
			min-height: 450px;
			_height: auto;
			overflow: hidden;
			position: relative;
		}

	</style>
	<link rel="stylesheet" type="text/css" href="css/blacklist_common.css"  charset="utf-8"/>
</head>
<body style="width: 100%; height: 100%; margin: 0px; overflow: auto;">
	<div id="rsMsg" style="color:red;padding-top:10px;padding-left:15px;">

	</div>
	<script type="text/javascript">
		var msg=parent.document.getElementById("showMsg").value;
		document.getElementById("rsMsg").innerHTML=msg;
	</script>
</body>

</html>