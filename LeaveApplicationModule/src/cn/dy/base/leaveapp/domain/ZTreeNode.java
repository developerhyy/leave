package cn.dy.base.leaveapp.domain;

import java.io.Serializable;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 11:30 2018-12-5
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class ZTreeNode implements Serializable {

    private static final long serialVersionUID = -3852909779228992468L;
    public String id;
    public String parent_id;
    public String name;
    public String dis_name;
    public String style;
    public int order_index;
    public int is_delete;
    public String sts;
    public String iconOpen;
    public String iconClose;

    public ZTreeNode() {
    }

    public String toString() {
        return "id=" + this.id + ",parent_id=" + this.parent_id + ",name=" + this.name;
    }

}
