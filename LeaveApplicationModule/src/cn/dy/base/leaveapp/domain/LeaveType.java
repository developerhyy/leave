package cn.dy.base.leaveapp.domain;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 11:27 2018-12-4
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public enum LeaveType {
    BUSY("事假", 1), SICK("病假", 2), FURLOUGH("休假", 3),HOME("探亲假", 4), WEDDING("婚假", 5), FUNERAL("丧假", 6), BIRTH("生育假", 7);
    // 成员变量
    private String name;
    private int index;
    // 构造方法
    private LeaveType(String name, int index) {
        this.name = name;
        this.index = index;
    }
    // 普通方法
    public static String getName(int index) {
        for (LeaveType c : LeaveType.values()) {
            if (c.getIndex() == index) {
                return c.name;
            }
        }
        return null;
    }
    // get set 方法
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public int getIndex() {
        return index;
    }
    public void setIndex(int index) {
        this.index = index;
    }


}
