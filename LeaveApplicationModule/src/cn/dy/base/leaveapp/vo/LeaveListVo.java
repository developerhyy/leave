package cn.dy.base.leaveapp.vo;

import cn.dy.base.leaveapp.domain.LeaveApplication;

import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 16:19 2018/11/30
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class LeaveListVo extends LeaveApplication {
    //审批和管理公用实体
    private static final long serialVersionUID = -8532343226547783944L;
    private Date audited_time;
    private String apply_name;
    private String leave_typeTxt;
    private long flowsts;
    private long auditsts;
    private long flowId;
    private long detailId;
    private long leaveId;
    private long cur_detail_id;

    public long getCur_detail_id() {
        return cur_detail_id;
    }

    public void setCur_detail_id(long cur_detail_id) {
        this.cur_detail_id = cur_detail_id;
    }

    public long getLeaveId() {
        return leaveId;
    }

    public void setLeaveId(long leaveId) {
        this.leaveId = leaveId;
    }

    public long getFlowId() {
        return flowId;
    }

    public void setFlowId(long flowId) {
        this.flowId = flowId;
    }

    public long getDetailId() {
        return detailId;
    }

    public void setDetailId(long detailId) {
        this.detailId = detailId;
    }

    public String getApply_name() {
        return apply_name;
    }

    public void setApply_name(String apply_name) {
        this.apply_name = apply_name;
    }

    public long getFlowsts() {
        return flowsts;
    }

    public void setFlowsts(long flowsts) {
        this.flowsts = flowsts;
    }

    public long getAuditsts() {
        return auditsts;
    }

    public void setAuditsts(long auditsts) {
        this.auditsts = auditsts;
    }

    public String getLeave_typeTxt() {
        return leave_typeTxt;
    }

    public void setLeave_typeTxt(String leave_typeTxt) {
        this.leave_typeTxt = leave_typeTxt;
    }

    public Date getAudited_time() {
        return audited_time;
    }

    public void setAudited_time(Date audited_time) {
        this.audited_time = audited_time;
    }
}
