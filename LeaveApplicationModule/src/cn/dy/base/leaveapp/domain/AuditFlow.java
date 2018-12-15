package cn.dy.base.leaveapp.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 11:51 2018-12-6
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class AuditFlow implements Serializable {
    private static final long serialVersionUID = -5456899889658173014L;
    private long id;
    private String flow_type;
    private String flow_sts;
    private long application_id;
    /**
     * //这个为staff_id
     */
    private long create_id;
    private Date create_time;
    private long cur_detail_id;

    public long getCur_detail_id() {
        return cur_detail_id;
    }

    public void setCur_detail_id(long cur_detail_id) {
        this.cur_detail_id = cur_detail_id;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFlow_type() {
        return flow_type;
    }

    public void setFlow_type(String flow_type) {
        this.flow_type = flow_type;
    }

    public String getFlow_sts() {
        return flow_sts;
    }

    public void setFlow_sts(String flow_sts) {
        this.flow_sts = flow_sts;
    }

    public long getApplication_id() {
        return application_id;
    }

    public void setApplication_id(long application_id) {
        this.application_id = application_id;
    }

    public long getCreate_id() {
        return create_id;
    }

    public void setCreate_id(long create_id) {
        this.create_id = create_id;
    }

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }

    /**
     * 审批流程类型1请假流程2考勤流程3工资流程4加值班补贴流程
     */
    public static class AuditFlowType{
        public static Integer LEAVEAUDITFLOWTYPE=1;
    }

    /**
     * 流程状态0审核中1结束
     */
    public static class FlowSts{
        public static Integer Auditing=0;
        public static Integer Over=1;
        public static Integer Invalid=2;
    }
}
