package cn.dy.base.leaveapp.dao;

import cn.dy.base.framework.db.DBConnectPool;
import cn.dy.base.framework.db.DBUtil;
import cn.dy.base.framework.dict.DataDictFactory;
import cn.dy.base.framework.dict.DictItem;
import cn.dy.base.framework.dict.IDataDict;
import cn.dy.base.framework.esb.def.ServiceBusinessException;
import cn.dy.base.leaveapp.common.Page;
import cn.dy.base.leaveapp.domain.LeaveApplication;
import cn.dy.base.leaveapp.domain.LeaveType;
import cn.dy.base.leaveapp.service.SeniorityService;
import cn.dy.base.leaveapp.util.Tools;
import cn.dy.base.leaveapp.vo.MemberInfoVo;
import com.ctc.wstx.util.StringUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 17:01 2018/12/3
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class SeniorityDao {
    protected static Logger logger = LoggerFactory.getLogger(MemberDao.class);
    private TransactionTemplate transactionTemplate;//事务
    private DataSource dataSource = DBConnectPool.create().getDataSource();
    //private JdbcTemplate jdbcTemplate;
    // 获取DB数据字典
    IDataDict dataDict = null;
    private NamedParameterJdbcTemplate namedParameterJdbcTemplate;
    private static final String QUERY_MEMBER = "select a.ID id, a.`NAME` name, case when a.GENDER=1 then '男' else '女' end gender, a.IDCARD idcard,a.`CODE` policecode,b.`NAME` dept, a.JOINTIME jointime from \n" +
            " ecc_contact_info a LEFT join ecc_contact_holder c on  a.ID=c.CONTACT_ID LEFT JOIN ecc_contact_group b ON c.GROUP_ID=b.ID where 1=1 ";

    public SeniorityDao() {
        if(transactionTemplate == null){
            DataSourceTransactionManager tm = new DataSourceTransactionManager(dataSource);
            this.transactionTemplate = new TransactionTemplate(tm);
        }
        if(namedParameterJdbcTemplate == null){
            this.namedParameterJdbcTemplate = new NamedParameterJdbcTemplate(this.dataSource);
        }
        if(dataDict == null){
            this.dataDict=DataDictFactory.getDBFactory();
        }

    }

    public long countOfMembers(SeniorityService.SeniorityServiceParam param) {
        Map<String, Object> params = new LinkedHashMap();
        String sSql = this.createParameters(param, params);
        return this.namedParameterJdbcTemplate.queryForLong(DBUtil.getCountSql(sSql), params);
    }
    public Object getSeniorityList(final SeniorityService.SeniorityServiceParam param) {
        return (Page) this.transactionTemplate.execute(new TransactionCallback<Page<MemberInfoVo>>() {
            public Page<MemberInfoVo> doInTransaction(TransactionStatus status) {
                Page<MemberInfoVo> page = new Page();
                page.setTotal_count(countOfMembers(param));
                List<MemberInfoVo> lst = querySeniorityList(param);

                for (MemberInfoVo memberInfoVo : lst) {
                    if(memberInfoVo.getJoinTime() != null)
                    {
                        setSeniorityDate(memberInfoVo);
                    }else{
                        memberInfoVo.setSeniority(0);
                        memberInfoVo.setFurloughDays(0);
                        memberInfoVo.setLeftFurloughDays(0);
                    }

                    //SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    }
                page.setRecords(lst);
                return page;
            }
        });
    }

    /**
     3、年休假的计算：
     ①　工龄满1年不满10年的，年休假5天，
     ②　工龄满10年不满20年的，年休假10天，
     ③　工龄满20年及以上的，年休假15天，
     ④　年内若出现下列情形之一的，年休假为0天：
     (1)请事假累计20天以上；
     (2)累计工龄满1年不满10年的，请病假累计60天以上的；
     (3)累计工龄满10年不满20年的，请病假累计90天以上的；
     (4)累计工龄满20年及以上的，请病假累计120天以上的；
     如已享受当年年休假，年内又出现以上情形之一的，下一年年休假为0天
     ⑤　从达到工龄起的下月起享受相应的年休假天数，如在12月满工作年限的，从下年度起享受相应的年休假天数。
     * @param memberInfoVo
     */
    private void setSeniorityDate(MemberInfoVo memberInfoVo) {
        //工龄计算
        Date joinDay = memberInfoVo.getJoinTime();
        Calendar cal = Calendar.getInstance();
        if (cal.before(joinDay)) {
            throw new ServiceBusinessException("无效的加入时间，加入时间大于当前时间", "加入时间大于当前时间");
        }
        int yearNow = cal.get(Calendar.YEAR);
        int monthNow = cal.get(Calendar.MONTH) + 1;
        int dayOfMonthNow = cal.get(Calendar.DAY_OF_MONTH);
        cal.setTime(joinDay);
        int yearJoin = cal.get(Calendar.YEAR);
        int monthJoin = cal.get(Calendar.MONTH) + 1;
        int dayOfMonthJoin = cal.get(Calendar.DAY_OF_MONTH);
        int year = yearNow - yearJoin;
        if (monthNow <= monthJoin) {
            if (monthNow == monthJoin) {
                if (dayOfMonthNow < dayOfMonthJoin) {
                    year--;
                }
            } else {
                year--;
            }
        }

        //cn.dy.base.framework.dict.DBDataDict
        memberInfoVo.setSeniority(year);//工龄
        if(year == 0 || overLeaveLastYear(yearNow, monthJoin, dayOfMonthJoin, memberInfoVo.getId(), year)){
            memberInfoVo.setFurloughDays(0);
            memberInfoVo.setLeftFurloughDays(0);
            return;
        }
        boolean overSickLeaveMonths = overSickLeaveMonths(yearNow, monthNow, dayOfMonthNow, year, monthJoin, dayOfMonthJoin, memberInfoVo.getId()+"");//病假
        boolean overbusyLeaveDays = overBusyLeaveDays(yearNow, monthNow, dayOfMonthNow, monthJoin, dayOfMonthJoin, memberInfoVo.getId()+"");//事假
        if(overSickLeaveMonths || overbusyLeaveDays){//今年的超期事病假
            memberInfoVo.setFurloughDays(0);
            memberInfoVo.setLeftFurloughDays(0);
            return;
        }

        int usedfurloughDays = getUsedFurloughDays(yearNow, monthNow, dayOfMonthNow, monthJoin, dayOfMonthJoin, memberInfoVo.getId());
        if(year < 10){
            int i = Integer.parseInt(dataDict.decodeParam("LEAVE_APP","leave_1"));
            memberInfoVo.setFurloughDays(i);//5
            memberInfoVo.setLeftFurloughDays(i-usedfurloughDays);
        }
        if(year >= 10 && year < 20){
            int i = Integer.parseInt(dataDict.decodeParam("LEAVE_APP","leave_2"));
            memberInfoVo.setFurloughDays(i);//10
            memberInfoVo.setLeftFurloughDays(i-usedfurloughDays);
        }
        if(year >= 20){
            int i = Integer.parseInt(dataDict.decodeParam("LEAVE_APP","leave_3"));
            memberInfoVo.setFurloughDays(i);//15
            memberInfoVo.setLeftFurloughDays(i-usedfurloughDays);
        }
    }

    /**
     * 查询剩余休假天数
     * @return
     */
    public Object getLeftFurloughDays(String staff_id) {

        Map<String, Object> params = new HashMap<>();
        StringBuffer sql = new StringBuffer(QUERY_MEMBER);
        if (StringUtils.isNotEmpty(staff_id)) {
            sql.append(" and a.STAFF_ID = :STAFF_ID");
            params.put("STAFF_ID", staff_id);
        }

        RowMapper<MemberInfoVo> rowMapper = new RowMapper<MemberInfoVo>() {
            public MemberInfoVo mapRow(ResultSet rs, int rowNum) throws SQLException {
                MemberInfoVo member = new MemberInfoVo();
                member.setId(rs.getLong("id"));
                member.setDept(rs.getString("dept"));
                member.setGender(rs.getString("gender"));
                member.setIdcard(rs.getString("idcard"));
                member.setJoinTime(rs.getString("jointime") == null ? null : Tools.parseDate(rs.getString("jointime")));
                member.setPolicecode(rs.getString("policecode"));
                member.setName(rs.getString("name"));
                return member;
            }
        };
        List<MemberInfoVo> list =  this.namedParameterJdbcTemplate.query(sql.toString(), params, rowMapper);

        MemberInfoVo memberInfoVo = list != null && list.size() > 0 ? (MemberInfoVo) list.get(0) : null;
        if(memberInfoVo == null) throw  new ServiceBusinessException("角色信息错误","角色信息错误");
        Map<String, Object> map = new HashMap<>();
        if(memberInfoVo.getJoinTime() != null)
        {
            setSeniorityDate(memberInfoVo);
            map.put("days",memberInfoVo.getFurloughDays());
            map.put("leftdays", memberInfoVo.getLeftFurloughDays());

        }else{
            map.put("days", 0);
            map.put("leftdays", 0);
        }
        return map;
    }

    /**
     * 已休假天数
     * @param yearNow
     * @param monthNow
     * @param dayOfMonthNow
     * @param monthJoin
     * @param dayOfMonthJoin
     * @return
     */
    private int getUsedFurloughDays(int yearNow, int monthNow, int dayOfMonthNow, int monthJoin, int dayOfMonthJoin, long userId) {
        Map<String, Object> params = new HashMap();
        int yearbegin=yearNow;
        if (monthNow <= monthJoin) {
            if (monthNow == monthJoin) {
                if (dayOfMonthNow < dayOfMonthJoin) {
                    yearbegin--;
                }
            } else {
                yearbegin--;
            }
        }
        String begindate = yearbegin+"-"+monthJoin+"-"+dayOfMonthJoin+" 00:00:00";
        String enddate = yearNow+"-"+monthNow+"-"+dayOfMonthNow+" 23:59:59";
        //请休假的天数=本年提交的请休假的审批状态为待审批和审批通过时的累计请休假的天数
        String sql = "select sum(duration) from\n" +
                " bz_leave_application c LEFT JOIN ecc_contact_info d on c.apply_id = d.ID" +
                " WHERE d.ID=:id AND c.sts<>"+ LeaveApplication.LeaveSts.DELETE +
                " \n AND c.leave_type=" + LeaveType.FURLOUGH.getIndex()+
                " and  c.create_time BETWEEN :begindate AND :enddate";
        params.put("id", userId);
        params.put("begindate", begindate);
        params.put("enddate", enddate);
        int usedday = 0;
        try {
            usedday= (Integer)this.namedParameterJdbcTemplate.queryForInt(sql,params);
        } catch (EmptyResultDataAccessException e) {
            usedday= 0;
        }
        return usedday;
    }

    /**
     * select count(1) -- , MAX(TO_DAYS(a.end_time)-TO_DAYS(a.begin_time)) max
     *  from
     *  bz_leave_application a LEFT JOIN ecc_contact_info b on a.apply_id = b.ID
     * WHERE b.ID=4 AND a.sts<>3  and (TO_DAYS(a.end_time)-TO_DAYS(a.begin_time)) >=15 and a.create_time > (select c.create_time from
     *  bz_leave_application c LEFT JOIN ecc_contact_info d on c.apply_id = d.ID WHERE d.ID=4 AND c.sts=2 -- 一个去年通过的休假
     *   AND c.leave_type=3 and  c.create_time BETWEEN '2018-01-01 00:00:00' AND '2018-12-29 00:00:00'
     *
     * )
     * and a.create_time BETWEEN '2018-01-01 00:00:00' AND '2018-12-29 00:00:00'
     * 均需判断此条件：去年已休假后，当年内又休超期事病假的，今年年休假为0天
     * @param userId
     * @return
     */
    private boolean overLeaveLastYear(int yearNow, int monthJoin, int dayOfMonthJoin, long userId, int year) {
        Map<String, Object> params = new HashMap();
        String begindate = (yearNow-1)+"-"+monthJoin+"-"+dayOfMonthJoin+" 00:00:00";
        String enddate = yearNow+"-"+monthJoin+"-"+dayOfMonthJoin+" 23:59:59";
        //一个去年最早通过的休假
        String sqlb = "select c.create_time from\n" +
                " bz_leave_application c LEFT JOIN ecc_contact_info d on c.apply_id = d.ID" +
                " WHERE d.ID=:id AND c.sts="+ LeaveApplication.LeaveSts.OVER +
                " \n AND c.leave_type=" + LeaveType.FURLOUGH.getIndex()+
                " and  c.create_time BETWEEN :begindate AND :enddate order by c.create_time limit 1";
        params.put("id", userId);
        params.put("begindate", begindate);
        params.put("enddate", enddate);

        String date = null;//休假时间
        try {
            date = this.namedParameterJdbcTemplate.queryForObject(sqlb, params, String.class);
        } catch (EmptyResultDataAccessException e) {
            date = "";
        }
        if(StringUtils.isEmpty(date)) return false;
        //事假的判断
        if(overBusyLeaveDays(yearNow,  monthJoin, dayOfMonthJoin, monthJoin, dayOfMonthJoin,userId+"")) return true;
        //病假的判断
        return overSickLeaveMonths(yearNow,  monthJoin,  dayOfMonthJoin, year,  monthJoin,  dayOfMonthJoin,userId+"");
    }

    /**
     * 是否请超期病假
     * @return
     * @param yearNow
     * @param monthNow
     * @param dayOfMonthNow
     * @param year
     * @param monthJoin
     * @param dayOfMonthJoin
     */
    private boolean overSickLeaveMonths(int yearNow, int monthNow, int dayOfMonthNow, int year, int monthJoin, int dayOfMonthJoin, String userId) {
        Map<String, Object> params = new HashMap();
        int yearbegin=yearNow;
        if (monthNow <= monthJoin) {
            if (monthNow == monthJoin) {
                if (dayOfMonthNow < dayOfMonthJoin) {
                    yearbegin--;
                }
            } else {
                yearbegin--;
            }
        }
        String begindate = yearbegin+"-"+monthJoin+"-"+dayOfMonthJoin+" 00:00:00";
        String enddate = yearNow+"-"+monthNow+"-"+dayOfMonthNow+" 23:59:59";

        String sql = "select sum(duration) duration from bz_leave_application a LEFT JOIN ecc_contact_info b on a.apply_id = b.ID \n" +
                "WHERE b.ID=:id AND a.sts<>" + LeaveApplication.LeaveSts.DELETE +
                " and a.leave_type=" + LeaveType.SICK.getIndex() +
                "\n and a.create_time BETWEEN :begindate AND :enddate GROUP BY b.ID";
        params.put("id", userId);
        params.put("begindate", begindate);
        params.put("enddate", enddate);
        long l = 0;
        try {
            l = namedParameterJdbcTemplate.queryForLong(sql, params);
        } catch (EmptyResultDataAccessException e) {
            l=0;
        }
        if(year < 10){
            if(l >= Long.parseLong(dataDict.decodeParam("LEAVE_APP","sick_leave_1"))) return true;//60)
        }
        if(year>=10 && year < 20){
            if(l >= Long.parseLong(dataDict.decodeParam("LEAVE_APP","sick_leave_2"))) return true;//90)
        }
        if(year >= 20){
            if(l >= Long.parseLong(dataDict.decodeParam("LEAVE_APP","sick_leave_3"))) return true;//120)
        }
        return false;
    }

    /**
     * 是否超过事假累计天数最大（一个年份内）超过20天
     * @param yearNow
     * @param monthNow
     * @param dayOfMonthNow
     * @param monthJoin
     * @param dayOfMonthJoin
     * @param userId
     * @return
     */
    private boolean overBusyLeaveDays(int yearNow, int monthNow, int dayOfMonthNow, int monthJoin, int dayOfMonthJoin, String userId) {
        Map<String, Object> params = new HashMap();
        int yearbegin=yearNow;
        if (monthNow <= monthJoin) {
            if (monthNow == monthJoin) {
                if (dayOfMonthNow < dayOfMonthJoin) {
                    yearbegin--;
                }
            } else {
                yearbegin--;
            }
        }
        String begindate = yearbegin+"-"+monthJoin+"-"+dayOfMonthJoin+" 00:00:00";
        String enddate = yearNow+"-"+monthNow+"-"+dayOfMonthNow+" 23:59:59";
        String sql = "select sum(duration) max from bz_leave_application a LEFT JOIN ecc_contact_info b on a.apply_id = b.ID \n" +
                "WHERE b.ID=:id AND a.sts<>3 and a.leave_type=" + LeaveType.BUSY.getIndex() +
                "\n and a.create_time BETWEEN :begindate AND :enddate GROUP BY b.ID";
        params.put("id", userId);
        params.put("begindate", begindate);
        params.put("enddate", enddate);
        int maxday = 0;
        try {
            maxday = namedParameterJdbcTemplate.queryForInt(sql, params);
        } catch (EmptyResultDataAccessException e) {
            maxday=0;
        }
        int day = Integer.parseInt(dataDict.decodeParam("LEAVE_APP","busy_leave"));//20
        return maxday > day;
    }


    public List<MemberInfoVo> querySeniorityList(SeniorityService.SeniorityServiceParam param) {

        Map<String, Object> params = new LinkedHashMap();
        String sSql = this.createParameters(param, params);
        RowMapper<MemberInfoVo> rowMapper = new RowMapper<MemberInfoVo>() {
            public MemberInfoVo mapRow(ResultSet rs, int rowNum) throws SQLException {
                MemberInfoVo member = new MemberInfoVo();
                member.setId(rs.getLong("id"));
                member.setDept(rs.getString("dept"));
                member.setGender(rs.getString("gender"));
                member.setIdcard(rs.getString("idcard"));
                member.setJoinTime(rs.getString("jointime") == null ? null : Tools.parseDate(rs.getString("jointime")));
                member.setPolicecode(rs.getString("policecode"));
                member.setName(rs.getString("name"));
                return member;
            }
        };
        int iPageNum = (int)param.getPageNum(); //? NumberUtils.toInt((String)fields.get("pageNum"), 0) : 0;
        int iPerPageSize = (int)param.getPageSize(); //fields != null ? NumberUtils.toInt((String)fields.get("pageSize"), 0) : 0;
        return iPageNum != 0 && iPerPageSize != 0 ? this.namedParameterJdbcTemplate.query(DBUtil.getPagingSql(sSql), DBUtil.parsePagingParam(params, iPageNum, iPerPageSize), rowMapper) : this.namedParameterJdbcTemplate.query(sSql, params, rowMapper);
    }

    private String createParameters(SeniorityService.SeniorityServiceParam param, Map<String, Object> params) {
            StringBuffer sbSql = new StringBuffer(QUERY_MEMBER);
            if (param != null) {
                long deptId = param.getDeptId();
                if (deptId > 0) {
                    sbSql.append(" and b.Id = :deptId");
                    params.put("deptId", deptId);
                }
                String gender = param.getGender();
                if(StringUtils.isNotEmpty(gender)){
                    sbSql.append(" and a.GENDER = :gender");
                    params.put("gender", gender);
                }
//姓名、身份证号、警号
                String query_member = param.getQuery();
                if (StringUtils.isNotEmpty(query_member)) {
                    sbSql.append(" and a.NAME = :query_member or a.IDCARD = :query_member or a.CODE = :query_member");
                    params.put("query_member", query_member);
                }
            }
            return sbSql.toString();
        }
}
