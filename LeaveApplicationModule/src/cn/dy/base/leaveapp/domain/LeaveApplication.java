package cn.dy.base.leaveapp.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 17:37 2018/11/27
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class LeaveApplication implements Serializable {
    private static final long serialVersionUID = -3887508169530067812L;
    private long id;
    private String leave_type;
    private Date begin_time;
    private Date end_time;
    private long duration;
    private String reason;
    /**
     * ////这个为staff_id，关联部门时，关联取ecc_id
     */
    private long apply_id;
    private Date create_time;
    private String sts;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getLeave_type() {
        return leave_type;
    }

    public void setLeave_type(String leave_type) {
        this.leave_type = leave_type;
    }

    public Date getBegin_time() {
        return begin_time;
    }

    public void setBegin_time(Date begin_time) {
        this.begin_time = begin_time;
    }

    public Date getEnd_time() {
        return end_time;
    }

    public void setEnd_time(Date end_time) {
        this.end_time = end_time;
    }

    public long getDuration() {
        return duration;
    }

    public void setDuration(long duration) {
        this.duration = duration;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public long getApply_id() {
        return apply_id;
    }

    public void setApply_id(long apply_id) {
        this.apply_id = apply_id;
    }

    public Date getCreate_time() {
        return create_time;
    }

    public void setCreate_time(Date create_time) {
        this.create_time = create_time;
    }

    public String getSts() {
        return sts;
    }

    public void setSts(String sts) {
        this.sts = sts;
    }
    public static class LeaveSts{
        public static Integer INITIAL=0;
        public static Integer AUDITING=1;
        public static Integer OVER=2;
        public static Integer DELETE=3;
    }
}
