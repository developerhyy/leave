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
<script type="text/javascript" src="/xyzg/system/scripts/zDialog.js"></script>
<script type="text/javascript" src="/xyzg/system/zDialog.js"></script>
   
    
<title>删除角色</title>
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
		<input type="hidden" name="sts" id="sts" value="Y"/>
        <div class="tab-content" style="padding-bottom: 50px;">
	<dl>
                <dt>角色名称：</dt>
                <dd>
                    <input type="text" name="name" id="name"  for="name"   class="input normal" sucmsg=" " 
                     maxlength="20"  value="" readonly="true"/>               
                </dd>
            </dl>		
		</div>

      

        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
                <input type="button" name="btnSubmit" value="删除" id="btnSubmit" class="btn" onclick="doSave();"/>
                <input type="button" name="btnReturn" value="取消" class="btn yellow" onclick="doCancal();" />
            </div>
            <div class="clear"></div>
        </div>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.config.js"></script>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.all.min.js"> </script>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/lang/zh-cn/zh-cn.js"></script>
  <link type="text/css" rel="stylesheet" href="${home}/system/common/css/star.css"/>
  <script src="${home}/system/common/scripts/star.js" type="text/javascript"></script>
  <script type="text/javascript" src="js/worker_info.js"></script>
<script type="text/javascript">
//删除角色

$(document).ready(function () {
	
	//页面加载时，获取父窗口的角色ID和角色名称
	$("#id").val(parent.roleId);
	$("#name").val(parent.roleName);
})

//点击删除后，执行删除操作
function doSave() {
	del();
}
	function del(){
		var head = {
            "service_name": "cn.dy.system.service.RoleManagerService",
            "operation_name": "deleteRole",
        }

        var param = {
            id: parent.roleId
 
        }
		var options = {
            "handleError": true
        }
		
		var myCallback=function callBack(data) {
			if(confirm("你确定要删除吗，删除后相应权限也会删除？")){
				if(data.response_code==0){
				alert(data.response_desc);				
				parent.$("#role").html("");
				parent.roleId = '';
				parent.query();
				parent.diag.close();
				
			}else{
				alert(data.response_desc);
			}
		}
			parent.diag.close();
		}
		$.ServiceAgent.JSONInvoke(head, param, myCallback, options);
	}
//点击返回后，跳转至主菜单	
function doReturn(){
	parent.diag.close();
	//window.location.href="role_manager.jsp";
	
}

//点击取消后，跳转至主菜单
function doCancal(){
	//window.location.href="role_manager.jsp";
	parent.diag.close();	
}	

</script>
</body>
</html>
