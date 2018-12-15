package cn.dy.base.leaveapp.util;

import cn.dy.base.framework.esb.call.imp.JsonServiceProxy;
import cn.dy.base.framework.esb.def.RepMessage;
import cn.dy.base.leaveapp.LeaveApplicationModule;
import cn.dy.base.leaveapp.domain.OperateLogRequest;

import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 16:17 2018-12-6
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class SystemUtil {
    public static void addOperateLogRequest(String Ope_name, String Ope_contact, String modoule, String Chi_module, String Ope_obj) {
        new RepMessage();
        OperateLogRequest operation = new OperateLogRequest();
        int staff_id = 0;
        if (null != LeaveApplicationModule.context &&  null != LeaveApplicationModule.context.getContextByName("staff_id")) {
            staff_id = Integer.parseInt(LeaveApplicationModule.context.getContextByName("staff_id"));
        }

        int corp_id = 0;
        if (null != LeaveApplicationModule.context && LeaveApplicationModule.context.getContextByName("corp_id") != null) {
            corp_id = Integer.parseInt(LeaveApplicationModule.context.getContextByName("corp_id").toString());
        }

        int user_id = 0;
        if (null != LeaveApplicationModule.context && LeaveApplicationModule.context.getContextByName("user_id") != null) {
            user_id = Integer.parseInt(LeaveApplicationModule.context.getContextByName("user_id").toString());
        }

        int dept_id = 0;
        if (null != LeaveApplicationModule.context && LeaveApplicationModule.context.getContextByName("dept_id") != null) {
            dept_id = Integer.parseInt(LeaveApplicationModule.context.getContextByName("dept_id").toString());
        }

        String user_name = "";
        if (null != LeaveApplicationModule.context && LeaveApplicationModule.context.getContextByName("user_name") != null) {
            user_name = LeaveApplicationModule.context.getContextByName("user_name").toString();
        }

        String dept_name = "";
        if (null != LeaveApplicationModule.context && LeaveApplicationModule.context.getContextByName("dept_name") != null) {
            dept_name = LeaveApplicationModule.context.getContextByName("dept_name").toString();
        }

        operation.setOperation_id(0);
        operation.setStaff_id(staff_id);
        operation.setCorp_id(corp_id);
        operation.setOperation_name(Ope_name);
        operation.setOperate_time(new Date());
        operation.setOperate_content(user_name + Ope_contact);
        operation.setModule(modoule);
        operation.setChild_module(Chi_module);
        operation.setOperation_obj(Ope_obj);
        operation.setUser_id(user_id);
        operation.setUser_name(user_name);
        operation.setDept_id(dept_id);
        operation.setDept_name(dept_name);
        JsonServiceProxy<RepMessage> service = new JsonServiceProxy("cn.dy.system.service.OperateLogService", RepMessage.class);
        service.setParam("operation", operation);
        RepMessage repMessage = (RepMessage)service.call("addOperateLog");
    }
}
