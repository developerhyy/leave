package cn.dy.base.leaveapp.util;

import cn.dy.base.leaveapp.domain.ZTreeNode;

import java.util.*;

/**
 * @ Author     ：hyy.
 * @ Date       ：Created in 11:34 2018-12-5
 * @ Description：${description}
 * @ Modified By：hyy.
 * @Version: $version$
 */
public class GZTreeUtil {
    public GZTreeUtil() {
    }

    private static void sortGroupList(List lists) {
        Collections.sort(lists, new Comparator() {
            public int compare(ZTreeNode arg0, ZTreeNode arg1) {
                if (arg0.order_index < arg1.order_index) {
                    return -1;
                } else {
                    return arg0.order_index <= arg1.order_index ? 0 : 1;
                }
            }

            public int compare(Object obj, Object obj1) {
                return this.compare((ZTreeNode)obj, (ZTreeNode)obj1);
            }
        });
    }

    public static void createZTree(String rootName, List treeNodes, List nodes, String parentId, Map childNodeMap) {
        ZTreeNode node;
        if (treeNodes.size() == 0) {
            node = new ZTreeNode();
            node.name = rootName;
            node.dis_name = node.name;
            node.id = "101";
            node.is_delete = 0;
            node.order_index = 0;
            node.parent_id = "0";
            node.style = "9";
            node.sts = "1";
            node.iconOpen = "../scripts/zTree/css/zTreeStyle/img/diy/1_open.png";
            node.iconClose = "../scripts/zTree/css/zTreeStyle/img/diy/1_close.png";
            treeNodes.add(node);
            nodes.add(node);
        }

        Iterator iterator1;
        if (childNodeMap == null && nodes != null) {
            childNodeMap = new HashMap();
            iterator1 = nodes.iterator();

            while(iterator1.hasNext()) {
                node = (ZTreeNode)iterator1.next();
                List list = (List)((Map)childNodeMap).get(node.parent_id);
                if (list == null) {
                    list = new ArrayList();
                }

                node.dis_name = node.name;
                ((List)list).add(node);
                sortGroupList((List)list);
                ((Map)childNodeMap).put(node.parent_id, list);
            }
        }

        List list = (List)((Map)childNodeMap).get(parentId);
        if (list != null) {
            iterator1 = list.iterator();

            while(iterator1.hasNext()) {
                ZTreeNode node1 = (ZTreeNode)iterator1.next();
                treeNodes.add(node1);
                createZTree(rootName, treeNodes, nodes, node1.id, (Map)childNodeMap);
            }
        }

    }
}

