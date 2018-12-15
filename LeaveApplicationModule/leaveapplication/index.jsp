<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>考勤录入</title>
<jsp:include page="${home}/assets/common_inc_new.jsp"  flush="true"></jsp:include>
<script type="text/javascript" src="${home}/system/common/scripts/utils.js"></script>
<!-- <script type="text/javascript" src="/zhcy/zrf/utils.js"></script> -->
<link rel="stylesheet" type="text/css" href="./index.css">
<script type="text/javascript">
	var result;
	var page_current=1;
	var page_size=0;
	var page_interval=10;
	//var id=window.setInterval(doCopy,5000);定时任务
	function queryGrid(){

		page_size=$("#txtPageNum").val();
		var queryCallBack=function(reqInfos,callResult){
			if(reqInfos!=null){
				$.dialog.tips("查询成功...");
				ui_addReqInfo(reqInfos.content.result.list);
				var htmlMsg2=OutPageListAjax(page_size,page_current, reqInfos.content.result.total,  pageChangeCallback, page_interval);
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
			"service_name":"cn.dy.system.service.OperateLogService",
			"operation_name":"queryOperatLogByNameOrTime"
		}
		var param={
			"beginTime":$("#begin_time").val(),
			"endTime":$("#end_time").val(),
			"nickName":$("#nickname").val(),
			"moduleName":$("#module").val(),
			"childModuleName":$("#childModule").val(),
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
			for(var i=0;i<data.length;i++){
					var reqInfo=data[i];
					var htmlMsg="<tr>"
					+"<td align=\"center\">"+(i + 1)+"</td>"
					+"<td align=\"center\">"+reqInfo.account+"</td>"
					+"<td align=\"center\">"+reqInfo.operate_time+"</td>"
					+"<td align=\"center\">"+reqInfo.child_module+"</td>"
					+"<td align=\"center\">"+reqInfo.operate_time+"</td>"
					+"<td align=\"center\">"+reqInfo.account+"</td>"
					+"<td align=\"center\">查看</td>"
					+"</tr>";
					$("#resultgrid").append(htmlMsg);

				}
		}
	function ui_addReqInfo(data,pageSize,pageNum){
			//下标
			var a=pageNum>1?(pageSize*(pageNum-1)):0;
			var temp=0;
			$("#resultgrid").html("<tr><th width='10%'>编号</th><th width='10%'>操作人</th><th width='10%'>关联成员</th><th width='10%'>模块名</th><th width='10%'>子模块名</th><th width='10%'>操作对象</th><th width='10%'>操作名称</th><th width='20%'>操作内容</th><th width='10%'>操作时间</th></tr>");
			for(var i=a;i<data.length;i++){
					var reqInfo=data[i];
					var htmlMsg="<tr>"
					+"<td align=\"center\">"+reqInfo.operation_id+"</td>"
					+"<td align=\"center\">"+reqInfo.account+"</td>"
					+"<td align=\"center\">"+reqInfo.nickname+"</td>"
					+"<td align=\"center\">"+reqInfo.module+"</td>"
					+"<td align=\"center\">"+reqInfo.child_module+"</td>"
					+"<td align=\"center\">"+reqInfo.operation_obj+"</td>"
					+"<td align=\"center\">"+reqInfo.operation_name+"</td>"
					+"<td align=\"center\">"+reqInfo.operate_content+"</td>"
					+"<td align=\"center\">"+reqInfo.operate_time+"</td>"
					+"</tr>";
					temp++;
					$("#resultgrid").append(htmlMsg);
					if(temp==pageSize)
						return ;

				}
		}
	//重置
	function doReset(){
		// var date = new Date();
  //   	var seperator1 = "-";
  //   	var seperator2 = ":";
  //   	var month = date.getMonth() + 1;
  //   	var strDate = date.getDate();
  //   	if (month >= 1 && month <= 9) {
  //      		 month = "0" + month;
  //  		 }
  //   	if (strDate >= 0 && strDate <= 9) {
  //       	strDate = "0" + strDate;
  //  		 }
  //   	var begin_time_now = date.getFullYear() + seperator1 + month + seperator1 + strDate+ " 00:00:00";
  //   	var end_time_now = date.getFullYear() + seperator1 + month + seperator1 + strDate+ " 23:59:59";
    	$("#begin_time").val(getYMD("begin"));
    	$("#end_time").val(getYMD("end"));
    	$("#nickname").val("");
    	$("#module").val("");
    	$("#childModule").val("")
    	// $("#begin_time").text("");
    	// $("#end_time").text();
    	// $("#nickname").text();
    	// $("#module").text();
    	// $("#childModule").text();

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



    //备份
    function doCopy(){

    	var head={
    		"service_name":"cn.dy.system.service.OperateLogService",
    		"operation_name":"copyOperateLogData"
    	}
    	var param={
    		"beginTime":$("#begin_time").val(),
    		"endTime":$("#end_time").val()
    	}
    	var options={
    		"handleError":false,
    		"showProgressBar":false,
    		"timeout":60000*10
    	}

    	if($("#begin_time").val()=="") {
    		alert("备份的开始时间不能为空！")
			return false;
    	}
    	if($("#end_time").val()=="") {
    		alert("备份的结束时间不能为空！")
			return false;
    	}
    	var informations="您将备份"+$("#begin_time").val()+"~"+$("#end_time").val()+"时间段内的数据,备份后数据将无法进行查看,请谨慎操作!";
    	//alert(informations);
    	var r=confirm(informations);
    	if(r==false){
    		return false;
    	}
		var beginTime=new Date(param.beginTime.replace(/-/g,"/"));
		var endTime=new Date(param.endTime.replace(/-/g,"/"));
		if(endTime.getTime()-beginTime.getTime()<0){
			alert("备份的开始不能大于结束时间！");
			return false;
		}

		var copyBack=function(data,error){
			if(data.response_code==0){
				alert("备份成功");
				//addOperation();
			}
		}

		$.ServiceAgent.JSONInvoke(head,param,copyBack,options);

    }
    //将备份数据也看做是一种操作  必须加入到考勤录入中
    function addOperation(){
    	var addBack=function(data,error){
    		if(data.response_code==0){
    			alert("添加日志成功");
    		}

    	}
    	var head={
    		"service_name":"cn.dy.system.service.OperateLogService",
    		"operation_name":"addOperateLog"
    	}
    	//将参数封装成对象
    	var operation=new Object();
    	operation.operation_id=0;
    	operation.operation_name="备份考勤录入";
    	operation.staff_id=1;
        operation.corp_id=0;
        operation.operate_time="";
    	operation.operate_content="备份了"+$("#begin_time").val()+"到"+$("#end_time").val()+"时间段内的考勤录入";
        operation.module="日志管理模块";
        operation.child_module="考勤录入管理模块";
        operation.operation_obj="考勤录入";
        operation.user_id=0;
        operation.user_name=null;
        operation.dept_id=0;
        operation.dept_name=null;
    	var param={
    		"operation":operation,
    	}
    	var options={
    		"handleError":false,
    		"showProgressBar":false,
    		"timeout":60000*10

    	}

    	$.ServiceAgent.JSONInvoke(head,param,addBack,options);
    }

	function add() {
		window.location.href="add.jsp";
	}

	$(document).ready(function(){
		doReset();
		queryGrid();
	});
</script>

</head>
<body class="mainbody">
			<!-- 操作栏 -->
			<div class="toolbar-wrap">
				<div id="floatHead" class="toolbar">
					<div class="r-list" style="float: none">
						<input type="text" name="部门" id="nickname" class="operation_date" placeholder="部门">
						<span class="operation_time">审批状态:</span>
						<div class="rule-single-select"
							style="float: left; margin-left: 5px;">
							<select id="statusSelect" style="width: 150px;">
								<option value="0">
									请选择
								</option>
								<option value="1">
									待审批
								</option>
								<option value="2">
									审批通过
								</option>
								<option value="3">
									审批未通过
								</option>
								<option value="4">
									未提交
								</option>
							</select>
						</div>
						<span class="operation_time">考勤日期:</span>
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
						<a id="lbtnSearch" class="reset" onclick="queryGrid();"><span>查询</span></a>
						<a id="lbtnSearch" class="reset" onclick="add();"><span>新增</span></a>
					</div>


				</div>
			</div>

		<!--查询结果列表-->
		<table width="100%" border="0" cellpadding="0" cellpadding="0" class="ltable" id="resultgrid">
			<tr>
				<th width="10%">序号</th>
				<th width="10%">部门</th>
				<th width="10%">考勤日期</th>
				<th width="10%">审批状态</th>
				<th width="10%">修改时间</th>
				<th width="10%">修改人员</th>
				<th width="10%">操作</th>
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

</body>
</html>
