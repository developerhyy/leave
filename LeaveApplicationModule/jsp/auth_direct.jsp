<%@ page language="java" contentType="text/html; charset=UTF-8"%><%@page import="org.apache.commons.lang3.StringUtils"%><%@page import="cn.ict.starnet.framework.esb.call.imp.ServiceProxy"%><%@page import="org.apache.commons.lang3.math.NumberUtils"%><%@page import="cn.ict.starnet.framework.esb.call.imp.JsonServiceProxy,cn.ict.starnet.framework.dict.*,java.util.*"%><%!

  /**
    created by linguang 2013/08/13
    用于统一认证中心识别身份并授权跳转指定页面  
  */
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
	 response.setDateHeader("expires", 0);
	 response.setHeader("Cache-Control", "no-cache");
	 response.setHeader("pragma", "no-cache");
 
  String remoteUrl = getConfigValue("SYS_AUTH_CENTER", "RMI_URL", null);
  String sysAccount = getConfigValue("SYS_AUTH_CENTER", "SYS_ACCOUNT", null);
  String sysPwd = getConfigValue("SYS_AUTH_CENTER", "SYS_PWD", null);


  /*
  http://192.168.43.43:15001/portal/system/auth_direct.jsp?check_token=72d896d6-2a62-4c52-a3a0-8844d7b1d8ae&direct_url=account_manage.jsp
  */
     
  String check_token=request.getParameter("check_token");
	String direct_url=request.getParameter("direct_url");
	
	if(StringUtils.isEmpty(check_token)||StringUtils.isEmpty(direct_url)){
	   response.sendRedirect("error.htm");
	   //out.println("EMPTY");
	   return;
	}

  JsonServiceProxy<List<String>> jsonServiceProxy =new JsonServiceProxy("cn.ict.starnet.passport.service.PassportService", remoteUrl,
                                    List.class);

  try {
    jsonServiceProxy.setParam("sys_account", sysAccount);
    jsonServiceProxy.setParam("sys_pwd", sysPwd);
    if (sysPwd.length() > 30)
      jsonServiceProxy.setParam("is_encrypt", true);
    else
      jsonServiceProxy.setParam("is_encrypt", false);
    jsonServiceProxy.setParam("token", check_token);
    List<String> slaveAccounts=jsonServiceProxy.call("getAccountInfosByToken");
    
    //out.println(slaveAccounts);
  	if(slaveAccounts!=null&&slaveAccounts.size()>0){
      JsonServiceProxy<String[][]> 
         proxy =new JsonServiceProxy<String[][]>("cn.ict.starnet.system.service.LoginService",String[][].class);
      proxy.setParam("account", slaveAccounts.get(0));
      proxy.setParam("token", check_token);           
      proxy.setParam("client_ip", request.getRemoteAddr());
      String[][] results=proxy.call("login");
      

      for (int i = 0; i < results.length; i++) {

        Cookie cookie = new Cookie(results[i][0], java.net.URLEncoder.encode(results[i][1], "UTF-8"));
        cookie.setMaxAge(-1);
        cookie.setPath("/");
        
        try{
          response.addCookie(cookie);
        }
        catch(Exception ex){
        }  
      }    
      
      /*
      for (int i = 0; i < results.length; i++) {
        out.println(results[i][0]+"="+results[i][1]+"<br>");
      }
      */
      response.sendRedirect(direct_url);
      return;
    } 
    else{
    	response.sendRedirect("error.htm");
    	//out.println(check_token+"无效");
    	return;
  	} 
    
  }
  catch (Exception e) {
    out.println("<pre>"+e+"</pre>");
    //response.sendRedirect("error.htm");
    return;
  }    
%>