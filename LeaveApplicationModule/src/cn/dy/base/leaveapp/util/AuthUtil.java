package cn.dy.base.leaveapp.util;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 14:36 2018/11/27
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */

import cn.dy.base.framework.db.util.DBExecuteUtil;
import cn.dy.base.framework.esb.call.imp.JsonServiceProxy;
import cn.dy.base.framework.util.SystemUtil;
/*import cn.dy.base.leaveapp.PassportModule;
import cn.dy.base.leaveapp.domain.AccountInfo;
import cn.dy.base.leaveapp.domain.SynAccountInfo;*/
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthUtil {
    protected static Logger logger = LoggerFactory.getLogger(AuthUtil.class);
    static AuthUtil instance;
    boolean needCall = true;
    String remoteUrl;
    String sysAccount;
    String sysPwd;

    private AuthUtil() {
        this.init();
    }

    private void init() {
       /* this.remoteUrl = Tools.getConfigValue("SYS_AUTH_CENTER", "RMI_URL", (String)null);
        if (this.remoteUrl != null && this.remoteUrl.startsWith("127.0.0.1:")) {
            String localIP = (String)SystemUtil.getLocalIPs().get(0);
            this.remoteUrl = this.remoteUrl.replaceAll("127.0.0.1:", localIP + ":");
        }

        this.sysAccount = Tools.getConfigValue("SYS_AUTH_CENTER", "SYS_ACCOUNT", (String)null);
        this.sysPwd = Tools.getConfigValue("SYS_AUTH_CENTER", "SYS_PWD", (String)null);
        if (this.sysAccount == null || this.sysPwd == null) {
            this.remoteUrl = null;
        }*/

    }

    public static AuthUtil create() {
        Class var0 = AuthUtil.class;
        synchronized(AuthUtil.class) {
            if (instance == null) {
                instance = new AuthUtil();
            }
        }

        return instance;
    }

    public boolean isNeedCall() {
        if (this.remoteUrl == null) {
            return false;
        } else {
            DBExecuteUtil db = new DBExecuteUtil();
            String sql = "select PARAM_VALUE from FRAME_DATA_DICT t where t.group_code='SYS_AUTH_CENTER' and t.param_code='RMI_URL'";
            String result = null;

            try {
                result = (String)db.queryObject(sql, String.class);
            } catch (Exception var7) {
                return false;
            }

            JsonServiceProxy<Boolean> jsonServiceProxy = new JsonServiceProxy("cn.dy.base.passport.service.PassportService", this.remoteUrl, Boolean.class);
            jsonServiceProxy.setParam("systemMsg", SystemUtil.getLocalMsg());
            jsonServiceProxy.setParam("sql", sql);
            jsonServiceProxy.setParam("dbMsg", result);

            try {
                return !(Boolean)jsonServiceProxy.call("isMe");
            } catch (Exception var6) {
                logger.warn("", var6);
                return false;
            }
        }
    }

    public void checkIsLocal() {
        /*Thread checkThread = new Thread() {
            public void run() {
                while(true) {
                    try {
                        if (PassportModule.context.containerStarted()) {
                            Thread.sleep(100L);
                            continue;
                        }
                    } catch (InterruptedException var2) {
                        ;
                    }

                    AuthUtil.this.needCall = AuthUtil.this.isNeedCall();
                    return;
                }
            }
        };*/
        //checkThread.start();
    }

    public String createToken() {
        if (this.remoteUrl != null && this.needCall) {
            JsonServiceProxy jsonServiceProxy = new JsonServiceProxy("cn.dy.base.passport.service.PassportService", this.remoteUrl, String.class);

            try {
                return (String)jsonServiceProxy.call("createToken");
            } catch (Exception var3) {
                logger.warn("", var3);
                return null;
            }
        } else {
            return null;
        }
    }

    /*public List<AccountInfo> getAccountInfosByToken(String token) {
        if (this.remoteUrl != null && this.needCall && token != null) {
            JsonServiceProxy jsonServiceProxy = new JsonServiceProxy("cn.dy.base.passport.service.PassportService", this.remoteUrl, List.class);

            try {
                jsonServiceProxy.setParam("sys_account", this.sysAccount);
                jsonServiceProxy.setParam("sys_pwd", this.sysPwd);
                if (this.sysPwd.length() > 30) {
                    jsonServiceProxy.setParam("is_encrypt", true);
                } else {
                    jsonServiceProxy.setParam("is_encrypt", false);
                }

                jsonServiceProxy.setParam("token", token);
                return (List)jsonServiceProxy.call("getAccountInfosByToken");
            } catch (Exception var4) {
                logger.warn("", var4);
                return null;
            }
        } else {
            return null;
        }
    }*/

    public String childAccountLogin(String childAccout, String childToken) {
        if (this.remoteUrl != null && this.needCall && childToken != null) {
            JsonServiceProxy jsonServiceProxy = new JsonServiceProxy("cn.dy.base.passport.service.PassportService", this.remoteUrl, String.class);

            try {
                jsonServiceProxy.setParam("sys_account", this.sysAccount);
                jsonServiceProxy.setParam("sys_pwd", this.sysPwd);
                if (this.sysPwd.length() > 30) {
                    jsonServiceProxy.setParam("is_encrypt", true);
                } else {
                    jsonServiceProxy.setParam("is_encrypt", false);
                }

                jsonServiceProxy.setParam("childAccout", childAccout);
                jsonServiceProxy.setParam("childToken", childToken);
                return (String)jsonServiceProxy.call("childAccountLogin");
            } catch (Exception var5) {
                logger.warn("", var5);
                return null;
            }
        } else {
            return null;
        }
    }

    /*public void synAccount(SynAccountInfo synAccountInfo) {
        if (this.remoteUrl != null && this.needCall && synAccountInfo != null) {
            JsonServiceProxy<Void> jsonServiceProxy = new JsonServiceProxy("cn.dy.base.passport.service.PassportService", this.remoteUrl, Void.class);
            synAccountInfo.sys_account = this.sysAccount;
            synAccountInfo.sys_pwd = this.sysPwd;
            if (synAccountInfo.sys_pwd.length() > 30) {
                synAccountInfo.pwd_is_md5 = true;
            } else {
                synAccountInfo.pwd_is_md5 = false;
            }

            jsonServiceProxy.setParam("accountInfo", synAccountInfo);
            jsonServiceProxy.call("synAccount");
        }
    }*/

    public boolean checkSysAccount() {
        if (this.remoteUrl != null && this.needCall) {
            JsonServiceProxy jsonServiceProxy = new JsonServiceProxy("cn.dy.base.passport.service.PassportService", this.remoteUrl, Boolean.class);

            try {
                jsonServiceProxy.setParam("sys_account", this.sysAccount);
                jsonServiceProxy.setParam("sys_pwd", this.sysPwd);
                if (this.sysPwd.length() > 30) {
                    jsonServiceProxy.setParam("is_encrypt", true);
                } else {
                    jsonServiceProxy.setParam("is_encrypt", false);
                }

                return (Boolean)jsonServiceProxy.call("checkSysAccount");
            } catch (Exception var3) {
                logger.warn("", var3);
                return false;
            }
        } else {
            return false;
        }
    }
}