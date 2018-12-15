<%@page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>服务调用测试</title>
		<jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
		<%--<link href="skin/default/style.css" rel="stylesheet" type="text/css" />--%>
		<%--<link href="css/pagination.css" rel="stylesheet" type="text/css" />--%>
	</head>
	<body class="mainbody">
		<form method="post" id="form1">

			<script type="text/javascript">
//<![CDATA[
var theForm = document.forms['form1'];
if (!theForm) {
    theForm = document.form1;
}

//]]>
</script>

			<!-- 导航栏 -->
			<div class="location">
				<a href="javascript:;" class="home"><i></i><span>信息设置</span>
				</a>
			</div>

			<!-- 提示栏 -->
			<div class="mytips">
				提示栏:&nbsp;
				<a href=""
					target="_blank">.........</a>
				<br />
			</div>

			<!-- 操作栏 -->
			<div class="toolbar-wrap">
			<div id="floatHead" class="toolbar">
					<div class="r-list" style="float: none">
						<input name="txtStart" type="text" id="txtStart"
							class="keyword date"
							onfocus="WdatePicker({dateFmt:&#39;yyyy-MM-dd HH:mm:ss&#39;})"
							datatype="*1-50" errormsg="请选择正确的日期" sucmsg=" " nullmsg=" "
							placeholder="开始日期" style="float: left" />
						<input name="txtEnd" type="text" id="txtEnd" class="keyword date"
							onfocus="WdatePicker({dateFmt:&#39;yyyy-MM-dd HH:mm:ss&#39;})"
							datatype="*1-50" errormsg="请选择正确的日期" sucmsg=" " nullmsg=" "
							placeholder="结束日期" style="float: left" />
						<div class="rule-single-select"
							style="float: left; margin-left: 5px;">
							<select name="ddWid" id="ddWid" datatype="*" sucmsg=" "
								style="width: 150px;">
								<option value="0">
									请选择
								</option>
								<option value="SYSTEM_LOGGER">
									SYSTEM_LOGGER
								</option>

							</select>
						</div>
						<div class="rule-multi-porp"
							style="float: left; margin-left: 5px;">
							<select name="ddSendType" id="ddSendType" datatype="*" sucmsg=" "
								style="width: 150px;">
								<option value="0">
									请选择发送对象
								</option>
								<option value="1">
									用户
								</option>
								<option value="2">
									管理员
								</option>

							</select>
						</div>
						<a id="lbtnSearch" class="btn-search"
							onclick="ui_listReqInfos();">查询</a>
					</div>

					<div class="l-list">
						<ul class="icon-list">
							<li>
								<a class="all"  onclick="checkAll(this);"><i></i><span>全选</span></a>
							</li>
							<li>
								<a class="add" onclick="return ShowAction();"><i></i><span>添加</span></a>
							</li>
							<li>
								<a onclick="return ExePostBack(&#39;btnDelete&#39;);"
									id="btnDelete" class="del"><i></i><span>删除</span>
								</a>
							</li>
							<li>
								<a class="save" onclick="return ShowSaveAction();"><i></i><span>弹出窗口</span></a>
							</li>
						</ul>
					</div>
				</div>
			</div>

			<!--列表-->

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				class="ltable" id="resultgrid">

				<tr>
					<th width="5%">
						选择
					</th>
					<th width="10%">
						open_id
					</th>
					<th align="left" width="10%">
						姓名
					</th>
					<th align="left" width="10%">
						登录名
					</th>
					<th width="20%">
						工作时间
					</th>
					<th width="10%">
						创建时间
					</th>
					<th width="8%">
						操作
					</th>
				</tr>
				<!--<tr>
					<td align="center">
						<span class="checkall" style="vertical-align: middle;"><input
								id="dataList_ctl01_chkId" type="checkbox"
								name="dataList$ctl01$chkId" />
						</span>
						<input type="hidden" name="dataList$ctl01$hidId"
							id="dataList_ctl01_hidId"
							value="B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77" />
					</td>
					<td align="center">
						oOOMHuFza1a-aTGetHuIFrQHwTOA
					</td>
					<td align="center">
						<a
							href="edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77">kefu</a>
					</td>
					<td align="center">
						kefu@xwmwqc
					</td>
					<td align="center">
						0:00:00 ~ 23:27:30
					</td>
					<td align="center">
						2016/1/21 11:26:25
					</td>
					<td align="center">
						<a
							href="edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77">修改</a>
						<a id="dataList_ctl02_lnDeal" href=""><font color='red'>禁用</font>
						</a>
					</td>
				</tr>-->


			</table>


			<!--内容底部-->
			<div class="line30"></div>
			<div class="pagelist">
				<div class="l-btns">
					<span>显示</span>
					<input name="txtPageNum" type="text" value="10"
						onchange="javascript:setTimeout(&#39;__doPostBack(\&#39;txtPageNum\&#39;,\&#39;\&#39;)&#39;, 0)"
						onkeypress="if (WebForm_TextBoxKeyHandler(event) == false) return false;"
						id="txtPageNum" class="pagenum"
						onkeydown="return checkNumber(event);" />
					<span>条/页</span>
				</div>
				<div id="PageContent" class="default">
					<%--<span>共4记录</span><span class="disabled">«上一页</span><span
						class="current">1</span><a href="index.html?page=2">2</a><a
						href="index.html?page=2">下一页»</a>--%>
				</div>
			</div>
		</form>

		<!-- js -->
		<script id="recharge-tpl" type="text/template">
        <div class="tab-content">
            <dl>
                <dt class="txt-pockge" style="width:70px" CssClass="pagenum">模板列表</dt>
                <dd style="margin:0px 10px 0 80px" class="rule-single-select">
                    <select name="listTemplates" id="listTemplates" style="height:32px;width:310px;">
                    </select>
                </dd>
            </dl>
            <dl>
                <dt class="txt-pockge" style="width:70px" CssClass="pagenum">{#0#}</dt>
                <dd style="margin:0px 10px 0 80px">
                    <textarea name="txtContent" rows="2" cols="20" id="txtContent" class="input normal">
                    </textarea>
                </dd>
            </dl>
        </div>
        </script>
	<script type="text/javascript">
     function ShowAction() {
                var param = {'0':'模版描述'};
                var tit = "模板选择";
                jsdialog(tit, RpTpl($("#recharge-tpl").html(), param), "", "None", function () { }, function () { }, function () { });
				//document.location.href="edit.html";
               // window.open("edit.html");
            }
      function RpTpl(tpl, obj) {
                var re = tpl;
                if (!tpl || tpl.length <= 0) return re;
                if (!obj || typeof obj != "object") return re;
                for (k in obj) {
                    re = re.replace("{#" + k + "#}", obj[k]);
                }
                return re;
            }
  	  function ui_listReqInfos(){
		  //$("#ddWid").attr("disabled","disabled");
		  $("#ddWid").closest(".rule-single-select").ruleSingleSelect();
  		var callBack=function(reqInfos,callResult){  			
  			
  			if(reqInfos!=null){
  				$.dialog.tips("查询成功 ...");
  				//for(var i=0;i<5;i++){
  				ui_addReqInfo(reqInfos.content.memberinfo);
  				//}
  				//var htmlMsg2="<span>共4记录</span><span class=\"disabled\">«上一页</span><span "+
				//"class=\"current\">1</span><a href=\"index.jsp?page=2\">2</a><a "+
				//"href=\"index.jsp?page=2\">下一页»</a>";
				//var htmlMsg2=OutPageList(10,  1,  25,  "http://dev.zhang-men.com:8082/app/system/index.jsp?curPage=__id__",  10);
					
				var htmlMsg2=OutPageListAjax(10,  1,  25,  pageChangeCallback,  10);
		$("#PageContent").html(htmlMsg2);
  			}
  		}
		//$("#resultgrid").html("");
  		listReqInfos(callBack);   		  	  	  	
  	  }
	  function pageChangeCallback (pageid){
					 alert("跳转到"+pageid);
	//	 var htmlMsg2=OutPageListAjax(10,  pageid,  25,  pageChangeCallback,  10);
	//	$("#PageContent").html(htmlMsg2);
	  }
  	  function ui_addReqInfo(reqInfos){
         for(var i=0;i<reqInfos.length;i++){
			 var reqInfo=reqInfos[i];
		    var htmlMsg="<tr>" +
				"<td align=\"center\">" +
			"<span class=\"checkall\" style=\"vertical-align: middle;\"><input " +
					"id=\"dataList_ctl01_chkId"+i+"\" type=\"checkbox\"" +
					"name=\"dataList$ctl01$chkId\" />" +
			"</span>" +
			"<input type=\"hidden\" name=\"dataList$ctl01$hidId\"" +
				"id=\"dataList_ctl01_hidId\"" +
				"value=\"B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77\" />" +
		"</td>" +
		"<td align=\"center\">" +
			reqInfo.GROUP_CODE +
		"</td>" +
		"<td align=\"center\">" +
			"<a href=\"edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77\">"+reqInfo.GROUP_NAME+"<\/a>" +
		"</td>" +
		"<td align=\"center\">" +
			reqInfo.PARAM_CODE+
		"</td>" +
		"<td align=\"center\">" +
			reqInfo.BEGIN_TIME+
		"</td>" +
		"<td align=\"center\">" +
			reqInfo.END_TIME+
		"</td>" +
		"<td align=\"center\">" +
			"<a href=\"edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77\">修改 <\/a> " +
			"<a id=\"dataList_ctl02_lnDeal\" href=\"\"><font color='red'>禁用</font>" +
			"</a>" +
		"</td>" +
	"</tr>";
		    $("#resultgrid").append(htmlMsg);
		 }
		   
  	  }
      function listReqInfos(callBackList){
		    var head = {
		      "service_name":"cn.dy.base.pcweb.system.service.MemberService",
		      "operation_name":"test"
		    }
		  	
		    var param = {
		        	"id":$("#ddWid").val(),	      
		    }
				var myCallBack=function(data,callResult){
					 //ui_enableServiceMask(false);
					 if(callBackList)callBackList(data,callResult);	
				}			    			    
		    var options = {
				  "handleError": false,
				  "showProgressBar":false,
		      "timeout":60000*10
				}    												
				//ui_enableServiceMask(true);
				$.ServiceAgent.JSONInvoke(head, param, myCallBack, options);  		  		
	  }
      var diag;
      function ShowSaveAction(){
    	  //("提示：你点击了一个按钮");
    		//Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
    	   diag = new Dialog();
    		diag.Width = 900;
    		diag.Height = 400;
    		diag.Title = "";
    		diag.URL = "edit.jsp";
    		diag.ShowMessageRow=false;
    		//diag.OKEvent = function(){diag.close();};//点击确定后调用的方法
    		//diag.OKEvent = function(){Dialog.alert("用户名不能为空")};
    		diag.show();
      }
      
      $(function(){
    	  //ui_listReqInfos();
		});
    </script>
	<script type="text/javascript"
			src="/xyzg/system/common/scripts/utils.js"></script>
	<script type="text/javascript"
			src="/xyzg/system/common/scripts/zDialog.js"></script>
		<%--<script type="text/javascript"
			src="scripts/jquery/jquery-1.10.2.min.js"></script>--%>
		<%--<script type="text/javascript"
			src="scripts/lhgdialog/lhgdialog.js?skin=idialog"></script>--%>
		<%--<script type="text/javascript" src="scripts/layout.js"></script>--%>
		<%--<script type="text/javascript" src="scripts/datepicker/WdatePicker.js"></script>--%>
		<script type="text/javascript">
	//dynamicLoading.css("../assets/css/main.css");
	</script>
	</body>
</html>
