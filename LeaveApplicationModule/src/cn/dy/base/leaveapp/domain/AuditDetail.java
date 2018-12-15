package cn.dy.base.leaveapp.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 11:55 2018-12-6
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class AuditDetail implements Serializable {
    private static final long serialVersionUID = 1874864188042582267L;
    private long id;
    private long flow_id;
    private long pre_id;
    /*
    //这个为staff_id
     */
    private long audit_id;
    private String audit_name;
    private Date audit_time;
    private String audit_remark;
    private String audit_sts;
    private Date create_time;

    public String getAudit_stsTxt() {
        return audit_stsTxt;
    }

    public void setAudit_stsTxt(String audit_stsTxt) {
        this.audit_stsTxt = audit_stsTxt;
    }

    private String audit_stsTxt;

    public String getAudit_name() {
        return audit_name;
    }

    public void setAudit_name(String audit_name) {
        this.audit_name = audit_name;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getFlow_id() {
        return flow_id;
    }

    public void setFlow_id(long flow_id) {
        this.flow_id = flow_id;
    }

    public long getPre_id() {
        return pre_id;
    }

    public void setPre_id(long pre_id) {
        this.pre_id = pre_id;
    }

    public long getAudit_id() {
        return audit_id;
    }

    public void setAudit_id(long audit_id) {
        this.audit_id = audit_id;
    }

    public Date getAudit_time() {
        return audit_time;
    }

    public void setAudit_time(Date audit_time) {
        this.audit_time = audit_time;
    }

    public String getAudit_remark() {
        return audit_remark;
    }

    public void setAudit_remark(String audit_remark) {
        this.audit_remark = audit_remark;
    }

    public String getAudit_sts() {
        return audit_sts;
    }

    public void setAudit_sts(String audit_sts) {
        this.audit_sts = audit_sts;
    }

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }
    public static class AuditDetailSts{
        public static Integer WaitAudit=0;
        public static Integer PassAudit=1;
        public static Integer Reject=2;
        public static Integer Transfer=3;
    }
}
