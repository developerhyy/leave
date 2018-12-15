<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
%>
<!DOCTYPE html>
<html class="no-js">
<head>
<jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
<script type="text/javascript">
var user_id = loginInfo.staff_id;
</script>
<link type="text/css" rel="stylesheet" href="${home}/scripts/fancybox/jquery.fancybox.css"/>
<script type="text/javascript" src="${home}/scripts/fancybox/jquery.fancybox.pack.js"></script>
<script type="text/javascript" src="/xyzg/system/common/scripts/zDialog.js"></script>
   
    
<title>修改角色</title>
<style>
	.checkModule{
		border-radius: 20px;
		width: 20px;
		height: 20px;
		align-content: center;
		}
</style>
</head>

<body class="mainbody">
   <form  name = "form1" id="form1" method="post" enctype="multipart/form- data">
        <input name="imgfile" type="file" id="imgfile" size="40"  style="border: 1px solid #d4d4d4;display:none;" onchange="viewmypic(this.form.imgfile);" /> 
   </form> 
   <form method="post" id="infoForm">
        <!--导航栏-->
        <div class="location">
            <a onclick="doReturn();" class="back"><i></i><span>返回角色管理页面</span></a>
            <i class="arrow"></i>
            <span id="lbTitle">角色信息</span>
        </div>
		<input type="hidden" name="id" id="id" value=""/>
		<!--<input type="hidden" name="sts" id="sts" value="Y"/>-->
		<input type="hidden" name="corp_id" id="corp_id" value="loginInfo.corp_id"/>
        <div class="tab-content" style="padding-bottom: 50px;">
            <dl>
                <dt>角色名称：</dt>
                <dd>
                    <input type="text" name="name" id="name"  for="name"   class="input normal" sucmsg=" " 
                     maxlength="20"  value=""/>               
                </dd>
            </dl>
			<dl>
                <dt>角色描述：</dt>
                <dd>
					<textarea style="font-size: 12px;color: #333;width:400px;" name="description" id="description"  rows="4" sucmsg=" " style="width:80%"  value=""></textarea>
                </dd>
            </dl>
		</div>

      

        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
                <input type="button" name="btnSubmit" value="保存" id="btnSubmit" class="btn" onclick="doSave();"/>
                <input type="button" name="btnReturn" value="取消" class="btn yellow" onclick="doCancal();" />
            </div>
            <div class="clear"></div>
        </div>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.config.js"></script>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.all.min.js"> </script>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/lang/zh-cn/zh-cn.js"></script>
  <link type="text/css" rel="stylesheet" href="${home}/system/common/css/star.css"/>
  <script src="${home}/system/common/scripts/star.js" type="text/javascript"></script>
  <!--<script type="text/javascript" src="js/worker_info.js"></script>-->
<script type="text/javascript">
//修改角色

$(document).ready(function () {
		$("#id").val(parent.roleId);
		$("#name").val(parent.roleName);
		$("#description").val(parent.roleDescription);
})

//点击保存后，执行修改角色的操作
function doSave() {
	edit();
}
    function edit() {
       var head = {	
			"service_name": "cn.dy.system.service.RoleManagerService",
			"operation_name": "modifyRole"
		}
		
		var param = {
			"role": {
			"id":$("#id").val(),
			"name":$("#name").val(),
			"corp_id":loginInfo.corp_id,
			"corp_name":"鼎旸股份",
			"description":$("#description").val(),
			"can_update":"Y",
			"parent_id":2,
			"staff_num":10
			}
		}
		var options = {
			"handleError": false,
			"showProgressBar":false,
			"timeout":60000*10
		}
		
		var myCallback=function callBack(data) {
			if(data.response_code==0){
				alert(data.response_desc);
				parent.$("#role").html("");
				parent.query();
				parent.diag.close();
			}else{
				alert(data.response_detail);
			}				
		}		
		$.ServiceAgent.JSONInvoke(head, param, myCallback, options);
    }
//点击返回后，跳转至主菜单	
function doReturn(){
	parent.diag.close();
	window.location.href="role_manager.jsp";
}

//点击取消后，跳转至主菜单
function doCancal(){
	window.location.href="role_manager.jsp";
	parent.diag.close();	
}	

	</script>
</body>
</html>
