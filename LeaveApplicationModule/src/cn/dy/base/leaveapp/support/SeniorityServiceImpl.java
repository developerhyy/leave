package cn.dy.base.leaveapp.support;

import cn.dy.base.framework.esb.def.RepMessage;
import cn.dy.base.leaveapp.dao.SeniorityDao;
import cn.dy.base.leaveapp.service.SeniorityService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 16:39 2018/12/3
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class SeniorityServiceImpl implements SeniorityService {
    SeniorityDao seniorityDao = null;
    protected Logger logger = LoggerFactory.getLogger(SeniorityServiceImpl.class);

    public SeniorityServiceImpl() {
        if(seniorityDao == null){
            this.seniorityDao = new SeniorityDao();
        }
    }

    @Override
    public RepMessage querySeniority(long deptId, String gender, String query, long pageNum, long pageSize) {
        SeniorityServiceParam param = new SeniorityServiceParam();
        param.setDeptId(deptId);
        param.setGender(gender);
        param.setQuery(query);
        param.setPageNum(pageNum);
        param.setPageSize(pageSize);
        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new HashMap();
            map.put("result", this.seniorityDao.getSeniorityList(param));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("条件查询人员失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("条件查询人员失败");
        }
        return repMessage;
    }

    @Override
    public RepMessage getLeftFurloughDays(String staff_id) {

        RepMessage repMessage = new RepMessage();
        try {
            Map<String, Object> map = new HashMap();
            map.put("result", this.seniorityDao.getLeftFurloughDays(staff_id));
            repMessage.setContent(map);
            repMessage.setResponse_code("0");
        } catch (Exception var10) {
            repMessage.setResponse_code("-1");
            repMessage.setResponse_desc("查询剩余休假天数失败");
            repMessage.setResponse_detail(var10.getLocalizedMessage());
            logger.warn("查询剩余休假天数失败");
        }
        return repMessage;
    }
}
