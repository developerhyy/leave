<%@page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils,cn.dy.base.framework.dict.*" %>
<%
  request.setAttribute("home", request.getContextPath());
%>

<!DOCTYPE html>
<html><head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script type="text/javascript">
	var def_country="CN";
	var def_language="zh";
</script>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户登录</title>

<style type="text/css">
input:-webkit-autofill {
 -webkit-box-shadow: 0 0 0px 63px white inset !important;
}
.search_box .td_detail input[type='text'],input[type='password']{
	width: 300px; /*For Firefox*/
	width: 280px\9; /*For IE*/
	height: 48px;
	line-height:48px;
	font-size:16px;
	display:block;
	border: none;
	margin:6px 0px;
	border-radius: 6px;
	border:1px solid #afbcca;
	color: #666666;
	padding:0px 10px;
	
}
@media screen and (-webkit-min-device-pixel-ratio:0){.search_box .td_detail input[type='text'],input[type='password']{width:300px;} }
@-moz-document url-prefix(){.search_box .td_detail input[type='text'],input[type='password']{width:300px;} }
.form_tabel .td_detail input[type='text'],input[type='password']{
	width: 300px; /*For Firefox*/
	width: 280px\9; /*For IE*/
	height: 48px;
	line-height:48px;
	font-size:16px;
	display: block;
	border: none;
	margin:6px 0px;
	border-radius: 6px;
	border:1px solid #afbcca;
	color: #666666;
	padding:0px 10px;
}
@media screen and (-webkit-min-device-pixel-ratio:0){.form_tabel .td_detail input[type='text'],input[type='password']{width:90%;}}
@-moz-document url-prefix(){.form_tabel .td_detail input[type='text'],input[type='password']{width:300px;} }
</style>
<link href="mainGray_files/login.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="loginForm" method="post" action="/j_spring_security_check" >

<div id="login">
	<div class="name_xt">新源工程车辆监控平台</div>
    <div style=" margin-left:8%; margin-top:8%; width:710px; height:418px;"><img src="img/wajueji.png"></div>
    <div style=" margin-left:3%; margin-top:4%; width:540px; height:81px;""><img src="img/biaozhi.png"></div>
	<div class="width_1k">
      <div class="login_box">
        <h2>用户登录</h2>
        
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2">
            <input name="username" id="username" type="text" class="user_name"  value="" style="outline:none;font-family: Microsoft YaHei;" placeholder="请输入登录账号"/>
            </td>
          </tr>
          <tr>
            <td colspan="2" style=" padding-top: 5%;">
            	<input id="password" type="password" other="input_password"  class="user_word" value="" style="outline:none;font-family: Microsoft YaHei;" placeholder="请输入密码"/>
				<!--<input class="user_word" other="password" tabIndex=2 type="text" id="input_password" name="input_password" maxlength="20" login_holder="请输入您的密码"/>-->
            	</td>
          </tr>
          <tr>
            <td style=" padding-top: 5%;">
            <input class="user_code" name="rand_img" id="rand_img" type="text" value="" style="outline:none;font-family: Microsoft YaHei;" placeholder="请输入验证码" login_holder="请输入验证码"/>
            </td>
            
            <td >
			<!-- <a id="jspImgArea" style="border:0px solid red;display:none;left:0px;top:0px;z-index:10000;position:absolute"
                   href="#"><img id="jspImg" border=0 src="about:blank"
                   style="height:48px;width:140px;vertical-align:middle" onclick="loginPlugin.doChangeRandImg()" title="点击换一张"></a>-->
                   
            <a id="validCode" href="javascript:void(0);" style="border: 0px;color: #ffffff;">
<img id="jspImg" border=0 src="about:blank"
                   style="height:48px;width:140px;vertical-align:middle;padding-top:10%;" onclick="loginPlugin.doChangeRandImg()" title="点击换一张">
            <!--<img id="validImage" height="48" width="140" src="http://27.148.153.190:18839/bmp/main/doCheckCode.srp?1508309332792" />-->
			</a>
            </td>
          </tr>
          
          <tr>
            <td colspan="2" align="center" id="loginbtnTd"><a  href="javascript:void(0);" id="btnLogin"  class="btn_login" style='text-decoration:none;' >登录</a></td><!--onclick="loginPlugin.login();return false"-->
          </tr>
        </table>
        <p id='message' style="font: 14px Microsoft YaHei;color:red;margin-top: 5px;"><p>
        </div>
    </div>
</div>
<input id="client_ip" name="client_ip" type="hidden" value="">
    <input id="login_method" name="login_method" type="hidden" value="">
    <input id="force_login" name="force_login" type="hidden" value="">
</form>
<form id="loginInfo" action="" style="display: none" method="post">
    <input id="token_id" name="token_id" type="hidden" value="">
    <input id="corp_id" name="corp_id" type="hidden" value="">
    <input id="staff_id" name="staff_id" type="hidden" value="">
    <input id="client_ip" name="client_ip" type="hidden" value="">
    <input id="login_time" name="login_time" type="hidden" value="">
    <input id="staff_account" name="staff_account" type="hidden" value="">
    <input id="staff_nickname" name="staff_nickname" type="hidden" value="">
    <input id="corp_account" name="corp_account" type="hidden" value="">
    <input id="corp_name" name="corp_name" type="hidden" value="">
    <input id="corp_short_name" name="corp_short_name" type="hidden" value="">
    <input id="is_password_expired" name="is_password_expired" type="hidden" value="">
    <input id="login_method" name="login_method" type="hidden" value="">
    <input id="user_id" name="user_id" type="hidden" value="0">
    <input id="user_name" name="user_name" type="hidden" value="">
    <input id="dept_id" name="dept_id" type="hidden" value="0">
    <input id="dept_name" name="dept_name" type="hidden" value="">
    <input id="city_code" name="city_code" type="hidden" value="">
</form>
<div class="footer">Copyright © 2017 福建鼎旸股份 All Rights Reserved</div>
</body>
	<script type="text/javascript" src="${home}/scripts/jquery-1.8.1.min.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/mask/jquery.loadmask.min.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/jquery-cookie-plugin.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/jquery-service-plugin.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/jquery-form-plugin.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/rsa/Barrett.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/rsa/BigInt.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/rsa/RSA.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${home}/scripts/LoginInfo.js" charset="UTF-8"></script>
	<!--<script  type="text/javascript"src="${home}/outfiles/js/popWin.js"></script>-->
	<script  type="text/javascript"src="${home}/scripts/md5.js"></script>
	<script type="text/javascript" src="login.js"></script>
	<script type="text/javascript">
		var useVerify = "YES";
		var corpAccount = "";
		var _CurrentWebAppHome = "${home}";
		$(document).ready(function() {

			try {
				$.ServiceAgent.setServiceUrl("${home}/service");
			} catch(ex) {}
			loginPlugin.doChangeRandImg();
			$(".loginForm").find("input[type!=button]").focusin(function() {
				$(this).parent().addClass("input_acitve");
			});
			$(".loginForm").find("input[type!=button]").focusout(function() {
				$(this).parent().removeClass("input_acitve");
			});

			$(".loginForm").find("input").on("keyup focus", function() {
				//$(this).val($(this).val().trim());
				if($(this).val().length > 0) {
					$(this).parent().find(".right-logo").show();
				} else {
					$(this).parent().find(".right-logo").hide();
				}
			});

			$(".loginForm").find(".right-logo").click(function() {
				$(this).hide();
				$(this).parent().find("input").val("");
				$(this).parent().find("input").focus();
			});

			$("#btnLogin").click(function() {
				loginPlugin.login();
			});
			
			$("#username").on("keyup",function(e){
				if(event.keyCode == "13"){
					$("#password").focus();
				}
			});
			
			$("#password").on("keyup",function(e){
				if(event.keyCode == "13"){
					$("#btnLogin").click();
				}
			});
			
		//	window.alert = function(msg) {
		//		$PopWin({
		//			content: msg,
		//			title: '消息提示',
					//设置宽高:可选参数
		//			width:'300',
					/*height:'150',*/
		//			ok: function() {
		//				return true;
		//			}
		//		}).alert();
		//	}
		});
	
	</script>
</html>