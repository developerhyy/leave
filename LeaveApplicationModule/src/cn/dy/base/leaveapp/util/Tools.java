//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package cn.dy.base.leaveapp.util;

import cn.dy.base.framework.db.DBUtil;
import cn.dy.base.framework.esb.def.FileAttach;
import cn.dy.base.framework.esb.def.ServiceBusinessException;
import cn.dy.base.framework.esb.util.ClassUtil;
import cn.dy.base.framework.util.encryption.RSAUtil;
//import cn.dy.base.system.SystemModule;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.security.KeyPair;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.jdbc.core.JdbcTemplate;

public class Tools {
    private static KeyPair keyPair;

    public Tools() {
    }

    public static synchronized KeyPair getRSAKeyPair() {
        if (keyPair == null) {
            keyPair = RSAUtil.generateKeyPair();
        }

        return keyPair;
    }

    public static Date parseDate(String date) {
        try {
            if(date == null){
                return null;
            }
            if(date.length() > 19)
                date = date.substring(0,19);
            if(date.length() < 12 )
                return DateUtils.parseDate(date, new String[]{"yyyyMMdd", "yyyy/MM/dd", "yyyy-MM-dd"});
            return DateUtils.parseDate(date, new String[]{"yyyyMMddHHmmss", "yyyy/MM/dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss"});
        } catch (ParseException var2) {
            throw new RuntimeException(var2);
        }
    }


    public static long getSequesce(String seqName, DataSource dataSource) {
        long l_seq = 0L;

        try {
            l_seq = (long)DBUtil.getSequence(new JdbcTemplate(dataSource), seqName);
            return l_seq;
        } catch (Exception var5) {
            var5.printStackTrace();
            throw new ServiceBusinessException("序列号获取失败", "获取" + seqName + "序列号失败");
        }
    }

    /*public static File saveAttach(String fieldName, String destFileName) {
        List<FileAttach> attaches = SystemModule.context.getAttachs();
        if (attaches != null) {
            Iterator var4 = attaches.iterator();

            while(var4.hasNext()) {
                FileAttach attach = (FileAttach)var4.next();
                if (StringUtils.equals(fieldName, attach.getFileName())) {
                    File destFile = new File(destFileName);
                    File tempFile = new File(attach.getSaveFileName());

                    try {
                        FileUtils.moveFile(tempFile, destFile);
                        return destFile;
                    } catch (IOException var8) {
                        throw new RuntimeException(var8);
                    }
                }
            }
        }

        return null;
    }
*/
    public static String[][] getObjValues(Object obj) {
        String[][] result = (String[][])null;

        try {
            Map<String, Field> map = new HashMap();
            ClassUtil.getAllFields(map, obj.getClass(), true, false, false, (Map)null);
            Collection<Field> fields = map.values();
            List<String> r = new ArrayList();
            List<String> n = new ArrayList();
            Iterator var7 = fields.iterator();

            while(var7.hasNext()) {
                Field field = (Field)var7.next();
                field.setAccessible(true);
                if (!Modifier.isStatic(field.getModifiers())) {
                    try {
                        n.add(field.getName());
                        Object value = field.get(obj);
                        r.add(value == null ? "" : value.toString());
                    } catch (Exception var9) {
                        ;
                    }
                }
            }

            result = new String[r.size()][2];

            for(int i = 0; i < r.size(); ++i) {
                result[i][0] = (String)n.get(i);
                result[i][1] = (String)r.get(i);
            }
        } catch (Exception var10) {
            ;
        }

        return result;
    }
}
