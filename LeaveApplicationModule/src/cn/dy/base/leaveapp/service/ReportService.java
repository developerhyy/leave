package cn.dy.base.leaveapp.service;

import cn.dy.base.framework.esb.def.ESBAnnotation;
import cn.dy.base.framework.esb.def.RepMessage;

import java.util.Date;
import java.util.Map;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 14:15 2018/11/29
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public interface ReportService {
    @ESBAnnotation(
            names = {"dept", "query", "pageNum", "pageSize"},
            req_login = false
    )
    RepMessage queryReportList(String dept, String query,long pageNum, long pageSize);
    class ReportServiceParam{
        String dept;
        String leave_type;
        Date start;//考勤开始时间
        Date end;//考勤结束时间
        String query;
        long pageSize;
        long pageNum;

        public String getDept() {
            return dept;
        }

        public void setDept(String dept) {
            this.dept = dept;
        }

        public String getQuery() {
            return query;
        }

        public void setQuery(String query) {
            this.query = query;
        }

        public long getPageSize() {
            return pageSize;
        }

        public void setPageSize(long pageSize) {
            this.pageSize = pageSize;
        }

        public long getPageNum() {
            return pageNum;
        }

        public void setPageNum(long pageNum) {
            this.pageNum = pageNum;
        }

        public String getLeave_type() {
            return leave_type;
        }

        public void setLeave_type(String leave_type) {
            this.leave_type = leave_type;
        }

        public Date getStart() {
            return start;
        }

        public void setStart(Date start) {
            this.start = start;
        }

        public Date getEnd() {
            return end;
        }

        public void setEnd(Date end) {
            this.end = end;
        }
    }
}

