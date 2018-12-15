package cn.dy.base.leaveapp.support;

import cn.dy.base.framework.esb.def.RepMessage;
import cn.dy.base.framework.esb.def.ServiceBusinessException;
import cn.dy.base.leaveapp.dao.LeaveManageDao;
import cn.dy.base.leaveapp.domain.AuditDetail;
import cn.dy.base.leaveapp.domain.LeaveApplication;
import cn.dy.base.leaveapp.service.LeaveManageService;
import cn.dy.base.leaveapp.util.SystemUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 18:56 2018/11/27
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class LeaveManageController implements LeaveManageService {
    protected static Logger logger = LoggerFactory.getLogger(LeaveManageController.class);
    private LeaveManageDao leaveManageDao;

    public LeaveManageController() {
        if (this.leaveManageDao == null) {
            this.leaveManageDao = new LeaveManageDao();
        }
    }

    //private AuthorityDao authorityDao;//权限控制
    public RepMessage getLeave(long leave_id) {
        LeaveManageParam param = new LeaveManageParam();
        param.setLeave_id(leave_id);

        RepMessage repMessage = new RepMessage();
        try {
            //LeaveApplication leaveApplication =
            Map<String, Object> map = new HashMap();
            map.put("result", this.leaveManageDao.getLeave(param));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("获取单条请假条失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("获取单条请假条失败");
        }
        return repMessage;
    }



    public RepMessage getAudit(long leave_id){
        LeaveManageParam param = new LeaveManageParam();
        param.setLeave_id(leave_id);
        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("result", this.leaveManageDao.getAudit(param));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception e) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("获取假单流程详情失败");
            repMessage.setResponse_detail(e.getLocalizedMessage()+e.getMessage());
            logger.warn("获取假单流程详情失败");
        }
        return repMessage;
    }

    @Override
    public RepMessage queryLeaveList(String leave_type,long apply_id, int sts, String begin_time, String end_time, long pageNum, long pageSize) {
        LeaveManageParam param = new LeaveManageParam();
        param.setLeave_type(leave_type);
        param.setApply_id(apply_id);//申请人
        param.setLeaveSts(sts);//这个需要拆解
        param.setBegin_time(begin_time);
        param.setEnd_time(end_time);
        param.setPageNum(pageNum);
        param.setPageSize(pageSize);

        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new HashMap();
            map.put("result", this.leaveManageDao.getLeaves(param));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("条件查询请假列表失败");
            Map<String,Object> map = new HashMap<>();
            map.put("err",var10.getMessage());
            repMessage.setContent(map);
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("条件查询请假列表失败");
        }
        return repMessage;
    }

    /**
     * 新增请假流程(id有值，则直接作废当前flow，新建一个flow)
     * @param flow_type
     * @param flow_sts
     * @param application_id
     * @param create_id
     * @return
     */
    @Override
    public RepMessage createNewLeaveAuditingFlow(long id, String flow_type, String flow_sts, long application_id, long create_id) {
        LeaveAuditParam param = new LeaveAuditParam();
        param.setFlow_id(id);
        param.setFlow_type(flow_type);
        param.setFlow_sts(flow_sts);
        param.setApplication_id(application_id);
        param.setCreate_id(create_id);
        long flowId=0;
        RepMessage repMessage = new RepMessage();
        try {
            flowId = (long)this.leaveManageDao.createNewAuditingFlow(param);
            Map<String, Object> map = new HashMap();
            map.put("result", flowId);
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("新增请假审批流程失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("新增请假审批流程失败");
        }
        try {
            SystemUtil.addOperateLogRequest("新增审核流程", "新增审核流程id[" + flowId + "]信息", "请假管理模块", "请假审核模块", "审核管理");
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        return repMessage;
    }

    /**
     * 新增请假详情
     * @return
     */
    @Override
    public RepMessage createNewLeaveAuditingDetail(long flowOldId, ArrayList<AuditDetail> audit_details) {

        String str="";
        RepMessage repMessage = new RepMessage();
        try {
            str = this.leaveManageDao.createNewDetail(flowOldId, audit_details).toString();
            Map<String, Object> map = new HashMap();
            map.put("result", str);
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("新增请假流程详情失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage()+var10.getMessage());
            logger.warn("新增请假流程详情失败");
        }
        try {
            SystemUtil.addOperateLogRequest("新增审核明细", "新增审核明细FlowId[" + str + "]信息", "请假管理模块", "请假审核模块", "审核管理");
        } catch (Exception e) {
            logger.warn(e.getMessage());
        }

        return repMessage;
    }

    /**
     * 审批列表
     * @param leave_type
     * @param sts
     * @param begin_time
     * @param end_time
     * @param query
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public RepMessage queryApproveLeaveList(String leave_type,long audit_id, int sts, String begin_time, String end_time, String query, long pageNum, long pageSize) {
        LeaveManageParam param = new LeaveManageParam();
        param.setLeave_type(leave_type);
        param.setApproveSts(sts);
        param.setAudit_id(audit_id);
        param.setBegin_time(begin_time);
        param.setEnd_time(end_time);
        param.setQuery(query);
        param.setPageNum(pageNum);
        param.setPageSize(pageSize);

        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new HashMap();
            map.put("result", this.leaveManageDao.getApproveLeaves(param));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("条件查询审批列表失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("条件查询审批列表失败");
        }
        return repMessage;
    }

    @Override
    public RepMessage getLeaveDetail() {
        return null;
    }

    @Override
    public RepMessage passAudit(long flowId, long detailId) {
        RepMessage repMessage = new RepMessage();
        boolean IsSuccess;
        try {
            IsSuccess = this.leaveManageDao.passAudit(flowId, detailId);
            Map<String, Object> map = new HashMap();
            map.put("result", IsSuccess);
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        }
        catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("审批通过假条失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("审批通过假条失败");
            logger.error("审批通过假条失败",var10);
        }
        try {
            SystemUtil.addOperateLogRequest("审批通过假条", "通过假条flowId[" + flowId + "],detailId["+detailId+"]", "审批管理模块", "审批假条模块", "审批管理");
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return repMessage;
    }

    @Override
    public RepMessage rejectAudit(long flowId, long detailId) {
        RepMessage repMessage = new RepMessage();
        boolean IsSuccess;
        try {
            IsSuccess = this.leaveManageDao.rejectAudit(flowId, detailId);
            Map<String, Object> map = new HashMap();
            map.put("result", IsSuccess);
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        }
        catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("审批不通过假条失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("审批不通过假条失败");
            logger.error("审批不通过假条失败",var10);
        }
        try {
            SystemUtil.addOperateLogRequest("审批不通过假条失败", "不通过假条flowId[" + flowId + "],detailId["+detailId+"]", "审批管理模块", "审批假条模块", "审批管理");
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return repMessage;
    }

    @Override
    public RepMessage getSts() {
        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new HashMap();
            map.put("result", this.leaveManageDao.getSts());
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("条件查询审批列表失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("条件查询审批列表失败");
        }
        return repMessage;
    }


    @Override
    public RepMessage createNewLeaveApplication(final String name, final LeaveApplication leaveApplication) {
        RepMessage repMessage = new RepMessage();
        long leaveId =0;
        try {
            leaveId = this.leaveManageDao.createNewLeave(name, leaveApplication);
            Map<String, Object> map = new HashMap();
            map.put("result", leaveId);
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        }catch (ServiceBusinessException e){
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("已申请过此类假条");
            repMessage.setResponse_detail("已申请过此类假条");
            repMessage.setResponse_detail(e.getLocalizedMessage());
            logger.warn("已申请过此类假条");
        }
        catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("新增请假申请失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("新增请假申请失败");
            logger.error("新增假条",var10);
        }
        try {
            SystemUtil.addOperateLogRequest("新增假条", "新增假条id[" + leaveId + "]信息", "请假管理模块", "请假假条模块", "假条管理");
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        return repMessage;
    }
}
