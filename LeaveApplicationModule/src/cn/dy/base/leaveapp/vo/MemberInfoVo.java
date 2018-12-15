package cn.dy.base.leaveapp.vo;

import cn.dy.base.leaveapp.domain.MemberInfo;

import java.io.Serializable;
import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 17:12 2018/12/3
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class MemberInfoVo extends MemberInfo {
    private static final long serialVersionUID = -8981126268770066241L;
    private Date JoinTime;
    private int Seniority;
    private int FurloughDays;
    private int leftFurloughDays;

    public Date getJoinTime() {
        return JoinTime;
    }

    public void setJoinTime(Date joinTime) {
        JoinTime = joinTime;
    }

    public int getSeniority() {
        return Seniority;
    }

    public void setSeniority(int seniority) {
        Seniority = seniority;
    }

    public int getFurloughDays() {
        return FurloughDays;
    }

    public void setFurloughDays(int furloughDays) {
        FurloughDays = furloughDays;
    }

    public int getLeftFurloughDays() {
        return leftFurloughDays;
    }

    public void setLeftFurloughDays(int leftFurloughDays) {
        this.leftFurloughDays = leftFurloughDays;
    }
}
