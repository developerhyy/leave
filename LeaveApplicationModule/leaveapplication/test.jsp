<%@page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="zh-cmn-Hans">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="format-detection" content="telephone=no" />
    <title>测试leave</title>
    <jsp:include page="../assets/common_inc_app.jsp" flush="true"></jsp:include>
</head>
<body>
<input type="button" id="test" onclick="getLeave(1)" value="点击">
<script type="text/javascript">
    function getUrl(fil, id) {
        var Cnv = document.getElementById('myCanvas');
        var Cntx = Cnv.getContext('2d');//获取2d编辑容器
        var imgss =   new Image();//创建一个图片
        var agoimg=document.getElementById("ago");
        for (var intI = 0; intI < fil.length; intI++) {//图片回显
            var tmpFile = fil[intI];
            var reader = new FileReader();
            reader.readAsDataURL(tmpFile);
            reader.onload = function (e) {
                url = e.target.result;
                imgss.src = url;
                agoimg.src=url;
                agoimg.onload = function () {
                    //等比缩放
                    var m = imgss.width / imgss.height;
                    Cnv.height =300;//该值影响缩放后图片的大小
                    Cnv.width= 300*m ;
                    //img放入画布中
                    //设置起始坐标，结束坐标
                    Cntx.drawImage(agoimg, 0, 0,300*m,300);
                }
            }
        }
    }


    function  pressss(){//
        //获取canvas压缩后的图片数据
        var Pic = document.getElementById("myCanvas").toDataURL("image/png");
        var imgs =document.getElementById("press");
        imgs.src =Pic ;
        //上传
        // 去除多余，得到base64编码的图片字节流
        Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, "");
        //可以用ajax提交到后台，提交后可以直接存数据库，也可以保存成图片，此处略
        //alert(Pic);
        //Pic = window.atob(Pic);
        alert(Pic.length);
        var ia = new Uint8Array(Pic.length);
        for (var i = 0; i < Pic.length; i++) {
            ia[i] = Pic.charCodeAt(i);

        };
        alert(ia[0]);
        alert(ia[111]);
        alert(ia.length);
        //canvas.toDataURL 返回的默认格式就是 image/png
        //             var blob = new Blob([ia], {
        //                 type: "image/jpeg"
        //             });
        var head = {
            "service_name" : "SessionService",
            "operation_name" : "upload2",
            "token_id" : "",
            "user_id" : "",
            "version" : "0100",
            "timestamp" : "",
            "request_seq" : "",
            "request_source" : ""
        };
        var options = {"handleError" : true};
//alert($.JsonUtil.jso2json(blob));
        var param = {s:ia};
        function callBack(data) {
            alert($.JsonUtil.jso2json(data));
        }
        $.ServiceAgent.JSONInvoke(head, param, callBack, options);

    }
    function getLeave(id){
        var head = {
            "service_name" : "LeaveManageService",
            "operation_name" : "getLeave",
            "token_id" : "",
            "user_id" : "",
            "version" : "0100",
            "timestamp" : "",
            "request_seq" : "",
            "request_source" : ""
        };
        var options = {"handleError" : true};
//alert($.JsonUtil.jso2json(blob));
        var param = {leave_id:id};
        function callBack(data) {
            alert($.JsonUtil.jso2json(data));
            console.log($.JsonUtil.jso2json(data))
        }
        $.ServiceAgent.JSONInvoke(head, param, callBack, options);


    }
</script>
<input type="file" id="fileId" name="fileId" value="上传图片"
       hidefocus="true" onchange="getUrl(this.files,this.id);"/>
<canvas id="myCanvas"     style="display: none" ></canvas>
old img-><img src="" alt="" id="ago" style="width: 500px;"/>
<input type="button" value="ya suo->" onclick="pressss()" />
new img-><img src="" alt="" id="press"/>
</body>
</html>