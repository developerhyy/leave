<%@page language="java" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
    <!DOCTYPE html>

    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>角色查看</title>
        <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
        <link rel="stylesheet" href="../scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
        <script type="text/javascript" src="../scripts/zTree/js/jquery.ztree.all-3.5.min.js"></script>
        <%--<link href="skin/default/style.css" rel="stylesheet" type="text/css" />--%>
            <%--<link href="css/pagination.css" rel="stylesheet" type="text/css" />--%>
                <style type="text/css">
                    #role li {
                        list-style: none;
                        font-size: 12px;
                        line-height: 40px;
                    }
                    
                    #role {
                        float: left;
                    }
                    
                    #roleAuthor {
                        float: left;
                    }
                    
                    #tree li {
                        font-size: 12px;
                    }
                </style>
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
                <a href="javascript:;" class="home"><i></i><span>角色查看</span>
				</a>
            </div>

            <!-- 提示栏 -->
            <!--<div class="mytips">
				提示栏:&nbsp;
				<a href=""
					target="_blank">.........</a>
				<br />
			</div>-->



            <!--列表-->
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="ltable" id="resultgrid">
            </table>


            <!--内容底部-->
            <div class="line30"></div>
            <div class="pagelist">
                <div class="l-btns">
                    <span>显示</span>
                    <input name="txtPageNum" type="text" value="10" onkeyup="value=value.replace(/[^\d]/g,'')" onblur="queryStaffRole();" id="txtPageNum" class="pagenum" onkeydown="return checkNumber(event);" />
                    <span>条/页</span>
                </div>
                <div id="PageContent" class="default">
                    <%--<span>共4记录</span><span class="disabled">«上一页</span><span
						class="current">1</span><a href="index.html?page=2">2</a><a
						href="index.html?page=2">下一页»</a>--%>
                </div>
            </div>
        </form>
        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
                <!-- <input type="button" name="btnSubmit" value="确定" id="btnSubmit" class="btn" onclick="doSave();" /> -->
                <input type="button" name="btnReturn" value="返回" class="btn yellow" onclick="doCancal();" />
            </div>
            <div class="clear"></div>
        </div>
        <script type="text/javascript">
            $(document).ready(function() {
                queryStaffRole();
            });
            var page_current = 1;
            var page_size;
            var page_interval = 10;

            function queryStaffRole() {
                page_size = $("#txtPageNum").val();
                $("#resultgrid").html("<tr><th align='left' width='10%'>账户名称</th><th align='left' width='10%'>昵称</th>" +
                    "<th width='10%'>角色名称</th><th width='10%'>公司名称</th></tr>");
                var queryCallBack = function(data, callResult) {
                    if (data != null) {
                        $.dialog.tips("查询成功...");
                        ui_addReqInfo(data.content.resultMap.List);
                        //var htmlMsg2="<span>共4记录</span><span class=\"disabled\">«上一页</span><span "+
                        //"class=\"current\">1</span><a href=\"index.jsp?page=2\">2</a><a "+
                        //"href=\"index.jsp?page=2\">下一页»</a>";
                        //var htmlMsg2=OutPageList(10,  1,  25,  "http://dev.zhang-men.com:8082/app/system/index.jsp?curPage=__id__",  10);

                        var htmlMsg2 = OutPageListAjax(page_size, page_current, data.content.resultMap.totalCount, pageChangeCallback, page_interval);
                        page_current = 1;
                        $("#PageContent").html(htmlMsg2);
                    }
                }
                listReqInfos(queryCallBack);
            }

            function pageChangeCallback(pageid) {
                page_current = pageid;

                //var htmlMsg2=OutPageListAjax(page_size,  pageid,  reqInfos.totalCount,  pageChangeCallback, page_interval);
                queryStaffRole();
                //$("#PageContent").html(htmlMsg2);
            }

            function ui_addReqInfo(data) {
                for (var i = 0; i < data.length; i++) {
                    var reqInfo = data[i];
                    var htmlMsg = "<tr>" +
                        "<td align=\"center\">" + reqInfo.account + "</td>" +
                        "<td align=\"center\">" + reqInfo.nickname + "</td>" +
                        "<td align=\"center\">" + reqInfo.role_name + "</td>" +
                        "<td align=\"center\">" + reqInfo.corp_name + "</td>" +
                        "</tr>";
                    $("#resultgrid").append(htmlMsg);
                }
            }

            /**function ui_addReqInfo(data,pageSize,pageNum){
            		//下标
            	var a=pageNum>1?(pageSize*(pageNum-1)):0;
            	var temp=0;
            	$("#resultgrid").html("<tr><th align='left' width='10%'>账户名称</th><th align='left' width='10%'>昵称</th>"+
            	"<th width='10%'>角色名称</th><th width='10%'>公司名称</th></tr>");  
            	for(var i=a;i<data.length;i++){
            		var reqInfo=data[i];
            		var htmlMsg="<tr>"
            		+"<td align=\"center\">"+reqInfo.account+"</td>"
            		+"<td align=\"center\">"+reqInfo.nickname+"</td>"
            		+"<td align=\"center\">"+reqInfo.role_name+"</td>"
            		+"<td align=\"center\">"+reqInfo.corp_name+"</td>"
            		+"</tr>";
            		temp++;
            		$("#resultgrid").append(htmlMsg);
            		if(temp==pageSize)
            		return ;

            	}
            }*/
            function listReqInfos(callBackList) {
                var head = {
                    "service_name": "cn.dy.system.service.RoleManagerService",
                    "operation_name": "queryStaffRole"
                }

                var param = {
                    "id": parent.roleId,
                    "pageSize": page_size,
                    "pageNum": page_current
                }
                var options = {
                    "handleError": false,
                    "showProgressBar": false,
                    "timeout": 60000 * 10
                }
                var myCallBack = function(data, callResult) {
                    if (callBackList) callBackList(data, callResult);
                }
                $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
            }
            //点击返回后，跳转至主菜单		
            function doSave() {
                window.location.href = "role_manager.jsp";
                parent.diag.close();
                //parent.$(".page-footer").show();	
            }

            //点击取消后，跳转至主菜单
            function doCancal() {
                window.location.href = "role_manager.jsp";
                parent.diag.close();
                //parent.$(".page-footer").show();	
            }
        </script>
        <script type="text/javascript" src="/xyzg/system/common/scripts/utils.js"></script>
        <script type="text/javascript" src="/xyzg/system/common/scripts/zDialog.js"></script>
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