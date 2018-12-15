<%@page language="java" pageEncoding="UTF-8"
        contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>工龄查询</title>
    <link rel="stylesheet" href="../scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
    <script type="text/javascript" src="../scripts/zTree/js/jquery.ztree.all-3.5.min.js"></script>
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
        <a href="javascript:;" class="home"><i></i><span>工龄查询</span>
        </a>
    </div>

    <!-- 操作栏 -->
    <div class="toolbar-wrap">
        <div id="floatHead" class="toolbar">
            <div class="r-list" style="float: none">
                <input type="text" name="txtdept" id="txtdept" for="txtdept" deptid="" readonly="readonly" placeholder="部门" sucmsg=" " style="width: 150px;" class="input normal"
                       onclick="ShowAction()" />
                <div class="rule-single-select" style="float: left;">
                    <select name="txtGender" id="txtGender" datatype="*" sucmsg=" "
                            style="width: 150px;">
                        <option value="">请选择性别</option>
                        <option value="1">男</option>
                        <option value="0">女</option>
                    </select>
                </div>
                <input type="text" name="txtQuery" id="txtQuery" for="txtQuery" placeholder="姓名、身份证号、警号" class="input normal" />
                <a id="lbtnSearch" class="btn-search" onclick="ui_listReqInfos();"><i></i><span>查询</span></a>
            </div>

            <%--<div class="l-list">
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
            </div>--%>
        </div>
    </div>

    <!--列表-->

    <table width="100%" border="0" cellspacing="0" cellpadding="0"
           class="ltable" id="resultgrid">
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
    <div id="role" style="width: 200px; float: left; ; height: 300px;background: #eeeeee">
        <div class="title">部门列表</div>
        <div id="treeParentArea" valign=top style="width: 100%;height: 500px;">
            <ul id="tree" class="ztree" style="overflow:auto;margin:0px;height:698px"></ul>
        </div>
    </div>
</script>
<script type="text/javascript">

    var page_current=1;
    var page_size=0;
    var page_interval=10;

    function ui_listReqInfos() {
        page_size=$("#txtPageNum").val();
        var queryCallBack=function(reqInfos,callResult){
            if(reqInfos!=null){
                $.dialog.tips("查询成功...");
                ui_addReqInfo(reqInfos.content.result.records);
                var htmlMsg2="";
                htmlMsg2=OutPageListAjax(page_size, page_current, reqInfos.content.result.total_count, pageChangeCallback, page_interval);
                $("#PageContent").html(htmlMsg2);
                page_current=1;
            }
        }
        listReqInfos(queryCallBack);
    }
    function pageChangeCallback (pageid){
        page_current=pageid;
        ui_listReqInfos();
        alert("跳转到"+pageid);
    }
    function listReqInfos(callBackList){
        var head = {
            "service_name":"SeniorityService",
            "operation_name":"querySeniority"
        }

        var param = {
            "deptId": $.trim($("#txtdept").attr("deptId")).length == 0 ? "" : $("#txtdept").attr("deptId"),
            "gender":$("#txtGender").val() ,
            "query":$("#txtQuery").val() ,
            "pageNum":page_current,
            "pageSize":page_size
        }

        var myCallBack=function(data,callResult){
            if(callBackList){
                callBackList(data,callResult);
            }
        }
        var options = {
            "handleError": false,
            "showProgressBar":false,
            "timeout":60000*10
        }
        //ui_enableServiceMask(true);
        $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
    }
    function ui_addReqInfo(reqInfos){
        $("#resultgrid").html("<tr>\n" +
            "            <th width=\"5%\">\n" +
            "                序号\n" +
            "            </th>\n" +
            "            <th width=\"10%\">\n" +
            "                姓名\n" +
            "            </th>\n" +
            "            <th align=\"left\" width=\"20%\">\n" +
            "                性别\n" +
            "            </th>\n" +
            "            <th align=\"left\" width=\"10%\">\n" +
            "                身份证号\n" +
            "            </th>\n" +
            "            <th width=\"20%\">\n" +
            "                警号\n" +
            "            </th>\n" +
            "            <th width=\"10%\">\n" +
            "                部门\n" +
            "            </th>\n" +
            "            <th width=\"8%\">\n" +
            "                工龄\n" +
            "            </th>\n" +
            "            <th width=\"8%\">\n" +
            "                年休假\n" +
            "            </th>\n" +
            "            <th width=\"8%\">\n" +
            "                剩余年休假\n" +
            "            </th>\n" +
            "        </tr>");

        for(var i=0;i<reqInfos.length;i++){
            var reqInfo=reqInfos[i];
            var htmlMsg = new StringBuffer();
            htmlMsg.append("<tr>" +
                "<td align=\"center\">" +
                ((page_current-1)*page_size + i + 1) +
                "<input type=\"hidden\" name=\"leave_id\"" +
                "id=\"leave_id\"" +
                "value=\""+ reqInfo.id +"\" />" +
                "</td>");
            htmlMsg.append("<td align=\"center\">" + reqInfo.name +"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.gender+"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.idcard+"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.policecode+"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.dept+"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.Seniority+"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.FurloughDays+"</td>");
            htmlMsg.append("<td align=\"center\">"+reqInfo.leftFurloughDays+"</td>");
            htmlMsg.append("</td></tr>");
            $("#resultgrid").append(htmlMsg.toString());
        }
    }
    $(function(){
        ui_listReqInfos();
    });

    function ShowAction() {
        var param = {'0':'模版描述'};
        var tit = "部门选择";
        jsdialog(tit, RpTpl($("#recharge-tpl").html(), param), "", "None", function (data) { alert(1+"=========="+data);},
            function () {
                $("#txtdept").attr("deptId",right_click_node.id);
                $("#txtdept").val(right_click_node.name);
            },
            function () {
                createTree();
            });
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

    function StringBuffer() {
        this.__strings__ = new Array();
    }
    StringBuffer.prototype.append = function (str) {
        this.__strings__.push(str);
        return this; //方便链式操作
    }
    StringBuffer.prototype.toString = function () {
        return this.__strings__.join("");
    }
</script>
<script type="text/javascript"
        src="/xyzg/system/common/scripts/utils.js"></script>
<script type="text/javascript"
        src="/xyzg/system/common/scripts/zDialog.js"></script>
<script type="text/javascript">
    //dynamicLoading.css("../assets/css/main.css");
</script>
<script src="deptTreeJs.js"></script>
</body>
</html>
