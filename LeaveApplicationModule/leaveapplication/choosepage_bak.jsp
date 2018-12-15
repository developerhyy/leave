<%@page language="java" pageEncoding="UTF-8"
        contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>人员列表</title>
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
        <a href="javascript:;" class="home"><i></i><span>添加审批人</span>
        </a>
    </div>

    <!-- 操作栏 -->
    <div class="toolbar-wrap">
        <div id="floatHead" class="toolbar">
            <div class="r-list" style="float: none">

                <input type="text" name="txtdept" id="txtdept" for="txtdept" placeholder="部门" sucmsg=" " style="width: 150px;" class="input normal"
                onclick="ShowAction()" />

                <input type="text" name="txtQuery" id="txtQuery" for="txtQuery" placeholder="姓名、身份证号、警号" class="input normal" />

            </div>

            <div class="l-list">
                <ul class="icon-list">
                    <%--<li>
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
                    </li>--%>
                    <li>
                        <a id="lbtnSearch" class="btn-search" onclick="ui_listReqInfos();"><i></i><span>查询</span></a>
                    </li>
                </ul>
            </div>
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
    <%--<div class="tab-content">--%>
        <div id="role" style="width: 400px; float: left; ; height: 500px;background: #eeeeee">
            <div class="title">部门列表</div>
            <div id="treeParentArea" valign=top style="width: 100%;height: 500px;">
                <ul id="tree" class="ztree" style="overflow:auto;margin:0px;height:698px"></ul>
            </div>
        </div>
        <%--<dl>
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
        </dl>--%>
    <%--</div>--%>
</script>
<script type="text/javascript">
    var zTree = null;
    var result;
    var page_current=1;
    var page_size=0;
    var page_interval=10;
    var right_click_node = {
        id: '',
        name: '',
        parent_id: '',
        parent_name: ''
    };
    function chooseNode(treeNode) {
        right_click_node.id = treeNode.id;
        right_click_node.name = treeNode.name;
        right_click_node.parent_id = treeNode.parent_id;
        var parentTreeNode = treeNode.getParentNode();
        if (parentTreeNode)
            right_click_node.parent_name = parentTreeNode.name;
        else
            right_click_node.parent_name = "";
    }

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
                page_current=1;
            }
        }
        listReqInfos(queryCallBack);
    }
    function pageChangeCallback (pageid){
        alert("跳转到"+pageid);
        page_current=pageid;
        ui_listReqInfos();
        //	 var htmlMsg2=OutPageListAjax(10,  pageid,  25,  pageChangeCallback,  10);
        //	$("#PageContent").html(htmlMsg2);
    }
    function listReqInfos(callBackList){
        var head = {
            "service_name":"MemberService",
            "operation_name":"queryMemberList"
        }

        var param = {
            "dept":$("#txtdept").val() ,
            "query": $.trim($("#txtQuery").val()).length == 0 ? "" : $("#txtQuery").val(),
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
            "                姓名\n" +
            "            </th>\n" +
            "            <th align=\"left\" width=\"8%\">\n" +
            "                性别\n" +
            "            </th>\n" +
            "            <th align=\"left\" width=\"20%\">\n" +
            "                身份证号\n" +
            "            </th>\n" +
            "            <th width=\"15%\">\n" +
            "                警号\n" +
            "            </th>\n" +
            "            <th width=\"15%\">\n" +
            "                手机号\n" +
            "            </th>\n" +
            "            <th width=\"8%\">\n" +
            "                所属部门\n" +
            "            </th>\n" +
            "            <th width=\"8%\">\n" +
            "                操作\n" +
            "            </th>\n" +
            "        </tr>");

        for(var i=0;i<reqInfos.length;i++){
            var reqInfo=reqInfos[i];
            /**
             *
             "<span class=\"checkall\" style=\"vertical-align: middle;\"><input " +
             "id=\"dataList_ctl01_chkId"+i+"\" type=\"checkbox\"" +
             "name=\"dataList$ctl01$chkId\" />1" +
             "</span>" +
             * @type {string}
             */
            var htmlMsg="<tr code="+reqInfo.id+">" +
                "<td align=\"center\">" +
                ((page_current-1)*page_size + i + 1) +
                "<input type=\"hidden\" name=\"leave_id\"" +
                "value=\""+reqInfo.id+"\" />" +
                "</td>" +
                "<td name="+ reqInfo.name+" align=\"center\">" +
                "<a href=\"\">"+reqInfo.name+"<\/a>" +
                "</td>" +
                "<td align=\"center\">" +
                reqInfo.gender+
                "</td>" +
                "<td align=\"center\">" +
                reqInfo.idcard+
                "</td>" +
                "<td align=\"center\">" +
                reqInfo.policecode+
                "</td>" +
                "<td align=\"center\">" +
                reqInfo.mobile+
                "</td>" +
                "<td align=\"center\">" +
                reqInfo.dept+
                "<td align=\"center\">" +
                "<a onclick='onChoose(this)' href=\"\"><font color='blue'>选择</font>" +
                "</a>" +
                "</td>" +
                "</tr>";
            $("#resultgrid").append(htmlMsg);
        }
        /*"<a href=\"edit.html?action=Edit&id=B6A0AEF5-25E6-41BB-A0D0-2DB2E4977C77\">修改 <\/a> " +*/
    }



    //////////=============================/////////////////////
    function ShowAction() {
        var param = {'0':'模版描述'};
        var tit = "部门选择";
        jsdialog(tit, RpTpl($("#recharge-tpl").html(), param), "", "None", function (data) { alert(1+"=========="+data);},
            function (data) {
                alert(2+"=========="+data);
                $("#txtdept").val(right_click_node.name);
                //alert(right_click_node.name);
            },
            function () {
            createTree();
            alert(3+"==========");
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
    function createTree(){
        var head={
            "service_name":"MemberService",
            "operation_name":"getDeptTree"
        };
        var param={
            "all": true
        };
        var options = {
            "handleError": false
        };
        function callBack(data){
            resizeTree();
            if(zTree != null){
                zTree.destroy();
            }
            zTree = $.fn.zTree.init($("#tree"),setting,data);
            var rootNode = zTree.getNodes()[0];
            if(rootNode && rootNode.children && rootNode.children.length > 0){
                var node = rootNode.children[0];
                if (node) {
                    zTree.selectNode(node, true);
                    zTree.cancelSelectedNode(node);
                }
            }

        };
        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }

    function dropPrev(treeId, nodes, targetNode) {
        if (targetNode.id == "101")
            return false; //不能插入到根节点之前

        return true;
    }

    function dropNext(treeId, nodes, targetNode) {
        if (targetNode.id == "101")
            return false; //不能插入到根节点之后
        return true;
    }

    function dropInner(treeId, nodes, targetNode) {
        return true;
    }

    var setting = {
        edit: {
            enable: true,
            showRemoveBtn: false,
            showRenameBtn: false,
            drag: {
                isCopy: true,
                isMove: true,
                prev: dropPrev,
                inner: dropInner,
                next: dropNext
            }
        },

        data: {
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parent_id",
                rootPId: 0
            },
            key: {
                name: "dis_name"
            }
        },

        callback: {
            beforeDrag: function(treeId, treeNodes) {
                if (treeNodes) {
                    var treeNode = treeNodes[0];
                    if (treeNode.getParentNode() == null)
                        return false;
                }
                return true;
            },

            beforeDragOpen: function(treeId, treeNode) {
                return false;
            },

            beforeDrop: function(treeId, treeNodes, targetNode, moveType) {
                if (targetNode) {
                    moveApp(treeNodes[0], targetNode, moveType);
                    return true;
                }
                return false;
            },

            onDrop: function(event, treeId, treeNodes, targetNode, moveType) {
                if (targetNode) {
                    return true;
                }
                return false;
            },

            beforeClick: function(treeId, treeNode, clickFlag) {
                return true;
            },

            onClick: function(callEvent, treeId, treeNode, clickFlag) {
                if (treeNode)
                    onClickTree(treeNode);
                return true;
            },
            onRightClick: function(callEvent, treeId, treeNode) {
                if (treeNode) {
                    zTree.selectNode(treeNode, false);
                    onClickTree(treeNode);
                    showRMenu(treeNode, callEvent.clientX, callEvent.clientY);
                }
                return true;
            }
        },

        view: {
            nameIsHTML: true,
            showTitle: false,
            selectedMulti: false
        }
    };

    //单击树节点时
    function onClickTree(treeNode) {
        //保存节点相关信息，供其他页面调用
        chooseNode(treeNode);
        var id = treeNode.id.toString();
        var cutStr = id.substring(0, 1);
        var cutId = id.substring(1);
        if (id != "101") {
            if (cutStr == "c") {
                $.form("#contactForm").sleep();
                $("#treeParentArea").show();
alert(cutStr)
                //getStaffDetail(cutId, treeNode);
            } else {

                $.form("#tableForm").sleep();
                $("#treeParentArea").show();
alert(cutStr)
                //getFunDetail(id, treeNode);
            }
        }

    }
    function resizeTree() {

        if ($.browser.msie) {
            if ($.browser.version == "10.0") {
                $("#treeParentArea")
                    .height($(document.body).height() - 23 - 45);
                $("#treeParentArea").width($("#search_key").width() * 10 / 7);
                $("#tree").height($("#treeParentArea").height() - 20);
                $("#tree").width($("#treeParentArea").width() - 20);
            } else {
                $("#treeParentArea")
                    .height($(document.body).height() - 23 - 62);
                $("#tree").height($("#treeParentArea").height() - 10);
            }
        } else {
            $("#treeParentArea").height($(document.body).height() - 23 - 40);
            $("#tree").height($("#treeParentArea").height() - 40);
        }

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
        //页面加载完毕后 自动触发查询按钮
        ui_listReqInfos();
    });

</script>
<script>
    function onChoose(e) {
        var tr = $(e).closest("tr");
        var Id = tr.attr("code");
        //var i = tr.index();
        var name= $(tr.children()[1]).attr("name");//tr.find("td:eq(1)").attr("name");
        PageBack("user-choose", { id: Id, name: name });
    }

    //执行关闭事件并且通知之前的页面（通常用在协议同意，签名之类）
    function PageBack(eventName, data) {
        if (window.parent != window) {
            parent.targetWindow = window.targetWindow;
            parent.ClosePage( eventName, data);
        } else {
            //alert("必需是在iframe里面的页面才能调用此方法！");
            history.back(-1);
        }
    }
</script>
<script type="text/javascript"
        src="/xyzg/system/common/scripts/utils.js"></script>
<script type="text/javascript"
        src="/xyzg/system/common/scripts/zDialog.js"></script>
<%--<script type="text/javascript"
    src="${home}/scripts/jquery/jquery-1.8.1.min.js"></script>
<script type="text/javascript"
    src="/scripts/lhgdialog/lhgdialog.js?skin=idialog"></script>
<script type="text/javascript" src="scripts/layout.js"></script>
<script type="text/javascript" src="scripts/datepicker/WdatePicker.js"></script>--%>
<script type="text/javascript">
    //dynamicLoading.css("../assets/css/main.css");
</script>
</body>
</html>
