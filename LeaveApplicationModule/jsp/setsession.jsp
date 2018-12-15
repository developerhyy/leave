<%@ page language="java" pageEncoding="UTF-8"%>
<%
  String[] cookieNames = { "token_id", "staff_id", "corp_id", "staff_account", "corp_account", "staff_nickname", "corp_name",
      "corp_short_name", "login_method","user_id" };

  boolean sessionCreated = false;
  Cookie[] cookies = request.getCookies();
  if (cookies != null && cookies.length > 0) {
    for (int i = 0; i < cookieNames.length; i++) {//判断cookie是否在这之前已经设置，若设置则不再设置
      boolean setted = false;      
      for (int j = 0; j < cookies.length; j++) {
        String cookieName = cookies[j].getName();
        System.out.println(cookieNames[i]+"!="+cookieName);
        if (cookieNames[i].equals(cookieName)) {
          //System.out.println(cookieNames[i]+"="+cookieName);
          setted = true;
          break;
        }
      }
      if (!setted) {//某个还未设置
        break;
      } else {
        if (i == cookieNames.length - 1) {//全部都已经设置
          sessionCreated = true;
        }
      }
      //System.out.println(sessionCreated+" "+ cookies.length);
    }
    if (!sessionCreated) {//cookie还为设过，清空其他cookie    
      for (int j = 0; j < cookies.length; j++) {
        String cookieName = cookies[j].getName();
        //System.out.println(cookies[j].getName()+" = "+cookies[j].getValue());
        //cookies[i].setPath("/");
        cookies[j].setMaxAge(0);//
        cookies[j].setValue(java.net.URLEncoder.encode(cookies[j].getValue(), "UTF-8"));
        response.addCookie(cookies[j]);
      }
    }
  }

  if (!sessionCreated){
    try {
      for (int i = 0; i < cookieNames.length; i++) {
        Cookie cookie = new Cookie(cookieNames[i], java.net.URLEncoder.encode(request.getParameter(cookieNames[i]), "UTF-8"));
        cookie.setMaxAge(-1);
        cookie.setPath("/");
        response.addCookie(cookie);
      }
      sessionCreated = true;
    } catch (Exception e) {
      //response.sendRedirect("./login.jsp");
    }
  }
%>