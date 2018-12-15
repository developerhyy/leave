<%@ page contentType="text/html;charset=UTF-8" %><%@ page import="cn.dy.base.framework.esb.call.imp.JsonServiceProxy,org.apache.commons.lang3.StringUtils,cn.dy.base.framework.dict.*" %><%!
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

    String PORTAL_ID=request.getParameter("PORTAL_ID");
    if(StringUtils.isEmpty(PORTAL_ID)){
        PORTAL_ID="";
    }
    String PortalCfgName=!StringUtils.isEmpty(PORTAL_ID)?"PORTAL_INIT_"+PORTAL_ID:"PORTAL_INIT";


    request.setAttribute("home", request.getContextPath());
    long nowTime = System.currentTimeMillis();

    String corpAccount = request.getParameter("corp_account");
    if (corpAccount == null) corpAccount = "";

    if (!StringUtils.isEmpty(corpAccount)) {
        JsonServiceProxy<String> jsonServiceProxy =
                new JsonServiceProxy<String>("cn.dy.base.system.service.CorporationService", String.class);
        jsonServiceProxy.setParam("corp_id", corpAccount);

        corpAccount = jsonServiceProxy.call("getCorporationAccount");
    }

    if (corpAccount == null) corpAccount = "";

    String useLineHeight="line-height: 42px;";
    String userAgent=request.getHeader("User-Agent");
    if(userAgent==null)userAgent="";
    if(userAgent.indexOf("MSIE")<0){
        useLineHeight="";
    }

    String webRoot=request.getContextPath();
    if(!webRoot.endsWith("/"))webRoot=webRoot+"/";


    String defaultImgPath=getConfigValue(PortalCfgName, "IMG_PATH", webRoot+"plug-in/skin/images/");

    if(!defaultImgPath.startsWith("/")&&!defaultImgPath.startsWith("../")){
        defaultImgPath=webRoot+defaultImgPath;
    }

    if(!defaultImgPath.endsWith("/"))defaultImgPath=defaultImgPath+"/";


    String defaultLoginAccountHint=getConfigValue(PortalCfgName, "LOGIN_ACCOUNT_HINT", "请输入您的登录帐号");

%><style>
    .login_input {
        width: 253px;
        height: 42px;
        vertical-align: middle;
        font-size: 14px;
        <%=useLineHeight%>
        border:1px solid #cbcbcb;
        color:#999999;
        margin: 0px;
        padding-top: 0px;
        padding-bottom: 0px;
        padding-left: 10px;
    }

    .login_input:focus{ outline:none }

    .loginForm tr {
        padding: 0px;
        margin: 0px;
    }

    .loginForm td {
        padding: 0px;
        margin: 0px;
    }

</style>
<script>
    var corpAccount = "<%=corpAccount%>";
    var _CurrentWebAppHome = "${home}";
    var PORTAL_ID="<%=PORTAL_ID%>";
</script>
<script type="text/javascript" src="${home}/scripts/jquery-1.8.1.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/mask/jquery.loadmask.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-cookie-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-service-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/jquery-form-plugin.js" charset="UTF-8"></script>
<!--<script type="text/javascript" src="${home}/assets/js/bootstrap.min.js" charset="UTF-8"></script>-->
<script type="text/javascript" src="${home}/assets/js/ie6.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/rsa/Barrett.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/rsa/BigInt.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/scripts/rsa/RSA.js" charset="UTF-8"></script>
<script type="text/javascript" src="${home}/system/login.js" charset="UTF-8"></script>
<form id="loginForm" style="margin:0px;padding:0px;border:0px solid green">
    <table style="margin:0px;padding:0px;border:0px solid blue" CELLPADDING=0 CELLSPACING=0>
        <tr>
            <td>
                <input class="login_input" tabIndex=1 type="text" id="username" name="username" maxlength="20"
                       login_holder="<%=defaultLoginAccountHint%>">
            </td>
        </tr>
        <tr>
            <td height=20px>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <input class="login_input" other="input_password" tabIndex=2 type="password" id="password"
                       login_holder="请输入您的密码" name="password" maxlength="20" style="display:none;"><input
                    class="login_input" other="password" tabIndex=2 type="text" id="input_password"
                    name="input_password" maxlength="20" login_holder="请输入您的密码">
            </td>
        </tr>
        <tr>
            <td height=20px>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <input class="login_input" tabIndex=3 type="text" id="rand_img" name="rand_img" maxlength="5"
                       login_holder="请输入校验码">
                <a id="jspImgArea" style="border:0px solid red;display:none;left:0px;top:0px;z-index:10000;position:absolute"
                   href="#"><img id="jspImg" border=0 src="about:blank"
                   style="height:31px;vertical-align:middle" onclick="loginPlugin.doChangeRandImg()" title="点击换一张"></a>
            </td>
        </tr>
        <tr>
            <td height=20px>&nbsp;</td>
        </tr>
        <tr>
            <td>
                <a href="#"><img id="loginButton"
                                 src="<%=defaultImgPath%>btn_login.png" onclick="loginPlugin.login();return false"
                                 border=0></a>
            </td>
        </tr>
    </table>
    <input id="client_ip" name="client_ip" type="hidden" value="">
    <input id="login_method" name="login_method" type="hidden" value="">
    <input id="force_login" name="force_login" type="hidden" value="">
</form>
<form id="loginInfo" action="" style="display: none" method="post">
    <input id="token_id" name="token_id" type="hidden" value="">
    <input id="corp_id" name="corp_id" type="hidden" value="">
    <input id="staff_id" name="staff_id" type="hidden" value="">
    <input id="client_ip" name="client_ip" type="hidden" value="">
    <input id="login_time" name="login_time" type="hidden" value="">
    <input id="staff_account" name="staff_account" type="hidden" value="">
    <input id="staff_nickname" name="staff_nickname" type="hidden" value="">
    <input id="corp_account" name="corp_account" type="hidden" value="">
    <input id="corp_name" name="corp_name" type="hidden" value="">
    <input id="corp_short_name" name="corp_short_name" type="hidden" value="">
    <input id="is_password_expired" name="is_password_expired" type="hidden" value="">
    <input id="login_method" name="login_method" type="hidden" value="">
    <input id="user_id" name="user_id" type="hidden" value="0">
    <input id="user_name" name="user_name" type="hidden" value="">
    <input id="dept_id" name="dept_id" type="hidden" value="0">
    <input id="dept_name" name="dept_name" type="hidden" value="">
    <input id="city_code" name="city_code" type="hidden" value="">
</form>
