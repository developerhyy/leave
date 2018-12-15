<%@ page import="org.apache.commons.lang3.StringUtils" %>
    <%@ page import="java.io.File" %>
        <%@page import="cn.dy.base.framework.dict.IDataDict"%>
            <%@page import="cn.dy.base.framework.dict.DataDictFactory"%>
                <%@ page contentType="text/html;charset=UTF-8" %>
                    <%!
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
%>
                        <%
    request.setAttribute("home", request.getContextPath());
   IDataDict dataDict = DataDictFactory.getDBFactory();
   String IMG_SERVICE_HOST_NAME ="http://"+ dataDict.decodeParam("SYSTEM_CONFIG", "IMG_SERVICE_HOST_NAME");
   String XWM_WEB_HOST_NAME =dataDict.decodeParam("SYSTEM_CONFIG", "XWM_WEB");
%>
                            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                            <meta http-equiv="Cache-Control" content="no-store" />
                            <meta http-equiv="Pragma" content="no-cache" />
                            <meta http-equiv="Expires" content="0" />
                            <link rel="shortcut icon" href="${home}/plug-in/skin/images/favicon.ico" />
                            <link rel="bookmark" href="${home}/plug-in/skin/images/favicon.ico" />
                            <link type="text/css" rel="stylesheet" href="${home}/scripts/mask/jquery.loadmask.css" />
                            <script>
                                var _CurrentWebAppHome = "${home}";
                            </script>
                            <script type="text/javascript" src="${home}/scripts/jquery-1.8.1.min.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/scripts/mask/jquery.loadmask.min.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/scripts/jquery-cookie-plugin.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/scripts/jquery-service-plugin.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/scripts/jquery-form-plugin.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/scripts/jquery-validate-plugin.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/scripts/util.js" charset="UTF-8"></script>
                            <script type="text/javascript" src="${home}/plug-in/js/mouse/mouse.js"></script>
                            <script type="text/javascript" src="${home}/system/common/scripts/lhgdialog/lhgdialog.js?self=true&skin=idialog"></script>
                            <script type="text/javascript" src="${home}/system/common/scripts/layout.js"></script>
                            <script type="text/javascript" src="${home}/system/common/scripts/datepicker/WdatePicker.js"></script>
                            <script>
                                $.CookieUtil.put("themes", "bluesky", -1, _CurrentWebAppHome); //默认样式 green bluesky salad
                            </script>
                            <script type="text/javascript" src="${home}/scripts/LoginInfo.js" charset="UTF-8"></script>
                            <link href="${home}/system/common/skin/default/style.css" rel="stylesheet" type="text/css" />
                            <link href="${home}/system/common/css/pagination.css" rel="stylesheet" type="text/css" />
                            <link href="${home}/system/common/skin/default/index.css" rel="stylesheet" type="text/css" />
                            <script type="text/javascript">
                                if (loginInfo == null || !loginInfo.token_id) {
                                    //alert("登录已经过期，请重新登录");
                                    //top.location.replace("${home}/login.jsp");
                                }

                                loginInfo.setContextPath("${home}");


                                document.onkeydown = function(eventObj) {
                                    if (!eventObj) eventObj = window.event;
                                    if (eventObj.keyCode == 8) //屏蔽退格删除键
                                    {
                                        //新增一个判断条件，输入框如果是只读状态，也需要屏蔽退格删除键
                                        if (eventObj.srcElement.readOnly || (eventObj.srcElement.tagName.toUpperCase() != "INPUT" &&
                                                eventObj.srcElement.tagName.toUpperCase() != "TEXTAREA" &&
                                                eventObj.srcElement.tagName.toUpperCase() != "TEXT")) {
                                            eventObj.keyCode = 0;
                                            eventObj.returnValue = false;
                                        }
                                    }
                                };

                                var oldWindowAlertFun = null;

                                $(function() {
                                    try {
                                        $.ServiceAgent.setServiceUrl("${home}/service");
                                    } catch (ex) {}

                                    oldWindowAlertFun = window.alert;

                                    window.customerAlert2 = function(msg) {
                                        if (self.alertMessage) {
                                            self.alertMessage(msg);
                                        } else {
                                            var oWin = self;
                                            var openerWin = self;
                                            while (oWin) {
                                                if (oWin.alertMessage) {
                                                    oWin.alertMessage(msg);
                                                    return;
                                                }
                                                if (oWin != oWin.parent) oWin = oWin.parent;
                                                else break;
                                            }
                                            while (openerWin) {
                                                if (openerWin.alertMessage) {
                                                    openerWin.alertMessage(msg);
                                                    return;
                                                }
                                                if (openerWin != openerWin.opener) openerWin = openerWin.opener;
                                                else break;
                                            }
                                            oldWindowAlertFun(msg);
                                        }
                                    }
                                });


                                //获取图片完整路径
                                function getImgUrl(url) {
                                    return "<%=IMG_SERVICE_HOST_NAME%>" + url;
                                };
                                //获取图片相对路径
                                function getRelativeImgUrl(url) {
                                    //return url.replace(reg,'');
                                    var reg = "<%=request.getContextPath()%>";
                                    return url.substr(url.indexOf(reg));
                                };
                            </script>