<html>
<head>
<title>应用选择</title>
<link rel="stylesheet" href="../zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<jsp:include flush="true" page="common_inc.jsp"></jsp:include>
<script type="text/javascript" src="fun_find.js" charset="UTF-8"></script>
<script type="text/javascript" src="../contact/scripts/pinyin.js" charset="UTF-8"></script>
<script type="text/javascript" src="../zTree/js/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript">
  var dhxWins;
  var tree;
  var tree_context_menu;
  var top_menu;
  var right_click_node = {id: '', name: '', parent_id: '', parent_name: ''}; 
	var zTree=null;
	
	function createTree() {
		
		var head = {
	    "service_name":"SystemFunctionService",
	    "operation_name":"getFunTree",
	    "version":"0100",
	    "timestamp":"",
	    "request_seq":"",
	    "request_source":""
	  }
		
		var param = {
			"all":false
	  }
	  
	  var options = {
		  "handleError": true,
		  "showProgressBar" : true
		}
		
		function callBack(data){
			if(zTree!=null)zTree.destroy();
			zTree=$.fn.zTree.init($("#tree"), setting, data);
			var rootNode=zTree.getNodes()[0];			
			rootNode.nocheck=true;
			zTree.updateNode(rootNode);
			if(rootNode&&rootNode.children&&rootNode.children.length>0){
				var node=rootNode.children[0];
				if(node){
			      zTree.selectNode(node,true);
			      zTree.cancelSelectedNode(node);
			  }    
			}
			setTimeout(doInit,1);			
	  }	
	  $.ServiceAgent.JSONInvoke(head, param, callBack, options);
	}  

	
	var setting = {
		edit: {
			enable: true,
			showRemoveBtn: false,
			showRenameBtn: false,
			drag:{
				isCopy:true,
				isMove:false,
				prev:false,
				inner:false,
				next:false
			}
		},
		
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "parent_id",
				rootPId: 0
			},
			key:{
			  name:"dis_name"
		  }			
		},				
		
		check:{
			chkboxType:{
				"Y" : "ps", 
				"N" : "s" 
			},
			enable:true
		},		
		

		
		view:{
			nameIsHTML:true,
			showTitle: false,
			selectedMulti:false
		}		
	};	
	
	
	function doInit(){
		if(parent&&parent.doInit){
			var selectedNodes=parent.doInit();
			for(var i=0;i<selectedNodes.length;i++){
				if(selectedNodes[i]==null||selectedNodes[i]=="")continue;
				var node=zTree.getNodeByParam("id", selectedNodes[i], null);
				if(!node)node=zTree.getNodeByParam("id", selectedNodes[i], null);
				if(node){
					zTree.checkNode(node,true,false);
					zTree.selectNode(node,true);
					zTree.cancelSelectedNode(node);
				}
			}			
		}
	}
	

	
	function doReturn(){	
  	var selected_id_list = new Array();
    var selected_name_list = new Array();

    var nodes = zTree.getCheckedNodes(true);  	
    for(var i=0;i<nodes.length;i++){
    	var node=nodes[i];
    	var select_id=node.id;
    	var select_name=node.name;
    	if(select_id=="ROOT")continue;
    	selected_id_list.push(select_id);
    	selected_name_list.push(select_name);    	
    }		
		
		if(parent&&parent.doReturn){
			parent.doReturn(selected_id_list,selected_name_list);
		}
		doCancel();
	}
	
	function doCancel(){
		if(parent&&parent.dhxWins&&parent.dhxWins.window("app_select_win"))
		parent.dhxWins.window("app_select_win").close();
	}
	
	
  function resizeEvent(){
  	setTimeout(resize,1);
  }
  
  function resize(){
  	if($.browser.msie ){    	
    	if($.browser.version=="10.0"){
		  	$("#treeParentArea").height($(window).height()-40);
		  	$("#tree").height($(treeParentArea).height()-20);    		
  	    $("#tree").width($(treeParentArea).width()-20)
  	  }
  	}
  	else{
		  	$("#treeParentArea").height($(window).height()-40);
		  	$("#tree").height($(treeParentArea).height()-20);    		
  	    $("#tree").width($(treeParentArea).width()-20)  		
  	}  	
  }
  
  
  $(function(){
  	
    document.title = "应用选择";
          
    //生成窗口组件
    dhxWins = new dhtmlXWindows();
    dhxWins.enableAutoViewport(true);
    
  	if($.browser.msie ){    	
    	if($.browser.version!="10.0"){
		  	$("table").css("height","100%");
  	  }
  	}


    resize();
    
    $(window).bind("resize",resizeEvent);
    createTree();
        
  });
</script>
</head>
<body style="margin:0px; padding:0px;overflow: hidden;">  
  <table border=0 width="100%">
    <tr>
      <td valign=top style="width:100%;height:100%">
      	<div id="treeParentArea" valign=top style="overflow:auto;width:100%;height:100%;">
           <ul id="tree" class="ztree" style="margin:0px;"></ul>
        </div>
      </td>  
    </tr>
    
    <tr>
      <td align="right" style="width:100%">
          <input type="button" style="height:23px;margin: 0px;padding:0px;" 
          value="刷新" onclick="createTree();return false;">
          <input type="button" style="height:23px;margin: 0px;padding:0px;" 
          value="确定" onclick="doReturn();return false;">
          <input type="button" style="height:23px;margin: 0px;padding:0px;" 
          value="取消" onclick="doCancel();return false;">      	
      </td>
    </tr>      
  </table>
</body>
</html>
