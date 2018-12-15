<%@page language="java" pageEncoding="UTF-8"
        contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css"/>
		<script src="js/bootstrap.min.js" type="text/javascript" charset="utf-8"></script>
    <title>新增请假</title>
    <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
    <script type="text/javascript">
        var staff_id = loginInfo.staff_id;
    </script>
		<style type="text/css">
			.Validform_checktip{
				color: red;
				margin-right: 10px;
			font-size: 18px;
			}
			dt{
				margin-right: 40px;
			}
			.rule-single-select{
				width: 400px;
			}
			.rule-single-select .boxwrap{
				width: 100%;
			}
			.single-select .select-tit i{
				border: none !important;
			}
			.input.normal{
				width: 400px;
			}
			.Validform_error{
				background: none !important;
			}
			.single-select .select-tit span{
				color: #999999;
			}
			.tab-content dl{
				margin-bottom: 12px;
			}
			.tab-content dl dt{
				font-size: 18px;
				font-weight: 400;
				line-height: 30px;
				margin-left: 30px;
			}
			.single-select .select-items{
				width: 400px;
			}
			.btn{
				margin-right: 20px;
			}
			.btn,.btn:hover{
				background: #dcf0ff;
				color:#000000;
				width: 100px;
				height: 35px;
				border-radius: 4px;
			}
			
				.btn-ok{
					background: #FFFFFF;
					margin-right: 40px;
					width: 120px;
					height: 40px;
					border: 1px solid #999999;
			}
			.btn-ok:hover{
				background: #3296fa;
				border-color: #3296fa;
				width: 120px;
				height: 40px;
			}
			.page-footer .btn-list{
				padding-left: 255px;
				
			}
		.WdateDiv {
    width: 400px;
    box-sizing: border-box;
		-webkit-box-sizing: border-box;
		-moz-box-sizing: border-box;
		-ms-box-sizing: border-box;
		-o-box-sizing: border-box;
    background-color: #FFFFFF;
    border: #bbb 1px solid;
    padding: 2px; 
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
        <span id="lbTitle">新增请假</span>
    </div>
    <input type="hidden" id="lib_template_id" value= "1" />
    <input type="hidden" id="lib_url" value="template_1.jsp">
    <div class="tab-content" style="padding-bottom: 50px;">
        <dl>
            <dt><span class="Validform_checktip">*</span>请假类型</dt>
            <dd>
				<input id="leaveId" type="hidden" value=""/>
                <input id="flowOldId" type="hidden" value=""/>
                <div class="rule-single-select" style="float: left;width: 400px;">
                    <select name="leave_type" id="leave_type" datatype="*" sucmsg=" "
                            style="width: 300px;">
                        <option value="">请选择请假类型</option>
                        <option value="1">事假</option>
                        <option value="2">病假</option>
                        <option value="3">休假</option>
                        <option value="4">探亲假</option>
                        <option value="5">婚假</option>
                        <option value="6">丧假</option>
                        <option value="7">生育假</option>
                    </select>
                </div>
            </dd>
            
        </dl>
        <dl>
					
						<dt><span class="Validform_checktip">*</span>姓名</dt>
            <dd>
                <input type="text" name="name" id="name" for="name"  class="input normal" sucmsg=" "
                      placeholder="请选择姓名" maxlength="20"/>
               
            </dd>
        </dl>
        <dl>
					
            <dt><span class="Validform_checktip">*</span>开始时间</dt>
            <dd>
                <div  class="input-date" >
                    <input name="txtbeginDate" type="text" id="begindate" class="input date Validform_error"
                      placeholder="请选择开始时间" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" errormsg="请选择正确的日期" onblur="checkDate();" style = "width:400px"/>
                </div>
                
            </dd>
        </dl>
        <dl>
					
            <dt><span class="Validform_checktip">*</span>结束时间</dt>
            <dd>
                <div  class="input-date" >
                    <input name="txtendDate" type="text" id="enddate" class="input date Validform_error"
                        placeholder="请选择结束时间"   onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" errormsg="请选择正确的日期" onblur="checkDate();" style = "width:400px"/>
                </div>
                
            </dd>
        </dl>
        <dl>
					 
            <dt> <span class="Validform_checktip">*</span>时长</dt>
            <dd>
                <div style="float: left;">
                    <input type="text" name="duration" readonly="readonly" id="duration" for="totalday" class="input normal" style="background: #f5f5f5;" />
                    <span>总可休假<span id="days" style="text-decoration: underline;margin: 0 2px;"></span>天,剩余休假天数<span id="leftday" style="margin:0 2px;text-decoration: underline;"></span>天</span>
                </div>
            </dd>
        </dl>


        <dl>
						
            <dt><span class="Validform_checktip">*</span>请假事由</dt>
            <dd>
                <textarea type="text" name="reason" id="reason" for="reason" class="input normal" sucmsg=" " style="width:400px;height: 100px;"></textarea>
              
            </dd>
        </dl>
        <dl>
						
            <dt><span class="Validform_checktip">*</span>一级审批人员</dt>
            <dd>
                <input type="button" name="approver1" id="approver1" userId="" for="approver1" class="btn" sucmsg=" " width="100px" height="35px" />
               
									<img name="btnAddapprover" onclick="return ShowAuditAction('user-choose1');" src="img/add.png" width="28px" height="28px" style="cursor: pointer;">
								
            </dd>
            <!-- <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员" class="btn" onclick="return ShowAuditAction();" />
            </dd> -->
        </dl>
        <dl>
            <dt><span class="Validform_checktip">*</span>二级审批人员</dt>
            <dd>
                <input type="button" name="approver2" id="approver2" userId="" for="approver2" class="btn" sucmsg=" " />
               <img name="btnAddapprover" onclick="return ShowAuditAction('user-choose2');" src="img/add.png" width="28px" height="28px" style="cursor: pointer;">
            </dd>
         
        </dl>
        <dl>
            <dt><span class="Validform_checktip">*</span>三级审批人员</dt>
            <dd>
                <input type="button" name="approver3" id="approver3" userId="" for="approver3" class="btn" sucmsg=" " />
                <img name="btnAddapprover" onclick="return ShowAuditAction('user-choose3');" src="img/add.png" width="28px" height="28px" style="cursor: pointer;">
            </dd>
            
        </dl>
        <dl>
            <dt><span class="Validform_checktip">*</span>四级审批人员</dt>
            <dd>
                <input type="button" name="approver4" id="approver4" userId="" for="approver4" class="btn" sucmsg=" " />
               <img name="btnAddapprover" onclick="return ShowAuditAction('user-choose4');" src="img/add.png" width="28px" height="28px" style="cursor: pointer;">
            </dd>
           
        </dl>
        <dl>
            <dt><span class="Validform_checktip">*</span>五级审批人员</dt>
            <dd>
                <input type="button" name="approver5" id="approver5" userId="" for="approver5" class="btn" sucmsg=" " />
								<img name="btnAddapprover" onclick="return ShowAuditAction('user-choose5');" src="img/add.png" width="28px" height="28px" style="cursor: pointer;">
            </dd>
            
        </dl>

        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
                <input type="button" name="btnSubmit" value="提交审批" id="btnSubmit" class="btn btn-ok" onclick="doCommit();"/>
                <input type="button" name="btnReturn" value="取消" class="btn btn-ok" onclick="doReturn();" />
            </div>
            <div class="clear"></div>
        </div>
    </div>
</form>
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

        <%--<script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.config.js"></script>
        <script type="text/javascript" charset="utf-8" src="${home}/ueditor/ueditor.all.min.js"> </script>
        <script type="text/javascript" charset="utf-8" src="${home}/ueditor/lang/zh-cn/zh-cn.js"></script>
        <link type="text/css" rel="stylesheet" href="${home}/system/common/css/star.css"/>
        <script src="${home}/system/common/scripts/star.js" type="text/javascript"></script>
        <script type="text/javascript" src="js/worker_info.js"></script>--%>
        
				<script type="text/javascript">
            function checkDate(){
                setTimeout(function(){
                    var beginTime=new Date(($("#begindate").val()+" 00:00:00").replace(/-/g,"/"));
                    var endTime=new Date(($("#enddate").val()+" 23:59:59").replace(/-/g,"/"));
                    if(beginTime=="Invalid Date" || endTime=="Invalid Date")return;
                    if(endTime.getTime()-beginTime.getTime()<0){
                        return;
                    }
                    var day=Math.ceil((endTime.getTime()-beginTime.getTime())/(1000*3600*24));
                    $("#duration").val(day);
                },500);
            };
            function doReturn(){
                window.location.href="leavemanage.jsp";
                parent.diag.close();
            }
            function doCommit(){
                $.fn.validate = function(tips){

                    if($(this).val() == "" || $.trim($(this).val()).length == 0){
                        alert(tips + "不能为空！");
                        throw SyntaxError(); //如果验证不通过，则不执行后面
                    }
                }
//调用validate()
                $("#leave_type").validate("请假类型")
                $("#name").validate("姓名");
                $("#begindate").validate("开始时间");
                $("#enddate").validate("结束时间");
                $("#duration").validate("时长");
                $("#reason").validate("请假事由");

                add();
            }
            function add() {
                var head = {
                    "service_name": "LeaveManageService",
                    "operation_name": "createNewLeaveApplication",
                    "token_id" : "",
                    "user_id" : "",
                    "version" : "0100",
                    "timestamp" : "",
                    "request_seq" : "",
                    "request_source" : ""
                }
                //var id = $("#id").val() ? parseInt($("#id").val()) : 0;
                var param = {
                    "name":$("#name").val().trim(),
                    "leaveApplication":{
                        "id":$("#leaveId").val().trim(),//有值覆盖
                        "leave_type":$("#leave_type").val().trim(),
                        "apply_id":staff_id,
                        "begin_time":$("#begindate").val()+" 00:00:00",
                        "duration":$("#duration").val(),
                        "end_time":$("#enddate").val()+" 23:59:59",
                        "reason":$("#reason").val(),
                        "sts":0
                    }
                }
                var beginTime=new Date($("#begindate").val().replace(/-/g,"/"));
                var endTime=new Date($("#enddate").val().replace(/-/g,"/"));
                if(endTime.getTime()-beginTime.getTime()<0){
                    alert("请假申请开始时间不得大于结束时间！");
                    throw SyntaxError();
                }
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var myCallBack=function callBack(data) {
console.log($.JsonUtil.jso2json(data));
                    if(data.response_code==0){
                        var flowOldId = $("#flowOldId").val().trim();
                        submitAuditFlow(data.content.result,flowOldId);
                    }else{
                        alert(data.response_desc);
                    }
                }
                $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
            }
            function getLeftFurloughDays(){
                var head = {
                    "service_name": "SeniorityService",
                    "operation_name": "getLeftFurloughDays",
                    "token_id" : "",
                    "user_id" : "",
                    "version" : "0100",
                    "timestamp" : "",
                    "request_seq" : "",
                    "request_source" : ""
                }

                var param = {
                    "staff_id":staff_id,
                }
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var daycallBack=function callBack(data) {
                    if(data.response_code==0){
                        $("#leftday").html(data.content.result.leftdays);
                        $("#days").html(data.content.result.days);
                        /*parent.$("#leave").html("");
                        parent.query();
                        parent.diag.close();*/
                    }else{
                        alert(data.response_desc);
                    }
                }
                $.ServiceAgent.JSONInvoke(head, param, daycallBack, options);

            }

            function submitAuditFlow(application_id, flowOldId){
                var head = {
                    "service_name": "LeaveManageService",
                    "operation_name": "createNewLeaveAuditingFlow",
                    "token_id" : "",
                    "user_id" : "",
                    "version" : "0100",
                    "timestamp" : "",
                    "request_seq" : "",
                    "request_source" : ""
                }
                //var id = $("#id").val() ? parseInt($("#id").val()) : 0;

                var param = {
                    "id":flowOldId,
                    "flow_type":1,
                    "flow_sts":0,
                    "application_id":application_id,
                    "create_id":staff_id
                }
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var myCallBack=function callBack(data) {
console.log($.JsonUtil.jso2json(data));
                    if(data.response_code==0){
                        var flowOldId = $("#flowOldId").val().trim();
                        submitAuditDetail(data.content.result,flowOldId);
                    }else{
                        alert(data.response_desc);
                    }
                }
                $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
                //存流程，及审批详情
            }
            //添加流程调用
            function submitAuditDetail(flow_id, flowOldId){//添加流程调用
                /**
                 *提交1-5条
                 */
                var head = {
                    "service_name": "LeaveManageService",
                    "operation_name": "createNewLeaveAuditingDetail",
                    "token_id" : "",
                    "user_id" : "",
                    "version" : "0100",
                    "timestamp" : "",
                    "request_seq" : "",
                    "request_source" : ""
                }

                var details=[];
                for(var i=1;i<=5;i++){
                    var str = "#approver"+i;
                    var approverval = $(str).val();
                    if(approverval!='undefined' && approverval!=null && approverval!=''){
                        var params={
                            "flow_id":flow_id,
                            "audit_id":$(str).attr("userid")
                        }
                        details.push(params);
                    }
                }

                var param = {
                    "flowOldId":flowOldId,
                    "audit_details":details
                }
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var myCallBack=function callBack(data) {
                    if(data.response_code==0){
                        alert("添加成功！");
                        //alert(data.content.result);
                        window.location.href="leavemanage.jsp";
                        parent.diag.close();
                    }else{
                        alert(data.response_desc);
                    }
                }
                $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
                //存流程，及审批详情
            }
            $(function(){
                getLeftFurloughDays();
                var edit = getUrlParam('edit');//////
                if(edit != null && l==edit){
                    getEdit();
                    // TODO 将详情页数据传入（cookie方式），并赋值，，此情形下提示用户：“点击提交按钮，则全部流程重新开始”
                }
            });
            var worker_type = "";
            var wz_id="";
            var nowDateTime = "";
        </script>
<script>
    var diag;
    window.addEventListener("user-choose1", function (e) {
        if(e ==null || e.detail.id==null)return;
        $("#approver1").val(e.detail.name).attr("userId",e.detail.id);
    });
    window.addEventListener("user-choose2", function (e) {
        if(e ==null || e.detail.id==null)return;
        $("#approver2").val(e.detail.name).attr("userId",e.detail.id);
    });
    window.addEventListener("user-choose3", function (e) {
        if(e ==null || e.detail.id==null)return;
        $("#approver3").val(e.detail.name).attr("userId",e.detail.id);
    });
    window.addEventListener("user-choose4", function (e) {
        if(e ==null || e.detail.id==null)return;
        $("#approver4").val(e.detail.name).attr("userId",e.detail.id);

    });
    window.addEventListener("user-choose5", function (e) {
        if(e ==null || e.detail.id==null)return;
        $("#approver5").val(e.detail.name).attr("userId",e.detail.id);

    });
    function ShowAuditAction(eventName){
        ShowPage(eventName);
    }
    function ShowPage(eventName){
        //("提示：你点击了一个按钮");
        //Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
        diag = new Dialog();
        diag.Width = 950;
        diag.Height = 600;
        diag.Title = "";
        diag.URL = "choosepage.jsp";
        diag.ShowMessageRow=false;
        diag.dialogId=eventName;
        diag.show();
        var iframe=$("#_DialogFrame_0");
        iframe[0].contentWindow.targetWindow = window;
				
    }
    //关闭对话框并触发事件
    function ClosePage(eventName, data) {
        CloseDialog();
        if (window.targetWindow && eventName) {
            var event = document.createEvent('HTMLEvents');
            event.initEvent(eventName, true, true);
            event.detail = data;
            window.targetWindow.dispatchEvent(event);
            window.targetWindow = null;
        }
    }
    function CloseDialog() {
        diag.close();
    }

</script>
<script>
    function getUrlParam(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    }
</script>
<script type="text/javascript" src="/xyzg/system/common/scripts/zDialog.js"></script>
</body>
</html>
