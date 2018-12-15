<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%

    String oper_type = request.getParameter("oper_type");
    if (oper_type == null) oper_type = "add";
%>
<html>
<head>
    <title></title>
    <style>
    .dropdown {
        position: relative;
    }

    .clearfix {
        *zoom: 1;
    }

    .dropdown-menu {
        position: absolute;
        top: 100%;
        left: 0;
        z-index: 1000;
        display: none;
        float: left;
        min-width: 100px;
        padding: 5px 0;
        margin: 2px 0 0;
        list-style: none;
        background-color: #ffffff;
        border: 1px solid #ccc;
        border: 1px solid rgba(0, 0, 0, 0.2);
        *border-right-width: 2px;
        *border-bottom-width: 2px;
        -webkit-border-radius: 6px;
        -moz-border-radius: 6px;
        border-radius: 6px;
        -webkit-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        -moz-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
        -webkit-background-clip: padding-box;
        -moz-background-clip: padding;
        background-clip: padding-box;
    }

    .dropdown-menu li {
        display: block;
        margin: 1px;
        clear: both;
        height: 19px;
    }

    .dropdown-menu li a {
        display: block;
        text-decoration: none;
        padding: 3px 20px;
        clear: both;
        font-weight: normal;
        line-height: 18px;
        font-size: 12px;
        color: #333333;
        white-space: nowrap;
    }

    .dropdown-menu li a:hover,
    .dropdown-menu li a:focus,
    .dropdown-menu .active a,
    .dropdown-menu .active a:hover,
    .dropdown-menu .active a:focus {
        color: #ffffff;
        text-decoration: none;
        background-color: #0081c2;
        background-image: -moz-linear-gradient(top, #0088cc, #0077b3);
        background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#0088cc), to(#0077b3));
        background-image: -webkit-linear-gradient(top, #0088cc, #0077b3);
        background-image: -o-linear-gradient(top, #0088cc, #0077b3);
        background-image: linear-gradient(to bottom, #0088cc, #0077b3);
        background-repeat: repeat-x;
        outline: 0;
        filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0077b3', GradientType=0);
    }

</style>

<link rel="stylesheet" href="../scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
<script type="text/javascript" src="../scripts/zTree/js/jquery.ztree.all-3.5.min.js"></script>


</head>
<body class="mainbody" style="width: 100%; height: 100%; margin: 10px; overflow: hidden;">
    <!-- 左边数据-->
    <div name="operForm" id="operForm" style="width: 100%; height: 100%;;background: #FFFFFF">
        <div id="role" style="width: 30%; float: left; ; height: 100%;background: #eeeeee">
            <div class="title">
                菜单列表
            </div>
            <div id="treeParentArea" valign=top style="width:100%;height:100%;">
                <ul id="tree" class="ztree" style="margin:0px;overflow:auto;"></ul>
            </div>
        </div>

        <form name="tableForm" id="tableForm">
        <div id="app_detail_table" valign=top style="width: 69%; float: right;; height: 100%;background: #eeeeee";overflow-y:szroll;>
            <div class="title">
                详细菜单列表
            </div>
           <div id="app_detail_table" class="tab-content" style="padding-bottom: 50px;">
<!-- 
    <form name="operForm" id="operForm"  style="padding-bottom: 50px;display:none;">
    <table id="app_detail_table"  border=0 style=" padding-bottom: 50px;display:none; "> -->
 
        <dl>
            <dt>上级应用：</dt>
            <dd>
                <input type="text" disabled="disabled" name="parent_name" id="parent_name" for="parent_name"  class="input normal" sucmsg=" " 
                maxlength="20"/>              
            </dd>
        </dl>
        
        <dl>
            <dt>应用标识：</dt>
            <dd>
               <input type="text" name="id" id="id"  for="id"  class="input normal" sucmsg=" " 
               maxlength="20"/> 
               <span class="Validform_checktip">*必填</span>          
           </dd>
       </dl>
<dl>
        <dt>应用名称：</dt>
        <dd>
           <input type="text" name="name" id="name"  for="name"  class="input normal" sucmsg=" " 
           maxlength="20"/> 
           <span class="Validform_checktip">*必填</span>          
       </dd>
</dl>

<dl>
    <dt>应用描述：</dt>
    <dd>
        <input type="text" name="description" id="description" for="description"  class="input normal" sucmsg=" " 
        maxlength="20" />              
    </dd>
</dl>

<!-- <dl>
    <dt>应用描述：</dt>
    <dd>
        <input type="text" name="style" id="style" for="style"  class="input normal" sucmsg=" " 
        maxlength="20" />              
    </dd>
</dl> -->
<!-- 请选择 应用菜单目录 应用菜单 按钮功能-->

<dl>
    <dt>功能类型：</dt>
    <dd>
     <div class="rule-single-select" style="float: left;">
      <select name="style" id="style" datatype="*" sucmsg=" "
      style="width: 150px;">
      <option value="0">请选择 </option>
      <option value="1">中间菜单 </option>
      <option value="2">叶子节点 </option>
      <option value="9">按钮功能 </option>
            </select>
        </div>     
    </dd>
</dl>

<dl>
    <dt>地址：</dt>
    <dd>
        <input type="text" name="content" id="content" for="content"  class="input normal" sucmsg=" " 
        />              
    </dd>
</dl>

<dl>
    <dt>打开方式：</dt>
    <dd>
    <div class="rule-single-select" style="float: left;">
      <select name="target" id="target" datatype="*" sucmsg=" "
      style="width: 150px;">
      <option value="_newtab">新选项卡
      <option value="_newwin">新窗口
      </select>
    </div>     
    </dd>
</dl>

<!-- <dl>
    <dt>支持最大化：</dt>
    <dd>
        <input type="text" name="maximize" id="maximize" for="maximize"  value="1" validation=integer class="input normal" sucmsg=" " 
        maxlength="20"/>              
    </dd>
</dl> -->

<!-- <dl>
 <dt>窗口宽度：</dt>
 <dd>
    <input type="text" name="width" id="width" for="width" value="0" maxlength=5 validation=integer class="input normal" sucmsg=" " 
    maxlength="20"/>              
</dd> 
</dl> -->

<!-- <dl>
 <dt>窗口高度：</dt>
 <dd>
    <input type="text"  name="width" id="height" for="width" value="0" maxlength=5 validation=integer class="input normal" sucmsg=" " 
    maxlength="20"/>              
</dd> 
</dl> -->

<dl>
 <dt>优先级：</dt>
 <dd>
    <input type="text" name="pri" id="pri" for="pri" maxlength=5 validation=integer class="input normal" sucmsg=" " 
    maxlength="20"/>              
</dd> 
</dl>

<dl>
    <dt>在用：</dt>
    <dd>
     <div class="rule-single-select" style="float: left;">
      <select name="sts" id="sts" datatype="*" sucmsg=" "
      style="width: 150px;">
      <option value="1">是
      <option value="0">否
      </select>
    </div>     
    </dd>
</dl>
<!--默认数据 -->
<dl>
<input type="hidden" name="width" id="width" value="0" for="width" sucmsg=" ">
<input type="hidden" name="height" id="height" for="height" value="0" sucmsg=" ">
<input type="hidden" name="maximize" id="maximize" for="maximize" value="1" sucmsg=" ">
<input type="hidden" name="is_delete" id="is_delete" for="is_delete" value=1 sucmsg=" ">
<input type="hidden" name="parent_id" id="parent_id" for="parent_id"  sucmsg=" ">
<input type="hidden" name="img_big" id="img_big" for="img_big"  sucmsg=" ">
<input type="hidden" name="img_big_dis" id="img_big_dis" for="img_big_dis"  sucmsg=" ">
<input type="hidden" name="img_mid" id="img_mid" for="img_mid"  sucmsg=" ">
<input type="hidden" name="img_mid_dis" id="img_mid_dis" for="img_mid_dis"  sucmsg=" ">
<input type="hidden" name="img_little" id="img_little" for="img_little"  sucmsg=" ">
<input type="hidden" name="img_little_dis" id="img_little_dis" for="img_little_dis"  sucmsg=" ">
<input type="hidden" name="images" id="images" for="images"  sucmsg=" ">
<input type="hidden" name="order_index" id="order_index" for="order_index"  sucmsg=" ">
<input type="hidden" name="style_path" id="style_path" for="style_path"  sucmsg=" ">
</dl>
</div>
<!--保存-->
<div class="page-footer" style="text-align: center">
    <div class="btn-list">
        <input type="button"  id="btnSave" name="btnSave" value="保存"
        class="btn green" onclick="doSave();return false;" />
        <input type="button"  id="btnCancel" name="btnCancel" value="添加"
        class="btn yellow" onclick="doAdd();return false;" />
        <input type="button"  id="btnClock" name="btnCancel" value="取消"
        class="btn blue" onclick="doClock();return false;" />

    </div>
</div>  
</div>
</form>
</div>


<!--保存 "  style="display:none;"-->
<!-- <div class="page-footer" style="text-align: center">
    <div class="btn-list">
        <button id="btnReturn" value="保存" class="btn green" onclick="doSave();return false;" >保存</button>
        <button id="btnAdd" value="添加" class="btn yellow" onclick="doAdd();return false;" >添加</button>
    </div>
</div>   -->





<div id="nodeMenu" class="dropdown clearfix" style="display:none;position:absolute;z-index:100">
    <ul id="nodeMenuContent" class="dropdown-menu"
        style="display: block; position: static; margin-bottom: 5px; width: 100px;">
    </ul>
</div>

</body>
<script type="text/javascript">
    var diag;
    var tree;
    var tree_context_menu;
    var top_menu;
    var oper_type = "<%=oper_type%>";
    var right_click_node = {id: '', name: '', parent_id: '', parent_name: ''};
   
    function chooseNode(treeNode) {
        right_click_node.id = treeNode.id;
        right_click_node.name = treeNode.name;
        right_click_node.parent_id = treeNode.parent_id;
        var parentTreeNode = treeNode.getParentNode();
        if (parentTreeNode)right_click_node.parent_name = parentTreeNode.name;
        else right_click_node.parent_name = "";
    }

    //单击树节点时
    function onClickTree(treeNode) {
        //保存节点相关信息，供其他页面调用
        chooseNode(treeNode);
        var id = treeNode.id;
        if (id != "ROOT") {
            $.form("#tableForm").sleep();
            $("#treeParentArea").show();
            $("#app_detail_table").show();

            getFunDetail(id, treeNode,'doClock');
            initApp();

        }
        else {
           $("#app_detail_table").hide();
        }
    }

    //获取菜单详情
    function getFunDetail(fun_id, treeNode,type) {
    	var type = type;
        var head = {
            "service_name": "cn.dy.system.service.MenuMemberService",
            "operation_name": "getFunctionDetail",
            "token_id": loginInfo.token_id,
            "user_id": loginInfo.staff_id,
            "version": "0100",
            "timestamp": "",
            "request_seq": "",
            "request_source": ""
        }

        var param = {
            "fun_id": fun_id
        }

        var options = {
            "handleError": true,
            "showProgressBar": false
        }

        function callBack(data) {
			if(data!=null){
			 $.form("#tableForm").clear();
             data.sts = "" + data.sts;
            //$("#style1").val("1");
            $("#style").val(data.style);
            $("#sts").val(data.sts);
            $("#style").attr("disabled","disabled");
            $("#style").closest(".rule-single-select").ruleSingleSelect();
            $("#target").val(data.target);
            $("#target").attr("disabled","disabled");
            $("#target").closest(".rule-single-select").ruleSingleSelect();
            $("#sts").attr("disabled","disabled");
            $("#sts").closest(".rule-single-select").ruleSingleSelect();


            //$("btnSave").hide();

            $.form("#tableForm").setJSON(data);
            if ($("#width").val() == null || $("#width").val() == "")$("#width").val("0");
            if ($("#height").val() == null || $("#height").val() == "")$("#height").val("0");


            $("#parent_name").val(right_click_node.parent_name);
            $.form("#tableForm").wakeup();
            //$("#parent_name").attr("disabled", true);
            $("#tableForm").find('input').attr("readonly",true);

         
            $(document).ready(function () {

            
        });

            $("input[id*=img][type=hidden]").each(function () {
                var idAttr = $(this).attr("id");
                var srcValue = $(this).val();
                if (srcValue == null)srcValue = "";
                if (srcValue != "" && srcValue.indexOf("/") != 0) {
                    srcValue = "../" + srcValue;
                }

                if (srcValue == "")srcValue = "../style/images/app/nopic.jpg";
                $("#" + idAttr + "_img").attr("src", srcValue);
            });
            
            if(type=='doClock'){
    	        $("#btnSave").attr("class","btn gray");
    	        $("#btnClock").attr("class","btn gray");
    	        $("#btnCancel").attr("class","btn gray");
    			$("#btnCancel").attr("disabled",true);
    	        $("#btnSave").attr("disabled",true);  
    	        $("#btnClock").attr("disabled",true);
            }
		  }
        }

        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }


    //显示预览图标
    function doShowImg() {
        var imgWin = dhxWins.createWindow("imgWin", 0, 0, 370, 213);
        imgWin.attachURL("img_show.jsp?id=" + $(this).attr("id") + "&src=" + $(this).attr("src") + "&size=" + $(this).attr("size"));
        imgWin.setText($(this).attr("size") + "X" + $(this).attr("size") + " 图标预览&设置");
        imgWin.setModal(true);
        imgWin.button("minmax1").hide();
        imgWin.button("park").hide();
        imgWin.denyResize();
        imgWin.center();
    }

    //取消按钮
    function doClock(treeNode){
        var id=right_click_node.id; 
		if(id!="ROOT"){
			getFunDetail(id, treeNode,'doClock'); 
		}else{
	        $("#btnSave").attr("class","btn gray");
	        $("#btnClock").attr("class","btn gray");
	        $("#btnCancel").attr("class","btn gray");
			$("#btnCancel").attr("disabled",true);
	        $("#btnSave").attr("disabled",true);  
	        $("#btnClock").attr("disabled",true);
		}
    }

    //添加组织
    function addApp() {
    	$("#app_detail_table").show();



        //$("#tableForm").find('input').attr("readonly",false);
        //$(":input").not(":button").val("");
        $("#parent_name").val(right_click_node.name);
        $("#parent_id").val(right_click_node.id);


        $("#name").attr("readonly",false);
        $("#name").val("");
        $("#description").attr("readonly",false);
        $("#description").val("");
        $("#id").attr("readonly",false);
        $("#id").val("");
        $("#pri").attr("readonly",false);
        $("#pri").val("");
        $("#content").val("");

        $("#content").attr("readonly",false);

        
        $("#btnClock").attr("class","btn yellow");
        $("#btnCancel").attr("class","btn green");
        $("#btnSave").hide();
        $("#btnClock").show();
        $("#btnCancel").show();
        $("#btnCancel").attr("disabled",false);
        $("#btnSave").attr("disabled",false);  
        $("#btnClock").attr("disabled",false); 
        

        //$("btnAdd").attr("display","inline");

        $("#width").val("0");
        $("#height").val("0");
        $("#maximize").val("1");
        $("#target").val(right_click_node.target);
        $("#sts").val("1");
        $("#is_delete").val("1");
        $("#style").val("0");

        

      $("#style").attr("disabled",false);
      $("#style").closest(".rule-single-select").ruleSingleSelect();
      $("#sts").attr("disabled",false);
      $("#sts").closest(".rule-single-select").ruleSingleSelect();
      $("#target").attr("disabled",false);
      $("#target").closest(".rule-single-select").ruleSingleSelect();

      }

      //修改组织
      function writeApp(){

      $("#btnClock").attr("class","btn yellow");
      $("#btnSave").attr("class","btn green");
      $("#btnCancel").hide();
      $("#btnSave").show();
      $("#btnClock").show();

      $("#btnCancel").attr("disabled",false);
      $("#btnSave").attr("disabled",false);  
      $("#btnClock").attr("disabled",false); 
      

      $("#tableForm").find('input').attr("readonly",false);
      $("#style").attr("disabled",false);
      $("#style").closest(".rule-single-select").ruleSingleSelect();
      $("#sts").attr("disabled",false);
      $("#sts").closest(".rule-single-select").ruleSingleSelect();
      $("#target").attr("disabled",false);
      $("#target").closest(".rule-single-select").ruleSingleSelect();
      //$("#style1").attr("disabled",false);
      //$("btnReturn").attr("display","inline");
      }


    function deleteApp() {

        var head = { 
            "service_name": "cn.dy.system.service.MenuMemberService",
            "operation_name": "getChildNums",
            "token_id": loginInfo.token_id,
            "user_id": loginInfo.staff_id,
            "version": "0100",
            "timestamp": "",
            "request_seq": "",
            "request_source": ""
        }

        var param = {
            "fun_id": right_click_node.id
        }

        var options = {
            "handleError": true
        }

        var callBack = function (data, error) {
            if (error.response_code == 0) {
                if (data > 0) {
                    alert("有下级菜单，不允许删除！");
                    var delayFun = function () {
                        var changeAppWin = dhxWins.createWindow("deleteAppWin", 0, 0, 570, 180);
                        changeAppWin.attachURL("app_delete.jsp");
                        changeAppWin.setText("删除应用");
                        changeAppWin.setModal(true);
                        changeAppWin.button("minmax1").hide();
                        changeAppWin.button("park").hide();
                        changeAppWin.denyResize();
                        changeAppWin.center();
                    }
                    setTimeout(delayFun,1 );
                }
                else {
                    setTimeout(realDeleteApp,1);
                }
            }
            else {
                alert("获取当前应用子应用个数失败");
            }
        }


        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }

    //删除组织
    function realDeleteApp() {

        if (!confirm("确认要删除应用 [" + right_click_node.name + "] 吗？")) return false;

        var head = {
            "service_name": "cn.dy.system.service.MenuMemberService",
            "operation_name": "deleteFunction",
            "token_id": loginInfo.token_id,
            "user_id": loginInfo.staff_id,
            "version": "0100",
            "timestamp": "",
            "request_seq": "",
            "request_source": ""
        }

        var param = {
            "func_id": right_click_node.id
        }

        var options = {
            "handleError": true
        }

        function callBack(data, error) {
            //tree.deleteItem(right_click_node.id, true);
            initApp();
            var treeNode = zTree.getNodesByParam("id", right_click_node.id, null)[0];
            zTree.removeNode(treeNode, false);
            $("#app_detail_table").hide();

        }

        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }


    //添加应用
    function doAdd() {


    	if($("#name").val() =="应用树根节点"){
    		alert("应用标识重名");
    		$("#name").select();
    		 return false;
    	}


    if ($("#id").val().trim() == "") {
        alert("请输入应用标识！");
        $("#id").select();
        return false;
    }

    if ($("#name").val().trim() == "" ) {
        alert("请输入应用名称！");
        $("#name").select();
        return false;
    }



    if ($("#style").val() == "2" && $("#content").val() == "") {
        alert("请输入应用菜单地址！");
        $("#content").select();
        return false;
    }

    if ($("#pri").val() == "")$("#pri").val("1");

    var head = {
        "service_name": "cn.dy.system.service.MenuMemberService",
        "operation_name": "insertFunction",
        "token_id": loginInfo.token_id,
        "user_id": loginInfo.staff_id,
        "version": "0100",
        "timestamp": "",
        "request_seq": "",
        "request_source": ""
    }


    var param = {
        "function": {
        }
    }

    param.function = $.form("#tableForm").getJSON();

    delete param.function.parent_name;
    delete param.function.btn_save;
    delete param.function.btn_cancel;
    delete param.function.add_next;

    if (oper_type == "add") {
        head.operation_name = "insertFunction";
        delete param.old_fun_id;
    }



    var options = {
        "handleError": false
    }

    function callBack(data, error) {
        //alert("32322");
        

        alert(data.response_desc);

        //doClock();
        initApp();
        //if(data.response_desc != "应用标识重名"|| data.response_desc != "应用名称重名"){
        if (data.response_code == "0") {
            if (oper_type == "add") {
                var parentNode = zTree.getNodesByParam("id", right_click_node.id, null)[0];
                var node = {
                    id: param.function.id + "",
                    name: param.function.name,
                    dis_name: param.function.name,
                    parent_id: right_click_node.id,
                    is_delete: param.function.is_delete,
                    style: param.function.style,
                    isParent: false
                };
                parentNode.isParent = true;
                zTree.addNodes(parentNode, node, false);
                zTree.updateNode(parentNode);

                if ($("#add_next").attr("checked") == undefined) {
                    //doCancel();
                }
                else {
                    $.form("#operForm").get(0).reset();
                    $("#parent_id").val(right_click_node.id);
                    $("#parent_name").val(right_click_node.name);
                    $("#parent_name").attr("disabled", true);
                    $("#add_next").attr("checked", true);

                    //需要清空一下图片
                    var aItems = $("a >img[id*=img]");
                    for (var i = 0; i < aItems.size(); i++) {
                        var item = $(aItems[i]);
                        item.attr("src", "../style/images/app/nopic.jpg");
                    }
                }
            }
            else {
                var treeNode = zTree.getNodesByParam("id", $("#id").val(), null)[0];
                treeNode.name = param.function.name;
                treeNode.style = param.function.style;
                treeNode.dis_name = treeNode.name;
                if (param.function.sts == "0") {
                    treeNode.sts = "1";
                    treeNode.dis_name = "<font color=gray>" + treeNode.dis_name + "</font>";
                }
               zTree.updateNode(treeNode, false);
                //doCancel();
                }
        }
        else {
            //alert(error.response_desc);
        }


        }
   

    $.ServiceAgent.JSONInvoke(head, param, callBack, options);
}



    //移动应用
    function moveApp(srcNode, targetNode, moveType) {
        var oldParentNode = srcNode.getParentNode();
        var oldPreNode = srcNode.getPreNode();
        var oldNextNode = srcNode.getNextNode();

        var head = {
            "service_name": "cn.dy.system.service.MenuMemberService",
            "operation_name": "moveFunction",
            "token_id": loginInfo.token_id,
            "user_id": loginInfo.staff_id,
            "version": "0100",
            "timestamp": "",
            "request_seq": "",
            "request_source": ""
        }


        var param = {
            "src_fun_id": srcNode.id,
            "target_fun_id": targetNode.id,
            "moveType": moveType
        }


        var options = {
            "handleError": false
        }

        function callBack(data, error) {

            if (error.response_code == "0") {

                //var treeNode=zTree.getNodesByParam("id","GROUP_" + $("#id").val(), null)[0];
                //treeNode.name=$("#name").val();
                //zTree.updateNode(treeNode,false);
            }
            else {

                alert(error.response_desc);

                if (oldPreNode == null && oldNextNode == null)zTree.moveNode(oldParentNode, srcNode, "inner");
                else if (oldNextNode != null) {
                    zTree.moveNode(oldNextNode, srcNode, "prev");
                }
                else {
                    zTree.moveNode(oldPreNode, srcNode, "next");
                }
            }
        }


        $.ServiceAgent.JSONInvoke(head, param, callBack, options);

    }






    //保存应用修改
    function doSave() {

        if ($("#id").val().trim() == "") {
            alert("请输入应用标识！");
            $("#id").select();
            return false;
        }

        if ($("#name").val().trim() == "") {
            alert("请输入应用名称！");
            $("#name").select();
            return false;
        }

        if ($("#style").val() == "2" && $("#content").val() == "") {
            alert("请输入应用菜单地址！");
            $("#content").select();
            return false;
        }

        if ($("#pri").val() == "")$("#pri").val("1");

        var head = {
            "service_name": "cn.dy.system.service.MenuMemberService",
            "operation_name": "updateMenuMemberInfo",
            "token_id": loginInfo.token_id,
            "user_id": loginInfo.staff_id,
            "version": "0100",
            "timestamp": "",
            "request_seq": "",
            "request_source": ""
        }
        var param = {
            "fun_id": right_click_node.id,
            "func":  {
                
            }   
        }
       param.func = $.form("#tableForm").getJSON();

        delete param.func.parent_name;
        delete param.func.btn_save;

        var options = {
            "handleError": false
        }

        function callBack(data, error) {
            doClock();
            initApp();
            alert(data.response_desc);
            if (error.response_code == "0") {
                var treeNode = zTree.getNodesByParam("id", param.fun_id, null)[0];
                treeNode.name = $("#name").val();
                treeNode.dis_name = treeNode.name;
                treeNode.id = $("#id").val();
                right_click_node.id = treeNode.id;
                if (param.func.sts == "0") {
                    treeNode.sts = "0";
                    treeNode.dis_name = "<font color=gray>" + treeNode.dis_name + "</font>";
                }
                zTree.updateNode(treeNode, false);

                if (treeNode.children && treeNode.children.length > 0) {
                    for (var i = 0; i < treeNode.children.length; i++) {
                        var childNode = treeNode.children[i];
                        childNode.parent_id = treeNode.id;
                        zTree.updateNode(childNode, false);
                    }
                }
            }
            else {
                alert(error.response_desc);
            }
        }

        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }


    function showRMenu(treeNode, x, y) {
        var id = treeNode.id;
        var menuContent = "";


        menuContent += "<li><a href=\"#\" onclick=\"addApp();hideRMenu();\">添加下级菜单</a></li>";
        if (treeNode.id != "ROOT") {
            menuContent += "<li><a href=\"#\" onclick=\"writeApp();hideRMenu();\">修改菜单</a></li>";
        }
        if (treeNode.is_delete == "1") {
            menuContent += "<li><a href=\"#\" onclick=\"deleteApp();hideRMenu();\">删除菜单</a></li>";
        }

        $("#nodeMenuContent").html(menuContent);


        $("#nodeMenu").css({"top": y + "px", "left": x + "px"});
        $("#nodeMenu").show();


        var menuHeight = $("#nodeMenu").height();
        //alert($(document).height()+"||"+(menuHeight+y));
        var treeAreaPo = $("#treeParentArea").position().top + $("#treeParentArea").height();
        while (y + menuHeight > treeAreaPo) {
            y--;
        }

        $("#nodeMenu").css({"top": y + "px", "left": x + "px"});
        $("#nodeMenu").show();


        $("body").bind("mousedown", onBodyMouseDown);
        $("body").bind("blur", onBodyBlur);
        $("window").bind("blur", onBodyBlur);


        //alert($("#nodeMenuContent").html());
    }

    function hideRMenu() {
        $("#nodeMenu").hide();
        $("body").unbind("mousedown", onBodyMouseDown);
        $("body").unbind("blur", onBodyBlur);
        $("window").unbind("blur", onBodyBlur);
    }

    function onBodyBlur(tri_event) {


        setTimeout(hideRMenu, 300);
    }

    function onBodyMouseDown(tri_event) {
        if (!(tri_event.target.id == "nodeMenu" || $(tri_event.target).parents("#nodeMenu").length > 0)) {
            hideRMenu();
        }
    }


    var zTree = null;
    function createTree() {

        var head = {
            "service_name": "cn.dy.system.service.MenuMemberService",
            "operation_name": "getFunTree",
            "version": "0100",
            "timestamp": "",
            "request_seq": "",
            "request_source": ""
        }

        var param = {
            "all": true
        }

        var options = {
            "handleError": true
        }

        function callBack(data) {
            resizeTree();
            if (zTree != null)zTree.destroy();
            zTree = $.fn.zTree.init($("#tree"), setting, data);
            var rootNode = zTree.getNodes()[0];
            if (rootNode && rootNode.children && rootNode.children.length > 0) {
                var node = rootNode.children[0];
                if (node) {
                    zTree.selectNode(node, true);
                    zTree.cancelSelectedNode(node);
                }
            }
        }

        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }

    function dropPrev(treeId, nodes, targetNode) {
        if (targetNode.id == "ROOT")return false;//不能插入到根节点之前

        return true;
    }

    function dropNext(treeId, nodes, targetNode) {
        if (targetNode.id == "ROOT")return false;//不能插入到根节点之后
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
            beforeDrag: function (treeId, treeNodes) {
                if (treeNodes) {
                    var treeNode = treeNodes[0];
                    if (treeNode.getParentNode() == null)return false;
                }
                return true;
            },

            beforeDragOpen: function (treeId, treeNode) {
                return false;
            },

            beforeDrop: function (treeId, treeNodes, targetNode, moveType) {
                if (targetNode) {
                    moveApp(treeNodes[0], targetNode, moveType);
                    return true;
                }
                return false;
            },

            onDrop: function (event, treeId, treeNodes, targetNode, moveType) {
                if (targetNode) {
                    return true;
                }
                return false;
            },

            beforeClick: function (treeId, treeNode, clickFlag) {
                return true;
            },

            onClick: function (callEvent, treeId, treeNode, clickFlag) {
                if (treeNode)
                    onClickTree(treeNode);
                return true;
            },
            onRightClick: function (callEvent, treeId, treeNode) {
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

    function resize() {
        //dhxLayout.setSizes();

        if (typeof(combo) != "undefined") {
            var myFunc = function () {
                combo.setSize(10);
                combo.setSize($("#search_key").width());
                resizeTree();
            }

            setTimeout(myFunc, 10);
        }
    }

    function resizeTree() {
        //alert(navigator.userAgent);
        if ($.browser.msie) {
            if ($.browser.version == "10.0") {
                $("#treeParentArea").height($(document.body).height() - 23 - 45);
                $("#treeParentArea").width($("#search_key").width() * 10 / 7);
                $("#tree").height($("#treeParentArea").height() - 60);
                $("#tree").width($("#treeParentArea").width() - 20);
            }
            else {
                $("#treeParentArea").height($(document.body).height() - 23 - 62);
                $("#tree").height($("#treeParentArea").height() - 10);
            }
        }
        else {
            $("#treeParentArea").height($(document.body).height() - 23 - 40);
            $("#tree").height($("#treeParentArea").height() - 50);
        }

    }


    function adjustLayOut() {
        //alert($("#layout").width()+"||"+$("#layout").height());
        dhxLayout.setSizes();
    }

     //初始化控件应用
    function initApp(){

    	    $("#style").attr("disabled","disabled");
            $("#style").closest(".rule-single-select").ruleSingleSelect();
            $("#target").attr("disabled","disabled");
            $("#target").closest(".rule-single-select").ruleSingleSelect();
            $("#sts").attr("disabled","disabled");
            $("#sts").closest(".rule-single-select").ruleSingleSelect();

        $("#tableForm").find('input').attr("readonly",true);
        $("#introduction").attr("readonly",true);
        
        $("#btnCancel").attr("disabled",true);
        $("#btnSave").attr("disabled",true);  
        $("#btnClock").attr("disabled",true); 

        $("#btnSave").attr("class","btn gray");
        $("#btnClock").attr("class","btn gray");
        $("#btnCancel").attr("class","btn gray");
        
        $("#btnCancel").hide();
        $("#btnSave").show();
        $("#btnClock").show();
      
        
    }

    $(function () {

        //$(window).resize(resizeTree());

        document.title = "菜单管理";

        initApp();
        $.form("#operForm").maxlen("textarea");

        $("#operForm").find(":text").bind('keyup', function (event) {
            if (event.keyCode == "13") {
                doSave();
            }
        });

        $.form("#operForm").maxlen("textarea");
        $.form("#operForm").integerOnly("input[validation=integer]");

        $(window).bind("resize", resize);

        var aItems = $("a >img[id*=img]");
        for (var i = 0; i < aItems.size(); i++) {
            var item = $(aItems[i]);
            item.bind("click", doShowImg);
        }
        createTree();


    });

</script>
</html>
