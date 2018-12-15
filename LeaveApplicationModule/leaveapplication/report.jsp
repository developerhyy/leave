<%@page language="java" pageEncoding="UTF-8"
        contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>报表统计</title>
    <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
</head>
<style>
    .operation_bar{
        margin:0 0 0 10px;
        padding:0 5px;
        height: 28px;
        line-height: 28px;
        color: #444;
        font-size: 12px;
        float:left;
        display: inline-block;
        vertical-align: middle;
    }
    .hy{
        margin: 0 0 0 5px;
        padding: 0 0px;
        height: 28px;
        line-height: 28px;
        font-size: 15px;
        color: #444444;
        display: block;
        float: left;
    }
    .reset{
        display: inline-block;
        margin-left: 15px;
        padding: 4px 10px 4px 8px;
        line-height: 19px;
        height: 20px;
        color: #333;
        font-size: 12px;
        text-decoration: none;
        background-color: #fafafa;
        border-style: none;
        border-color: inherit;
        border-width: medium;
        border-right: 1px solid #e1e1e1;
        border-top: 1px solid #e1e1e1;
        border-bottom: 1px solid #e1e1e1;
        cursor: pointer;
        border-left-style: none;
        border-left-color: inherit;
        border-left-width: medium;
        border-left: solid 1px #dbdbdb;
    }
</style>
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
        <a href="javascript:;" class="home"><i></i><span>请假管理</span>
        </a>
    </div>

    <!-- 操作栏 -->
    <div class="toolbar-wrap">
        <div id="floatHead" class="toolbar">
            <div class="r-list" style="float: none">
                <span class="operation_bar">请假类型：</span>
                <div class="rule-single-select"
                     style="float: left; margin-left: 5px;">
                    <select name="leavests" id="leavests" datatype="*" sucmsg=" "
                            style="width: 150px;">
                        <option value="0">请选择</option>
                        <option value="1">事假</option>
                        <option value="2">病假</option>
                        <option value="3">休假</option>
                        <option value="4">探亲假</option>
                        <option value="5">婚假</option>
                        <option value="6">丧假</option>
                        <option value="7">生育假</option>
                    </select>
                </div>
                <span class="operation_bar">审批状态：</span>
                <div class="rule-single-select"
                     style="float: left; margin-left: 5px;">
                    <select name="approvests" id="approvests" datatype="*" sucmsg=" "
                            style="width: 150px;">
                        <option value="0">请选择</option>
                        <option value="1">审批通过</option>
                        <option value="2">审批不通过</option>
                        <option value="3">待审批</option>
                        <option value="4">已撤回</option>
                    </select>
                </div>
                <span class="operation_bar">请假时间：</span>
                <input name="txtStart" type="text" id="txtStart"
                       class="keyword date"
                       onfocus="WdatePicker({dateFmt:&#39;yyyy-MM-dd HH:mm:ss&#39;})"
                       datatype="*1-50" errormsg="请选择正确的日期" sucmsg=" " nullmsg=" "
                       placeholder="开始日期" style="float: left" />
                <span class="hy">--</span>
                <input name="txtEnd" type="text" id="txtEnd" class="keyword date"
                       onfocus="WdatePicker({dateFmt:&#39;yyyy-MM-dd HH:mm:ss&#39;})"
                       datatype="*1-50" errormsg="请选择正确的日期" sucmsg=" " nullmsg=" "
                       placeholder="结束日期" style="float: left" />

                <a id="lbtnSearch" class="reset" onclick="ui_listReqInfos();"><i></i><span>查询</span></a>

                <a id="btnAdd" class="reset" onclick="window.location.href='leaveadd.jsp';"><i></i><span>新增</span></a>
            </div>

            <%--<div class="l-list">
                <ul class="icon-list">
                    <li>
                        <a class="all"  onclick="checkAll(this);"><i></i><span>全选</span></a>
                    </li>
                    <li>
                        <a id="btnAdd" class="add" onclick="window.location.href='leaveadd.jsp';"><i></i><span>新增</span></a>
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
    var result;
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
                //var htmlMsg2=OutPageListAjax(10,  1,  25,  pageChangeCallback,  10);
                htmlMsg2=OutPageListAjax(page_size, page_current, reqInfos.content.result.total_count, pageChangeCallback, page_interval);
                $("#PageContent").html(htmlMsg2);
                //page_current=1;
            }
        }
        listReqInfos(queryCallBack);
    }
    function pageChangeCallback (pageid){
        page_current=pageid;
        ui_listReqInfos();
        //	 var htmlMsg2=OutPageListAjax(10,  pageid,  25,  pageChangeCallback,  10);
        //   $("#PageContent").html(htmlMsg2);
        alert("跳转到"+pageid);
    }
    function listReqInfos(callBackList){
        var head = {
            "service_name":"LeaveManageService",
            "operation_name":"queryLeaveList"
        }

        var param = {
            "leave_type":"",//$("#leavests").val() ,
            "sts":"",//$("#approvests").val() ,
            "begin_time":null,//$("#txtStart").val() ,
            "end_time":null,//$("#txtEnd").val() ,
            "pageNum":page_current,
            "pageSize":page_size
        }

        var myCallBack=function(data,callResult){
            //ui_enableServiceMask(false);
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
            "                请假类型\n" +
            "            </th>\n" +
            "            <th align=\"left\" width=\"20%\">\n" +
            "                请假时间\n" +
            "            </th>\n" +
            "            <th align=\"left\" width=\"10%\">\n" +
            "                提交时间\n" +
            "            </th>\n" +
            "            <th width=\"20%\">\n" +
            "                审批时间\n" +
            "            </th>\n" +
            "            <th width=\"10%\">\n" +
            "                审批状态\n" +
            "            </th>\n" +
            "            <th width=\"8%\">\n" +
            "                操作\n" +
            "            </th>\n" +
            "        </tr>");

        for(var i=0;i<reqInfos.length;i++){
            var reqInfo=reqInfos[i];
            /*"<span class=\"checkall\" style=\"vertical-align: middle;\"><input " +
                "id=\"dataList_ctl01_chkId"+i+"\" type=\"checkbox\"" +
                "name=\"dataList$ctl01$chkId\" />" +
                "</span>" +
                "<a href=\"edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77\">"+reqInfo.begin_time + reqInfos.end_time+"<\/a>" +
                */
            var htmlMsg = new StringBuffer();
            htmlMsg.append("<tr>" +
                "<td align=\"center\">" +
                ((page_current-1)*page_size + i + 1) +
                "<input type=\"hidden\" name=\"leave_id\"" +
                "id=\"leave_id\"" +
                "value=\""+ reqInfo.id +"\" />" +
                "</td>");
            htmlMsg.append("<td align=\"center\">" +
                reqInfo.leave_type +
                "</td>");
            htmlMsg.append("<td align=\"center\"><span>开始时间：</span>" +
                reqInfo.begin_time.substring(0,10) + "<br/><span>结束时间：</span>" + reqInfo.end_time.substring(0,10) +
                "</td>");
            htmlMsg.append("<td align=\"center\">" +
                reqInfo.create_time+
                "</td>");
            var str = (reqInfo.audit_time == null) ? " " : reqInfo.audit_time;
            htmlMsg.append("<td align=\"center\">" + str +
                "</td>");

            ////////////////
            htmlMsg.append("<td align=\"center\">");

            if(reqInfo.sts==0 || reqInfo.sts==1) {
                htmlMsg.append("待审批</td><td align=\"center\">");
                htmlMsg.append("<a href=\"leavedetail.jsp?leave_id="+$("#leave_id") +"\">查看<\/a></td> ");
                //"<a href=\"edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77\">修改 <\/a> " +
                //"<a id=\"dataList_ctl02_lnDeal\" href=\"\"><font color='red'>禁用</font>" +
            } else if(reqInfo.sts==2){
                if(reqInfo.audit_time !=null){
                    htmlMsg.append("审批通过</td><td align=\"center\">");
                    htmlMsg.append("<a href=\"leavedetail.jsp?leave_id="+$("#leave_id") +"\">查看<\/a></td> ");
                }else{
                    htmlMsg.append("审批不通过</td><td align=\"center\">");
                    htmlMsg.append("<a href=\"leavedetail.jsp?leave_id="+$("#leave_id") +"\">查看<\/a></td> ");
                }
            } else if(reqInfo.sts==3){//结束
                htmlMsg.append("已撤回</td><td align=\"center\">");
                htmlMsg.append("<a href=\"leavedetail.jsp?leave_id="+$("#leave_id") +"\">查看<\/a></td> " +
                    "<a onclick=\"DeleteAction("+$("#leave_id")+")\" href=\"\"><font color='red'>禁用</font></a></td>");
            }
            htmlMsg.append("</td></tr>");


            $("#resultgrid").append(htmlMsg.toString());
        }

    }



    function DeleteAction(){
        Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
    }
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
        ui_listReqInfos();
    });

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
<script type="text/javascript"
    src="../scripts/jquery/jquery-1.8.1.min.js"></script>
<script type="text/javascript"
    src="../scripts/lhgdialog/lhgdialog.js?skin=idialog"></script>
<%--<script type="text/javascript" src="scripts/layout.js"></script>--%>
<%--<script type="text/javascript" src="scripts/datepicker/WdatePicker.js"></script>--%>
<script type="text/javascript">
    //dynamicLoading.css("../assets/css/main.css");
</script>
</body>
</html>
