package cn.dy.base.leaveapp.test;

import cn.dy.base.framework.esb.def.RepMessage;
import cn.dy.base.leaveapp.common.Page;
import cn.dy.base.leaveapp.domain.AuditDetail;
import cn.dy.base.leaveapp.domain.LeaveApplication;
import cn.dy.base.leaveapp.domain.MemberInfo;
import cn.dy.base.leaveapp.service.LeaveManageService;
import cn.dy.base.leaveapp.service.MemberService;
import cn.dy.base.leaveapp.service.SeniorityService;
import cn.dy.base.leaveapp.support.LeaveManageController;
import cn.dy.base.leaveapp.support.MemberServiceController;
import cn.dy.base.leaveapp.support.SeniorityServiceImpl;
import cn.dy.base.leaveapp.util.Tools;
import cn.dy.base.leaveapp.vo.LeaveListVo;
import cn.dy.base.leaveapp.vo.MemberInfoVo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 17:08 2018/11/28
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class Test {
    public static void main(String[] args) {
        //MemberService memberService=new MemberServiceController();
        //memberService.getDeptTree(true,1065);
        System.out.println("========================");
        LeaveManageService leaveManageService = new LeaveManageController();

        //leaveManageService.createNewLeaveAuditingFlow(0,1+"",0+"",1001,1373);
        ArrayList<AuditDetail> list = new ArrayList<>(5);
        for(int i=0;i<5;i++){
            AuditDetail ad = new AuditDetail();
            ad.setFlow_id(1001);
            ad.setAudit_id(1+i);
            list.add(ad);
        }
        leaveManageService.createNewLeaveAuditingDetail(0,list);
        //leaveManageService.getLeave(1);
        LeaveApplication leaveApplication = new LeaveApplication();

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
        leaveApplication.setLeave_type(2+"");
        leaveApplication.setDuration(9);
        leaveApplication.setApply_id(1373);//申请人
        leaveApplication.setSts("0");
        try {
            leaveApplication.setBegin_time(Tools.parseDate("2018-11-26"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        leaveApplication.setEnd_time(Tools.parseDate("2018-12-04"));
        leaveApplication.setReason("ggdfgddg灌灌灌灌灌");
        RepMessage repMessage = leaveManageService.createNewLeaveApplication("hyy",leaveApplication);

        System.out.println(repMessage.getContent().get("result"));// new Date()为获取当前系统时间
        //System.out.println(new Date()+"+++++++" + new java.sql.Date(System.currentTimeMillis()));


       /* MemberService memberService = new MemberServiceController();
        RepMessage repMessage = memberService.queryMemberList("","郑晗炜",0,10);
List list = memberService.getDeptTree(true);
        //System.out.println(repMessage.getContent().get("result").toString());
        Page page = (Page)repMessage.getContent().get("result");
        List<MemberInfo> memberInfo = page.getRecords();
        System.out.println(memberInfo.get(0).getName());
System.out.println(list);*/

       /* LeaveManageService leaveManageService = new LeaveManageController();
        //{"leave_type", "audit_id", "sts", "begin_time", "end_time", "query", "pageNum", "pageSize"},
        //RepMessage repMessage = leaveManageService.queryApproveLeaveList("",1184,"",null,null,"",1,10);
        //RepMessage repMessage = leaveManageService.getLeave(10);
        //RepMessage repMessage = leaveManageService.getAudit(10);

        System.out.println(repMessage.getContent().get("result"));*/

       /* LeaveManageService leaveManageService = new LeaveManageController();
        RepMessage repMessage = leaveManageService.queryLeaveList("","",null,null,1,4);
        Page<LeaveListVo> page = (Page)repMessage.getContent().get("result");
        List<LeaveListVo> list = page.getRecords();
        for (LeaveListVo l:list
             ) {

            System.out.println(l.getCreate_time());
        }
        System.out.println(repMessage.getContent().get("result").toString());*/
        /*SeniorityService seniorityService = new SeniorityServiceImpl();
        RepMessage repMessage = seniorityService.getLeftFurloughDays("1373");
        System.out.println(repMessage.getContent().get("result"));*/
        //RepMessage repMessage = seniorityService.querySeniority("","","",1,10);
        /*Page<MemberInfoVo> page = (Page)repMessage.getContent().get("result");
        List<MemberInfoVo> list = page.getRecords();
        for (MemberInfoVo l:list
                ) {

            System.out.println(l.getName());
        }*/
    }
}
