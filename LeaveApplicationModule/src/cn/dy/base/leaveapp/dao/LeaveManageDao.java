package cn.dy.base.leaveapp.dao;

import cn.dy.base.framework.db.DBConnectPool;
import cn.dy.base.framework.db.DBUtil;
import cn.dy.base.framework.esb.call.imp.JsonServiceProxy;
import cn.dy.base.framework.esb.def.RepMessage;
import cn.dy.base.framework.esb.def.ServiceBusinessException;
import cn.dy.base.leaveapp.common.Page;
import cn.dy.base.leaveapp.domain.*;
import cn.dy.base.leaveapp.service.LeaveManageService;
import cn.dy.base.leaveapp.util.SystemUtil;
import cn.dy.base.leaveapp.util.Tools;
import cn.dy.base.leaveapp.vo.LeaveListVo;
import cn.dy.base.leaveapp.vo.LeaveVo;
import com.ctc.wstx.util.StringUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 19:01 2018/11/27
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class LeaveManageDao {
    private TransactionTemplate transactionTemplate;//事务
    private DataSource dataSource = DBConnectPool.create().getDataSource();
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;

    public LeaveManageDao() {
        if (this.transactionTemplate == null) {
            DataSourceTransactionManager tm = new DataSourceTransactionManager(dataSource);
            this.transactionTemplate = new TransactionTemplate(tm);
        }
        if (this.namedParameterJdbcTemplate == null) {
            this.namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(this.dataSource);
        }
    }


    public long getUniqueId(String seqName) {
        return Tools.getSequesce(seqName, this.dataSource);
    }


    /**
     * 请假条列表记录总数（请假管理与请假审批公用方法）
     * @param param
     * @param sSql
     * @param params
     * @return
     */
    public long countOfLeaves(LeaveManageService.LeaveManageParam param, String sSql, Map<String, Object> params) {
        return this.namedParameterJdbcTemplate.queryForLong(DBUtil.getCountSql(sSql), params);
    }

    /**
     * 参数拼接方法（请假管理与请假审批公用方法）
     * @param param
     * @param params
     * @param sbSql
     * @return
     */
    private String createParameters(LeaveManageService.LeaveManageParam param, Map<String, Object> params, StringBuffer sbSql) {
        sbSql.append(" and leaveapp.sts>0 and detail.audit_sts is not null and flow.flow_sts is not null ");//固定条件
        if (param != null) {
            long id = param.getLeave_id();
            if (id > 0) {
                sbSql.append(" and leaveapp.id = :leave_id");
                params.put("leave_id", id);
            }
            int leaveSts = param.getLeaveSts();//只针对leave的sts
            if(leaveSts > 0){
                switch (leaveSts){
                    case 1:{//待审批
                        params.put("leavests", LeaveApplication.LeaveSts.AUDITING);
                        params.put("flowsts", AuditFlow.FlowSts.Auditing);
                        params.put("auditsts", AuditDetail.AuditDetailSts.WaitAudit);
                        sbSql.append(" and leaveapp.sts = :leavests and flow.flow_sts=:flowsts and detail.audit_sts=:auditsts");
                        break;
                    }
                    case 2:{//通过
                        params.put("leavests", LeaveApplication.LeaveSts.OVER);
                        params.put("flowsts", AuditFlow.FlowSts.Over);
                        params.put("auditsts", AuditDetail.AuditDetailSts.PassAudit);
                        sbSql.append(" and leaveapp.sts = :leavests and flow.flow_sts=:flowsts and detail.audit_sts=:auditsts");
                        break;
                    }
                    case 3:{//不通过
                        params.put("leavests", LeaveApplication.LeaveSts.OVER);
                        params.put("flowsts", AuditFlow.FlowSts.Over);
                        params.put("auditsts", AuditDetail.AuditDetailSts.Reject);
                        sbSql.append(" and leaveapp.sts = :leavests and flow.flow_sts=:flowsts and detail.audit_sts=:auditsts");
                        break;
                    }
                    case 4:{//撤回
                        params.put("leavests", LeaveApplication.LeaveSts.DELETE);
                        params.put("flowsts", AuditFlow.FlowSts.Invalid);
                        params.put("auditsts", AuditDetail.AuditDetailSts.Reject);
                        sbSql.append(" and leaveapp.sts = :leavests and flow.flow_sts=:flowsts and detail.audit_sts=:auditsts");
                        break;
                    }
                    default:
                        break;
                }
            }
            int approveSts = param.getApproveSts();
            if(approveSts > 0){
                switch (approveSts){
                    case 1:{//待审批
                        params.put("auditsts", AuditDetail.AuditDetailSts.WaitAudit);
                        sbSql.append(" and detail.audit_sts=:auditsts");
                        break;
                    }
                    case 2:{//通过
                        params.put("auditsts", AuditDetail.AuditDetailSts.PassAudit);
                        sbSql.append(" and detail.audit_sts=:auditsts");
                        break;
                    }
                    case 3:{//不通过
                        params.put("auditsts", AuditDetail.AuditDetailSts.Reject);
                        sbSql.append(" and detail.audit_sts=:auditsts");
                        break;
                    }
                    default:
                        break;
                }
            }
            String leave_type = param.getLeave_type();
            if (StringUtils.isNotEmpty(leave_type)) {
                sbSql.append(" and leaveapp.leave_type = :leave_type");
                params.put("leave_type", leave_type);
            }
            String query = param.getQuery();
            if(StringUtils.isNotEmpty(query)){
                sbSql.append(" and usr.NAME = :query_approve or usr.IDCARD = :query_approve or usr.CODE = :query_approve");
                params.put("query_approve", query);
            }
            Long audit_id = param.getAudit_id();
            if(audit_id > 0){
                sbSql.append(" and detail.audit_id=:audit_id ");
                params.put("audit_id", audit_id);
            }
            Long apply_id = param.getApply_id();
            if(apply_id > 0){
                sbSql.append(" and leaveapp.apply_id=:apply_id");
                params.put("apply_id",apply_id);
            }
            String beginTime = param.getBegin_time();
            if(StringUtils.isNotEmpty(beginTime)){
                sbSql.append(" and leaveapp.begin_time=:beginTime");
                params.put("beginTime",beginTime);
            }
            String endTime = param.getEnd_time();
            if (StringUtils.isNotEmpty(endTime)) {
                sbSql.append(" and leaveapp.end_time=:endTime");
                params.put("endTime",endTime);
            }
        }
        return sbSql.toString();
    }

    public void addLeave(LeaveApplication leaveApplication, boolean isNew) {
        Map<String, Object> parameters = DBUtil.getMapObj(leaveApplication);
        if(isNew){
            this.namedParameterJdbcTemplate.update("insert into bz_leave_application\n  (id, leave_type, begin_time, end_time, duration, reason, apply_id, create_time, sts)\nvalues\n  (:id, :leave_type, :begin_time, :end_time, :duration, :reason, :apply_id, :create_time, :sts)", parameters);
        }
        else{
            this.namedParameterJdbcTemplate.update(DBUtil.getUpdateSql(leaveApplication,"bz_leave_application"), parameters);
        }
    }


//<editor-fold> 单条请假详情

    public ArrayList<AuditDetail> getAudit(LeaveManageService.LeaveManageParam param){
        if(param.getLeave_id() <=0) throw new ServiceBusinessException("请假单leaveId为空","请假单leaveId为空");
        ArrayList<AuditDetail> arrayList = new ArrayList<>(5);
        AuditFlow auditFlow = getAuditFlow(0, param.getLeave_id());//application_id
        if(auditFlow==null)throw new ServiceBusinessException("请假单流程不存在","请假单流程不存在");
        List<AuditDetail> list = getAuditDetailList(auditFlow.getId());
        int num=0;
        long preId=0;
        while (list.size() > 0){
            Iterator<AuditDetail> it = list.iterator();
            num=list.size();
            while(it.hasNext()){
                AuditDetail ad = it.next();
                if(ad.getPre_id() == preId){
                    arrayList.add(ad);
                    preId = ad.getId();
                    it.remove();
                    break;
                }
            }
            if(list.size() == num) break;
        }
        return arrayList;
    }

    private List<AuditDetail> getAuditDetailList(long id) {
        String str = " case a.audit_sts ";
        str+=" when "+ AuditDetail.AuditDetailSts.WaitAudit +" then '待审批' ";
        str+=" when "+ AuditDetail.AuditDetailSts.PassAudit +" then '通过' ";
        str+=" when "+ AuditDetail.AuditDetailSts.Reject +" then '拒绝' ";
        str+=" when "+ AuditDetail.AuditDetailSts.Transfer +" then '转批' ";
        str+=" else '其他' end audit_stsTxt";
        LeaveManageService.LeaveAuditParam param = new LeaveManageService.LeaveAuditParam();
        param.setFlow_id(id);
        StringBuffer sbSql = new StringBuffer("SELECT a.id , a.flow_id, a.pre_id, b.name audit_name, a.audit_time, a.audit_sts, a.audit_remark, "+str+", a.create_time from bz_auditing_detail a left join ecc_contact_info b on a.audit_id=b.ID  where 1=1 \n ");
        Map<String, Object> params = new LinkedHashMap();//内部维持了一个双向链表,可以保持顺序
        String sSql = this.createAuditParameters(param, params, sbSql);
        RowMapper<AuditDetail> rowMapper = new RowMapper<AuditDetail>() {
            public AuditDetail mapRow(ResultSet rs, int rowNum) throws SQLException {
                AuditDetail auditDetail = new AuditDetail();
                auditDetail.setId(rs.getLong("id"));
                auditDetail.setFlow_id(rs.getLong("flow_id"));
                auditDetail.setPre_id(rs.getLong("pre_id"));
                auditDetail.setAudit_name(rs.getString("audit_name"));
                auditDetail.setAudit_time(rs.getString("audit_time") == null ? null : Tools.parseDate(rs.getString("audit_time")));
                auditDetail.setAudit_remark(rs.getString("audit_remark"));
                auditDetail.setAudit_sts(rs.getString("audit_sts"));
                auditDetail.setAudit_stsTxt(rs.getString("audit_stsTxt"));
                auditDetail.setCreate_time(rs.getString("create_time") == null ? null : Tools.parseDate(rs.getString("create_time")));
                return auditDetail;
            }
        };
        return  this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }

    private String createAuditParameters(LeaveManageService.LeaveAuditParam param, Map<String, Object> params, StringBuffer sbSql) {
        if (param != null) {
            long id = param.getFlow_id();
            if (id > 0) {
                sbSql.append(" and a.flow_id=:flow_id");
                params.put("flow_id", id);
            }
        }
        sbSql.append(" order by a.id ");
        return sbSql.toString();
    }

    public LeaveVo getLeave(LeaveManageService.LeaveManageParam param) {
        if(param.getLeave_id() == 0) throw new RuntimeException("参数未赋值");//初始化默认值0
        List<LeaveVo> list = this.queryLeaveApplication(param);
        return list != null && list.size() > 0 ? (LeaveVo) list.get(0) : null;
    }
    public List<LeaveVo> queryLeaveApplication(LeaveManageService.LeaveManageParam param) {
        String str = " case leaveapp.leave_type ";
        for (int i=1; i<=LeaveType.BIRTH.getIndex();i++){
            str += " when "+ i +" then '" + LeaveType.getName(i) + "' ";
        }
        str += " else '其他' end leave_type";
        StringBuffer sbSql = new StringBuffer("SELECT leaveapp.id id, "+str+" , leaveapp.begin_time, leaveapp.end_time, leaveapp.create_time, leaveapp.duration, leaveapp.sts, leaveapp.reason, usr.name apply_name \n"+
                "FROM bz_leave_application leaveapp LEFT JOIN bz_auditing_flow flow on leaveapp.id=flow.application_id LEFT JOIN bz_auditing_detail detail on flow.cur_detail_id=detail.id \n" +
                " LEFT JOIN ecc_contact_info usr on usr.STAFF_ID=leaveapp.apply_id  where 1=1 ");
        Map<String, Object> params = new LinkedHashMap();//内部维持了一个双向链表,可以保持顺序
        String sSql = this.createParameters(param, params, sbSql);
        RowMapper<LeaveVo> rowMapper = new RowMapper<LeaveVo>() {
            public LeaveVo mapRow(ResultSet rs, int rowNum) throws SQLException {
                LeaveVo leaveApplication = new LeaveVo();
                leaveApplication.setId(rs.getLong("id"));
                leaveApplication.setLeave_type(rs.getString("leave_type"));
                leaveApplication.setBegin_time(rs.getString("begin_time") == null ? null : Tools.parseDate(rs.getString("begin_time")));
                leaveApplication.setEnd_time(rs.getString("end_time") == null ? null : Tools.parseDate(rs.getString("end_time")));
                leaveApplication.setCreate_time(rs.getString("create_time") == null ? null : Tools.parseDate(rs.getString("create_time")));
                leaveApplication.setDuration(rs.getLong("duration"));
                leaveApplication.setSts(rs.getString("sts"));
                leaveApplication.setReason(rs.getString("reason"));
                leaveApplication.setApply_name(rs.getString("apply_name"));
                return leaveApplication;
            }
        };
        return  this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }


//</editor-fold>

//<editor-fold> 请假审批


    public Object getApproveLeaves(final LeaveManageService.LeaveManageParam param){
        return (Page)this.transactionTemplate.execute(new TransactionCallback<Page<LeaveListVo>>() {
            public Page<LeaveListVo> doInTransaction(TransactionStatus status) {
                String str = " case leaveapp.leave_type ";
                for (int i=1; i<=LeaveType.BIRTH.getIndex();i++){
                    str += " when "+ i +" then '" + LeaveType.getName(i) + "' ";
                }
                str += " else '其他' end leave_typeTxt";
                //添加detail_id,flow_id
                StringBuffer sbSql = new StringBuffer("SELECT flow.cur_detail_id cur_detail_id, leaveapp.id leaveId,flow.id flowId, detail.id detailId, leaveapp.apply_id apply_id, usr.name name, leaveapp.leave_type, " + str + ",leaveapp.begin_time, leaveapp.end_time,leaveapp.reason reason, leaveapp.create_time, detail.audit_time , leaveapp.sts leavests,flow.flow_sts flowsts, detail.audit_sts auditsts  \n"+
                        " FROM bz_auditing_detail detail LEFT JOIN bz_auditing_flow flow on flow.id=detail.flow_id LEFT JOIN bz_leave_application leaveapp on leaveapp.id=flow.application_id   \n" +
                        " LEFT JOIN ecc_contact_info usr on usr.STAFF_ID=leaveapp.apply_id  where 1=1");
                Map<String, Object> params = new LinkedHashMap();
                String sSql = createParameters(param, params, sbSql);
                sSql+=" order by leaveapp.id ";
                Page<LeaveListVo> page = new Page();
                page.setTotal_count(countOfLeaves(param, sSql, params));
                page.setRecords(queryApproveLeaves(param, sSql, params));
                return page;
            }
        });
    }
    /**
     * 请假审批假条列表
     * @param param
     * @param sSql
     * @param params
     * @return
     */
    public List<LeaveListVo> queryApproveLeaves(LeaveManageService.LeaveManageParam param, String sSql, Map<String, Object> params) {
        RowMapper<LeaveListVo> rowMapper = new RowMapper<LeaveListVo>() {
            public LeaveListVo mapRow(ResultSet rs, int rowNum) throws SQLException {
                LeaveListVo leaveListVo = new LeaveListVo();
                leaveListVo.setCur_detail_id(rs.getLong("cur_detail_id"));
                leaveListVo.setId(rs.getLong("leaveId"));
                leaveListVo.setLeaveId(rs.getLong("leaveId"));
                leaveListVo.setFlowId(rs.getLong("flowId"));
                leaveListVo.setDetailId(rs.getLong("detailId"));
                leaveListVo.setApply_id(rs.getLong("apply_id"));
                leaveListVo.setApply_name(rs.getString("name"));
                leaveListVo.setLeave_type(rs.getString("leave_type"));
                leaveListVo.setLeave_typeTxt(rs.getString("leave_typeTxt"));
                leaveListVo.setBegin_time(Tools.parseDate(rs.getString("begin_time")));
                leaveListVo.setEnd_time(Tools.parseDate(rs.getString("end_time")));
                leaveListVo.setReason(rs.getString("reason"));
                leaveListVo.setCreate_time(Tools.parseDate(rs.getString("create_time")));
                leaveListVo.setAudited_time(Tools.parseDate(rs.getString("audit_time")));
                leaveListVo.setSts(rs.getString("leavests"));
                leaveListVo.setFlowsts(rs.getLong("flowsts"));
                leaveListVo.setAuditsts(rs.getLong("auditsts"));
                return leaveListVo;
            }
        };
        int iPageNum = (int)param.getPageNum(); //? NumberUtils.toInt((String)fields.get("pageNum"), 0) : 0;
        int iPerPageSize = (int)param.getPageSize(); //fields != null ? NumberUtils.toInt((String)fields.get("pageSize"), 0) : 0;
        return iPageNum != 0 && iPerPageSize != 0 ? this.namedParameterJdbcTemplate.query(DBUtil.getPagingSql(sSql), DBUtil.parsePagingParam(params, iPageNum, iPerPageSize), rowMapper) : this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }
//</editor-fold>

//<editor-fold> 请假管理

    /**
     * 新增假条
     * @param name
     * @param leaveApplication
     * @return
     */
    public Long createNewLeave(final String name,final LeaveApplication leaveApplication){
        return (Long) this.transactionTemplate.execute(new TransactionCallback<Long>() {
            public Long doInTransaction(TransactionStatus status) {
                if (leaveApplication.getApply_id() <= 0) {
                    throw new ServiceBusinessException("用户未登陆","用户未登陆");
                }
                long id;
                if (leaveApplication.getId() <=0 && checkLeaveApplication(name, leaveApplication) > 0L) {
                    throw new ServiceBusinessException("已申请过此类假条","已申请过此类假条");
                } else {
                    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
                    boolean isNew = false;
                    if(leaveApplication.getId() > 0){
                        id=leaveApplication.getId();
                    }else{
                        id=getUniqueId("SEQ_BZ_LEAVE_APPLICATION");
                        isNew=true;
                    }
                    leaveApplication.setId(id);
                    leaveApplication.setCreate_time(Tools.parseDate((df.format(new Date()))));
                    leaveApplication.setSts("0");//状态:0初始1审批中2结束3删除
                    addLeave(leaveApplication,isNew);
                    /*if (functions != null && functions.length > 0) {
                        String[] var7 = functions;
                        int var6 = functions.length;

                        for(int var5 = 0; var5 < var6; ++var5) {
                            String func_id = var7[var5];
                            RoleControl.this.authorityDao.addRoleAuthority(role.getId(), func_id);
                        }
                    }*/

                    /*OperationControl operationControl = new OperationControl();
                    Operation operation = new Operation();
                    operation.module = "cn.dy.base.system";
                    operation.child_module = "cn.dy.base.system.Role";
                    operation.operation_obj = "角色";
                    if (SystemModule.context != null) {
                        try {
                            operation.staff_id = Integer.parseInt(SystemModule.context.getContextByName("staff_id").toString());
                            operation.corp_id = Integer.parseInt(SystemModule.context.getContextByName("corp_id").toString());
                        } catch (Exception var8) {
                            ;
                        }
                    }

                    operation.operation_name = "创建角色";
                    operation.operate_content = "操作员[" + operation.staff_id + "]创建角色[" + role.getName() + "]";
                    operationControl.writeOperationLog(operation);*/
                    return id;
                }
            }
        });
    }

    public Object getLeaves(final LeaveManageService.LeaveManageParam param){
        return (Page)this.transactionTemplate.execute(new TransactionCallback<Page<LeaveListVo>>() {
            public Page<LeaveListVo> doInTransaction(TransactionStatus status) {
                String str = " case leaveapp.leave_type ";
                for (int i=1; i<=LeaveType.BIRTH.getIndex();i++){
                    str += " when "+ i +" then '" + LeaveType.getName(i) + "' ";
                }
                str += " else '其他' end leave_typeTxt";
                StringBuffer sbSql = new StringBuffer("SELECT leaveapp.id id,"+str+", leaveapp.leave_type,leaveapp.begin_time, leaveapp.end_time, leaveapp.create_time, detail.audit_time audit_time, leaveapp.sts leavests,flow.flow_sts flowsts, detail.audit_sts auditsts \n" +
                       "FROM bz_leave_application leaveapp LEFT JOIN bz_auditing_flow flow on leaveapp.id=flow.application_id LEFT JOIN bz_auditing_detail detail on flow.cur_detail_id=detail.id \n" +
                       "LEFT JOIN ecc_contact_info usr on usr.STAFF_ID=leaveapp.apply_id  where 1=1 ");
                Map<String, Object> params = new LinkedHashMap();
                String sSql = createParameters(param, params, sbSql);
                Page<LeaveListVo> page = new Page();
                page.setTotal_count(countOfLeaves(param, sSql, params));
                page.setRecords(queryLeaves(param, sSql, params));
                return page;
            }
        });
    }

    /**
     * 新增时是否存在相同类型假条
     * @param name
     * @param leaveApplication
     * @return
     */
    public long checkLeaveApplication(String name, LeaveApplication leaveApplication) {
        //TODO 加入验证名字name与userid是否匹配
        Map<String, Object> parameters = new HashMap();
        parameters.put("leave_type", leaveApplication.getLeave_type());
        parameters.put("apply_id", leaveApplication.getApply_id());
        parameters.put("sts", leaveApplication.getSts());
        long name_num = this.namedParameterJdbcTemplate.queryForLong(DBUtil.getCountSql("select duration from bz_leave_application where leave_type=:leave_type and apply_id=:apply_id and sts=:sts"), parameters);
        return name_num;
    }

    /**
     * 请假管理假条列表
     * @param param
     * @param sSql
     * @param params
     * @return
     */
    public List<LeaveListVo> queryLeaves(LeaveManageService.LeaveManageParam param, String sSql, Map<String, Object> params) {
        RowMapper<LeaveListVo> rowMapper = new RowMapper<LeaveListVo>() {
            public LeaveListVo mapRow(ResultSet rs, int rowNum) throws SQLException {

                LeaveListVo leaveListVo = new LeaveListVo();
                leaveListVo.setId(rs.getLong("id"));
                leaveListVo.setLeave_typeTxt(rs.getString("leave_typeTxt"));
                leaveListVo.setLeave_type(rs.getString("leave_type"));
                leaveListVo.setBegin_time(Tools.parseDate(rs.getString("begin_time")));
                leaveListVo.setEnd_time(Tools.parseDate(rs.getString("end_time")));
                leaveListVo.setCreate_time(Tools.parseDate((rs.getString("create_time"))));
                leaveListVo.setAudited_time(Tools.parseDate(rs.getString("audit_time")));
                leaveListVo.setSts(rs.getString("leavests"));
                leaveListVo.setFlowsts(rs.getLong("flowsts"));
                leaveListVo.setAuditsts(rs.getLong("auditsts"));
                return leaveListVo;
            }
        };
        int iPageNum = (int)param.getPageNum(); //? NumberUtils.toInt((String)fields.get("pageNum"), 0) : 0;
        int iPerPageSize = (int)param.getPageSize(); //fields != null ? NumberUtils.toInt((String)fields.get("pageSize"), 0) : 0;
        return iPageNum != 0 && iPerPageSize != 0 ? this.namedParameterJdbcTemplate.query(DBUtil.getPagingSql(sSql), DBUtil.parsePagingParam(params, iPageNum, iPerPageSize), rowMapper) : this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }



//</editor-fold>


//<editor-fold> 审核流程和审核明细
    public Object createNewAuditingFlow(final LeaveManageService.LeaveAuditParam param) {
        //验证
        if(Integer.parseInt(param.getFlow_type()) !=AuditFlow.AuditFlowType.LEAVEAUDITFLOWTYPE || Integer.parseInt(param.getFlow_sts()) != AuditFlow.FlowSts.Auditing){
            throw new ServiceBusinessException("创建流程参数不正确！", "参数错误");
        }
        return (Long) this.transactionTemplate.execute(new TransactionCallback<Long>() {
            public Long doInTransaction(TransactionStatus status) {
                AuditFlow auditFlow = null;
                if(param.getFlow_id() > 0){
                    //无修改概念，有值就直接作废旧的建立新的
                    int i = invalidAuditFlow(param.getFlow_id());
                    int j = invalidAuditDetails(param.getFlow_id());
                }

                auditFlow = new AuditFlow();//新建
                long id = getUniqueId("SEQ_BZ_AUDITING_FLOW");
                auditFlow.setId(id);
                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
                auditFlow.setFlow_type(param.getFlow_type());
                auditFlow.setFlow_sts(param.getFlow_sts());
                auditFlow.setApplication_id(param.getApplication_id());//请假单id
                auditFlow.setCreate_id(param.getCreate_id());//申请人id
                auditFlow.setCreate_time(Tools.parseDate((df.format(new Date()))));
                int i = addAuditFlow(auditFlow);
                int j = initLeave(param.getApplication_id());
                return auditFlow.getId();

            }
        });
    }

    private int initLeave(long application_id) {
        /**
         * flow创建完成就将leavests改为1(审批中)
         */
        if(application_id <= 0) return 0;
        Map<String, Object> parameters = new HashMap<>(1);
        parameters.put("application_id", application_id);
        return this.namedParameterJdbcTemplate.update("update bz_leave_application set sts=1 where id=:application_id", parameters);
    }

    private int delAuditFlow(long flow_id) {
        if(flow_id <= 0) return 0;
        Map<String, Object> parameters = new HashMap<>(1);
        parameters.put("id", flow_id);
        return this.namedParameterJdbcTemplate.update("delete from bz_auditing_flow where id=:id", parameters);
    }
    private int delAuditDetails(long flow_id){
        if(flow_id <= 0) return 0;
        Map<String, Object> parameters = new HashMap();
        parameters.put("flow_id", flow_id);
        return this.namedParameterJdbcTemplate.update("delete from bz_auditing_detail where flow_id=:flow_id", parameters);
    }
    private int invalidAuditFlow(long flow_id){
        if(flow_id <= 0) return 0;
        Map<String, Object> parameters = new HashMap<>(1);
        parameters.put("flow_id", flow_id);
        int i = this.namedParameterJdbcTemplate.update("update bz_auditing_flow set flow_sts=2 where id=:flow_id", parameters);
        return i;
    }
    private int invalidAuditDetails(long flow_id){
        if(flow_id <= 0) return 0;
        Map<String, Object> parameters = new HashMap<>(1);
        parameters.put("flow_id", flow_id);
        int i = this.namedParameterJdbcTemplate.update("update bz_auditing_detail set audit_sts=2 where flow_id=:flow_id",parameters);
        return i;
    }

    private int addAuditFlow(AuditFlow auditFlow) {
        Map<String, Object> parameters = DBUtil.getMapObj(auditFlow);
        return this.namedParameterJdbcTemplate.update("insert into bz_auditing_flow\n  (id, flow_type, flow_sts, application_id, create_id, create_time)\nvalues\n  (:id, :flow_type, :flow_sts, :application_id, :create_id, :create_time)", parameters);
    }


    public AuditFlow getAuditFlow(long detail_id, long application_id){
        Map<String, Object> parameters = new HashMap();
        String str = "";
        if(detail_id > 0){
            parameters.put("id", detail_id);
            str = "select * from bz_auditing_flow where id=:id ";
        }
        if(application_id > 0){
            parameters.put("application_id", application_id);
            str = "select id,flow_type,flow_sts,application_id,create_id,create_time,cur_detail_id from bz_auditing_flow where application_id=:application_id and flow_sts="+AuditFlow.FlowSts.Auditing+" and flow_type="+AuditFlow.AuditFlowType.LEAVEAUDITFLOWTYPE;
        }

        List<AuditFlow> list =null;
        try {
            list = queryAuditFlow(str,parameters);

        } catch (EmptyResultDataAccessException e) {

        }
        return list != null && list.size() > 0 ? (AuditFlow) list.get(0) : null;
    }

    private List<AuditFlow> queryAuditFlow(String sSql,Map<String, Object> params) {
        RowMapper<AuditFlow> rowMapper = new RowMapper<AuditFlow>() {
            public AuditFlow mapRow(ResultSet rs, int rowNum) throws SQLException {
                AuditFlow auditDetail = new AuditFlow();
                auditDetail.setId(rs.getLong("id"));
                auditDetail.setFlow_type(rs.getString("flow_type"));
                auditDetail.setFlow_sts(rs.getString("flow_sts"));
                auditDetail.setApplication_id(rs.getLong("application_id"));
                auditDetail.setCreate_id(rs.getLong("create_id"));
                auditDetail.setCreate_time(Tools.parseDate(rs.getString("create_time")));
                auditDetail.setCur_detail_id(rs.getLong("cur_detail_id"));
                return auditDetail;
            }
        };
        return  this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }

    public Object createNewDetail(long flowOldId, ArrayList<AuditDetail> audit_details){
//HashMap<String, Object> map, long flow_id
        AuditDetail auditDetail = null;
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
        for(int i=0;i<audit_details.size();i++){
            if(i==0 && audit_details.get(i)!=null && auditDetail == null){
                audit_details.get(i).setPre_id(0);
                audit_details.get(i).setAudit_sts(0+"");
                audit_details.get(i).setCreate_time(Tools.parseDate((df.format(new Date()))));
                auditDetail=createNewAuditingDetail(audit_details.get(i));

                Map<String, Object> parameters = new HashMap();
                parameters.put("cur_detail_id", auditDetail.getId());
                parameters.put("flow_id", auditDetail.getFlow_id());
                /**
                 * detail创建第一条创建完成时将flow的cur_detail_id改为当前第一条detail
                 */
                int iii = this.namedParameterJdbcTemplate.update("update bz_auditing_flow set cur_detail_id=:cur_detail_id where id=:flow_id", parameters);
            }
            audit_details.get(i).setPre_id(auditDetail.getId());
            audit_details.get(i).setAudit_sts(0+"");
            audit_details.get(i).setCreate_time(Tools.parseDate((df.format(new Date()))));
            auditDetail = createNewAuditingDetail(audit_details.get(i));
        }
        return "success"+auditDetail.getFlow_id();
    }

    public AuditDetail createNewAuditingDetail(final AuditDetail auditDetail) {
        //验证
        if(auditDetail.getFlow_id() <= 0 )
            throw new ServiceBusinessException("未创建请假审核流程", "未创建请假审核流程");
        if(auditDetail.getAudit_id() <= 0 )
            throw new ServiceBusinessException("未指定审核人员", "未指定审核人员");
        return (AuditDetail) this.transactionTemplate.execute(new TransactionCallback<AuditDetail>() {
            public AuditDetail doInTransaction(TransactionStatus status) {
                long id = getUniqueId("SEQ_BZ_AUDITING_DETAIL");
                auditDetail.setId(id);
                //审核日期,审核备注在审核成功处，赋值
                long i = addAuditDetail(auditDetail);
                if(i<=0) throw new ServiceBusinessException("更新失败", "更新失败");
                return auditDetail;
            }
        });
    }

    private long addAuditDetail(AuditDetail auditDetail) {
        Map<String, Object> parameters = DBUtil.getMapObj(auditDetail);
        return this.namedParameterJdbcTemplate.update("insert into bz_auditing_detail\n  (id, flow_id, pre_id, audit_id, audit_sts, create_time)\nvalues\n  (:id, :flow_id, :pre_id, :audit_id, :audit_sts, :create_time)", parameters);
    }

    public Map<String,Integer> getSts() {
        Map<String,Integer> map = new HashMap<>();
        map.put("leaveinitial",LeaveApplication.LeaveSts.INITIAL);
        map.put("leaveauditing",LeaveApplication.LeaveSts.AUDITING);
        map.put("leaveover",LeaveApplication.LeaveSts.OVER);
        map.put("leavedel",LeaveApplication.LeaveSts.DELETE);
        map.put("flowauditing",AuditFlow.FlowSts.Auditing);
        map.put("flowover",AuditFlow.FlowSts.Over);
        map.put("flowinvalid",AuditFlow.FlowSts.Invalid);
        map.put("auditauditing",AuditDetail.AuditDetailSts.WaitAudit);
        map.put("auditpass",AuditDetail.AuditDetailSts.PassAudit);
        map.put("auditreject",AuditDetail.AuditDetailSts.Reject);
        map.put("audittranfer",AuditDetail.AuditDetailSts.Transfer);
        return map;
    }

    /**
     * 审批通过就是，，带入当前flowID，和detailID，改变flow的cur_detail_id为下一个审批detail,取值方式，detailsts=1
     * select detail from detail表，where preID=当前detailID。。flow.cur_detail_id改变当前ID，，当取值为空，表示最后一条，多修改flowsts=1与leavests=2状态
     * @param flowId
     * @param detailId
     * @return
     */
    public boolean passAudit(long flowId, long detailId) {
        Map<String, Object> param1 = new HashMap<>(1);
        param1.put("detailId",detailId);
        param1.put("auditSts", AuditDetail.AuditDetailSts.PassAudit);
        int j = this.namedParameterJdbcTemplate.update("update bz_auditing_detail set audit_sts=:auditSts where id=:detailId", param1);
        if(j<=0)return false;
        long next_detailId = 0;
        try {
            next_detailId = this.namedParameterJdbcTemplate.queryForLong("select id from bz_auditing_detail where pre_id=:detailId and audit_sts="+AuditDetail.AuditDetailSts.WaitAudit, param1);
        } catch (EmptyResultDataAccessException e) {//流程结束
            Map<String, Object> param2 = new HashMap<>(1);
            param2.put("flowId",flowId);
            param2.put("flowSts",AuditFlow.FlowSts.Over);
            int i = this.namedParameterJdbcTemplate.update("update bz_auditing_flow flow set flow.flow_sts=:flowSts where id=:flow_id", param2);
            if(i<=0)return false;

            Map<String, Object> param3 = new HashMap<>(1);
            param3.put("flowId",flowId);
            param3.put("leaveSts",LeaveApplication.LeaveSts.OVER);
            i = this.namedParameterJdbcTemplate.update("update bz_leave_application leaveapp set leaveapp.sts=:leaveSts where id=(select flow.application_id from bz_auditing_flow flow where flow.id=:flow_id)", param3);
            if(i<=0)return false;

            return true;
        }
        //下一流程
        Map<String, Object> parameters = new HashMap();
        parameters.put("flowId", flowId);
        parameters.put("cur_detail_id", next_detailId);
        j = this.namedParameterJdbcTemplate.update("update bz_auditing_flow set cur_detail_id=:cur_detail_id where id=:flow_id", parameters);
        if(j<=0)return false;
        return true;
    }

    /**
     * 不通过，，直接修改flow最终值为结束，leave状态为结束，，所有detail状态为已经结束，，，
     * @param flowId
     * @param detailId
     * @return
     */
    public boolean rejectAudit(long flowId, long detailId) {
        Map<String, Object> param1 = new HashMap<>(1);
        param1.put("flowId",flowId);
        param1.put("auditSts", AuditDetail.AuditDetailSts.Reject);
        int j = this.namedParameterJdbcTemplate.update("update bz_auditing_detail set audit_sts=:auditSts where flow_id=:flow", param1);//所有detail状态为已经结束
        if(j<=0)return false;

        Map<String, Object> param2 = new HashMap<>(1);
        param2.put("flowId",flowId);
        param2.put("flowSts",AuditFlow.FlowSts.Over);
        int i = this.namedParameterJdbcTemplate.update("update bz_auditing_flow flow set flow.flow_sts=:flowSts where id=:flow_id", param2);
        if(i<=0)return false;

        Map<String, Object> param3 = new HashMap<>(1);
        param3.put("flowId",flowId);
        param3.put("leaveSts",LeaveApplication.LeaveSts.OVER);
        i = this.namedParameterJdbcTemplate.update("update bz_leave_application leaveapp set leaveapp.sts=:leaveSts where id=(select flow.application_id from bz_auditing_flow flow where flow.id=:flow_id)", param3);
        if(i<=0)return false;

        return true;
    }

    //</editor-fold>
}
