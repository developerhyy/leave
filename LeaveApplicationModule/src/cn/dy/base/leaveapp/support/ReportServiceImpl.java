package cn.dy.base.leaveapp.support;

import cn.dy.base.framework.esb.def.RepMessage;
import cn.dy.base.leaveapp.dao.MemberDao;
import cn.dy.base.leaveapp.dao.ReportDao;
import cn.dy.base.leaveapp.service.ReportService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 14:15 2018/11/29
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class ReportServiceImpl implements ReportService {
    protected static Logger logger = LoggerFactory.getLogger(ReportServiceImpl.class);
    private ReportDao reportDao = null;

    public ReportServiceImpl() {
        if (this.reportDao == null) {
            this.reportDao = new ReportDao();
        }
    }

    @Override
    public RepMessage queryReportList(String dept, String query, long pageNum, long pageSize) {
        ReportService.ReportServiceParam param = new ReportServiceParam();
        param.setDept(dept);
        param.setQuery(query);
        param.setPageNum(pageNum);
        param.setPageSize(pageSize);

        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new HashMap();
            map.put("result", this.reportDao.getReportList(param));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("条件查询报表失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("条件查询报表失败");
        }
        return repMessage;
    }


}
