package cn.dy.base.leaveapp.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 16:07 2018-12-6
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class OperateLogRequest implements Serializable {
    private static final long serialVersionUID = 1489772473867911065L;
    private int operation_id;
    private String operation_name;
    private int staff_id;
    private int corp_id;
    private Date operate_time;
    private String operate_content;
    private String module;
    private String child_module;
    private String operation_obj;
    private int user_id;
    private String user_name;
    private int dept_id;
    private String dept_name;

    public OperateLogRequest() {
    }

    public int getOperation_id() {
        return this.operation_id;
    }

    public void setOperation_id(int operation_id) {
        this.operation_id = operation_id;
    }

    public String getOperation_name() {
        return this.operation_name;
    }

    public void setOperation_name(String operation_name) {
        this.operation_name = operation_name;
    }

    public int getStaff_id() {
        return this.staff_id;
    }

    public void setStaff_id(int staff_id) {
        this.staff_id = staff_id;
    }

    public int getCorp_id() {
        return this.corp_id;
    }

    public void setCorp_id(int corp_id) {
        this.corp_id = corp_id;
    }

    public Date getOperate_time() {
        return this.operate_time;
    }

    public void setOperate_time(Date operate_time) {
        this.operate_time = operate_time;
    }

    public String getOperate_content() {
        return this.operate_content;
    }

    public void setOperate_content(String operate_content) {
        this.operate_content = operate_content;
    }

    public String getModule() {
        return this.module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getChild_module() {
        return this.child_module;
    }

    public void setChild_module(String child_module) {
        this.child_module = child_module;
    }

    public String getOperation_obj() {
        return this.operation_obj;
    }

    public void setOperation_obj(String operation_obj) {
        this.operation_obj = operation_obj;
    }

    public int getUser_id() {
        return this.user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getUser_name() {
        return this.user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public int getDept_id() {
        return this.dept_id;
    }

    public void setDept_id(int dept_id) {
        this.dept_id = dept_id;
    }

    public String getDept_name() {
        return this.dept_name;
    }

    public void setDept_name(String dept_name) {
        this.dept_name = dept_name;
    }

    public String toString() {
        return "OperateLogRequest [operation_id=" + this.operation_id + ", operation_name=" + this.operation_name + ", staff_id=" + this.staff_id + ", corp_id=" + this.corp_id + ", operate_time=" + this.operate_time + ", operate_content=" + this.operate_content + ", module=" + this.module + ", child_module=" + this.child_module + ", operation_obj=" + this.operation_obj + ", user_id=" + this.user_id + ", user_name=" + this.user_name + ", dept_id=" + this.dept_id + ", dept_name=" + this.dept_name + "]";
    }
}
