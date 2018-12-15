<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
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
                filter: progid: DXImageTransform.Microsoft.gradient(startColorstr='#ff0088cc', endColorstr='#ff0077b3', GradientType=0);
            }
            
             ::-webkit-scrollbar {
                width: 25px;
            }
            
             ::-webkit-scrollbar-track {
                background-color: #eeeeee;
            }
            
             ::-webkit-scrollbar-thumb {
                background-color: #eeeeee;
            }
            
             ::-webkit-scrollbar-thumb:hover {
                background-color: #999999
            }
            
             ::-webkit-scrollbar-thumb:active {
                background-color: #999999
            }
            
            .page-footer .btn-list {
                padding: 1px 0;
            }
        </style>

        <link rel="stylesheet" href="../scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
        <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
        <script type="text/javascript" src="../scripts/zTree/js/jquery.ztree.all-3.5.min.js"></script>
        <!--  <script type="text/javascript"
	src="/zhcy/system/common/scripts/zDialog.js"></script>-->
        <script type="text/javascript">
            var diag;
            var tree;
            var tree_context_menu;
            var top_menu;

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
                        $("#app_detail_table").show();

                        getStaffDetail(cutId, treeNode);
                    } else {

                        $.form("#tableForm").sleep();
                        $("#treeParentArea").show();
                        $("#app_detail_table").show();

                        getFunDetail(id, treeNode);
                    }
                } else {
                    $("#app_detail_table").hide();
                }

            }

            function getRole() {
                var head = {
                    "service_name": "cn.dy.system.service.ContactInfoService",
                    "operation_name": "getAllRole",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "flag": true
                }

                var options = {
                    "handleError": true,
                    "showProgressBar": false
                }

                function callBack(data) {
                    var roleName;
                    var roleId;
                    var htmlMsg;
                    var index = 1;
                    if (data != null) {
                        for (var i = 0; i < data.length; i++) {
                            roleName = data[i][1];
                            roleId = data[i][0];
                            if (roleId != 3 && roleId != 4) {
                                htmlMsg = "<input type='checkbox' id='role_id" + roleId + "' name='role_id' value='" + roleId + "'/>" +
                                    roleName + "&nbsp&nbsp&nbsp";
                                if (index % 6 == 0) {
                                    htmlMsg = htmlMsg + "</br>";
                                }
                                $("#roleChk").append(htmlMsg);
                            }
                            index++;
                        }

                    }
                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);

            }
            //获取人员详情
            function getStaffDetail(staff_id, treeNode) {
                var head = {
                    "service_name": "cn.dy.system.service.ContactInfoService",
                    "operation_name": "getStaffRoleHole",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "id": staff_id
                }

                var options = {
                    "handleError": true,
                    "showProgressBar": false
                }

                function callBack(data) {
                    openApp();
                    $.form("#contactForm").clear();
                    console.log("disabled");
                    $("#contactForm").find('input').attr("readonly", true);
                    // $("#contactForm").find('input').attr("disabled", true);
                    var role = new Array();
                    data.eci_sts = "" + data.eci_sts;
                    //$.form("#contactForm").setJSON(data);
                    var sex = data.eci_gender;
                    role = data.role_id;
                    $("#eci_password").val(data.eci_password);
                    $("#hidPwd").val(data.eci_password);
                    $("#eci_cpassword").val(data.eci_password);
                    $("#group_name").val(right_click_node.parent_name);
                    $("#eci_contact_nbr").val(data.eci_contact_nbr);
                    $("#eci_staff_account").val(data.eci_staff_account);
                    $("#eci_email").val(data.eci_email);
                    $("#ech_group_id").val(data.ech_group_id);
                    $("#eci_staff_id").val(data.eci_staff_id);
                    $("#ecg_corp_id").val(data.ecg_corp_id);
                    $("#eci_sts").val(data.eci_sts);
                    $("#eci_sts").closest(".rule-single-select").ruleSingleSelect();
                    //显示性别
                    $("input[name='eci_gender'][value=" + sex + "]").attr({
                        "checked": true,
                        "disabled": true
                    });
                    // $("#eci_gender").attr("disabled", true);
                    //显示权限
                    $("input[name='role_id']").attr("checked", false); //清空复选框
                    if (role != null) {
                        for (var i = 0; i < role.length; i++) {
                            $("input[name='role_id'][value=" + role[i] + "]").attr(
                                "checked", true);
                        }
                    }

                    $.form("#contactForm").wakeup();
                    $("input[name='role_id']").attr("disabled", true);
                    $("#group_name").attr("disabled", true);
                    $("input[id*=img][type=hidden]").each(function() {
                        var idAttr = $(this).attr("id");
                        var srcValue = $(this).val();
                        if (srcValue == null)
                            srcValue = "";
                        if (srcValue != "" && srcValue.indexOf("/") != 0) {
                            srcValue = "../" + srcValue;
                        }

                        if (srcValue == "")
                            srcValue = "../style/images/app/nopic.jpg";
                        $("#" + idAttr + "_img").attr("src", srcValue);
                    });
                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);

            }

            //获取组织详情
            function getFunDetail(group_id, treeNode) {
                var head = {
                    "service_name": "cn.dy.system.service.ContactGroupService",
                    "operation_name": "getContactGroupDetail",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "id": group_id
                }

                var options = {
                    "handleError": true,
                    "showProgressBar": false
                }

                function callBack(data) {
                    initApp();

                    $.form("#tableForm").clear();
                    $("#strata").val(data.strata);
                    $("#strata").closest(".rule-single-select").ruleSingleSelect();

                    data.sts = "" + data.sts;

                    $.form("#tableForm").setJSON(data);
                    $("#parent_name").val(right_click_node.parent_name);
                    $.form("#operForm").wakeup();
                    $("#parent_name").attr("disabled", true);

                    $("input[id*=img][type=hidden]").each(function() {
                        var idAttr = $(this).attr("id");
                        var srcValue = $(this).val();
                        if (srcValue == null)
                            srcValue = "";
                        if (srcValue != "" && srcValue.indexOf("/") != 0) {
                            srcValue = "../" + srcValue;
                        }

                        if (srcValue == "")
                            srcValue = "../style/images/app/nopic.jpg";
                        $("#" + idAttr + "_img").attr("src", srcValue);
                    });
                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);
            }

            //  显示预览图标
            //  function doShowImg() {
            //       var imgWin = dhxWins.createWindow("imgWin", 0, 0, 370, 213);
            //       imgWin.attachURL("img_show.jsp?id=" + $(this).attr("id") + "&src=" + $(this).attr("src") + "&size=" + $(this).attr("size"));
            //        imgWin.setText($(this).attr("size") + "X" + $(this).attr("size") + " 图标预览&设置");
            //        imgWin.setModal(true);
            //        imgWin.button("minmax1").hide();
            //        imgWin.button("park").hide();
            //        imgWin.denyResize();
            //        imgWin.center();
            //    }


            //取消
            function cancelApp(treeNode) {
                var id = right_click_node.id.toString();
                var cutStr = id.substring(0, 1);
                var cutId = id.substring(1);
                if (id == 101) {
                    initApp();
                    $("#app_detail_table").hide();
                } else if (cutStr == "c") {

                    getStaffDetail(cutId, treeNode);
                } else {
                    getFunDetail(id, treeNode);
                }

            }
            //添加
            function addApp() {
                var id = right_click_node.id.toString();
                var cutStr = id.substring(0, 1);
                var cutId = id.substring(1);
                $("#app_detail_table").show();
                if (cutStr == "c") {
                    $("#contactForm").find('input').attr("readonly", false);

                    //$("#eci_sts").attr("readonly",false);
                    $("#eci_sts").val("1");
                    $("#eci_sts").closest(".rule-single-select").ruleSingleSelect();
                    $("#eci_staff_id").val("");
                    $("#eci_contact_nbr").val("");
                    $("#eci_password").val("");
                    $("#eci_cpassword").val("");
                    $("#eci_staff_account").val("");
                    $("#eci_sts").closest(".rule-single-select").ruleSingleSelect();
                    $("input[name='eci_gender']").attr("checked", false);
                    $("input[name='role_id']").attr("checked", false);
                    $("btnSave2").attr("disable", false);
                    $("#btnCancel").attr("disabled", false);
                    $("#btnSave2").show();
                    $("#btnSave2").attr("class", "btn green");
                    $("#btnCancel").attr("class", "btn yellow");
                    $("#btnSave").hide();
                } else {
                    $("#tableForm").find('input').attr("readonly", false);
                    $("#name").val("");
                    $("#strata").attr("disabled", false);
                    $("#strata").closest(".rule-single-select").ruleSingleSelect();
                    $("#introduction").val("");
                    $("#introduction").attr("readonly", false);
                    $("#address").val("");
                    $("#postcode").val("");
                    $("#phone").val("");
                    $("#fax").val("");
                    $("#contact").val("");
                    $("#btnSave").attr("disabled", false);
                    $("#btnCancel").attr("disabled", false);
                    $("#id").val("0");
                    $("#parent_name").val(right_click_node.name);
                    $("#parent_id").val(right_click_node.id);
                    $("#btnSave").show();
                    $("#btnSave").attr("class", "btn green");
                    $("#btnSave2").hide();
                    $("#btnCancel").attr("class", "btn yellow");
                }
            }

            //添加人员  
            function contactApp() {
                $("#tableForm").css("display", "none");
                $("#contactForm").css("display", "block");
                $("#contactForm").find('input').attr("readonly", false);
                $("#eci_contact_nbr").val("");
                $("#eci_password").val("");
                $("#eci_cpassword").val("");
                $("#eci_staff_id").val("");
                $("#eci_staff_account").val("");
                $("#eci_email").val("");
                //$("input[name=eci_gender]").attr("checked", false);
                $("input[name='eci_gender'][value='1']").attr("checked", true);
                $("input[name='role_id']").attr("checked", false);
                $("#btnCancel").attr("disabled", false);
                $("#btnSave2").attr("disabled", false);
                $("#btnSave2").show();
                $("#btnSave").hide();
                $("#btnSave2").attr("class", "btn green");
                $("#btnCancel").attr("class", "btn yellow");
                $("#group_name").val(right_click_node.name);
                $("#ech_group_id").val(right_click_node.id);
            }

            //修改部门
            function changeApp() {
                var id = right_click_node.id.toString();
                var cutStr = id.substring(0, 1);
                var cutId = id.substring(1);
                if (cutStr == "c") {
                    $("#contactForm").find('input').attr("readonly", false);
                    $("#eci_sts").attr("readonly", false);
                    $("#eci_sts").closest(".rule-single-select").ruleSingleSelect();
                    $("#btnSave2").show();
                    $("#btnSave2").removeAttr("disabled");
                    $("#btnSave2").attr("class", "btn green");
                    $("#btnSave").hide();
                    $("#btnCancel").attr("disabled", false);
                    $("#btnCancel").attr("class", "btn yellow");
                    $("input[name='role_id']").attr("disabled", false);
                    // console.log("修改人员");
                    // $("#eci_gender").attr("disabled",
                    //     false);
                } else {
                    $("#tableForm").find('input').attr("readonly", false);
                    $("#introduction").attr("readonly", false);
                    $("#strata").attr("disabled", false);
                    $("#strata").closest(".rule-single-select").ruleSingleSelect();
                    $("#btnSave").show();
                    $("#btnSave2").hide();
                    $("#btnSave").attr("disabled", false);
                    $("#btnCancel").attr("disabled", false);
                    $("#btnSave").attr("class", "btn green");
                    $("#btnCancel").attr("class", "btn yellow");
                }
            }

            function deleteApp() {

                var head = {
                    "service_name": "cn.dy.system.service.ContactGroupService",
                    "operation_name": "getChildNubs",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "id": right_click_node.id
                }

                var options = {
                    "handleError": true
                }

                function callBack(data, error) {

                    var id = right_click_node.id.toString();
                    var cutStr = id.substring(0, 1);

                    if (data <= 0) {
                        if (cutStr == "c") {
                            realDelectStaffApp();
                            openApp();
                        } else {
                            realDeleteApp();
                            initApp();

                        }
                    } else {
                        alert("该目录下存其他部门或人员，不允许被删除");
                    }

                }
                $.ServiceAgent.JSONInvoke(head, param, callBack, options);
            }

            //删除组织
            function realDeleteApp() {

                if (!confirm("确认要删除部门 [" + right_click_node.name + "] 吗？"))
                    return false;

                var head = {
                    "service_name": "cn.dy.system.service.ContactGroupService",
                    "operation_name": "deleteContactGroup",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "id": right_click_node.id
                }

                var options = {
                    "handleError": true
                }

                function callBack(data, error) {
                    //tree.deleteItem(right_click_node.id, true);
                    var treeNode = zTree.getNodesByParam("id", right_click_node.id,
                        null)[0];
                    zTree.removeNode(treeNode, false);
                    $("#app_detail_table").hide();

                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);
            }

            //删除人员详情
            function realDelectStaffApp() {
                if (!confirm("确认要删除人员 [" + right_click_node.name + "] 吗？"))
                    return false;

                var head = {
                    "service_name": "cn.dy.system.service.ContactInfoService",
                    "operation_name": "delStaffRoleContact",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "id": right_click_node.id
                }

                var options = {
                    "handleError": true
                }

                function callBack(data, error) {
                    var treeNode = zTree.getNodesByParam("id", right_click_node.id,
                        null)[0];
                    zTree.removeNode(treeNode, false);
                    $("#app_detail_table").hide();

                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);

            }

            function CheckPwd(Pwd) {
                var check_pwd = "(?=^[0-9a-zA-Z]{6,}$)(?=(?:.*?[0-9]){1,})(?=(?:.*?[a-z]){1,})(?=(?:.*?[A-Z]){1,})";
                var reg = /^[A-Za-z0-9_-]{6,18}$/;
                if (check_pwd != "") {
                    reg = new RegExp(check_pwd);
                }
                return reg.test(Pwd);

            }

            function StaffSave() {

                var regPhone = /^1[3|4|5|7|8][0-9]\d{8}$/; //手机判断
                var regPwd = /^[A-Za-z0-9_-]{6,18}$/; //密码限制
                var regEmail = /^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$/; //邮箱限制


                if ($("#eci_contact_nbr").val().trim() == "" ||
                    !regPhone.test($("#eci_contact_nbr").val().trim())) {
                    alert("请输入正确的手机号码");
                    $("#eci_contact_nbr").select();
                    return;
                }

                if ($("#eci_password").val() != $("#hidPwd").val() ||
                    $("#eci_password").val().trim() == "") {
                    if (CheckPwd($("#eci_password").val()) == false) {
                        alert("密码必须包含一个大写字母一个小写字母和一个数字，密码长度不能少于6位");
                        return;
                    }

                    if ($("#eci_cpassword").val().trim() == "" ||
                        $("#eci_password").val() != $("#eci_cpassword").val()) {
                        alert("两次输入的密码不一致！");
                        $("#eci_cpassword").select();
                        return;
                    }
                }

                if ($("#eci_staff_account").val().trim() == "") {
                    alert("请填写你的姓名");
                    $("#eci_staff_account").select();
                    return;
                }

                var str = "";
                $("[name='role_id']:checked").each(function() {
                    str += $(this).val();
                });
                if (str == "") {
                    alert("请选择至少一个角色");
                    return;
                }

                if ($("#eci_email").val().trim() != "" &&
                    regEmail.test($("#eci_email").val())) {
                    alert("邮箱格式不正确");
                    return;
                }

                //	$("input[name='eci_gender'][value='1']").attr("checked", true);

                var head = {
                    "service_name": "cn.dy.system.service.ContactInfoService",
                    "operation_name": "UpdOrAddStaff",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "oldId": $("#eci_staff_id").val(),
                    "staffRoleContact": {},
                    "rolelList": {}
                }
                param.staffRoleContact = $.form("#contactForm").getJSON();

                var roles = new Array();
                $("input[name='role_id']:checked").each(function() {
                    var roleid = $(this).val();
                    roles.push(roleid);

                });
                param.rolelList = roles;

                delete param.staffRoleContact.eci_cpassword;
                delete param.staffRoleContact.group_name;
                delete param.staffRoleContact.role_id;
                delete param.staffRoleContact.hidPwd;

                var options = {
                    "handleError": false
                }

                function callBack(data, error) {
                    if (error.response_code == "0") {
                        if (data.response_code == "1") {

                            var treeNode = zTree.getNodesByParam("id",
                                right_click_node.id, null)[0];
                            treeNode.name = $("#eci_staff_account").val();
                            treeNode.dis_name = treeNode.name;
                            treeNode.id = right_click_node.id;
                            right_click_node.id = treeNode.id;

                            if (param.staffRoleContact.sts == "0") {
                                treeNode.sts = "0";
                                treeNode.dis_name = "<font color=gray>" +
                                    treeNode.dis_name + "</font>";
                            }
                            zTree.updateNode(treeNode, false);

                            if (treeNode.children && treeNode.children.length > 0) {
                                for (var i = 0; i < treeNode.children.length; i++) {
                                    var childNode = treeNode.children[i];
                                    childNode.parent_id = treeNode.id;
                                    zTree.updateNode(childNode, false);
                                }
                            }
                            alert(data.response_desc);
                            openApp();
                        } else if (data.response_code == "-1") {
                            alert(data.response_desc);
                        } else if (data.response_code == "0") {
                            alert(data.response_desc);
                        } else if (data.response_code == "-2") {
                            alert(data.response_desc);
                        } else if (data.response_code == "2") {

                            var parentNode = zTree.getNodesByParam("id", $(
                                "#ech_group_id").val(), null)[0];
                            var parentId = $("#ech_group_id").val();
                            var node = {
                                id: data.content.contact_id,
                                name: param.staffRoleContact.eci_staff_account,
                                dis_name: param.staffRoleContact.eci_staff_account,
                                parent_id: parentId,
                                isParent: false
                            };
                            parentNode.isParent = true;
                            zTree.addNodes(parentNode, node, false);
                            zTree.updateNode(parentNode);
                            alert(data.response_desc);
                            openApp();
                        }

                    } else {
                        alert(error.response_desc);
                    }

                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);
            }

            //保存应用修改
            function doSave() {

                if ($("#name").val().trim() == "根目录节点") {
                    alert("子级不能与父级同名");
                    return false;
                }

                if ($("#name").val().trim() == $("#parent_name").val().trim()) {
                    alert("子级不能与父级同名");
                    return false;
                }

                if ($("#parent_name").val().trim() == "") {
                    alert("请输入上级名称");
                    $("#parent_name").select();
                    return false;
                }
                if ($("#name").val().trim() == "") {
                    alert("请输入部门名称！");
                    $("#name").select();
                    return false;
                }

                var head = {
                    "service_name": "cn.dy.system.service.ContactGroupService",
                    "operation_name": "updateContactGroup",
                    "token_id": loginInfo.token_id,
                    "user_id": loginInfo.staff_id,
                    "version": "0100",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                }

                var param = {
                    "old_id": right_click_node.id,
                    "contactGroup": {}
                }
                param.contactGroup = $.form("#tableForm").getJSON();

                delete param.contactGroup.parent_name;
                delete param.contactGroup.btn_save;

                var options = {
                    "handleError": false
                }

                function callBack(data, error) {
                    if (error.response_code == "0") {
                        if (data == 1) {
                            alert("修改成功");
                            var treeNode = zTree.getNodesByParam("id", param.old_id,
                                null)[0];
                            treeNode.name = $("#name").val();
                            treeNode.dis_name = treeNode.name;
                            treeNode.id = $("#id").val();
                            right_click_node.id = treeNode.id;
                            if (param.contactGroup.sts == "0") {
                                treeNode.sts = "0";
                                treeNode.dis_name = "<font color=gray>" +
                                    treeNode.dis_name + "</font>";
                            }
                            zTree.updateNode(treeNode, false);

                            if (treeNode.children && treeNode.children.length > 0) {
                                for (var i = 0; i < treeNode.children.length; i++) {
                                    var childNode = treeNode.children[i];
                                    childNode.parent_id = treeNode.id;
                                    zTree.updateNode(childNode, false);
                                }
                            }
                            initApp();
                        } else if (data == -1) {
                            alert("该部门名称已存在，请重新输入");
                        } else {

                            var parentNode = zTree.getNodesByParam("id",
                                right_click_node.id, null)[0];
                            var node = {
                                id: data,
                                name: param.contactGroup.name,
                                dis_name: param.contactGroup.name,
                                parent_id: right_click_node.id,
                                isParent: false
                            };
                            parentNode.isParent = true;
                            zTree.addNodes(parentNode, node, false);
                            zTree.updateNode(parentNode);
                            alert("添加成功");
                            initApp();
                        }

                    } else {
                        alert(error.response_desc);
                    }
                }

                $.ServiceAgent.JSONInvoke(head, param, callBack, options);
            }

            //保存人员详情
            function showRMenu(treeNode, x, y) {
                var id = treeNode.id;
                var strId = id.toString();
                var cutStr = strId.substring(0, 1);
                var menuContent = "";
                if (id == 101) {
                    menuContent += "<li><a href=\"#\" onclick=\"addApp();hideRMenu();\">添加下级部门</a></li>";
                } else if (cutStr == "c") {
                    // menuContent += "<li><a href=\"#\" onclick=\"addApp();hideRMenu();\">添加人员</a></li>";
                    menuContent += "<li><a href=\"#\" onclick=\"changeApp();hideRMenu();\">修改人员</a></li>";
                    menuContent += "<li><a href=\"#\" onclick=\"deleteApp();hideRMenu();\">删除人员</a></li>";
                } else {
                    menuContent += "<li><a href=\"#\" onclick=\"addApp();hideRMenu();\">添加下级部门</a></li>";
                    menuContent += "<li><a href=\"#\" onclick=\"changeApp();hideRMenu();\">修改部门</a></li>";
                    menuContent += "<li><a href=\"#\" onclick=\"deleteApp();hideRMenu();\">删除部门</a></li>";
                    menuContent += "<li><a href=\"#\" onclick=\"contactApp();hideRMenu();\">添加人员</a></li>";
                }
                $("#nodeMenuContent").html(menuContent);

                $("#nodeMenu").css({
                    "top": y + "px",
                    "left": x + "px"
                });
                $("#nodeMenu").show();

                var menuHeight = $("#nodeMenu").height();
                var treeAreaPo = $("#treeParentArea").position().top +
                    $("#treeParentArea").height();
                while (y + menuHeight > treeAreaPo) {
                    y--;
                }

                $("#nodeMenu").css({
                    "top": y + "px",
                    "left": x + "px"
                });
                $("#nodeMenu").show();

                $("body").bind("mousedown", onBodyMouseDown);
                $("body").bind("blur", onBodyBlur);
                $("window").bind("blur", onBodyBlur);
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
                if (!(tri_event.target.id == "nodeMenu" || $(tri_event.target).parents(
                        "#nodeMenu").length > 0)) {
                    hideRMenu();
                }
            }

            var zTree = null;

            function createTree() {

                var head = {
                    "service_name": "cn.dy.system.service.ContactGroupService",
                    "operation_name": "getGroupTree",
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
                    if (zTree != null)
                        zTree.destroy();
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

            function resize() {

                if (typeof(combo) != "undefined") {
                    var myFunc = function() {
                        combo.setSize(10);
                        combo.setSize($("#search_key").width());
                        resizeTree();
                    }

                    setTimeout(myFunc, 10);
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

            //打开隐藏的人员详情表单
            function openApp() {
                $("#tableForm").css("display", "none");
                $("#contactForm").css("display", "block");
                $("#contactForm").find('input').attr("readonly", true);
                // $("#contactForm").find('input').attr("disabled", true);
                $("#btnSave").hide();
                $("#btnSave2").show();
                $("input[name='role_id']").attr("readonly", true);
                // $("#eci_gender").attr("disabled", true);
                $("#btnSave2").attr("class", "btn gray");
                $("#btnSave2").attr("disabled", "disabled");
                $("#btnCancel").attr("class", "btn gray");

            }

            //初始化控件应用
            function initApp() {
                $("#tableForm").css("display", "block");
                $("#tableForm").find('input').attr("readonly", true);
                // $("#tableForm").find('input').attr("disabled", true);
                $("#contactForm").css("display", "none");
                $("#introduction").attr("readonly", true);
                $("#strata").attr("disabled", "disabled");
                $("#strata").closest(".rule-single-select").ruleSingleSelect();
                $("#btnSave").attr("disabled", "disabled");
                $("#btnSave2").hide();
                $("#btnCancel").attr("disabled", "disabled");
                $("#btnSave").show();
                $("#btnSave").attr("class", "btn gray");
                $("#btnCancel").attr("class", "btn gray");
            }

            $(function() {
                console.log(loginInfo);
                document.title = "组织管理";
                initApp();
                getRole();
                $.form("#tableFrom").maxlen("textarea");

                $("#operForm").find(":text").bind('keyup', function(event) {
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
    </head>

    <body class="mainbody" style="width: 100%; height: 100%; margin: 10px; overflow: hidden;">
        <!-- 左边数据-->
        <div name="operForm" id="operForm" style="width: 100%; height: 100%;;background: #FFFFFF">
            <div id="role" style="width: 30%; float: left; ; height: 100%;background: #eeeeee">
                <div class="title">组织机构列表</div>
                <div id="treeParentArea" valign=top style="width: 100%;height: 705px;">
                    <ul id="tree" class="ztree" style="overflow:auto;margin:0px;height:698px"></ul>
                </div>
            </div>
            <!-- 右边数据 -->
            <form name="tableForm" id="tableForm">
                <div id="app_detail_table" valign=top style="width: 69%; float: right;; height: 100%;background: #eeeeee ;overflow-y:auto;">
                    <div class="title">组织机构详情</div>
                    <div id="app_detail_table" class="tab-content" style="padding-bottom: 50px;">
                        <dl>
                            <dt>上级名称:</dt>
                            <dd>
                                <input type="text" name="parent_name" id="parent_name" for="parent_name" class="input normal" sucmsg=" " maxlength="20" />

                            </dd>
                        </dl>
                        <dl>
                            <dt>部门名称:</dt>
                            <dd>
                                <input type="text" name="name" id="name" for="name" class="input normal" sucmsg=" " maxlength="20" /> <span class="Validform_checktip">*必填</span>
                            </dd>
                        </dl>

                        <dl>
                            <dt>部门阶层：</dt>
                            <dd>
                                <div class="rule-single-select" style="float: left;">
                                    <select name="strata" id="strata" datatype="*" sucmsg=" " style="width: 150px;" readonly="readonly">
									<option value="0">部门类型</option>
									<option value="5">普通部门</option>
								</select>
                                </div>
                            </dd>
                        </dl>
                        <dl>
                            <dt>部门简介:</dt>
                            <dd>
                                <textarea name="introduction" id="introduction" for="introduction" class="input normal" sucmsg=" " maxlength="20"></textarea>
                            </dd>
                        </dl>
                        <dl>
                            <dt>地址:</dt>
                            <dd>
                                <input type="text" name="address" id="address" for="address" class="input normal" sucmsg=" " maxlength="20" />
                            </dd>
                        </dl>
                        <dl>
                            <dt>邮编:</dt>
                            <dd>
                                <input type="text" name="postcode" id="postcode" for="postcode" class="input normal" sucmsg=" " maxlength="20" />
                            </dd>
                        </dl>
                        <dl>
                            <dt>联系电话:</dt>
                            <dd>
                                <input type="text" name="phone" id="phone" for="phone" class="input normal" sucmsg=" " maxlength="20" />
                            </dd>
                        </dl>

                        <dl>
                            <dt>传真:</dt>
                            <dd>
                                <input type="text" name="fax" id="fax" for="fax" class="input normal" sucmsg=" " maxlength="20" />
                            </dd>
                        </dl>

                        <dl>
                            <dt>联系人:</dt>
                            <dd>
                                <input type="text" name="contact" id="contact" for="contact" class="input normal" sucmsg=" " maxlength="20" />
                            </dd>
                        </dl>
                        <!-- 隐藏的控件 -->
                        <dl>
                            <!-- id -->
                            <input type="hidden" name="id" id="id" for="id" sucmsg="" />
                            <!-- contact_type 联系人类型 -->
                            <input type="hidden" name=contact_type id="contact_type" for="contact_type" value="corp" sucmsg="" />
                            <!--parent_id 父节点id-->
                            <input type="hidden" name=parent_id id="parent_id" for="parent_id" sucmsg="" />
                            <!-- staff_id 创建人员-->
                            <input type="hidden" name="staff_id" id="staff_id" for="staff_id" sucmsg="" />
                            <!-- group_type -->
                            <input type="hidden" name="group_type" id="group_type" for="group_type" value="NORMAL" sucmsg="" />
                            <!-- 是否自动生成 is_syn -->
                            <input type="hidden" name="is_syn" id="is_syn" for="is_syn" sucmsg="" />
                            <!-- 机构编码  code-->
                            <input type="hidden" name="code" id="code" for="code" sucmsg="" />
                            <!-- order_index 序号-->
                            <input type="hidden" name="order_index" id="order_index" for="order_index" sucmsg="" />
                            <!-- is_fixed 是否修改  -->
                            <input type="hidden" name="is_fixed" id="is_fixed" for="is_fixed" value="Y" sucmsg="" />
                            <!-- corp_id 公司id -->
                            <input type="hidden" name="corp_id" id="corp_id" for="corp_id" value="1" sucmsg="" />
                            <!-- corp_code 公司编码 -->
                            <input type="hidden" name="corp_code" id="corp_code" for="corp_code" value="" sucmsg="" />
                            <!--header 头像地址-->
                            <input type="hidden" name="header" id="header" for="header" sucmsg="" />
                            <!-- parent_code 企业编码-->
                            <input type="hidden" name="parent_code" id="parent_code" for="parent_code" sucmsg="" />
                            <!-- extern_id 而外id-->
                            <input type="hidden" name="extern_id" id="extern_id" for="extern_id" sucmsg="" />
                        </dl>
                    </div>
                </div>
            </form>
            <!--人员详情form表单 -->
            <form name="contactForm" id="contactForm">
                <div id="app_detail_table" valign=top style="width: 69%; float: right;; height: 100%;background: #eeeeee ;overflow-y:auto;">
                    <div class="title">人员信息详情</div>
                    <div id="app_detail_table" class="tab-content" style="padding-bottom: 50px;">
                        <dl>
                            <dt>所属部门:</dt>
                            <dd>
                                <input type="text" name="group_name" id="group_name" for="group_name" class="input normal" sucmsg=" " maxlength="20" />

                            </dd>
                        </dl>
                        <dl>
                            <dt>手机号:</dt>
                            <dd>
                                <input type="text" name="eci_contact_nbr" id="eci_contact_nbr" for="eci_contact_nbr" class="input normal" sucmsg=" " onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" maxlength="11" />
                                <!--  -->
                                <span class="Validform_checktip">*手机号作为登入账号</span>
                            </dd>
                        </dl>
                        <dl>
                            <dt>登入密码:</dt>
                            <dd>
                                <input type="password" name="eci_password" id="eci_password" for="eci_password" class="input normal" sucmsg=" " maxlength="20" /> <span class="Validform_checktip">*必填</span>
                            </dd>
                        </dl>
                        <dl>
                            <dt>确认密码:</dt>
                            <dd>
                                <input type="password" name="eci_cpassword" id="eci_cpassword" for="eci_cpassword" class="input normal" sucmsg=" " maxlength="20" /> <span class="Validform_checktip">*必填</span>
                            </dd>
                        </dl>

                        <dl>
                            <dt>姓名:</dt>
                            <dd>
                                <input type="text" name="eci_staff_account" id="eci_staff_account" for="eci_staff_account" class="input normal" sucmsg=" " maxlength="20" /> <span class="Validform_checktip">*必填</span>
                            </dd>
                        </dl>
                        <dl>
                            <dt>性别：</dt>
                            <dd>
                                <input type="radio" name="eci_gender" id="eci_gender" value="1" /> 男&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="radio" name="eci_gender" id="eci_gender" value="0" /> 女
                            </dd>
                        </dl>
                        <dl>
                            <dl>
                                <dt>邮件地址:</dt>
                                <dd>
                                    <input type="text" name="eci_email" id="eci_email" for="eci_email" class="input normal" sucmsg=" " maxlength="20" />
                                    <!--  <span class="Validform_checktip">*必填</span>-->
                                </dd>
                            </dl>
                        </dl>
                        <dl>
                            <dt>状态:</dt>
                            <dd>
                                <div class="rule-single-select" style="float: left;">
                                    <select name="eci_sts" id="eci_sts" datatype="*" sucmsg=" " style="width: 150px;" readonly="readonly">
									<option value="1">正常</option>
									<option value="L">锁定</option>
								</select>
                                </div>
                            </dd>
                        </dl>
                        <dl>
                            <dt>角色:</dt>

                            <dd id="roleChk" name="roleChk">
                                <!-- <input type="checkbox" id='' name=''/>-->
                                <!--<span class="Validform_checktip">*必选</span>-->
                            </dd>


                        </dl>
                        <dl>
                            <!-- 隐藏控件 -->
                            <input type="hidden" id="ech_group_id" name="ech_group_id" for="ech_group_id" />
                            <input type="hidden" id="eci_staff_id" name="eci_staff_id" for="eci_staff_id" />
                            <input type="hidden" id="ecg_corp_id" name="ecg_corp_id" value="1" for="ecg_corp_id" />
                            <!--  <input type="hidden" id="eci_sts" name="eci_sts" for="eci_sts" value="1" />-->
                            <input type="hidden" id="hidPwd" name="hidPwd" for="hidPwd" />
                        </dl>
                    </div>
                </div>
            </form>
        </div>

        <!--按钮-->
        <div class="page-footer" style="text-align: center; ">
            <div class="btn-list">
                <button id="btnSave" value="保存" class="btn green" onclick="doSave();return false;">保存</button>
                <button id="btnSave2" value="保存" class="btn green" onclick="StaffSave();return false;">保存</button>
                <button id="btnCancel" value="取消" class="btn yellow" onclick=" cancelApp();">取消</button>
            </div>
        </div>
        <div id="nodeMenu" class="dropdown clearfix" style="display:none;position:absolute;z-index:100">
            <ul id="nodeMenuContent" class="dropdown-menu" style="display: block; position: static; margin-bottom: 5px; width: 100px;">
            </ul>
        </div>
    </body>

    </html>