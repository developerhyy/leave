package cn.dy.base.leaveapp;

import cn.dy.base.framework.esb.def.IModule;
import cn.dy.base.framework.esb.def.IModuleContext;
import cn.dy.base.leaveapp.domain.LeaveApplication;
import cn.dy.base.leaveapp.service.LeaveManageService;
import cn.dy.base.leaveapp.service.MemberService;
import cn.dy.base.leaveapp.service.ReportService;
import cn.dy.base.leaveapp.service.SeniorityService;
import cn.dy.base.leaveapp.support.LeaveManageController;
import cn.dy.base.leaveapp.support.MemberServiceController;
import cn.dy.base.leaveapp.support.ReportServiceImpl;
import cn.dy.base.leaveapp.support.SeniorityServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Constructor;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 15:54 2018/11/26
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class LeaveApplicationModule implements IModule {
    public static LeaveManageController leaveManageController;
    public static IModuleContext context;
    protected  static Logger logger = LoggerFactory.getLogger(LeaveApplicationModule.class);
    HashMap<Class<?>, Class<?>> instanceMap;
    public LeaveApplicationModule() {
        this.init();
    }

    private void init() {
        logger.info("本模块实现类[" + LeaveApplicationModule.class + "]的类加载器:[" + LeaveApplicationModule.class.getClassLoader() + "]");
        this.instanceMap = new HashMap();
        //this.instanceMap.put(LoginService.class, LoginControl.class);
        //leaveManageController = new LeaveManageController();
        //this.instanceMap.put(CorporationService.class, CorporationControl.class);
        //this.instanceMap.put(StaffService.class, StaffControl.class);
        this.instanceMap.put(LeaveManageService.class, LeaveManageController.class);
        this.instanceMap.put(MemberService.class, MemberServiceController.class);
        this.instanceMap.put(SeniorityService.class, SeniorityServiceImpl.class);
        this.instanceMap.put(ReportService.class, ReportServiceImpl.class);
        /*this.instanceMap.put(FunctionService.class, FunctionControl.class);
        this.instanceMap.put(OperationService.class, OperationControl.class);
        this.instanceMap.put(GetAreaInfoServer.class, GetAreaInfoControl.class);
        this.instanceMap.put(DataDictService.class, DataDictControl.class);
        this.instanceMap.put(ReportService.class, ReportControll.class);*/
    }

    @Override
    public void loadModule(IModuleContext context) {
        context = context;
        //AuthUtil.create().checkIsLocal();

        /*try {
            Class cl = Class.forName("cn.dy.base.system.support.CheckerCreate");
            Constructor constructor = cl.getConstructor(LeaveManageController.class, IModuleContext.class);
            constructor.newInstance(leaveManageController, context);
        } catch (Throwable var4) {
            ;
        }*/
    }

    @Override
    public void uninstallModule() {
    }

    @Override
    public Object createService(Class<?> interfaceClass) {
        try {
            Class<?> cl = (Class)this.instanceMap.get(interfaceClass);
            Object result = null;
            if (cl != null) {
                result = cl.newInstance();
            }

            return result;
        } catch (Exception var4) {
            logger.warn("", var4);
            return null;
        }
    }

    @Override
    public boolean serviceAlive(String s) {
        return true;
    }
    public static void main(String[] args) {
        System.out.println(IModule.class.isAssignableFrom(LeaveApplicationModule.class));
    }
}
