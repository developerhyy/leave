<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="org.apache.commons.lang3.StringUtils,cn.dy.base.framework.dict.*" %>
<%!

    IDataDict dataDict = DataDictFactory.getDBFactory();

    public String getConfigValue(String groupCode, String paramCode, String defaultString) {
        DictItem[] items = dataDict.findItem(groupCode);

        if (items != null) {
            for (DictItem item : items) {
                if (item.param_code.equals(paramCode)) {
                    return StringUtils.isEmpty(item.param_value) ? defaultString : item.param_value;
                }
            }
        }
        return defaultString;
    }
%><%
    request.setAttribute("home", request.getContextPath());

    String PORTAL_ID = request.getParameter("PORTAL_ID");
    if (StringUtils.isEmpty(PORTAL_ID)) {
        PORTAL_ID = "";
    }
    String PortalCfgName = !StringUtils.isEmpty(PORTAL_ID) ? "PORTAL_INIT_" + PORTAL_ID : "PORTAL_INIT";

    String menuTreeType = getConfigValue(PortalCfgName, "MENU_TYPE", "AccordMenu");

    String portalTitleName = getConfigValue(PortalCfgName, "TITLE_NAME", "新源重工车辆远程监控云平台");

    String rightInfo = getConfigValue(PortalCfgName, "RIGHT_INFO", "福建新源重工有限公司<br>福建省泉州市洛江经济开发区五金机电产业园<br><br>");

    String themes = getConfigValue(PortalCfgName, "THEMES", "green");

    String leftImgZoom = getConfigValue(PortalCfgName, "LEFT_IMG_ZOOM", "3/5");

    String leftImgTop = getConfigValue(PortalCfgName, "LEFT_IMG_TOP", "$(\"#loginTable\").css(\"top\")");

    //String leftImgLeft = getConfigValue(PortalCfgName, "LEFT_IMG_LEFT", "($(window).width() * 0.5-$(\"#leftImg\").width())-20");
	String leftImgLeft ="20";

    String rightTitleMargin = getConfigValue(PortalCfgName, "RIGHT_TITLE_MARGIN", "");

    String webRoot = request.getContextPath();
    if (!webRoot.endsWith("/")) webRoot = webRoot + "/";


    String defaultImgPath = getConfigValue(PortalCfgName, "IMG_PATH", webRoot + "plug-in/skin/images/");
   // String defaultImgPath = webRoot + "system/images/";
    if (!defaultImgPath.startsWith("/") && !defaultImgPath.startsWith("../")) {
        defaultImgPath = webRoot + defaultImgPath;
    }

    if (!defaultImgPath.endsWith("/")) defaultImgPath = defaultImgPath + "/";
%>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="shortcut icon" href="<%=defaultImgPath%>favicon.ico"/>
    <!--<link rel="stylesheet" href="../plug-in/skin/login_skin.jsp?PORTAL_ID=<%=PORTAL_ID%>>" type="text/css">-->
	 <link rel="stylesheet" href="../plug-in/skin/login_skin.jsp" type="text/css">
    <title><%=portalTitleName%>
    </title>
</head>
<body SCROLL="no" style="width:100%;height:100%;">
<img id="leftImg" style="position:absolute;left:0px;top:0px;display:none;z-index:2;"
     src="<%=defaultImgPath%>left_pic.png">
<img id="logoImg" style="position:absolute;left:125px;top:55px;z-index:100;display:none;" src="<%=defaultImgPath%>logo.png">
<img id="bodyBackImg" style="position:absolute;left:0;top:0;z-index:1;display:none">
<table id="loginTable" style="position:absolute;left:800px;top:200px;z-index:100;display:none;overflow:hidden" border=0
       CELLPADDING=0 CELLPACING=0>
    <tr style="margin:0px;padding:0px;border:1px solid green">
        <td style="margin:0px;padding:0px;border:0px solid red;height:88px;width:292px;background:url(<%=defaultImgPath%>right_title.png) no-repeat"></td>
    </tr>
    <%=rightTitleMargin%>
    <tr style="margin:0px;padding:0px;">
        <td valign=top style="margin:0px;padding:0px;border:0px solid red">
            <jsp:include flush="true" page="loginForm.jsp"></jsp:include>
        </td>
    </tr>
</table>
<div id="footArea">
    <%=rightInfo%>
</div>
<script type="text/javascript">
    var oldLeftPicWidth = 0;
    var oldLeftPicHeight = 0;
    var menuTreeType = "<%=menuTreeType%>";

    function justFootTop(){
        var winHeight = $(window).height();
        if (winHeight == 0)winHeight = $("body").height();
        //alert(winHeight + "||" + $("#footArea").height()+"||"+$("#footArea").position().top);
        while ($("#footArea").position().top + $("#footArea").height() < winHeight) {
            $("#footArea").css("top", $("#footArea").position().top + 1);
        }
    }

    function resizeFun() {
        var winWidth = $(window).width();
        if (winWidth == 0)winWidth = $("body").width();
        var winHeight = $(window).height();
        if (winHeight == 0)winHeight = $("body").height();


        //alert($("#footArea").width()+"||"+$("#footArea").height()+"||"+winHeight);


        if ($("#leftImg").height() != Math.floor(winHeight *<%=leftImgZoom%>))
            $("#leftImg").height(Math.floor(winHeight *<%=leftImgZoom%>));

        $("#leftImg").width(oldLeftPicWidth * $("#leftImg").height() / oldLeftPicHeight);


        var add = Math.floor((winWidth * 0.5 - $("#loginTable").width()) / 3);
        if (add < 0)add = 5;
        $("#loginTable").css("left", Math.floor(winWidth * 0.5) + add);
        $("#loginTable").css("top", Math.floor((winHeight - $("#loginTable").height()) / 2));

        $("#leftImg").css("left", <%=leftImgLeft%>);
        $("#leftImg").css("top", <%=leftImgTop%>);


        /*
        $("#footArea").css("top", winHeight - $("#footArea").height());
        $("#footArea").css("left", (winWidth - $("#footArea").width()) / 2);
        $("#footArea").show();
        justFootTop();
        */

        $("#leftImg").show();

        $("#loginTable").show();

        $("#bodyBackImg").width(winWidth);
        $("#bodyBackImg").height(winHeight);

        try {
            setVerImg();
        }
        catch (ex) {
        }
        if($("#footArea").width()!=winWidth){
            $("#footArea").width(winWidth);
        }
    }



    function loginCallBack(url, menuTreeType, targetPost, themes) {
        $.CookieUtil.put("themes", "<%=themes%>", -1, _CurrentWebAppHome);//默认样式 green bluesky salad
        try {
            if (PORTAL_ID) {
                if (url.indexOf("?") < 0)url = url + "?PORTAL_ID=" + PORTAL_ID;
                else url = url + "&PORTAL_ID=" + PORTAL_ID;
            }
        }
        catch (ex) {
        }
        if (url.indexOf("?") < 0)location.replace(url + "?menu_type=" + menuTreeType);
        else location.replace(url + "&menu_type=" + menuTreeType);
    }


    window.onload = new function () {
        try {
            $.ServiceAgent.setServiceUrl("${home}/service");
        }
        catch (ex) {
        }


        try {
            var url = "./index.jsp";
            if (menuTreeType == "dyn")url = "../desktop/index.jsp";
            loginPlugin.setLoginOption(url, menuTreeType, null, loginCallBack, "green");
        }
        catch (ex) {
        }

        try {

            var backImg = new Image();
            $(backImg).bind("load",function(){
                if (backImg.width > 60) {//使用不平铺的背景图，且拉升背景图和当前窗口一样大小
                    //alert($(window).width()+"||"+$(window).height());
                    //alert($(document.body).css("background-repeat"));
                    //$(document.body).css("background-repeat","no-repeat");
                    //$(document.body).css("background-position","top center");
                    //$(document.body).css("background-attachment","fixed");
                    //alert($(document.body).css("background-repeat"));

                    $(document.body).css("background", "url(<%=defaultImgPath%>nbsp.png) repeat");

                    $("#bodyBackImg").attr("src", backImg.src);
                    $("#bodyBackImg").show();
                }
                oldLeftPicWidth = $("#leftImg").width();
                oldLeftPicHeight = $("#leftImg").height();
                $("#logoImg").show();
                resizeFun();

                try{
                    loginInit();
                }
                catch(ex){
                }

                //alert($("#footArea").width()+"||"+$("#footArea").height());

                $(window).resize(function () {
                    setTimeout(resizeFun, 1);
                });
            });
            backImg.src = "<%=defaultImgPath%>bg.png";
            var themes = $.CookieUtil.get("themes");
        }
        catch (ex) {
        }

    }
</script>
</body>
</html>
