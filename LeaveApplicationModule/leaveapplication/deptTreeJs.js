    var staff_id=0;
    if(staff_id <=0){
        staff_id = loginInfo.staff_id;
    }
    var zTree = null;

    var right_click_node = {
        id: '',
        name: '',
        parent_id: '',
        parent_name: ''
    };
    function chooseNode(treeNode) {
        right_click_node.id = treeNode.id;
        right_click_node.name = treeNode.name;
        right_click_node.parent_id = treeNode.parent_id;
        var parentTreeNode = treeNode.getParentNode();
        if (parentTreeNode)
            right_click_node.parent_name = parentTreeNode.name;
        else
            right_click_node.parent_name = "";
    }
    function createTree(){
        var head={
            "service_name":"MemberService",
            "operation_name":"getDeptTree"
        };
        var param={
            "all": true,
            "staff_id":staff_id
        };
        var options = {
            "handleError": false
        };
        function callBack(data){
            resizeTree();
            if(zTree != null){
                zTree.destroy();
            }
            zTree = $.fn.zTree.init($("#tree"),setting,data);
            var rootNode = zTree.getNodes()[0];
            if(rootNode && rootNode.children && rootNode.children.length > 0){
                var node = rootNode.children[0];
                if (node) {
                    zTree.selectNode(node, true);
                    zTree.cancelSelectedNode(node);
                }
            }

        };
        $.ServiceAgent.JSONInvoke(head, param, callBack, options);
    }

    function dropPrev(treeId, nodes, targetNode) {
        if (targetNode.id == "101")
            return false; //不能插入到根节点之前

        return true;
    }

    function dropNext(treeId, nodes, targetNode) {
        if (targetNode.id == "101")
            return false; //不能插入到根节点之后
        return true;
    }

    function dropInner(treeId, nodes, targetNode) {
        return true;
    }

    var setting = {
        edit: {
            enable: true,
            showRemoveBtn: false,
            showRenameBtn: false,
            drag: {
                isCopy: true,
                isMove: true,
                prev: dropPrev,
                inner: dropInner,
                next: dropNext
            }
        },

        data: {
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parent_id",
                rootPId: 0
            },
            key: {
                name: "dis_name"
            }
        },

        callback: {
            beforeDrag: function(treeId, treeNodes) {
                if (treeNodes) {
                    var treeNode = treeNodes[0];
                    if (treeNode.getParentNode() == null)
                        return false;
                }
                return true;
            },

            beforeDragOpen: function(treeId, treeNode) {
                return false;
            },

            beforeDrop: function(treeId, treeNodes, targetNode, moveType) {
                if (targetNode) {
                    moveApp(treeNodes[0], targetNode, moveType);
                    return true;
                }
                return false;
            },

            onDrop: function(event, treeId, treeNodes, targetNode, moveType) {
                if (targetNode) {
                    return true;
                }
                return false;
            },

            beforeClick: function(treeId, treeNode, clickFlag) {
                return true;
            },

            onClick: function(callEvent, treeId, treeNode, clickFlag) {
                if (treeNode)
                    onClickTree(treeNode);
                return true;
            },
            onRightClick: function(callEvent, treeId, treeNode) {
                if (treeNode) {
                    zTree.selectNode(treeNode, false);
                    onClickTree(treeNode);
                    //showRMenu(treeNode, callEvent.clientX, callEvent.clientY);
                }
                return true;
            }
        },

        view: {
            nameIsHTML: true,
            showTitle: false,
            selectedMulti: false
        }
    };

    //单击树节点时
    function onClickTree(treeNode) {
        //保存节点相关信息，供其他页面调用
        chooseNode(treeNode);
        var id = treeNode.id.toString();
        var cutStr = id.substring(0, 1);
        var cutId = id.substring(1);
        if (id != "101") {
            if (cutStr == "c") {
                $.form("#contactForm").sleep();
                $("#treeParentArea").show();
                //getStaffDetail(cutId, treeNode);
            } else {
                $.form("#tableForm").sleep();
                $("#treeParentArea").show();

//(cutStr+"+++++++++++++===========")
                //getFunDetail(id, treeNode);
            }
        }

    }
    function resizeTree() {

        if ($.browser.msie) {
            if ($.browser.version == "10.0") {
                $("#treeParentArea")
                    .height($(document.body).height() - 23 - 45);
                $("#treeParentArea").width($("#search_key").width() * 10 / 7);
                $("#tree").height($("#treeParentArea").height() - 20);
                $("#tree").width($("#treeParentArea").width() - 20);
            } else {
                $("#treeParentArea")
                    .height($(document.body).height() - 23 - 62);
                $("#tree").height($("#treeParentArea").height() - 10);
            }
        } else {
            $("#treeParentArea").height($(document.body).height() - 23 - 40);
            $("#tree").height($("#treeParentArea").height() - 40);
        }

    }


