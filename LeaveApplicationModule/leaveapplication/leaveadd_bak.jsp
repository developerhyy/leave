<%@page language="java" pageEncoding="UTF-8"
        contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>新增请假</title>
    <jsp:include page="../assets/common_inc_new.jsp" flush="true"></jsp:include>
    <script type="text/javascript">
        var user_id =loginInfo.user_id;
        var staff_id = loginInfo.staff_id;
    </script>
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
            <dt>请假类型</dt>
            <dd>
                <div class="rule-single-select" style="float: left;">
                    <select name="leave_type" id="leave_type" datatype="*" sucmsg=" "
                            style="width: 300px;">
                        <option value="">请选择</option>
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
            <span class="Validform_checktip">*必填</span>
        </dl>
        <dl>
            <dt>姓名</dt>
            <dd>
                <input type="text" name="name" id="name" for="name"  class="input normal" sucmsg=" "
                       maxlength="20"/>
                <span class="Validform_checktip">*必填</span>
            </dd>
        </dl>
        <dl>
            <dt>开始时间</dt>
            <dd>
                <div  class="input-date" style="width: 320px">
                    <input name="txtbeginDate" type="text" id="begindate" class="input date Validform_error"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd 00:00:00'})" errormsg="请选择正确的日期" onblur="checkDate();" style = "width:300px"/>
                </div>
                <span class="Validform_checktip">*必填</span>
            </dd>
        </dl>
        <dl>
            <dt>结束时间</dt>
            <dd>
                <div  class="input-date" style="width: 320px">
                    <input name="txtendDate" type="text" id="enddate" class="input date Validform_error"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd 23:59:59'})" errormsg="请选择正确的日期" onblur="checkDate();" style = "width:300px"/>
                </div>
                <span class="Validform_checktip">*必填</span>
            </dd>
        </dl>
        <dl>
            <dt>时长</dt>
            <dd>
                <div style="float: left;">
                    <input type="text" name="duration" id="duration" for="totalday" class="input normal" />
                    <span>总可休假<span id="days"></span>天,剩余休假天数<span id="leftday"></span>天</span>
                </div>
            </dd>
        </dl>


        <dl>
            <dt>请假事由</dt>
            <dd>
                <textarea type="text" name="reason" id="reason" for="reason" class="input normal" sucmsg=" "></textarea>
                <span class="Validform_checktip">*必填</span>
            </dd>
        </dl>
        <dl>
            <dt>一级审批人员</dt>
            <dd>
                <input type="button" name="approver1" id="approver1" userId="" for="approver1" class="btn" sucmsg=" " />
                <span class="Validform_checktip">*必填</span>
            </dd>
            <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员" class="btn" onclick="return ShowAuditAction();" />
            </dd>
        </dl>
        <dl>
            <dt>二级审批人员</dt>
            <dd>
                <input type="button" name="approver2" id="approver2" for="approver2" class="btn" sucmsg=" " />
                <span class="Validform_checktip">*必填</span>
            </dd>
            <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员" class="btn" onclick="ShowAuditAction();" />
            </dd>
        </dl>
        <dl>
            <dt>三级审批人员</dt>
            <dd>
                <input type="button" name="approver3" id="approver3" for="approver3" class="btn" sucmsg=" " />
                <span class="Validform_checktip">*必填</span>
            </dd>
            <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员" class="btn" onclick="ShowAuditAction();" />
            </dd>
        </dl>
        <dl>
            <dt>四级审批人员</dt>
            <dd>
                <input type="button" name="approver4" id="approver4" for="approver4" class="btn" sucmsg=" " />
                <span class="Validform_checktip">*必填</span>
            </dd>
            <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员"  class="btn" onclick="ShowAuditAction();" />
            </dd>
        </dl>
        <dl>
            <dt>五级审批人员</dt>
            <dd>
                <input type="button" name="approver5" id="approver5" for="approver5" class="btn" sucmsg=" " />
                <span class="Validform_checktip">*必填</span>
            </dd>
            <dd>
                <input type="button" name="btnAddapprover" value="增加审批人员" class="btn" onclick="ShowAuditAction();" />
            </dd>
        </dl>

        <!--工具栏-->
        <div class="page-footer">
            <div class="btn-list">
                <input type="button" name="btnSubmit" value="保存" id="btnSubmit" class="btn" onclick="doCommit();"/>
                <input type="button" name="btnReturn" value="取消" class="btn yellow" onclick="doReturn();" />
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
                    var beginTime=new Date($("#begindate").val().replace(/-/g,"/"));
                    var endTime=new Date($("#enddate").val().replace(/-/g,"/"));
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
                        "id":"",
                        "leave_type":$("#leave_type").val().trim(),
                        "apply_id":4,//user_id,
                        "begin_time":$("#begindate").val(),
                        "duration":$("#duration").val(),
                        "end_time":$("#enddate").val(),
                        "reason":$("#reason").val(),
                        "sts":0
                        //TODO bz_auditing_flow审核流程表 bz_auditing_detail 审核明细表 处理
                    }
                }
                var beginTime=new Date($("#begindate").val().replace(/-/g,"/"));
                var endTime=new Date($("#enddate").val().replace(/-/g,"/"));
                if(endTime.getTime()-beginTime.getTime()<0){
                    alert("请假申请开始时间不得大于结束时间！");
                    throw SyntaxError();
                }
console.log(param);
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var myCallBack=function callBack(data) {
                    alert(data);
                    if(data.response_code==0){
                        alert(data.response_desc);
                        submitAudit(data.content.result);
                        parent.$("#leave").html("");
                        parent.query();
                        parent.diag.close();
                    }else{
                        alert(data.response_detail);
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
console.log(data.content.result);
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

            function submitAuditFlow(application_id){
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
                    "flow_type":1,
                    "flow_sts":0,
                    "application_id":application_id,
                    "create_id":user_id
                }
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var myCallBack=function callBack(data) {
console(data);
                    if(data.response_code==0){
                        alert(data.response_desc);
                        submitAuditDetail(data.content.result);
                    }else{
                        alert(data.response_detail);
                    }
                }
                $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
                //存流程，及审批详情
            }
            function submitAuditDetail(flow_id){//添加流程调用
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
                //var id = $("#id").val() ? parseInt($("#id").val()) : 0;

                var param = {
                    "flow_id":flow_id,
                    "audit_ids":{
                        "1":$("#approver1"),
                        "2":$("#approver2"),
                        "3":$("#approver3"),
                        "4":$("#approver4"),
                        "5":$("#approver5"),
                    }
                }
                var options = {
                    "handleError": false,
                    "showProgressBar":false,
                    "timeout":60000*10
                }
                var myCallBack=function callBack(data) {
                    alert(data);
                    if(data.response_code==0){
                        data(data.response_desc);
                    }else{
                        alert(data.response_detail);
                    }
                }
                $.ServiceAgent.JSONInvoke(head, param, myCallBack, options);
                //存流程，及审批详情
            }
            $(function(){
                getLeftFurloughDays();
            });
            var worker_type = "";
            var wz_id="";
            var nowDateTime = "";
        </script>
<script>
    var diag;
    window.addEventListener("user-choose", function (e) {
        if(e ==null || e.detail.id==null)return;
        $("#approver1").val(e.detail.name).attr("userId",e.detail.id);

    });
    function ShowAuditAction(index){
        ShowPage1();
    }
    function ShowPage1(){
        //("提示：你点击了一个按钮");
        //Dialog.confirm('警告：您确认要XXOO吗？',function(){Dialog.alert("yeah，周末到了，正是好时候")});
        diag = new Dialog();
        diag.Width = 950;
        diag.Height = 600;
        diag.Title = "";
        diag.URL = "choosepage.jsp";
        diag.ShowMessageRow=false;
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
<script type="text/javascript"
        src="/xyzg/system/common/scripts/zDialog.js"></script>
</body>
</html>
