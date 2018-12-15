<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
%>
<!DOCTYPE html>
<html class="no-js">
<head>
<jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
<script type="text/javascript">
var user_id = loginInfo.staff_id;
</script>
<link type="text/css" rel="stylesheet" href="${home}/scripts/fancybox/jquery.fancybox.css"/>
<script type="text/javascript" src="${home}/scripts/fancybox/jquery.fancybox.pack.js"></script>
<script type="text/javascript" src="../system/scripts/zDialog.js"></script>
<script type="text/javascript" src="../system/zDialog.js"></script>
   
    
<title>师傅编辑信息</title>
<style>
	.checkModule{
		border-radius: 20px;
		width: 20px;
		height: 20px;
		align-content: center;
		}
</style>
</head>

<body class="mainbody">
   <form  name = "form1" id="form1" method="post" enctype="multipart/form- data">
        <input name="imgfile" type="file" id="imgfile" size="40"  style="border: 1px solid #d4d4d4;display:none;" onchange="viewmypic(this.form.imgfile);" /> 
   </form> 
   <form method="post" id="infoForm">
        <!--导航栏-->
        <div class="location">
            <a onclick="doReturn();" class="back"><i></i><span>返回管理页面</span></a>
            <i class="arrow"></i>
            <span id="lbTitle">编辑类型</span>
        </div>
		<input type="hidden" id="lib_template_id" value= "1" />
		<input type="hidden" id="lib_url" value="template_1.jsp">
        <div class="tab-content" style="padding-bottom: 50px;">
            <dl>
                <dt>姓名</dt>
                <dd>
                    <input type="text" name="name" id="name" for="name"  class="input normal" sucmsg=" " 
                     maxlength="20"/> 
                    <span class="Validform_checktip">*必填</span>                
                </dd>
            </dl>
            <dl>
                <dt>出生年月</dt>
                <dd>
                	<div  class="input-date" >
										<input name="txtbeginDate" type="text" id="birthday" class="input date Validform_error"
										 onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})" errormsg="请选择正确的日期" style = "width:300px"/>
									</div>           
                </dd>
            </dl>
						<dl>
                <dt>性别</dt>
                <dd>
                   <div class="rule-single-select" style="float: left;">
				              <select name="sex" id="sex" datatype="*" sucmsg=" "
				                style="width: 150px;">
                    	<option value="M">男</option>
                    	<option value="F">女</option>
                    </select>
                  </div>     
                </dd>
            </dl>
            <dl>
                <dt>联系电话</dt>
                <dd>
                  <input type="text" name="contact_num" id="contact_num" for="contact_num" class="input normal" sucmsg=" "
                   onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')"  />
                  <span class="Validform_checktip">*必填，全局唯一</span> 
                </dd>
            </dl>

			     <dl>
            	<dt>服务星级</dt>
                <dd>
                   <div id="star_level_d" style="float:left"></div>
				              <input type="text" name="star_level" id="star_level" datatype="*" class="input normal" sucmsg=" " style="width:50px"
                   onkeyup="this.value=this.value.replace(/[^\d.]/g,'')"  onafterpaste="this.value=this.value.replace(/[^\d.]/g,'')" onchange = level_change();>
								<span class="Validform_checktip">*请输入0~5.0的任意数字</span> 
                </dd>
            </dl>
            <dl>
                <dt>归属县市</dt>
                <dd>
                   <div class="rule-single-select"
				              style="float: left;">
				              <select name="province_code" id="province_code" datatype="*" sucmsg=" "
				                style="width: 150px;" onchange="show_relate_span('1',this.value,'city_code');changeCode();">
				              </select>
				            </div>
				
				            <div class="rule-single-select"
				              style="float: left; margin-left: 5px;">
				              <select name="city_code" id="city_code" datatype="*" sucmsg=" "
				                style="width: 150px;" onchange="show_relate_span('2',this.value,'county_code');changeCode();">
				              </select>
				            </div>
				
				            <div class="rule-single-select"
				              style="float: left; margin-left: 5px;">
				              <select name="county_code" id="county_code" datatype="*" sucmsg=" "
				                style="width: 100px;" onchange="changeCode();">
				              </select>
            			</div>
            			<span class="Validform_checktip">*必填</span>
                </dd>
            </dl>
            <dl>
            	<dt>归属渠道</dt>
                <dd>
                	<input type="text" name="cn_name" id="cn_name" for="cn_name" class="input normal" sucmsg=" " />
				           <input type="button" name="btnSubmit" value="选择" id="btnSubmit" class="btn" onclick="click_ShowAction()"/>
				          <span class="Validform_checktip">*必填</span>
                </dd>
                <dd style="display:none">
                	<input type="text" name="channel_id" id="channel_id" for="channel_id" onchange="channelValue();" class="input normal" sucmsg=" " />
                </dd>
            </dl>
            <dl>
                <dt>类别</dt>
                <dd>
                   <div class="rule-single-select" style="float: left;">
				              <select name="type" id="type" datatype="*" sucmsg=" "
				                style="width: 100px;">

                    </select>
                  </div>     
                </dd>
            </dl>
            <dl>
                <dt>业务范围</dt>
                <dd>
                  <input type="text" name="biz_name" id="biz_name" for="biz_name" class="input normal" sucmsg=" " />
                   <input type="button" name="btnSubmit" value="选择" id="btnSubmit" class="btn" onclick="doSelectServiceItem();"/>
                  <span class="Validform_checktip">*必填</span> 
                </dd>
                <dd style="display:none;">
                  <input type="text" name="biz_id" id="biz_id" for="biz_id" class="input normal" sucmsg=" " />
                </dd>
            </dl>
            <dl>
                <dt>保证金</dt>
                <dd>
                  <input type="text" name="cash_pledge" id="cash_pledge" for="cash_pledge" class="input normal" sucmsg=" " 
                  onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                  
                  <span class="Validform_checktip">*必填，单位元</span> 
                </dd>
            </dl>
             <dl id="idcard_url">
                <dt>手持身份证照</dt>
                <dd>                                           
                      <input type="text" name="img_url1" id="img_url1" for="img_url1"  class="input normal" sucmsg=" " 
                      placeholder="请选择手持身份证照1" onclick="myFocus('imgfile','img_url1','showimg1');"/>  
                      <img name="showimg1" id="showimg1" src="" style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" />
                      <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg1','img_url1');" />
                      <span class="Validform_checktip">*不大于1M的图片</span>                    
                </dd>
              <!--  <dd>                            
                      <input type="text" name="img_url2" id="img_url2" for="img_url2"  class="input normal" sucmsg=" " 
                      placeholder="请选择手持身份证照2"  onclick="myFocus('imgfile','img_url2','showimg2');"/>
                       <img name="showimg2" id="showimg2" src=""  style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" /> 
                       <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg2','img_url2');" />  
                      <span class="Validform_checktip">*不大于1M的图片</span>
                </dd> -->
             </dl>
            
             <dl id="jobcard_url">
             	<dt>工作证件照</dt>
                <dd>                         
                      <input type="text" name="img_url3" id="img_url3" for="img_url3"  class="input normal" sucmsg=" " 
                      placeholder="请选择工作证件照1"  onclick="myFocus('imgfile','img_url3','showimg3');"/>
                       <img name="showimg3" id="showimg3" src="" style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" />
                       <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg3','img_url3');" />
                       <input type="button" name="btnReturn" value="删除图片" class="btn" onclick="delImg('img_url3');" />
                      <span class="Validform_checktip">*不大于1M的图片</span>                     
                </dd>
                <dd>                            
                      <input type="text" name="img_url4" id="img_url4" for="img_url4"  class="input normal" sucmsg=" " 
                      placeholder="请选择工作证件照2" onclick="myFocus('imgfile','img_url4','showimg4');"/>
                       <img name="showimg4" id="showimg4" src="" style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" />
                       <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg4','img_url4');" />
                       <input type="button" name="btnReturn" value="删除图片" class="btn" onclick="delImg('img_url4');" />    
                     <span class="Validform_checktip">*不大于1M的图片</span>
                </dd>
                <dd>                            
                      <input type="text" name="img_url5" id="img_url5" for="img_url5"  class="input normal" sucmsg=" " 
                      placeholder="请选择工作证件照3" onclick="myFocus('imgfile','img_url5','showimg5');"/>
                       <img name="showimg4" id="showimg4" src="" style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" />
                       <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg5','img_url5');" />
                       <input type="button" name="btnReturn" value="删除图片" class="btn" onclick="delImg('img_url5');" />    
                     <span class="Validform_checktip">*不大于1M的图片</span>
                </dd>    
                <dd>                            
                      <input type="text" name="img_url6" id="img_url6" for="img_url6"  class="input normal" sucmsg=" " 
                      placeholder="请选择工作证件照4" onclick="myFocus('imgfile','img_url6','showimg6');"/>
                       <img name="showimg4" id="showimg4" src="" style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" />
                       <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg6','img_url6');" />
                       <input type="button" name="btnReturn" value="删除图片" class="btn" onclick="delImg('img_url6');" />    
                     <span class="Validform_checktip">*不大于1M的图片</span>
                </dd>    
                <dd>                            
                      <input type="text" name="img_url7" id="img_url7" for="img_url7"  class="input normal" sucmsg=" " 
                      placeholder="请选择工作证件照5" onclick="myFocus('imgfile','img_url7','showimg7');"/>
                       <img name="showimg4" id="showimg4" src="" style="width:8%;height:8%;border:1px;border-style:solid;border-color:#f60;display:none;" alt="预览图片" />
                       <input type="button" name="btnReturn" value="预览图片" class="btn" onclick="openImg('showimg7','img_url7');" />
                       <input type="button" name="btnReturn" value="删除图片" class="btn" onclick="delImg('img_url7');" />    
                     <span class="Validform_checktip">*不大于1M的图片</span>
                </dd>                               
						</dl>
      			<dl>
                <dt>银行卡号</dt>
                <dd>
                  <input type="text" name="card_no" id="card_no" for="card_no" class="input normal" sucmsg=" " 
                  onkeyup="this.value=this.value.replace(/\D/g,'')"  onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                  
                  <span class="Validform_checktip">*必填</span> 
                </dd>
            </dl>
            <dl>
                <dt>个人说明</dt>
                <dd>
                  <input type="text" name="resume" id="resume" for="resume" class="input normal" sucmsg=" " />
                  
                  <span class="Validform_checktip">*必填</span> 
                </dd>
            </dl>
            <dl>
                <dt>业务状态</dt>
                <dd>
                   <div class="rule-single-select" style="float: left;">
				              <select name="sts" id="sts" datatype="*" sucmsg=" "
				                style="width: 150px;">
                    </select>
                  </div>     
                </dd>
                <span class="Validform_checktip">*必填</span> 
            </dl>
            <dl>
                <dt>安全密码</dt>
                <dd>
                  <input type="password" name="tx_pwd" id="tx_pwd" for="tx_pwd" class="input normal" sucmsg=" " />
                  
                  <span class="Validform_checktip">*必填</span> 
                </dd>
            </dl>

      

        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
                <input type="button" name="btnSubmit" value="保存" id="btnSubmit" class="btn" onclick="doCommit();"/>
                <input type="button" name="btnReturn" value="返回上一级" class="btn yellow" onclick="doReturn();" />
            </div>
            <div class="clear"></div>
        </div>

  <!-- ueditor -->
<script id="recharge-tpl" type="text/template">
        <div class="tab-content">
        	<div style="overflow:auto;height:250px;width:930px">
		       <table style="width: 900px" border="0" cellspacing="0" cellpadding="0"
			        class="ltable" id="tp_resultgrid" style="width:70px">
				      <tr>
				        <th width="12%" align="center">选择</th>
				        <th width="22%" align="center">省</th>
				        <th width="22%" align="center">市</th>
				        <th width="22%" align="center">县</th>
				        <th width="22%" align="center">渠道名称</th>
				      </tr>
				    <tbody id="tp1_t_body">
			
				    </tbody>
	  		  </table>
	  		  </div>
        </div>
</script>

  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.config.js"></script>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.all.min.js"> </script>
  <script type="text/javascript" charset="utf-8" src="${home}/ueditor/lang/zh-cn/zh-cn.js"></script>
  <link type="text/css" rel="stylesheet" href="${home}/system/common/css/star.css"/>
  <script src="${home}/system/common/scripts/star.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/worker_info.js"></script>
	<script type="text/javascript">
    	var worker_type = "";
    	var wz_id="";
    	var nowDateTime = ""; 
	</script>
</body>
</html>
