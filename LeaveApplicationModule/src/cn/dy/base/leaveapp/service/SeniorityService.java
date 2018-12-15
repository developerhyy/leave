package cn.dy.base.leaveapp.service;

import cn.dy.base.framework.esb.def.ESBAnnotation;
import cn.dy.base.framework.esb.def.RepMessage;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 16:29 2018/12/3
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public interface SeniorityService {
    @ESBAnnotation(
            names={"deptId", "gender", "query", "pageNum", "pageSize"},
            req_login = false
    )
    RepMessage querySeniority(long deptId, String gender, String query, long pageNum, long pageSize);
    @ESBAnnotation(
            names={"staff_id"},
            req_login = false
    )
    RepMessage getLeftFurloughDays(String staff_id);
    class SeniorityServiceParam{
        private long deptId;

        public long getDeptId() {
            return deptId;
        }

        public void setDeptId(long deptId) {
            this.deptId = deptId;
        }

        private String dept;
        private String gender;
        private String query;
        private long pageNum;
        private long pageSize;

        public String getDept() {
            return dept;
        }

        public void setDept(String dept) {
            this.dept = dept;
        }

        public String getGender() {
            return gender;
        }

        public void setGender(String gender) {
            this.gender = gender;
        }

        public String getQuery() {
            return query;
        }

        public void setQuery(String query) {
            this.query = query;
        }

        public long getPageNum() {
            return pageNum;
        }

        public void setPageNum(long pageNum) {
            this.pageNum = pageNum;
        }

        public long getPageSize() {
            return pageSize;
        }

        public void setPageSize(long pageSize) {
            this.pageSize = pageSize;
        }
    }
}
