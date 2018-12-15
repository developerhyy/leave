package cn.dy.base.leaveapp.dao;

import cn.dy.base.framework.db.DBConnectPool;
import cn.dy.base.framework.db.DBUtil;
import cn.dy.base.framework.db.util.DBExecuteUtil;
import cn.dy.base.leaveapp.common.Page;
import cn.dy.base.leaveapp.domain.MemberInfo;
import cn.dy.base.leaveapp.service.MemberService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 17:01 2018/11/29
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class MemberDao {
    protected static Logger logger = LoggerFactory.getLogger(MemberDao.class);
    private TransactionTemplate transactionTemplate;//事务
    private DataSource dataSource = DBConnectPool.create().getDataSource();
    //private JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
    private static final String QUERY_MEMBER = "select a.ID id,a.STAFF_ID staff_id, a.`NAME` name, case when a.GENDER=1 then '男' else '女' end gender, a.IDCARD idcard,a.`CODE` policecode, a.MOBILE_NBR1 mobile, b.`NAME` dept from \n ecc_contact_info a LEFT join ecc_contact_holder c on  a.ID=c.CONTACT_ID LEFT JOIN ecc_contact_group b ON c.GROUP_ID=b.ID where 1=1 ";
    // "select a.operation_id, a.operation_name, a.staff_id, b.account staff_account,\n  a.corp_id, a.module,a.child_module,a.operation_obj,c.account corp_account, a.operate_time, a.operate_content \n  from sm_operation_log a, sm_staff_info b, sm_corporation_info c\n where a.staff_id = b.id\n   and a.corp_id = c.id";
    public MemberDao() {
        if (this.transactionTemplate == null) {
            DataSourceTransactionManager tm = new DataSourceTransactionManager(dataSource);
            this.transactionTemplate = new TransactionTemplate(tm);
        }
        if (this.namedParameterJdbcTemplate == null) {
            this.namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(this.dataSource);
        }
    }

    public long countOfMembers(MemberService.MemberServiceParam param) {
        Map<String, Object> params = new LinkedHashMap();
        String sSql = this.createParameters(param, params);
        sSql = DBUtil.getCountSql(sSql);
        long l = this.namedParameterJdbcTemplate.queryForLong(sSql, params);
        return l;
    }
    public Object getMember(final MemberService.MemberServiceParam param){
        return (Page)this.transactionTemplate.execute(new TransactionCallback<Page<MemberInfo>>() {
            public Page<MemberInfo> doInTransaction(TransactionStatus status) {
                Page<MemberInfo> page = new Page();
                page.setTotal_count(countOfMembers(param));
                page.setRecords(queryMembers(param));
                return page;
            }
        });
    }




    public List<MemberInfo> queryMembers(MemberService.MemberServiceParam param) {
        Map<String, Object> params = new LinkedHashMap();
        String sSql = this.createParameters(param, params);
        RowMapper<MemberInfo> rowMapper = new RowMapper<MemberInfo>() {
            public MemberInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
                MemberInfo member = new MemberInfo();
                member.setId(rs.getLong("id"));
                member.setStaff_id(rs.getLong("staff_id"));
                member.setDept(rs.getString("dept"));
                member.setGender(rs.getString("gender"));
                member.setIdcard(rs.getString("idcard"));
                member.setMobile(rs.getString("mobile"));
                member.setPolicecode(rs.getString("policecode"));
                member.setName(rs.getString("name"));
                return member;
            }
        };
        int iPageNum = (int)param.getPageNum(); //? NumberUtils.toInt((String)fields.get("pageNum"), 0) : 0;
        int iPerPageSize = (int)param.getPageSize(); //fields != null ? NumberUtils.toInt((String)fields.get("pageSize"), 0) : 0;
        return iPageNum != 0 && iPerPageSize != 0 ? this.namedParameterJdbcTemplate.query(DBUtil.getPagingSql(sSql), DBUtil.parsePagingParam(params, iPageNum, iPerPageSize), rowMapper) : this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }
    private String createParameters(MemberService.MemberServiceParam param, Map<String, Object> params) {
        StringBuffer sbSql = new StringBuffer(QUERY_MEMBER);
        if (param != null) {
            long deptId = param.getDeptId();
            if (deptId > 0) {
                sbSql.append(" and b.Id = :deptId");
                params.put("deptId", deptId);
            }
//姓名、身份证号、警号
            String query_member = param.getQuery();
            if (StringUtils.isNotEmpty(query_member)) {
                sbSql.append(" and a.NAME = :query_member or a.IDCARD = :query_member or a.CODE = :query_member");
                params.put("query_member", query_member);
            }

            /*String operate_time_min = (String)fields.get("operate_time_min");
            if (StringUtils.isNotEmpty(operate_time_min)) {
                sbSql.append(" and a.operate_time >= :operate_time_min");
                params.put("operate_time_min", Tools.parseDate(operate_time_min));
            }*/
        }

        return sbSql.toString();
    }
    public String getCorpName() {
        DBExecuteUtil db = new DBExecuteUtil();
        new HashMap();
        String sql = "SELECT sci.NAME FROM sm_corporation_info sci WHERE id=1";
        return (String)db.queryObject(sql, String.class);
    }
}
