<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录日志</title>
<jsp:include page="../assets/common_inc_new.jsp"  flush="true"></jsp:include>
<script type="text/javascript" src="${home}/system/common/scripts/utils.js"></script>
<!-- <script type="text/javascript" src="/zhcy/zrf/utils.js"></script> -->
<link rel="stylesheet" type="text/css" href="${home}/system/css/log.css">
<script type="text/javascript">
	var result;
	var page_current=1;
	var page_size=0;
	var page_interval=10;

	function queryGrid(){
		page_size=$("#txtPageNum").val();
		var queryCallBack=function(reqInfos,callResult){
			if(reqInfos!=null){
				$.dialog.tips("查询成功...");
	            ui_addReqInfo(reqInfos.content.result.list);
	            var htmlMsg2="";
				htmlMsg2=OutPageListAjax(page_size,page_current, reqInfos.content.result.total,  pageChangeCallback, page_interval);
				$("#PageContent").html(htmlMsg2);
				page_current=1;
			}
		}
		listReqInfos(queryCallBack);
	}
	function pageChangeCallback(pageid){
			page_current=pageid;
			queryGrid();
			

	}

	function listReqInfos(callBackList){
		var head={
			"service_name":"cn.dy.system.service.LoginLogService",
			"operation_name":"queryLoginLogByNameOrTime"
		}
		var param={
			"beginTime":$("#begin_time").val(),
			"endTime":$("#end_time").val(),
			"nickname":$("#nickname").val(),
			"pageNum": page_current,
        	"pageSize": page_size
		}

		if($("#begin_time").val()==""){
			alert("操作日期开始时间不能为空！")
			return false;
		}
			if($("#end_time").val()==""){
			alert("操作日期结束时间不能为空！")
			return false;
		}
		var beginTime=new Date(param.beginTime.replace(/-/g,"/"));
		var endTime=new Date(param.endTime.replace(/-/g,"/"));
		if(endTime.getTime()-beginTime.getTime()<0){

			alert("操作日期开始时间不得大于结束时间！")
			return false;
		}
		if(endTime.getTime()-beginTime.getTime()>1000*3600*24*7){
			alert("操作日期查询范围不得查过7天！")
			return false;
		}
		var myCallBack=function(data,callResult){
		if(callBackList){
			callBackList(data,callResult);	
			}			
		}
		var options={ 
			 "handleError": false,
		      "showProgressBar":false,
		      "timeout":60000*10
		  }
		$.ServiceAgent.JSONInvoke(head,param,myCallBack,options);
	}	

	function ui_addReqInfo(data){
		    alert(0);
			for(var i=0;i<data.length;i++){
					var reqInfo=data[i];
					var htmlMsg="<tr>"
					+"<td align=\"center\">"+reqInfo.nickname+"</td>"
					+"<td align=\"center\">"+reqInfo.account+"</td>"
					+"<td align=\"center\">"+reqInfo.login_time+"</td>"
					+"<td align=\"center\">"+reqInfo.logout_time+"</td>"
					+"<td align=\"center\">"+reqInfo.client_ip+"</td>"
					+"<td align=\"center\">"+reqInfo.sts+"</td>"
					+"</tr>";
					$("#resultgrid").append(htmlMsg);

				}
		}
	function ui_addReqInfo(data,pageSize,pageNum){
			//下标
			var a=pageNum>1?(pageSize*(pageNum-1)):0;
			var temp=0;
			$("#resultgrid").html("<tr><th width='15%'>姓名</th><th width='15%'>账号</th><th width='20%'>登陆时间</th><th width='20%'>登出时间</th><th width='15%'>登陆IP地址</th><th width='15%'>状态</th></tr>");
			for(var i=a;i<data.length;i++){
					var reqInfo=data[i];
					var htmlMsg="<tr>"
					+"<td align=\"center\">"+reqInfo.nickname+"</td>"
					+"<td align=\"center\">"+reqInfo.account+"</td>"
					+"<td align=\"center\">"+reqInfo.login_time+"</td>"
					+"<td align=\"center\">"+(reqInfo.logout_time==null?"":reqInfo.logout_time)+"</td>"
					+"<td align=\"center\">"+reqInfo.client_ip+"</td>"
					+"<td align=\"center\">"+reqInfo.sts+"</td>"
					+"</tr>";
					temp++;
					$("#resultgrid").append(htmlMsg);
					if(temp==pageSize)
						return ;

				}
		}
	function doReset(){
    	$("#begin_time").val(getYMD("begin"));
    	$("#end_time").val(getYMD("end"));
    	$("#nickname").val("");
    
	}
	//获取年月日 如2017-11-12
	function getYMD(type){
		var date = new Date();
    	var seperator1 = "-";
    	var seperator2 = ":";
    	var month = date.getMonth() + 1;
    	var strDate = date.getDate();
    	if (month >= 1 && month <= 9) {
       		 month = "0" + month;
   		 }
    	if (strDate >= 0 && strDate <= 9) {
        	strDate = "0" + strDate;
   		 }
   		 var currentdate;
   		 if(type=="begin"){
   		 	 currentdate = getBeforeDate(7)+ " " + 
   		 	 (date.getHours()>9?date.getHours():"0"+date.getHours()) + seperator2 + 
   		 	 (date.getMinutes()>9?date.getMinutes():"0"+date.getMinutes())+ seperator2 +
   		 	 (date.getSeconds()>9?date.getSeconds():"0"+date.getSeconds());
   		 }
   		 if(type=="end"){
   		 	currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate+ " " + 
   		    (date.getHours()>9?date.getHours():"0"+date.getHours()) + seperator2 + 
   		 	(date.getMinutes()>9?date.getMinutes():"0"+date.getMinutes())+ seperator2 +
   		 	(date.getSeconds()>9?date.getSeconds():"0"+date.getSeconds());
   		 }		
   		 //var ymd=date.getFullYear() + seperator1 + month + seperator1 + strDate;
   		 return currentdate;
	}
	//获取七天前的日期
 	function getBeforeDate(n){  
   		var n = n;  
        var d = new Date();  
        var year = d.getFullYear();  
        var mon=d.getMonth()+1;  
        var day=d.getDate();  
        if(day <= n){  
            if(mon>1) {  
               mon=mon-1;  
            }  
           else {  
             year = year-1;  
             mon = 12;  
             }  
           }  
         d.setDate(d.getDate()-n);  
         year = d.getFullYear();  
         mon=d.getMonth()+1;  
         day=d.getDate();  
         s = year+"-"+(mon<10?('0'+mon):mon)+"-"+(day<10?('0'+day):day);  
         return s;  
  }  
	$(document).ready(function(){
		doReset();
		queryGrid();
		//alert(getBeforeDate(332));
		//页面加载完毕后 自动触发查询按钮
		//$("#btnQuery").click();
    
	});

</script>

</head>
<body class="mainbody">
	<form id="form1" method="post">
		<script type="text/javascript">
			var theForm = document.forms['form1'];
			if (!theForm) {
   			 theForm = document.form1;
			}
		</script>
			<!-- 导航栏 -->
		<!-- 	<div class="location">
				<a href="javascript:;" class="home"><i></i><span>登录日志</span>
				</a>
			</div> -->

			<!-- 提示栏 -->
		<!-- 	<div class="mytips" id="tsl" >
				温馨提示:&nbsp;
				<a href="" target="_blank" ><span id="tips"></span></a>
				<br />
			</div> -->

			<!-- 操作栏 -->
			<div class="toolbar-wrap">

				<div id="floatHead" class="toolbar">
					<div class="r-list" style="float: none">
						<!-- <span class="nickname">姓名:</span> -->
						<input type="text" name="nickname" id="nickname" class="operation_date" placeholder="姓名">

						<!-- <span class="operation_time">操作时间:</span> -->
						<input name="begin_time" type="text" id="begin_time"
							class="operation_date"
							onfocus="WdatePicker({dateFmt:&#39;yyyy-MM-dd HH:mm:ss&#39;})"
							datatype="*1-50" errormsg="请选择正确的日期" sucmsg=" " nullmsg=" "
							placeholder="开始日期"  /> 
						<span class="hx">--</span>
						<input name="end_time" type="text" id="end_time" class="operation_date"
							onfocus="WdatePicker({dateFmt:&#39;yyyy-MM-dd HH:mm:ss&#39;})"
							datatype="*1-50" errormsg="请选择正确的日期" sucmsg=" " nullmsg=" "
							placeholder="结束日期"  />
						<a id="btnQuery" class="query" onclick="queryGrid();">查询</a>
						<a id="btnReset" class="reset" onclick="doReset();"><span>重 置</span></a>
					</div>

		
				</div>
			</div>

		<!--查询结果列表-->
		<table width="100%" border="0" cellpadding="0" cellpadding="0" class="ltable" id="resultgrid">
			<tr>
				<th width="15%">姓名</th>
				<th width="15%">账号</th>
				<th width="20%">登陆时间</th>
				<th width="20%">登出时间</th>
				<th width="15%">登陆IP地址</th>
				<th width="15%">状态</th>
			</tr>
		</table>

		<!--内容底部-->
		<div class="line30"></div>
		<div class="pagelist">
			<div class="l-btns">
				<span>显示</span>
				<input type="text" name="txtPageNum" value="10"
				onchange="javascript:setTimeout(&#39;__doPostBack(\&#39;txtPageNum\&#39;,\&#39;\&#39;)&#39;, 0)"
				onkeypress="if (WebForm_TextBoxKeyHandler(event) == false) return false;"
						id="txtPageNum" class="pagenum"
						onkeydown="return checkNumber(event);"/>
				<span>条/页</span>
			</div>
			<div id="PageContent" class="default">
			</div>
		</div>
	</form>

</body>
</html>