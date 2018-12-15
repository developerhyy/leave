<%@ page contentType="text/html; charset=utf-8" %>
    <%@page import="org.apache.commons.lang3.StringUtils,cn.dy.base.framework.dict.*,java.io.*" %>
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

    public String check(ServletContext app, String configPath) {
        if (!StringUtils.isEmpty(configPath)) {

            String webRoot = app.getContextPath();
            if ("/".equals(webRoot))webRoot = "";


            if (configPath.startsWith("/")) {
                configPath =configPath.substring(1);
            }

            String filePath = app.getRealPath("/"+configPath);//这个肯定不能包含当前web应用路径



           // System.out.println("webRoot="+webRoot+",filePath="+filePath);

            File file = new File(filePath);
            if (!file.exists() || !file.isFile()) {
                configPath = "";
            }
        } else configPath = "";

        return configPath;
    }


%>
            <%
    //System.out.println(application.getContextPath()+","+application.getRealPath("/portal/system/customer_add.jsp"));
	String PortalCfgName="PORTAL_INIT";
    String corpAccount = request.getParameter("corp_account");
    if (corpAccount == null) corpAccount = "";
    String menuTreeType = request.getParameter("menu_type");
    if (menuTreeType == null) {//TreeMenu///AccordMenu
		menuTreeType =getConfigValue(PortalCfgName,"MENU_TYPE","AccordMenu");
		//menuTreeType = "AccordMenu";
	}
    boolean sessionCreated = false;
    Cookie[] cookies = request.getCookies();
    if (cookies != null && cookies.length > 0) {
        for (int j = 0; j < cookies.length; j++) {
            String cookieName = cookies[j].getName();
            //System.out.println(cookieName+",path="+cookies[j].getPath());
            if ("token_id".equals(cookieName)) {
                sessionCreated = true;
                break;
            }
        }
    }
    if (!sessionCreated) {
        String params=request.getQueryString();
        if(StringUtils.isEmpty(params))response.sendRedirect("login.jsp");
        else response.sendRedirect("login.jsp?"+params);
        return;
    }


   // String PORTAL_ID=request.getParameter("PORTAL_ID");
   // if(StringUtils.isEmpty(PORTAL_ID)){
    String  PORTAL_ID="";
   // }
    //String PortalCfgName=!StringUtils.isEmpty(PORTAL_ID)?"PORTAL_INIT_"+PORTAL_ID:"PORTAL_INIT";


    String portalTitleName=getConfigValue(PortalCfgName,"TITLE_NAME","管理平台系统");


    String DIS_ORG_NAME=getConfigValue(PortalCfgName,"DIS_ORG_NAME","0");

    out.clear();
    //System.out.println(getConfigValue(PortalCfgName, "INIT_PAGE_URL", null));
    String INIT_PAGE_URL = check(application, getConfigValue(PortalCfgName, "INIT_PAGE_URL", null));
    //System.out.println(INIT_PAGE_URL);
    String INCLUDE_PAGE = check(application, getConfigValue(PortalCfgName, "INCLUDE_PAGE", null));

    String HELP_PAGE = check(application, getConfigValue(PortalCfgName, "HELP_PAGE", null));

    String USE_SKIN_BUTTON = getConfigValue(PortalCfgName, "USE_SKIN_BUTTON", "");

    String TRUST_DOMAINS = getConfigValue("SYS_AUTH_CENTER", "TRUST_DOMAINS", "");
	String THEMES=getConfigValue(PortalCfgName,"THEMES","green");

    if (!StringUtils.isEmpty(INCLUDE_PAGE)){
        INCLUDE_PAGE="../"+INCLUDE_PAGE;
    }

    if (!StringUtils.isEmpty(HELP_PAGE)){
        HELP_PAGE="../"+HELP_PAGE;
    }
%>
                <html lang="zh-cn">

                <head>
                    <title>
                        <%=portalTitleName%>
                    </title>
                    <link rel="stylesheet" href="../scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
                    <link rel="stylesheet" href="../plug-in/skin/index_skin.jsp?PORTAL_ID=<%=PORTAL_ID%>" type="text/css">
                    <link rel="stylesheet" type="text/css" href="msg.css" />
                    <jsp:include flush="true" page="common_inc.jsp"></jsp:include>
                    <script type="text/javascript" src="../scripts/zTree/js/jquery.ztree.all-3.5.min.js"></script>
                    <script type="text/javascript" src="accordion.js"></script>
                    <script type="text/javascript" src="msg.js"></script>
                    <script type="text/javascript" src="../scripts/pinyin.js" charset="UTF-8"></script>
                    <script type="text/javascript" src="/xyzg/carspace111/js/car_monitor.js?v=1"></script>
                    <script type="text/javascript">
                        var corpAccount = "<%=corpAccount%>";
                        var menuTreeType = "<%=menuTreeType%>";
                        var INIT_PAGE_URL = "<%=INIT_PAGE_URL%>";
                        var TRUST_DOMAINS = "<%=TRUST_DOMAINS%>";
                        var USE_SKIN_BUTTON = "<%=USE_SKIN_BUTTON%>";
                        var DIS_ORG_NAME = "<%=DIS_ORG_NAME%>";
                        $.CookieUtil.put("themes", "<%=THEMES%>", -1, _CurrentWebAppHome);
                    </script>
                    <script type="text/javascript" src="index.js"></script>
                    <script type="text/javascript" src="./common/scripts/zDialog.js"></script>
                </head>

                <body style="width: 100%;margin: 0px; padding:0px;overflow: hidden;" SCROLL="no">
                    <table class="workzone">
                        <tr class="banner_bg">
                            <td class="banner">
                                <!-- div style="position: relative; top: 18px; left: 315px;">管理平台</div-->
                                <div id="shortcut" style="position: absolute; width: 100%; height: 30px; left: 0px; top: 8px; text-align: right;"></div>
                                <div id="statusbar" style="color:#333333;position: absolute; width: 100%; height: 20px; left: 0px; top: 36px; text-align: right;">

                                </div>
                            </td>
                        </tr>

                        <tr style="marging:0px;padding:0px;width:100%;height:1px;">
                            <td style="marging:0px;padding:0px;width:100%;height:1px;">
                                <div class="banner_line"></div>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <div id="layout" style="position: relative; width: 100%; height: 100%; margin: 0px; overflow: hidden;"></div>
                            </td>
                        </tr>
                        <tr style="display:none">
                            <td>
                                <div id="buttonDiv" style="text-align:center;width:100%;height:40px;margin:0px;margin-top:5px;padding:0;border:0;">
                                    <input type="button" _class="ok" value="确定" />
                                    <input type="button" _class="cancel" value="取消" />
                                </div>
                            </td>
                        </tr>
                        <tr style="display:none">
                            <td>
                                <div id="MenuShow" style="width: 100%; height: 100%; display:none;">
                                    <table border=0 width="100%" height="100%">
                                        <tr height="23">
                                            <td id="searchArea" align="center" valign=top style="padding:3px">
                                                <table width="100%" height="23" border="0">
                                                    <tr>
                                                        <td valign=top style="height:23px;margin: 0px;">
                                                            <div id="search_key" style="width:100%; height:23px;"></div>
                                                        </td>
                                                        <td id="refreshBtnArea" valign=top align=center style="height:23px;">
                                                            <input type="button" style="height:23px;margin: 0px;padding:0px;" value="刷新" onclick="loadMenu();return false;">
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr height="100%">
                                            <td valign=top style="width:100%;height:100%;">
                                                <div id="menuArea" valign=top style="overflow:auto;width:100%;height:100%;border:0px solid red">
                                                    <%if ("AccordMenu".equals(menuTreeType)) {%>
                                                        <ul class="nav" id="menu"></ul>
                                                        <%} else {%>
                                                            <ul class="ztree" id="menu"></ul>
                                                            <%}%>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>

                    </table>

                    <!-- 右键 -->
                    <div id="rMenu2" class="ztreeRightMenucss" onmouseout="rMenuOut(event)">
                        <ul>

                            <li id="tabCloseAll" onclick="tabCloseAll(event);" onmouseout="mouseOut('tabCloseAll')" onmouseover="mouseIn('tabCloseAll')">关闭全部
                            </li>
                            <li id="tabCloseOther" onclick="tabCloseOther(event);" onmouseout="mouseOut('tabCloseOther')" onmouseover="mouseIn('tabCloseOther')">关闭其他
                            </li>
                            <li id="tabCloseSelf" onclick="tabCloseSelf(event);" style="border: none;" onmouseout="mouseOut('tabCloseSelf')" onmouseover="mouseIn('tabCloseSelf')"> 关闭自身
                            </li>


                        </ul>
                    </div>

                    <%if (!StringUtils.isEmpty(INCLUDE_PAGE)) {%>
                        <jsp:include flush="true" page="<%=INCLUDE_PAGE%>"></jsp:include>
                        <%}%>


                            <%if (!StringUtils.isEmpty(HELP_PAGE)) {%>
                                <jsp:include flush="true" page="<%=HELP_PAGE%>"></jsp:include>
                                <%}%>


                </body>

                </html>