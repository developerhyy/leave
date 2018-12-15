var LoginPlugin = function () {
};

LoginPlugin.prototype = {

    _default_themes: "green",//默认样式 green bluesky salad
    _login_Post_Url: "./index.jsp",
    _login_menuTreeType: "tree",
    _callBack: null,
    _tareget: null,
    _img_flag: -1,

    setLoginOption: function (url, menuType, targetF, callBack, themes) {
        if (url)this._login_Post_Url = url;
        if (menuType)this._login_menuTreeType = menuType;
        if (targetF)this._tareget = targetF;
        if (callBack)this._callBack = callBack;
        if (themes)this._default_themes = themes;
    },

    getWebContextPath: function () {
        var webContextPath = "";
        try {
            var scripts = $("script");
            for (var i = 0; i < scripts.size(); i++) {
                if ($(scripts[i]).get(0).src.indexOf("/system/login.js") > 0) {
                    webContextPath = "" + $(scripts[i]).get(0).src;
                    webContextPath = webContextPath.replace("/system/login.js", "");
                    break;
                }
            }
            scripts = null;
        }
        catch (ex) {
        }
        return webContextPath;
    },

    doChangeImg: function (flag) {
        try {
            if (this._img_flag == flag)return;
            var oldSrc = document.getElementById("loginButton").src;

            if (flag + "" == "1") {
                document.getElementById("loginButton").src = oldSrc.replace("btn_loginhover.png", "btn_loginactive.png").replace("btn_login.png", "btn_loginactive.png");
            }
            else if (flag + "" == "2") {
                document.getElementById("loginButton").src = oldSrc.replace("btn_login.png", "btn_loginhover.png").replace("btn_loginactive.png", "btn_loginhover.png");
            }
            else {
                document.getElementById("loginButton").src = oldSrc.replace("btn_loginhover.png", "btn_login.png").replace("btn_loginactive.png", "btn_login.png");
            }
            this._img_flag = flag;
        }
        catch (ex) {
        }
    },

    enter: function (eventObj) {
        try {

            if (!eventObj)eventObj = window.event;
            var keyCode = eventObj.which ? eventObj.which : eventObj.keyCode;
            if (keyCode == 13) {
                if (this.check()) {
                    this.login();
                    return;
                }
                //event.keyCode=9;
            }
        }
        catch (ex) {
        }
    },

    check: function () {//登录
        if ($("#username").val() == "" || $("#username").val() == $("#username").attr("login_holder")) {
            alert("请输入登录帐号!");
            $("#username").focus();
            return false;
        }


        if ($("#password").val() == "" || $("#password").val() == $("#password").attr("login_holder")) {
            alert("请输入密码!");
            if ($("#password").is(":visible")) {
                $("#password").focus();
            }
            else $("#input_password").focus();
            return false;
        }


        if ($("#rand_img").val() == "" || $("#rand_img").val() == $("#rand_img").attr("login_holder")) {
            alert("请输入校验码!");
            $("#rand_img").focus();
            return false;
        }

        return true;
    },

    encryptPassword: function (password) {
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
            handleError: false,
            showProgressBar: false
        });
        $.ServiceAgent.setSync(false);

        return password;
    },

    isDoLogin: false,//控制不重复登录

    login: function () {
        if (this.isDoLogin)
            return;
        this.isDoLogin = true;
        if (this.check()) {
            $.form("#loginForm").sleep();
            $("#jspImgArea").attr("disabled", true);
            $("#jspImg").attr("disabled", true);
            var password = $("#password").val();
            if (password) {
                var head = {
                    "service_name": "cn.dy.base.system.service.LoginService",
                    "operation_name": "login",
                    "token_id": "",
                    "user_id": "",
                    "version": "",
                    "timestamp": "",
                    "request_seq": "",
                    "request_source": ""
                };

                var param = $.form("#loginForm").getJSON();
                delete param.loginButton;
                delete param.jspImg;
                delete param.input_password;

                if (corpAccount != "") {
                    param.username = param.username + "@" + corpAccount;
                }
                param.password = this.encryptPassword(param.password);//加密
                if (param.password) {
                    //var test_param = $.JsonUtil.jso2json(param);
                    //alert($.JsonUtil.jso2json(test_param));
                    $("#force_login").val("");
                    $.ServiceAgent.JSONInvoke(head, param, this.loginCallBack, {
                        handleError: false,
                        showProgressBar: false
                    });
                } else {
                    $.form("#loginForm").wakeup();
                    $("#jspImgArea").removeAttr("disabled");
                    $("#jspImg").removeAttr("disabled");
                    this.isDoLogin = false;
                    return;
                }
            }
        }
        this.isDoLogin = false;
    },

    doChangeRandImg: function () {
        document.getElementById("jspImg").src = _CurrentWebAppHome+"/system/img.jsp?" + (new Date()).getTime();
    },


    loginCallBack: function (data, error) {

        if (error.response_code == 0) {
            $.form("#loginInfo").setJSON(data);

            var exist_login = data.attributes.exist_login;
            if (exist_login != "undefined" && exist_login == "Y") {
                if (confirm("该员工已经登入，是否强制登入！")) {
                    $("#force_login").val("Y");
                    loginPlugin.isDoLogin = false;
                    var delayLogin = function () {
                        loginPlugin.login();
                    }
                    setTimeout(delayLogin, 10);
                    return false;
                }
                $.form("#loginForm").wakeup();
                $("#jspImgArea").removeAttr("disabled");
                $("#jspImg").removeAttr("disabled");
                loginPlugin.isDoLogin = false;
                return false;
            }
            var cardReaderType = $.CookieUtil.get("cardReaderType");
            $.CookieUtil.clear("", _CurrentWebAppHome);
			$.CookieUtil.put("cardReaderType",cardReaderType,-1,_CurrentWebAppHome);
            var cookieNames = [ "token_id", "staff_id", "corp_id",
                "staff_account", "corp_account", "staff_nickname",
                "corp_name", "corp_short_name", "login_method","is_password_expired",
                "user_id", "user_name", "dept_id", "dept_name", "city_code", "client_ip", "login_time"];
            for (var i = 0; i < cookieNames.length; i++) {
                var cookieName = cookieNames[i];
                if ($("#" + cookieName).val() == "" || $("#" + cookieName).val() == null)continue;
                $.CookieUtil.put(cookieName, $("#" + cookieName).val(), -1, _CurrentWebAppHome);
                //alert(cookieName);
            }


            if (data.attributes.is_password_expired) {
                $.CookieUtil.put("is_password_expired", true, -1, _CurrentWebAppHome);//设置密码过期
            }


            $.CookieUtil.put("themes", loginPlugin._default_themes, -1, _CurrentWebAppHome);//设置默认样式


            if (loginPlugin._callBack) {
                var doCallBack = function () {
                    if (corpAccount != "") {
                        if (loginPlugin._login_Post_Url.indexOf("?") < 0)
                            loginPlugin._login_Post_Url = loginPlugin._login_Post_Url + "?corp_account=" + corpAccount;
                        else
                            loginPlugin._login_Post_Url = loginPlugin._login_Post_Url + "&corp_account=" + corpAccount;
                    }
                    loginPlugin._callBack(loginPlugin._login_Post_Url, loginPlugin._login_menuTreeType, loginPlugin._tareget, loginPlugin._default_themes);
                }
                setTimeout(doCallBack, 1);
            }
            else {
                $("#loginInfo").attr("action", loginPlugin._login_Post_Url + "?menu_type=" + loginPlugin._login_menuTreeType);
                if (loginPlugin._tareget) {
                    $("#loginInfo").attr("target", loginPlugin._tareget);
                }
                $("#loginInfo").submit();
            }
        } else {
            alert(error.response_desc);

            $.form("#loginForm").wakeup();

            $("#jspImgArea").removeAttr("disabled");
            $("#jspImg").removeAttr("disabled");
            loginPlugin.doChangeRandImg();

            if (error.response_desc.indexOf("验证码") > 0)$("#rand_img").focus();
            else $("#username").focus();
            loginPlugin.isDoLogin = false;
        }
    },

    doLoginInput: false,

    initLoginInput: function () {

        if (this.doLoginInput)return;
        this.doLoginInput = true;
        var inputs = $("input[login_holder]");
        var myself = this;
        var enterEvent = function (e) {
            myself.enter(e);
        };

        for (var i = 0; i < inputs.size(); i++) {
            var inputObj = inputs[i];

            $(inputObj).bind("keydown", enterEvent);

            if ($(inputObj).is(":visible")) {
                $(inputObj).bind("focus", function () {
                    $(this).css({color: "#333333"});
                    $(this).css({border: "1px solid #56bdf3"});

                    if ($(this).val() == $(this).attr("login_holder")) {
                        $(this).val("");

                        if ($(this).is("input[other]")) {
                            var otherName = $(this).attr("other");
                            $(this).hide();

                            $("#" + otherName).css({color: "#333333"});
                            $("#" + otherName).css({border: "1px solid #56bdf3"});
                            $("#" + otherName).val("");
                            $("#" + otherName).show();
                            $("#" + otherName).focus();
                        }
                    }
                });
            }

            if (!$(inputObj).is(":visible")) {
                $(inputObj).bind("focus", function () {
                    $(this).css({color: "#333333"});
                    $(this).css({border: "1px solid #56bdf3"});
                });
            }

            if (($(inputObj).is(":visible") && !$(inputObj).is("input[other]"))
                || (!$(inputObj).is(":visible") && $(inputObj).is("input[other]"))) {

                //alert($(inputObj).attr("name")+"||input[other]="+$(inputObj).is("input[other]")+"||visible="+$(inputObj).is(":visible"));
                $(inputObj).bind("blur", function () {
                    $(this).css({color: "#999999"});
                    $(this).css({border: "1px solid #cbcbcb"});
                    if ($(this).val() == "") {
                        if ($(this).is("input[other]")) {
                            var otherName = $(this).attr("other");
                            $(this).hide();
                            $("#" + otherName).css({color: "#999999"});
                            $("#" + otherName).val($("#" + otherName).attr("login_holder"));


                            $("#" + otherName).css({border: "1px solid #cbcbcb"});

                            $("#" + otherName).show();
                            //alert($(this).attr("name"));
                            //alert($("#"+otherName).attr("name"));
                        }
                        else $(this).val($(this).attr("login_holder"));
                    }
                });
            }


            if ($(inputObj).is(":visible")) {
                //$(inputObj).css({color: "gray"});
                $(inputObj).val($(inputObj).attr("login_holder"));
            }
        }

        var loginButton = $("#loginButton");
        loginButton.bind("mousemove", function () {
            myself.doChangeImg(2);
        });
        loginButton.bind("mousedown", function () {
            myself.doChangeImg(1);
        });
        loginButton.bind("mouseout", function () {
            myself.doChangeImg(0);
        });
        loginButton.bind("mouseup", function () {
            myself.doChangeImg(0);
        });
    }
};

var loginPlugin = new LoginPlugin();

function tickChangeVerImg() {
    try {
        //$("#jspImg").click();
        loginPlugin.doChangeRandImg();
    }
    catch (ex) {
    }
}

function setVerImg() {
    $("#jspImgArea").css("top", $("#rand_img").position().top + 7);
    $("#jspImgArea").css("left", $("#rand_img").position().left + $("#rand_img").width() - 60);
    $("#jspImgArea").show();
}

function loginInit() {
	var cardReaderType = $.CookieUtil.get("cardReaderType");
    $.CookieUtil.clear("", _CurrentWebAppHome);
    $.CookieUtil.put("cardReaderType",cardReaderType,-1,_CurrentWebAppHome);
    loginPlugin.initLoginInput();
    tickChangeVerImg();
    setVerImg();
    //setInterval(tickChangeVerImg, 300000);//每300秒自动替换当前的验证码图片 300000
}

$(function () {
    try {
        if (!document.getElementById("bodyBackImg")) {
            loginInit();
        }
    }
    catch (ex) {
    }
})
