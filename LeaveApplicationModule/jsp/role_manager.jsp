<%
  /**
   * title: 角色管理
   */
%>
    <%@ page language="java" contentType="text/html; charset=UTF-8"%>
        <%String func_id = "BUSINESS_TYPE";%>
            <html>

            <head>
                <title>角色管理</title>
                <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
                <link rel="stylesheet" href="../scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
                <script type="text/javascript" src="../scripts/zTree/js/jquery.ztree.all-3.5.min.js"></script>
                <script type="text/javascript" src="/xyzg/system/common/scripts/utils.js"></script>
                <script type="text/javascript" src="/xyzg/system/common/scripts/zDialog.js"></script>
                <style type="text/css">
                    #role ul li {
                        list-style: none;
                        font-size: 13px;
                        line-height: 25px;
                        text-align: right;
                        padding-right: 20px;
                        //color:black;
                        font-weight: bolder;
                    }
                    
                    #role ul li:hover {
                        background: linear-gradient(#FFFFFF, #f4f4f4, #e6e6e6);
                        cursor: pointer;
                        color: green;
                    }
                    
                    .role_info_td_select {
                        color: #f00;
                        font-weight: bolder;
                        background: linear-gradient(to right, #FFFFFF, #A2B5CD);
                        cursor: pointer;
                    }
                    
                    .role_info_td_select:after {
                        display: inline-block;
                        margin-right: 3px;
                        margin-top: 2px;
                        text-indent: -999em;
                        //background: url(skin_icons_1.png) no-repeat;
                        vertical-align: middle;
                        border: 10px solid transparent;
                        border-left: 10px solid #f00;
                        width: 0;
                        height: 0;
                        position: absolute;
                        content: ' '
                    }
                    
                    .role_info_td {
                        list-style: none;
                        font-size: 14px;
                        line-height: 40px;
                        text-align: center;
                        color: black;
                    }
                    
                    .checkall {
                        position: fixed;
                        bottom: 65px;
                        right: 20px;
                    }
                    /*
		#tree_1_ul  添加了角色管理中内部滚动条
		*/
                    
                    #tree_1_ul {
                        overflow: auto;
                        position: relative;
                        height: 85%;
                    }
                </style>
                <script type="text/javascript">
                    //页面加载时调用方法
                    $(function() {
                        if (!loginInfo.staff_id) {
                            alert("请先登录再操作");
                            window.location.href = "${home}/index.jsp";
                        }

                        //初始化角色人员列表	
                        query();
                        init();
                        $('.del').removeAttr('onclick');
                        $('.update').removeAttr('onclick');
                        $('.updateAuth').removeAttr('onclick');
                        $('.query').removeAttr('onclick');
                        $(".del").attr("onclick", "choose();");
                        $(".update").attr("onclick", "choose();");
                        $(".updateAuth").attr("onclick", "choose();");
                        $(".query").attr("onclick", "choose();");
                        $("#allAuth").attr({
                            "disabled": "disabled"
                        });

                    });

                    function init() {
                        //$(".page-footer").hide();	
                        //初始化树
                        createTree();
                        $("#allAuth").attr('checked', false);
                        $("#save1").attr({
                            "disabled": "disabled"
                        });
                        $("#cancal1").attr({
                            "disabled": "disabled"
                        });
                        $("#save1").attr("class", "btn gray");
                        $("#cancal1").attr("class", "btn gray");
                        //$("input:checkbox").attr("disabled","disabled") //禁用
                    }

                    function choose() {
                        if (confirm("请先选择一个角色？")) {}
                    }
                    var dhxLayout;
                    var tree;
                    var tree_context_menu;
                    var right_click_node = new Array();

                    var head = {
                        "service_name": "cn.dy.system.service.MenuMemberService",
                        "operation_name": "getFunTree",
                        "token_id": loginInfo.token_id,
                        "user_id": loginInfo.staff_id,
                        "version": "0100",
                        "timestamp": "",
                        "request_seq": "",
                        "request_source": ""
                    }

                    var param = {
                        "all": false
                    }

                    var options = {
                        "handleError": true
                    }

                    var setting = {
                        check: {
                            enable: true,
                            chkStyle: "checkbox",
                            chkboxType: {
                                "Y": "ps",
                                "N": "ps"
                            },
                            chkDisabled: false
                                //chkDisabledInherit: false
                        },
                        edit: {
                            enable: true,
                            showRemoveBtn: false,
                            showRenameBtn: false,
                            drag: {
                                isCopy: false,
                                isMove: false,
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
                            }
                        },
                        callback: {
                            beforeClick: function(treeId, treeNode, clickFlag) {
                                if (treeNode && treeNode.i == "0") return false;
                                return true;
                            },
                            onCheck: function(callEvent, treeId, treeNode) {

                                //onClickTree(treeNode);
                                return true;
                            },
                            onClick: function(callEvent, treeId, treeNode, clickFlag) {
                                //  if (treeNode)
                                //               onClickTree(treeNode);
                                return true;
                            },
                            beforeDrag: function(treeId, treeNodes) {
                                if (treeNodes) {
                                    var treeNode = treeNodes[0];
                                    if (treeNode.id == "0") return false;
                                    else return true;
                                }
                                return false;
                            },
                            beforeDragOpen: function(treeId, treeNode) {
                                return false;
                            },
                            beforeDrop: function(treeId, treeNodes, targetNode, moveType) {
                                return false;
                            },
                            onDrop: function(event, treeId, treeNodes, targetNode, moveType) {
                                if (targetNode) {
                                    return true;
                                }
                                return false;
                            }
                        },
                        view: {
                            nameIsHTML: true,
                            showTitle: false,
                            selectedMulti: false
                        }
                    };

                    var zTree = null;
                    var auth = null;
                    var rootNode = null;

                    function createTree() {
                        function callBack(data) {
                            //alert($.JsonUtil.jso2json(data));
                            //resizeTree();
                            if (zTree != null) zTree.destroy();
                            zTree = $.fn.zTree.init($("#tree"), setting, data);
                            rootNode = zTree.getNodes()[0];
                            zTree.updateNode(rootNode);
                            zTree.expandNode(rootNode, true, false, false, false);

                            //var treeObj = $.fn.zTree.getZTreeObj("tree");
                            /**  var abiz_id = parent.$("#biz_id").val().split(",");
        for (var i = 0; i < abiz_id.length;i++) {
        	var nodes = treeObj.getNodesByParam("id", abiz_id[i], null);
        	treeObj.checkNode(nodes[0], true, true);
        }
        **/
                            /**var treeNode = treeObj.getNodes();
        for(var i =0;i<treeNode[0].children.length;i++){
        		if(treeNode[0].children[i].children==null)
        			treeObj.removeNode(treeNode[0].children[i],false);
        	}
				treeObj = $.fn.zTree.getZTreeObj("tree");
				var nodes = treeObj.getNodes();
				for (var i = 0; i < nodes.length;i++) {
					for(var j =0;j<nodes[i].children.length;j++)
						for(var h =0;h<nodes[i].children[j].children.length;h++)
							for(var m =0;m<nodes[i].children[j].children[h].children.length;m++)
								for(var k =0 ;k<abiz_id.length;k++)
									if(nodes[i].children[j].children[h].children[m].id == abiz_id[k])
									//	treeObj.selectNode(nodes[i].children[j].children[h].children[m],true);
									treeObj.checkNode(nodes[i].children[j].children[h].children[m], true, true);
				}
				var se_nodes = treeObj.getSelectedNodes();
				for (var i=0, l=se_nodes.length; i < l; i++) {
					treeObj.checkNode(se_nodes[i], true, true);
				}
				
         var selectNodes = function (childs) {    	
            for (var i = 0; i < childs.length; i++) {
                var node = childs[i];
                if ((node.getParentNode() == rootNode || node.getParentNode().i == "0") && node.i == "1") {
                    zTree.selectNode(node, true);
                    zTree.cancelSelectedNode(node);
                    continue;
                }
                selectNodes(node.children);
            }
        }
        if (rootNode.children)
            selectNodes(rootNode.children); **/
                        }
                        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                    }

                    function chooseNode(treeNode) {

                    }

                    function showRMenu(treeNode, x, y) {
                        return false;
                    }

                    function hideRMenu() {
                        return false;
                    }

                    function dropPrev(treeId, nodes, targetNode) {
                        return false;
                    }

                    function dropNext(treeId, nodes, targetNode) {
                        return false;
                    }

                    function dropInner(treeId, nodes, targetNode) {
                        return false;
                    }

                    //查询角色列表	 
                    function query() {
                        var head = {
                            "service_name": "cn.dy.system.service.RoleManagerService",
                            "operation_name": "queryRole"
                        }

                        var param = {}

                        var options = {
                            "handleError": false,
                            "showProgressBar": false,
                            "timeout": 60000 * 10
                        }

                        function callBack(result) {
                            var roleList = result.content.list;
                            $.each(roleList, function(index) {
                                $("#role").append("<ul><li class='lili'  id=\"" + roleList[index].id + "\" a=\"" + roleList[index].name + "\" b=\"" + roleList[index].description + "\" c=\"" + roleList[index].can_update + "\" d=\"" + roleList[index].corp_id + "\" onclick='get(this);'>" + roleList[index].name + "</li></ul>");
                            });

                        }
                        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                    }

                    //查询菜单权限，渲染树节点
                    var roleId;
                    var roleName;
                    var roleDescription;
                    var roleCan_update;
                    var roleCorp_id;

                    function get(obj) {
                        $(".del").attr("onclick", "ShowDelAction();");
                        $(".update").attr("onclick", "ShowEditAction();");
                        $(".updateAuth").attr("onclick", "editAuth1();");
                        $(".query").attr("onclick", "queryStaffRole();");
                        $("#allAuth").attr('checked', false);
                        $("#allAuth").attr('checked', false);
                        $("#save1").attr({
                            "disabled": "disabled"
                        });
                        $("#cancal1").attr({
                            "disabled": "disabled"
                        });
                        $("#save1").attr("class", "btn gray");
                        $("#cancal1").attr("class", "btn gray");

                        clearBackGround();
                        obj.className = "role_info_td_select";
                        roleId = obj.id;
                        //alert(roleId);
                        roleName = $(obj).attr("a");
                        roleDescription = $(obj).attr("b");
                        roleCan_update = $(obj).attr("c");
                        //alert(roleCan_update);
                        roleCorp_id = $(obj).attr("d");
                        //alert(roleCorp_id);
                        if (roleCan_update == "N" || roleCan_update == null || roleCan_update == "") {
                            //alert("此条数据不可修改！");
                            $('.del').removeAttr('onclick');
                            $('.update').removeAttr('onclick');
                        }
                        var head = {
                            "service_name": "cn.dy.system.service.RoleManagerService",
                            "operation_name": "queryAuthority",
                        }

                        var param = {
                            id: roleId

                        }
                        var options = {
                            "handleError": false,
                            "showProgressBar": false,
                            "timeout": 60000 * 10
                        }

                        function callBack(data) {
                            zTree.expandNode(rootNode, true, true, true, true);
                            var treeObj = $.fn.zTree.getZTreeObj("tree");
                            treeObj.checkAllNodes(false);
                            var abiz_id = data.content.list;
                            if (abiz_id == "ALL") {
                                treeObj.checkAllNodes(true);
                                $("#allAuth").attr('checked', true);
                            } else {
                                $("#allAuth").attr('checked', false);
                                for (var i = 0; i < abiz_id.length; i++) {
                                    var nodes = treeObj.getNodesByParam("id", abiz_id[i], null);
                                    if (nodes[0] != undefined) {
                                        treeObj.checkNode(nodes[0], true);
                                    }
                                }
                            }
                            $("#tree span[id$='check']").removeAttr("treenode_check");
                        }
                        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                    }

                    //添加角色	
                    /*function ShowSaveAction1(){
                        if (roleCan_update=="N" || roleCan_update==null || roleCan_update==""){
                    		alert("无此权限！该权限归平台管理员所有！");
                    		window.location.href="role_manager.jsp";
                    	}else{
                    		ShowSaveAction();
                    	}
                    }*/
                    var diag;

                    function ShowSaveAction() {
                        //("提示：你点击了一个按钮");
                        //Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
                        diag = new Dialog();
                        diag.Width = 900;
                        diag.Height = 400;
                        diag.Title = "";
                        diag.URL = "add_role.jsp";
                        diag.ShowMessageRow = false;
                        /*diag.OKEvent = function(){
				};*/ //点击确定后调用的方法
                        //diag.OKEvent = function(){Dialog.alert("用户名不能为空")};
                        diag.show();
                    }

                    //删除角色	  
                    function ShowDelAction() {
                        //("提示：你点击了一个按钮");
                        //Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
                        diag = new Dialog();
                        diag.Width = 900;
                        diag.Height = 400;
                        diag.Title = "";
                        diag.URL = "del_role.jsp";
                        diag.ShowMessageRow = false;
                        /*diag.OKEvent = function(){
				};*/ //点击确定后调用的方法
                        //diag.OKEvent = function(){Dialog.alert("用户名不能为空")};
                        if ($('#role .role_info_td_select').length > 0)
                            diag.show();
                        else
                        if (confirm("请先选择一个角色？")) {};
                    }

                    //修改角色	  
                    function ShowEditAction() {
                        //("提示：你点击了一个按钮");
                        //Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
                        diag = new Dialog();
                        diag.Width = 900;
                        diag.Height = 400;
                        diag.Title = "";
                        diag.URL = "edit_role.jsp";
                        diag.ShowMessageRow = false;
                        /*diag.OKEvent = function(){
				};*/ //点击确定后调用的方法
                        //diag.OKEvent = function(){Dialog.alert("用户名不能为空")};
                        if ($('#role .role_info_td_select').length > 0)
                            diag.show();
                        else
                        if (confirm("请先选择一个角色？")) {};
                    }

                    //修改权限
                    /*function editAuth1(){
                        if (roleCan_update=="N" ||  roleCan_update==null || roleCan_update==""){
                    		alert("无此权限！该权限归平台管理员所有！");
                    		window.location.href="role_manager.jsp";
                    	}else{
                    		$(".page-footer").show();
                    		alert("请选择一个角色：");
                    		$(".lili").bind("click",function(){
                    			$(".btn green").bind("click",function(){
                    				editAuth();
                    			});                 	
                    		});	
                    	}
                    }*/
                    function editAuth1() {
                        $("#tree span[id$='check']").attr("treenode_check", ""); //取name以test结束的所有span
                        $("#save1").removeAttr("disabled");
                        $("#cancal1").removeAttr("disabled");
                        $("#allAuth").removeAttr("disabled"); //启用
                        $("#save1").attr("class", "btn green");
                        $("#cancal1").attr("class", "btn yellow");
                        $('#save').css('background-color', '#2db472');
                        $('#cancal').css('background-color', '#c37f12');

                    }

                    function editAuth() {
                        zTree.expandNode(rootNode, true, true, true, true);
                        //var treeObj = $.fn.zTree.getZTreeObj("tree");
                        //treeObj.checkAllNodes(false);
                        var nodes = null;
                        if (true) nodes = zTree.getCheckedNodes(true);
                        else nodes = zTree.getSelectedNodes();
                        var check_ids = [];
                        for (var i = 0; i < nodes.length; i++) {
                            check_ids.push(nodes[i].id);
                        }
                        var head = {
                            "service_name": "cn.dy.system.service.RoleManagerService",
                            "operation_name": "setRoleFunction"
                        }

                        var param = {
                            "id": roleId,
                            "functions": check_ids

                        }

                        var options = {
                            "handleError": false,
                            "showProgressBar": false,
                            "timeout": 60000 * 10
                        }

                        function callBack(result) {
                            alert("修改权限成功！");
                            $("#allAuth").attr('checked', false);
                            $("#save1").attr({
                                "disabled": "disabled"
                            });
                            $("#cancal1").attr({
                                "disabled": "disabled"
                            });
                            $("#save1").attr("class", "btn gray");
                            $("#cancal1").attr("class", "btn gray");
                        }
                        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                    }

                    function unsave() {
                        //$(".page-footer").hide();
                        $("#tree span[id$='check']").removeAttr("treenode_check"); //去除多选框点击
                        init();
                    }

                    //选中所有权限
                    function checkAllauth1() {
                        if (confirm("您确定要修改权限吗？")) {
                            zTree.expandNode(rootNode, true, true, true, true);
                            var treeObj = $.fn.zTree.getZTreeObj("tree");
                            var nodes = null;
                            var allAuth = null;
                            if ($("input[type='checkbox']").is(':checked') == true) {
                                nodes = treeObj.checkAllNodes(true);
                                $("#allAuth").val("ALL");

                            } else {
                                nodes = treeObj.checkAllNodes(false);
                                $("#allAuth").val("");
                            }
                            checkAllauth();
                        } else {
                            init();
                        }
                    };

                    function checkAllauth() {
                        var head = {
                            "service_name": "cn.dy.system.service.RoleManagerService",
                            "operation_name": "addAllRoleAuthority"
                        }

                        var param = {
                            "id": roleId,
                            "func_id": $("#allAuth").val()
                        }

                        var options = {
                            "handleError": false,
                            "showProgressBar": false,
                            "timeout": 60000 * 10
                        }

                        function callBack(result) {
                            if (result.response_code == 0) {
                                alert(result.response_desc);
                                //init();
                            } else {
                                alert(result.response_detail);
                                //init();
                            }
                        }
                        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                    }

                    //查询人员清单		
                    function queryStaffRole() {
                        //$(".page-footer").hide();
                        diag = new Dialog();
                        diag.Width = 900;
                        diag.Height = 600;
                        diag.Title = "";
                        diag.URL = "staffrole.jsp";
                        diag.ShowMessageRow = false;
                        /*diag.OKEvent = function(){
		diag.close();
	};*/ //点击确定后调用的方法
                        //diag.OKEvent = function(){Dialog.alert("用户名不能为空")};
                        if ($('#role .role_info_td_select').length > 0)
                            diag.show();
                        else
                        if (confirm("请先选择一个角色？")) {};
                    }

                    function clearBackGround() {
                        //$(".role_info_td_select").className= "role_info_td";
                        $("#role").find("li[class=role_info_td_select]").attr("class", "role_info_td");
                    }
                </script>
            </head>

            <body class="mainbody">
                <!--<div class="location">
			<a href="javascript:;" class="home"><i></i><span>角色管理</span> </a>
		</div>-->
                <!-- 操作栏 -->
                <div class="toolbar-wrap" style="margin-top:-10px;">

                    <div id="floatHead" class="toolbar">
                        <div class="l-list">
                            <ul class="icon-list">
                                <li>
                                    <a class="add" onclick="ShowSaveAction();"><i></i><span>添加角色</span>
							</a>
                                </li>
                                <li>
                                    <a onclick=" ShowDelAction();" id="btnDelete" class="del"><i></i><span>删除角色</span>
							</a>
                                </li>
                                <li>
                                    <a class="update" onclick="ShowEditAction();"><i></i><span>修改角色</span>
							</a>
                                </li>
                                <li>
                                    <a class="updateAuth" onclick="editAuth1();"><i></i><span>修改权限</span>
							</a>
                                </li>
                                <li>
                                    <a class="query" onclick="queryStaffRole();"><i></i><span>查询人员清单</span>
							</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div id="tree_area" style="width: 100%; height: 100%;;background: #FFFFFF;">
                    <div id="role" style="width: 20%; float: left; ; height: 100%;background: #eeeeee;border: 1px solid #e1e1e1;">
                        <div class="title">
                            角色列表
                        </div>
                    </div>
                    <div valign=top style="width: 79%; float: right;; height: 100%;background: #eeeeee;border: 1px solid #e1e1e1;">
                        <div class="title">
                            功能菜单列表
                        </div>
                        <div id="treeParentArea" valign=top style="overflow: auto;">
                            <ul id="tree" class="ztree" style="margin: 0px;"></ul>
                        </div>
                        <!--<div class="checkall" style="vertical-align: middle;"><input
				id="allAuth" type="checkbox" value="" onclick="checkAllauth1();"
					name="allAuth" /><span style="font-size: 12px;">拥有全部权限</span>
				</div>-->
                        <!--工具栏-->
                        <div class="page-footer" style="text-align: center">
                            <div class="btn-list">
                                <input type="button" onclick="editAuth();" id="save1" name="btnReturn" value="保存" class="btn green" />
                                <input type="button" name="btnReturn" value="取消" class="btn yellow" id="cancal1" onclick="unsave();" />
                            </div>
                            <div class="clear"></div>
                        </div>
                    </div>
                </div>

            </body>

            </html>