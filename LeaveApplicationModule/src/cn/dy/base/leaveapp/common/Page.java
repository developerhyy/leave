package cn.dy.base.leaveapp.common;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 15:00 2018/11/27
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
import java.io.Serializable;
import java.util.List;

public class Page<T> implements Serializable {
    private static final long serialVersionUID = -5199557731249084180L;
    private long total_count;
    private List<T> records;
    public Page() {
    }

    public long getTotal_count() {
        return this.total_count;
    }

    public void setTotal_count(long total_count) {
        this.total_count = total_count;
    }

    public List<T> getRecords() {
        return this.records;
    }

    public void setRecords(List<T> records) {
        this.records = records;
    }

    public String toString() {
        return "Page [total_count=" + this.total_count + ", records=" + this.records + "]";
    }
}
