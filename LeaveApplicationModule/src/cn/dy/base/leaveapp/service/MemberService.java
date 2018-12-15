package cn.dy.base.leaveapp.service;

import cn.dy.base.framework.esb.def.ESBAnnotation;
import cn.dy.base.framework.esb.def.RepMessage;

import java.util.List;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 14:15 2018/11/29
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public interface MemberService {
    @ESBAnnotation(
            names = {"deptId", "query", "pageNum", "pageSize"},
            req_login = false
    )
    RepMessage queryMemberList(long deptId, String query,long pageNum, long pageSize);
    @ESBAnnotation(
            names = {"all","staff_id"},
            req_login = false,
            req_log = true,
            record_log_detail = true
    )
    List getDeptTree(boolean all, long staff_id);
    class MemberServiceParam{
        long deptId;
        String dept;
        String query;
        long pageSize;
        long pageNum;

        public long getDeptId() {
            return deptId;
        }

        public void setDeptId(long deptId) {
            this.deptId = deptId;
        }

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
    }
}

