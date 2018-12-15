<%@ page import="org.apache.commons.lang3.StringUtils" %><%@ page import="java.io.File" %><%@ page contentType="text/html;charset=UTF-8" %><%!
    public String check(ServletContext app, String configPath) {
        if (!StringUtils.isEmpty(configPath)) {

            String webRoot = app.getContextPath();
            if ("/".equals(webRoot))webRoot = "";


            if (configPath.startsWith("/")) {
                configPath =configPath.substring(1);
            }

            String filePath = app.getRealPath("/"+configPath);//这个肯定不能包含当前web应用路径



            //System.out.println("webRoot="+webRoot+",filePath="+filePath);

            File file = new File(filePath);
            if (!file.exists() || !file.isFile()) {
                configPath = "";
            }
        } else configPath = "";

        return configPath;
    }
%><%
    request.setAttribute("home", request.getContextPath());
    String themes="bluesky";
    Cookie[] cookies = request.getCookies();
    if (cookies != null && cookies.length > 0) {
        for (int j = 0; j < cookies.length; j++) {
            String cookieName = cookies[j].getName();
            if ("themes".equals(cookieName)) {
                try{
                    themes=java.net.URLDecoder.decode(cookies[j].getValue(), "UTF-8");
                }
                catch(Exception ex){
                }
            }
        }
    }
    String cssName="plug-in/skin/css/"+themes+".css";
    cssName=check(application,cssName);

    String fileName=application.getRealPath(cssName);
    File file=new File(fileName);
    if(!file.exists()){
        themes="green";
        cssName="plug-in/skin/css/"+themes+".css";
    }

%><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-store"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<link rel="shortcut icon" href="${home}/plug-in/skin/images/favicon.ico"/>
<link rel="bookmark" href="${home}/plug-in/skin/images/favicon.ico"/>
<link type="text/css" rel="stylesheet" href="${home}/scripts/mask/jquery.loadmask.css"/>
<link class="myStyle" rel="stylesheet" type="text/css" href="${home}/dhtmlx/skins/<%=themes%>/style.css" title="<%=themes%>"/>
<%
    if(!StringUtils.isEmpty(cssName)){
%>
<link class="myStyle" rel="stylesheet" type="text/css" href="${home}/<%=cssName%>" />
<%
    }
%>
<script>
    var _CurrentWebAppHome="${home}";
</script>
<script type="text/javascript" src="${home}/scripts/jquery-1.8.1.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/mask/jquery.loadmask.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-cookie-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-service-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-form-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-validate-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/util.js" charset="UTF-8"></script>
<script src="${home}/plug-in/js/mouse/mouse.js"></script>
<script src="${home}/plug-in/js/switch/themeSwitch.js"></script>
<script src="${home}/dhtmlx/dhtmlx_zhcn.min.js?proName=<%=request.getContextPath()%>&useImagePath=0"></script>
<script type="text/javascript" src="${home}/scripts/LoginInfo.js" charset="UTF-8"></script>
<script type="text/javascript">
    if (loginInfo == null || !loginInfo.token_id) {
        //alert("登录已经过期，请重新登录");
        //top.location.replace("${home}/login.jsp");
    }

    loginInfo.setContextPath("${home}");


    document.onkeydown = function (eventObj) {
        if (!eventObj)eventObj = window.event;
        if (eventObj.keyCode == 8) //屏蔽退格删除键
        {
            //新增一个判断条件，输入框如果是只读状态，也需要屏蔽退格删除键
            if (eventObj.srcElement.readOnly || (eventObj.srcElement.tagName.toUpperCase() != "INPUT"
                    && eventObj.srcElement.tagName.toUpperCase() != "TEXTAREA"
                    && eventObj.srcElement.tagName.toUpperCase() != "TEXT")) {
                eventObj.keyCode = 0;
                eventObj.returnValue = false;
            }
        }
    };

    var oldWindowAlertFun=null;

    $(function () {
        try{
          $.ServiceAgent.setServiceUrl("${home}/service");
        }
        catch(ex){
        }
        $("input[type=button][use_comm_style!='false']").each(function (i) {
            if ($(this).val().length <= 4) {
                $(this).attr("class", "button-normal-two");
            }
            else {
                $(this).attr("class", "button-normal-five");
            }
        });

        $("input[type=button][use_comm_style!='false']").bind("mousedown", function () {
            if ($(this).val().length <= 4) {
                $(this).attr("class", "button-press-two");
            }
            else {
                $(this).attr("class", "button-press-five");
            }
        });

        $("input[type=button][use_comm_style!='false']").bind("mouseup", function () {
            if ($(this).val().length <= 4) {
                $(this).attr("class", "button-normal-two");
            }
            else {
                $(this).attr("class", "button-normal-five");
            }
        });

        $("input[type=button][use_comm_style!='false']").bind("mouseover", function () {
            if ($(this).val().length <= 4) {
                $(this).attr("class", "button-hover-two");
            }
            else {
                $(this).attr("class", "button-hover-five");
            }
        });

        $("input[type=button][use_comm_style!='false']").bind("mouseout", function () {
            if ($(this).val().length <= 4) {
                $(this).attr("class", "button-normal-two");
            }
            else {
                $(this).attr("class", "button-normal-five");
            }
        });

        $("input[type=button][use_comm_style!='false']").bind("focus", function () {
            $(this).blur();
        });

        oldWindowAlertFun=window.alert;

        window.customerAlert2=function(msg){
            if(self.alertMessage){
                self.alertMessage(msg);
            }
            else{
                var oWin=self;
                var openerWin=self;
                while(oWin){
                    if(oWin.alertMessage){
                        oWin.alertMessage(msg);
                        return;
                    }
                    if(oWin!=oWin.parent)oWin=oWin.parent;
                    else break;
                }
                while(openerWin){
                    if(openerWin.alertMessage){
                        openerWin.alertMessage(msg);
                        return;
                    }
                    if(openerWin!=openerWin.opener)openerWin=openerWin.opener;
                    else break;
                }
                oldWindowAlertFun(msg);
            }
        }
    });
</script>