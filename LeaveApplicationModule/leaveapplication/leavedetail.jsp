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


    <title>请假详情</title>
    <style>
			*{
				font-weight: 400;
			}
        .checkModule{
            border-radius: 20px;
            width: 20px;
            height: 20px;
            align-content: center;
        }
				
					dl dt{
						margin-left: 40px;
				}
				.tab-content dl dt{
					color: #000000;
					font-size: 18px;
					font-weight: 400;
					
				}
				label{
					font-size: 18px;
					color:#3296fa;
					font-weight: 400;
					margin-left: 20px;
				}
				.line{
					border-bottom: 1px solid #dddddd;
					margin-bottom: 44px;
					margin-top: 20px;
				}
				.cl:after{
					clear: both;
					height: 0;
					content: '';
					display:block;
				}
				
				.state .title1{
					    font-size: 18px;
							font-weight: 400;
							margin:13px 35px 0 100px;
							color: #000;
							float: left;
							width: 80px;
				}
				.state img{
					display: block;
					float: left;
				}
				.mainss{
					float:left;
					width: 500px;
				}
				.mainss .state{
					width: 100%;
					margin-bottom: 30px;
					position: relative;
				}
				.mainss .state img{
					    width: 28px;
							height: 28px;
							margin-top: 9px;
							z-index: 5;
							position: relative;
							display: block;
				}
				.mainss .state .content{
					/* background: #f1f9fc; */
					margin-left: 60px;
					width: 400px;
					padding: 14px 20px;
					line-height: 20px;
					font-weight: 400;
					font-size: 16px;
					position: relative;
					margin-bottom: 30px;
				} 
				.mainss .state .content .name{
					color: #000000;
					margin-right: 20px;
				}
				.mainss .state .content .status{
					color: #dddddd;
				}
				.statuss{
					color: #3296FA;
				}
				.mainss .state .content .time{
					    position: absolute;
						right: 20px;
						top: 12px;
						width: 165px;
						height: 20px;
						font-size: 16px;
						color: #666666;
						text-align: center;
				}
				.btn{
					width: 120px;
					height: 40px;
					margin: 0px 40px 0 0;
					border: 1px solid #288ff4;
					color: #288ff4;
					font-size: 16px;
					background-color: #fff;
					border-radius: 5px;
				}
				.page-footer .btn-list{
					    padding: 10px 218px;
				}
				.line2{
					    width: 13px;
							height: 130px;
							position: absolute;
							border-right: 2px solid #dddddd ;
							top: -29px;
							z-index: -1;
							left: 0;
				}
				.remark{
					height: 32px;
					font-size: 16px;
					white-space: pre-wrap;
					overflow: hidden;
					overflow-y: auto;
					line-height: 16px;
					margin-top:15px ;
					color: #666666;
					
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
        <span id="lbTitle">请假详情</span>
    </div>
    <input type="hidden" id="lib_template_id" value= "1" />
    <input type="hidden" id="lib_url" value="template_1.jsp">
    <div class="tab-content" style="padding-bottom: 10px;">
        <dl>
            <dt>请假类型：</dt>
            <dd>
                <label id="leavetype"></label>
            </dd>
        </dl>
        <dl>
            <dt>开始时间：</dt>
            <dd>
                <label id="begintime"></label>
            </dd>
        </dl>
        <dl>
            <dt>结束时间：</dt>
            <dd>
                <label id="endtime"></label>
            </dd>
        </dl>
        <dl>
            <dt>时长：</dt>
            <dd>
                <label id="day"></label>
            </dd>
        </dl>

        <dl>
            <dt>请假事由：</dt>
            <dd>
                <label id="reason"></label>
            </dd>
        </dl>
				<div class="line"></div>
       <!-- <dl>
            <dt>审批人员</dt>
            <dd>
                <input type="button" name="approver1" id="approver1" for="approver1" class="input normal" sucmsg=" " />
                <span class="Validform_checktip">*必填</span>
            </dd>
            <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员" class="btn" onclick="alert('新增人员');" />
            </dd>
        </dl> -->
				<div class="state cl">
					<div class="title1">审批状态:</div>
					<div class="mainss cl" id='mainss'>
						<div class="state cl">
							<div class="line2" style="border-right-color: rgb(50, 150, 250);top: 0px;height: 60px;"></div>
							<img class="img" id="img0" src="img/through.png">
							<div class="content cl" style="background: rgb(241, 249, 252);">
								<span class="name" id="approver00"></span>
							<span class="status" id="status00" style="color: rgb(50, 150, 250);">发起申请</span>
							<div class="time" id="time00"></div></div></div>
					</div>
				</div>
    </div>
    <div style="padding-bottom: 10px;align-content: center">
        <textarea name="remark" style="display: none" id="txtareaRemark" cols="30" rows="10"></textarea>
    </div>
</form>
        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
				<input type="button" id="btnReturn" name="btnReturn" value="返回" class="btn" onclick="doReturn();" />
                <input type="button" style="display: none" id="btnBackoff" name="btnBackoff" value="撤回" id="btnSubmit" class="btn" onclick="doCommit();"/>
                <input type="button" style="display: none" id="btnEdit" name="btnEdit" value="修改" class="btn" onclick="" />
                <input type="button" style="display: none" id="btnPass" name="btnPass" value="审批通过" class="btn" onclick="" />
                <input type="button" style="display: none" id="btnReject" name="btnPass" value="审批不通过" class="btn" onclick="" />
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
			
                   function doReturn(){
                       window.history.back(-1);
                       parent.diag.close();
                   }
                   function getLeaveDetail(id){
                           var head = {
                               "service_name" : "LeaveManageService",
                               "operation_name" : "getLeave",
                               "token_id" : "",
                               "user_id" : "",
                               "version" : "0100",
                               "timestamp" : "",
                               "request_seq" : "",
                               "request_source" : ""
                           };
                           var options = {"handleError" : true};
                           var param = {leave_id:id};
                           function callBack(data) {
								console.log($.JsonUtil.jso2json(data))
                               if(data.response_code==0){
                                   infoForm(data.content.result);
								   
                               }else{
                                   alert(data.response_detail);
                               }
                           }
                           $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                   }
       
                   function getAuditDetail(id){
                       var head = {
                           "service_name" : "LeaveManageService",
                           "operation_name" : "getAudit",
                           "token_id" : "",
                           "user_id" : "",
                           "version" : "0100",
                           "timestamp" : "",
                           "request_seq" : "",
                           "request_source" : ""
                       };
                       var options = {"handleError" : true};
       //alert($.JsonUtil.jso2json(blob));
                       var param = {leave_id:id};
                       function callBack(data) {
                           if(data.response_code==0){
                               infoAuditForm(data.content.result);
							   
							   
                           }else{
                               alert(data.response_detail);
                           }
						   
                       }
                       $.ServiceAgent.JSONInvoke(head, param, callBack, options);
                   }
                   function infoForm(result){
                       $("#leavetype").html(result.leave_type);
                       $("#begintime").html(result.begin_time);
                       $("#endtime").html(result.end_time);
                       $("#day").html(result.duration);
                       $("#reason").html(result.reason);
											 $("#approver00").html(result.apply_name);
											 $("#time00").html(result.create_time);
												//console.log(result);
					  
                   }
				  
                   function infoAuditForm(result){
                       console.log(result);
					   for(var $i = 0; $i < result.length;$i++){
							var $approver='approver'+$i;
							var $status='status'+$i;
							var $time='time'+$i;
						   var $str='<div class="state cl">'+'<div class="line2"></div><img class="img" id=img'+$i+' src="img/wait.png">'+'<div class="content cl"><span class="name" id=approver'+$i+'></span><span class="status" id=status'+$i+'></span><div class="time" id=time'+$i+'></div><div class="remark" id=remark'+$i +'></div></div></div>';
								
						  
							$('#mainss').append($str);
							
							if(result[$i].audit_sts == 1){
								$('.img').attr('src','img/through.png');
								$('.status').css('color','#3296FA');
								$('.content').css('background','#f1f9fc');
								$('.line2').css('border-right-color','#3296fa');
								$('#remark'+$i).html(result[$i].audit_remark);
								$('#time'+$i).html(result[$i].create_time);
							}
							
							$('#status'+$i).html(result[$i].audit_stsTxt);
							$('#status'+$i).html(result[$i].audit_stsTxt);
							
							$('#name'+$i).html(result[$i].create_time);
							$('#approver'+$i).html(result[$i].audit_name);
							
					   }
					   $('.line2:last').css('height','94px');
                   }

                   $(function(){
                       var leaveId = getUrlParam('leaveId');
                       var approve = getUrlParam("approve");
                       var leave = getUrlParam("leave");

                       if(leaveId == null){
                           alert("假条不存在");
                           return;
                       }
                       if(approve != null ){//false不能通过
                           if(approve){
                               $("txtareaRemark").css("display","block");
                               $("btnPass").css("display","block");
                               $("btnReject").css("display","block");
                               //https://v5i2xx.axshare.com/#g=1&p=请假审批（完成）_1  ///返回，通过，不通过
                           }else{
                               //https://v5i2xx.axshare.com/#g=1&p=请假详情（完成）_1 ///返回
                           }
                       }

                       if(leave != null){
                           if(leave){
                               $("btnBackoff").css("display","block");
                               $("btnEdit").css("display","block");
                               //返回，撤回，修改
                           }else{
                               //返回
                           }
                       }
                       getLeaveDetail(leaveId);
                       getAuditDetail(leaveId);
                   })
               </script>
       <script>
               function getUrlParam(name) {
                   var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
                   var r = window.location.search.substr(1).match(reg);
                   if (r != null) return unescape(r[2]); return null;
               }
       </script>
</body>
</html>
