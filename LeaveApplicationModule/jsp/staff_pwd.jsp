<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
    <%@page import="org.apache.commons.lang3.StringUtils,cn.dy.base.framework.dict.*,java.io.*" %>
        <%!

    IDataDict dataDict = DataDictFactory.getDBFactory();

    public DictItem getConfigValue(String groupCode, String paramCode) {
        DictItem[] items = dataDict.findItem(groupCode);
        if (items != null) {
            for (DictItem item : items) {
                if (item.param_code.equals(paramCode)) {
                    return item;
                }
            }
        }
        return null;
    }

%>
            <%
    boolean sessionCreated = false;
    Cookie[] cookies = request.getCookies();
    if (cookies != null && cookies.length > 0) {
        for (int j = 0; j < cookies.length; j++) {
            String cookieName = cookies[j].getName();
            if ("token_id".equals(cookieName)) {
                sessionCreated = true;
                break;
            }
        }
    }
    if (!sessionCreated) {
        response.sendRedirect("error.htm");
        return;
    }

    String open_win = request.getParameter("open_win");
    if (StringUtils.isEmpty(open_win)) {
        open_win = "style=\"display:none\"";
    } else open_win = "";

    DictItem dictItem = getConfigValue("SEC_POLICY", "PWD_CHECK");
    String pwd_check = "";
    if (dictItem != null && !StringUtils.isEmpty(dictItem.getParam_value())) pwd_check = dictItem.getParam_value();
    String pwd_check_txt = "密码由6-16个字符组成，区分大小写(不能包含空格)";
    if (dictItem != null && !StringUtils.isEmpty(dictItem.getParam_memo())) {
        pwd_check_txt = dictItem.getParam_memo();
    }
    String pwd_tip = pwd_check_txt.replace("\r", "\\r").replace("\n", "\\n").replace("\"", "\\\"");

%>
                <!DOCTYPE html>
                <html class="no-js">

                <head>
                    <style>
                        .input.normal {
                            //color:red;
                        }
                    </style>
                    <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
                    <script type="text/javascript" src="function.js" charset="UTF-8"></script>
                    <script type="text/javascript" src="${home}/scripts/rsa/Barrett.js" charset="UTF-8"></script>
                    <script type="text/javascript" src="${home}/scripts/rsa/BigInt.js" charset="UTF-8"></script>
                    <script type="text/javascript" src="${home}/scripts/rsa/RSA.js" charset="UTF-8"></script>

                    <script type="text/javascript">
                        var pwd_check = "<%=pwd_check%>";

                        function doSave() {
                            if (!checkElementInput("editForm", "input")) {
                                return false;
                            }

                            var param = {
                                "password": encryptPassword($("#password").val()),
                                "old_password": encryptPassword($("#old_password").val()),
                                "staff_id": parseInt($("#staff_id").val())
                            };

                            var queryBack2 = function(data, error) {
                                if (error.response_code == 0) {
                                    alert("修改成功！");
                                    $.CookieUtil.put("is_password_expired", "false");
                                    var delayClose = function() {
                                        try {
                                            parent.dhxWins.window("updatePwdWin").close();
                                        } catch (ex) {}
                                    }
                                    setTimeout(delayClose, 1);
                                } else {
                                    alert(error.response_desc);
                                }
                                $("#editForm").find("input[type=password]").val("");
                            }

                            var service_name = "cn.dy.base.system.service.StaffService";
                            var op_name = "modifyStaffPassword";

                            CallService(service_name, op_name, param, queryBack2);

                        }


                        function encryptPassword(password) {
                            var head = {
                                "service_name": "cn.dy.base.system.service.LoginService",
                                "operation_name": "getRSAPublicKey",
                                "token_id": "",
                                "user_id": "",
                                "version": "",
                                "timestamp": "",
                                "request_seq": "",
                                "request_source": ""
                            };
                            var param = {};

                            function callBack(data, error) {
                                if (error.response_code == 0) {
                                    setMaxDigits(130);
                                    var key = new RSAKeyPair(data.publicExponent, '', data.modulus);
                                    password = encryptedString(key, password); //不支持汉字
                                } else {
                                    alert(error.response_desc);
                                    password = "";
                                }
                            }

                            $.ServiceAgent.setSync(true);
                            $.ServiceAgent.JSONInvoke(head, param, callBack, {
                                handleError: false
                            });
                            $.ServiceAgent.setSync(false);
                            console.log("password:" + password);
                            return password;
                        }

                        var doFocusStatus = 0;

                        function doFocus(obj) {
                            var delayFocus = function() {
                                obj.focus();
                                doFocusStatus = 0;
                            }
                            if (doFocusStatus == 0) {
                                doFocusStatus = 1;
                                setTimeout(delayFocus, 1);
                            }
                        }


                        //初始化验证数据
                        function initValidElement() {

                            $.form("#editForm").find("input").each(
                                function(i) {
                                    $(this).focus(function() {
                                        //clearErrorInfo($(this).attr("id"));
                                        this.style.imeMode = "disabled";
                                        /* 禁止输入法*/
                                    });
                                }
                            );


                            $("#old_password").focusout(function() {
                                if (doFocusStatus == 1) return false;
                                var check_sts = checkInputEmpty(this, "当前密码");
                                if (!check_sts) {
                                    doFocus($("#old_password"));
                                    return false;
                                }
                                clearErrorInfo($(this).attr("id"));
                            });


                            $("#password").focusout(function() {
                                if (doFocusStatus == 1) return false;

                                if (!checkInputEmpty($("#old_password"), "当前密码")) {
                                    doFocus($("#old_password"));
                                    return false;
                                }

                                if (!checkInputEmpty(this, "新密码")) {
                                    doFocus($("#password"));
                                    return false;
                                }

                                if (!checkPwd($(this).val())) {
                                    afterErrorInfo("密码输入格式不对", $(this).attr("id"));
                                    doFocus($("#password"));
                                    return false;
                                }


                                clearErrorInfo($(this).attr("id"));

                                if ($("#check_password").val() == $(this).val()) {
                                    clearErrorInfo($("#check_password").attr("id"));
                                }
                            });

                            $("#check_password").focusout(function() {
                                if (doFocusStatus == 1) return false;

                                if (!checkInputEmpty($("#old_password"), "当前密码")) {
                                    doFocus($("#old_password"));
                                    return false;
                                }

                                if (!checkInputEmpty($("#password"), "新密码")) {
                                    doFocus($("#password"));
                                    return false;
                                }


                                var check_sts = checkInputEmpty(this, "确认新密码");
                                if (!check_sts) {
                                    doFocus($("#check_password"));
                                    return false;
                                }

                                if ($("#check_password").val() != $("#password").val()) {
                                    afterErrorInfo("两次输入密码不一致！", $(this).attr("id"));
                                    //doFocus($("#check_password"));
                                    return false;
                                }


                                if (!checkPwd($(this).val())) {
                                    afterErrorInfo("密码输入不对，不满足要求！", $(this).attr("id"));
                                    doFocus($("#check_password"));
                                    return false;
                                }

                                clearErrorInfo($(this).attr("id"));
                            });
                        }

                        function checkPwd(sValue) {
                            var reg = /^[A-Za-z0-9_-]{6,18}$/;
                            if (pwd_check != "") {
                                reg = new RegExp(pwd_check);
                            }
                            return reg.test(sValue);
                        }

                        function doQuit() {
                            parent.logout();
                        }

                        $(function() {
                            initValidElement();
                            if (loginInfo.staff_id != "undefined") {
                                $("#staff_id").val(loginInfo.staff_id);
                            }
                            var winWidth = $(window).width();
                            if (winWidth == 0) winWidth = $("body").width();
                            var winHeight = $(window).height();
                            if (winHeight == 0) winHeight = $("body").height();

                            //$("#editArea").height(winHeight-10);
                            //$("#editArea").css("left", (winWidth-$("#editArea").width())/2);
                            //alert(winHeight+"||"+)
                            //$("#editForm").css("top", (winHeight-$("#editForm").height())/2);
                        })
                    </script>



                    <title>密码修改</title>
                    <style>

                    </style>
                </head>

                <body class="mainbody">
                    <form name="form1" id="form1" method="post" enctype="multipart/form- data">
                        <input name="imgfile" type="file" id="imgfile" size="40" style="border: 1px solid #d4d4d4;display:none;" onchange="viewmypic(this.form.imgfile);" />
                    </form>
                    <form method="post" id="editForm">
                        <input type="hidden" name="staff_id" id="staff_id" value="" />
                        <!--导航栏-->
                        <!-- 导航栏 -->
                        <div class="location">
                            <a href="javascript:;" class="home"><i></i><span>密码修改</span>
				</a>
                        </div>

                        <!-- 提示栏 -->
                        <div class="mytips">
                            <div>
                                <font color="gray">
                                    <%=pwd_check_txt%>
                                </font>
                            </div>
                        </div>
                        <div class="tab-content" style="padding-bottom: 50px;">
                            <dl>
                                <dt>当前密码：</dt>
                                <dd>
                                    <input type="password" name="old_password" id="old_password" class="input normal" sucmsg=" " maxlength="16" />
                                    <span class="Validform_checktip">*必填</span>
                                </dd>
                            </dl>
                            <dl>
                                <dt>新密码：</dt>
                                <dd>
                                    <input type="password" name="password" id="password" class="input normal" sucmsg=" " maxlength="16" />
                                </dd>
                            </dl>
                            <!--			<dl>
                <dt>&nbsp;</dt>
                <dd>
                   <div><font color="gray"><%=pwd_check_txt%>
                    </font></div>  
                </dd>
            </dl>-->
                            <dl>
                                <dt>确认新密码：</dt>
                                <dd>
                                    <input type="password" name="check_password" id="check_password" class="input normal" maxlength="16" />
                                </dd>
                            </dl>





                            <!--工具栏-->
                            <div class="page-footer">
                                <div class="btn-list">
                                    <input type="button" name="btnSubmit" value="保存" id="btnSubmit" class="btn green" onclick="doSave();" />
                                    <input <%=open_win%> type="button" value="退出" class="btn yellow" onclick="doQuit();">
                                </div>
                                <div class="clear"></div>
                            </div>

                </body>

                </html>