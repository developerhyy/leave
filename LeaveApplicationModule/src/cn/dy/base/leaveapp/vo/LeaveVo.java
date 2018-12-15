package cn.dy.base.leaveapp.vo;

import cn.dy.base.leaveapp.domain.LeaveApplication;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 9:41 2018-12-13
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class LeaveVo extends LeaveApplication {
    private static final long serialVersionUID = -4411618247957484827L;
    private String apply_name;

    public String getApply_name() {
        return apply_name;
    }

    public void setApply_name(String apply_name) {
        this.apply_name = apply_name;
    }
}
