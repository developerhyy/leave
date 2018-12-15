<%@ page language="java" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>新源重工-实时监控</title>

<link rel="stylesheet" type="text/css" href="layout.css"/>


<!-- <jsp:include page="../assets/common_inc_new.jsp"  flush="true"></jsp:include> -->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
    body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
    /* æœç´¢ */
.searchMenu{
    width:386px;
    position: absolute;
    z-index: 10;
    left:20px;
    top:20px;
}
#searchMenu input:focus{
    outline: none;
}
/* æœç´¢æ¡† */
#searchForm{
    width: 100%;
    height: 38px;
    /*box-shadow: 0 2px 2px rgba(0,0,0,.15);*/
}
::-webkit-input-placeholder { /* WebKit browsers */
    color:#e9e9ea;
    outline: none;
    border-radius: 0;
}

.searchBox{
    float: left;
    width:260px;
    height:38px;
    position: relative;
    box-shadow: 1px 2px 1px rgba(0,0,0,.15);
}
.searchBox input{
    width:100%;
    height:38px;
    background: #ffffff;
    border:none;
    padding:9px 10px;
    border-radius: 2px 0 0 2px;
    outline: none;
    box-sizing: border-box;
}
.searchBox input:focus{
    outline: none;
    border:none;
    border-color: #ffffff;
    /*box-shadow: 0 0 0px rgba(207, 220, 0, 0.4);*/
    border-radius: 0;
}
.searchBox .cancleText{
    width:18px;
    height:18px;
    background-image: url("images/icon16.png");
    background-position: -21px -132px;
    position: absolute;
    right:10px;
    top:50%;
    margin-top: -9px;
    cursor: pointer;
    display: none;
}
.searchBtn{
    float: left;
    width:57px;
    height:38px;
    position: relative;
    cursor: pointer;
    border: none;
    box-shadow: 1px 2px 1px rgba(0,0,0,.15);
}
.searchBtn .searchButton{
    width:18px;
    height:18px;
    background-image: url("images/icon16.png");
    background-position: 0 -132px;
    position: absolute;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
}
.searchBtn .button{
    width:100%;
    height:38px;
    background: #fafafa;
    border:none;
    cursor: pointer;

}
.searchBtn .button.current{
    background-color: #f5f5f5;
}
/* æœç´¢æ¡† */

/* æ•°æ®åˆ—è¡¨ */
.searchDetails{
    width:100%;
    display: none;
    position: absolute;
    box-shadow:0 2px 2px rgba(0,0,0,.15);
    z-index:-5;
}
    </style>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=jrOddHXhZj6x8ebH9gMlX1yTLQIxXxBC"></script>
    
</head>

<body>

    <div id="left">
        <div class="anniuyi">
            <a href="#">全国车辆监控</a>
        </div>
        <div class="anniuer">
            <a href="#">故障情况分布</a>
        </div>
        <div class="anniusan">
            <a href="#">销售情况分布</a>
        </div>
        <div class="anniusi">
            <a href="#">返回主页</a>
        </div>
    </div>

    <div class="main_content">
        <div class="car on">
            <div id="center">
                <div id="allmap"></div>
            </div>

            <div id="right">
                <div class="shang" style="display:table; width:100%;"> 

                    <div class="one" style="padding-left:5%; display:table-cell; vertical-align:middle;">
                        <div class="tubiaoyi">
                            <img style=" display:inline-block;" src="images/clzs.png" width="18" height="20" longdesc="images/clzs.png" />
                            <label style=" line-height:18px;">车辆总数：</label>
                            <label id="totalcar" style=" font-size:20px; color: #0000ff; font-weight: bold; line-height:20px;">1290</label>
                        </div>
                        <div class="tubiaoer" style=" padding-top: 10%;">
                            <img style=" display:inline-block;" src="images/zxcl.png" width="20" height="19" longdesc="images/zxcl.png" />
                            <label style="">在线车辆：</label>
                            <label id="incar" style=" font-size:20px; color: #0000ff; font-weight: bold;"></label>
                        </div>
                        <div class="tubiaosan" style=" padding-top: 10%;">
                            <img style=" display:inline-block;" src="images/lxcl.png" width="20" height="19" longdesc="images/lxcl.png" />
                            <label style="">离线车辆：</label>
                            <label id="outcar" style=" font-size:20px; color: #ff0000; font-weight: bold;">117</label>
                        </div>
                        <div class="tubiaosi" style=" padding-top: 10%;">
                            <img style=" display:inline-block;" src="images/bjcl.png" width="24" height="23" longdesc="images/bjcl.png" />
                            <label style="">报警车辆：</label>
                            <label id="alarm" style=" font-size:20px; color: #ff0000; font-weight: bold;">27</label>
                        </div>
                    </div>  
                </div>
                <div class="zhong">
                    <!-- <div class="clzt">车辆状态</div> -->
                    <div id="carStatus" style="height: 100%"></div>
                </div>
                <div class="xia">
                    <div class="gzllfb">
                        故障类型分布（次）
                    </div>
                    <div id="fault_distributed" style="height: 100%"></div>

                </div>
            </div>
        </div>

        <div id="fault" class="error" style="height: 100%; margin: 0 auto;width: 80%;">
            <h2>全国车辆故障率分布</h2>

            <div id="container1" style="height: 100%"></div> 

            <div id="right">
                <div class="shang malfunction"> 
                    <div class="alarm">
                        <h3>12</h3>
                        <p>报警车辆数</p>
                    </div>
                    <div class="alarm">
                        <h3>36</h3>
                        <p>报警数量</p>
                    </div>
                </div>
                <div class="zhong">
                    <!-- <div class="clzt">车辆状态</div> -->
                    <div id="containe" style="height: 100%"></div>
                </div>
                <div class="xia">
                    <div class="gzllfb">
                        故障类型分布（次）
                    </div>
                    <div id="fault-type" style="height: 100%"></div>

                </div>
            </div>
        </div>

        <div id="rank_provien" class="sale" style="height: 100%; margin: 0 auto;width: 80%; ">
            <h2>全国各省销售分布</h2>

            <div id="sales" style="height: 100%"></div> 

            <div id="right">
                <div class="provience_ranking">
                    <div class="title">各省销量排名Top5</div>
                    <div class="ranking">
                        <ul>
                            <li class="first">
                                <span class="dot">No.1</span>
                                <span>福建</span>
                                <span>235</span>
                            </li>
                            <li class="second">
                                <span class="dot">No.2</span>
                                <span>浙江</span>
                                <span>200</span>
                            </li>
                            <li class="third">
                                <span class="dot ">No.3</span>
                                <span>江苏</span>
                                <span>195</span>
                            </li>
                            <li class="fourth">
                                <span class="dot ">No.4</span>
                                <span>上海</span>
                                <span>150</span>
                            </li>
                            <li class="fifth">
                                <span class="dot ">No.5</span>
                                <span>江西</span>
                                <span>100</span>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="agents_ranking">
                    <div class="title">代理商月销量排名Top5</div>
                    <div class="ranking">
                        <ul>
                            <li class="first">
                                <span class="dot">No.1</span>
                                <span>张三</span>
                                <span>36</span>
                            </li>
                            <li class="second">
                                <span class="dot ">No.2</span>
                                <span>李四</span>
                                <span>25</span>
                            </li>
                            <li class="third">
                                <span class="dot ">No.3</span>
                                <span>王五</span>
                                <span>12</span>
                            </li>
                            <li class="fourth">
                                <span class="dot">No.4</span>
                                <span>赵六</span>
                                <span>10</span>
                            </li>
                            <li class="fifth">
                                <span class="dot">No.5</span>
                                <span>陈七</span>
                                <span>9</span>
                            </li>
                        </ul>
                        
                    </div>
                </div>
            </div>
        </div>
        
    </div>

    <div class="searchMenu" style="display: block;padding-left: 113px;">
    <!-- 搜索框 -->
    <form action="" method="get" id="searchForm">
        <div class="searchBox">
            <input name="" style="outline: 0;" id="searchBox" type="text" autocomplete="off" onkeydown="if(event.keyCode == 32){return false;}" placeholder="搜索VIN、车牌号" maxlength="35">
            <div class="cancleText" style="display: none;"></div>
        </div><!--搜索框-->
        <button id="btn_search" class="searchBtn" onclick="initsearchlocalcarid();" title="搜索">
            <div class="button"></div>
            <div class="searchButton"></div>
        </button><!--搜索按钮-->
    </form>
    </div>
    
<script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/echarts-all-3.js"></script>
<script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts-stat/ecStat.min.js"></script>
<script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/extension/dataTool.min.js"></script>
<script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/map/js/china.js"></script>
<script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/map/js/world.js"></script>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ZUONbpqGBsYGXNIYHicvbAbM"></script>
<script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/extension/bmap.min.js"></script>
<script type="text/javascript" src="../scripts/jquery-1.8.1.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="../scripts/mask/jquery.loadmask.min.js" charset="UTF-8"></script>
<script type="text/javascript" src="../scripts/jquery-cookie-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="../scripts/jquery-service-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="../scripts/jquery-form-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="../scripts/jquery-validate-plugin.js" charset="UTF-8"></script>
<script type="text/javascript" src="../scripts/util.js" charset="UTF-8"></script>
<script type="text/javascript" src="../plug-in/js/mouse/mouse.js"></script>
<script type="text/javascript" src="../system/common/scripts/lhgdialog/lhgdialog.js?self=true&skin=idialog"></script>
<script type="text/javascript" src="../system/common/scripts/layout.js"></script>
<script type="text/javascript" src="../system/common/scripts/datepicker/WdatePicker.js"></script>

       
       
<script type="text/javascript">


    $(document).ready(function(){

         try{
                $.ServiceAgent.setServiceUrl("${home}/service");
            }
            catch(ex){
            }

            init();
            initout();
            inittotal();
            initalarmcar();
            initlocalcarid();



        // 百度地图API功能
    var map = new BMap.Map("allmap");    // 创建Map实例s
    map.centerAndZoom(new BMap.Point(116.404, 39.915), 5);  // 初始化地图,设置中心点坐标和地图级别
    //添加地图类型控件
    map.addControl(new BMap.MapTypeControl({
        mapTypes:[
            BMAP_NORMAL_MAP,
            BMAP_HYBRID_MAP
        ]}));     
    map.setCurrentCity("北京");          // 设置地图显示的城市 此项是必须设置的
    map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
        
        
        var dom = document.getElementById("containe");
        var myChart = echarts.init(dom);
        var faultType=document.getElementById("fault-type");
        var faultChart=echarts.init(faultType);
        var sales_province=document.getElementById("sales");
        var provice_sales=echarts.init(sales_province);
        var oStatus=document.getElementById("carStatus");
        var myStatus=echarts.init(oStatus);
        var faultDistribute=document.getElementById("fault_distributed");
        var distributeChart=echarts.init(faultDistribute);

        $('.anniuer').click(function(){
           
           $("#fault").addClass("on");
            myMap.resize();
            myChart.resize();
            faultChart.resize();

           $("#rank_provien").removeClass("on");
           $(".car").removeClass("on");
        })


        $('.anniusan').click(function(){
            $("#fault").removeClass("on");
            $(".car").removeClass("on");  

           $("#rank_provien").addClass("on");
           provice_sales.resize();
        })

        $('.anniuyi').click(function(){
            $(".car").addClass("on");
             myStatus.resize();
            distributeChart.resize();
            $("#rank_provien").removeClass("on");
             $("#fault").removeClass("on");
        })



        var salesOption = {
            title : {
                // text: '订单量',
                // subtext: '纯属虚构',
                x:'center'
            },
            tooltip : {
                trigger: 'item'
            },
            legend: {
                orient: 'vertical',
                x:'left',
                
            },
            dataRange: {
                x: 'left',
                y: 'bottom',
                splitList: [
                    {start: 500},
                    {start: 201, end: 500},
                    {start: 51, end: 200},
                    // {start: 11, end: 50, label: '10 到 200（自定义label）'},
                    {start: 11, end: 50},
                    // {start: 5, end: 5, label: '5（自定义特殊颜色）', color: 'black'},
                    {end: 10}
                ],
                color: ['#74aebf',  '#003691']
            },
            toolbox: {
                show: true,
                orient : 'vertical',
                x: 'right',
                y: 'center',
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            roamController: {
                show: true,
                x: 'right',
                mapTypeControl: {
                    'china': true
                }
            },
            series : [
                {
                    name: '销售量',
                    type: 'map',
                    mapType: 'china',
                    roam: false,
                    itemStyle:{
                        normal:{
                            label:{
                                show:true,
                                textStyle: {
                                   color: "rgb(249, 249, 249)"
                                }
                            }
                        },
                        emphasis:{label:{show:true}}
                    },
                    data:[
                        {name: '北京',value: Math.round(Math.random()*600)},
                        {name: '天津',value: Math.round(Math.random()*600)},
                        {name: '上海',value: Math.round(Math.random()*600)},
                        {name: '重庆',value: Math.round(Math.random()*600)},
                        {name: '河北',value: 0},
                        {name: '河南',value: Math.round(Math.random()*600)},
                        {name: '云南',value: 5},
                        {name: '辽宁',value: 305},
                        {name: '黑龙江',value: Math.round(Math.random()*600)},
                        {name: '湖南',value: 200},
                        {name: '安徽',value: Math.round(Math.random()*600)},
                        {name: '山东',value: Math.round(Math.random()*600)},
                        {name: '新疆',value: Math.round(Math.random()*600)},
                        {name: '江苏',value: Math.round(Math.random()*600)},
                        {name: '浙江',value: Math.round(Math.random()*600)},
                        {name: '江西',value: Math.round(Math.random()*600)},
                        {name: '湖北',value: Math.round(Math.random()*600)},
                        {name: '广西',value: Math.round(Math.random()*600)},
                        {name: '甘肃',value: Math.round(Math.random()*600)},
                        {name: '山西',value: Math.round(Math.random()*600)},
                        {name: '内蒙古',value: Math.round(Math.random()*600)},
                        {name: '陕西',value: Math.round(Math.random()*600)},
                        {name: '吉林',value: Math.round(Math.random()*600)},
                        {name: '福建',value: Math.round(Math.random()*600)},
                        {name: '贵州',value: Math.round(Math.random()*600)},
                        {name: '广东',value: Math.round(Math.random()*600)},
                        {name: '青海',value: Math.round(Math.random()*600)},
                        {name: '西藏',value: Math.round(Math.random()*600)},
                        {name: '四川',value: Math.round(Math.random()*600)},
                        {name: '宁夏',value: Math.round(Math.random()*600)},
                        {name: '海南',value: Math.round(Math.random()*600)},
                        {name: '台湾',value: Math.round(Math.random()*600)},
                        {name: '香港',value: Math.round(Math.random()*600)},
                        {name: '澳门',value: Math.round(Math.random()*600)}
                    ]
                }
            ]
        };
                        
        if (salesOption && typeof salesOption === "object") {
            provice_sales.setOption(salesOption, true);
        }





        // var app = {};
        option = null;
        // app.title = '嵌套环形图';

        option = {
            tooltip: {
                trigger: 'item',
                formatter: "{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: 'left',
                
            },
            series: [
                {
                    name:'访问来源',
                    type:'pie',
                    selectedMode: 'single',
                    radius: [0, 0],

                    label: {
                        normal: {
                             backgroundColor: '#eee',
                             fontSize: 16,
                            position: 'center'
                        }
                    },
                    labelLine: {
                        normal: {
                            show: false
                        }
                    },
                    data:[
                        { name:'车辆状态', selected:true},
                       
                    ]
                },
                {
                    // name:'访问来源',
                    type:'pie',
                    radius: ['40%', '55%'],
                    label: {
                        normal: {
                            formatter: '{b|{b}：}{c} \n {per|{d}%}',
                            rich: {
                                b: {
                                    fontSize: 10,
                                     lineHeight: 20
                                },
                                per: {
                                    color: '#aaa',

                                    
                                }
                            }
                        }
                    },
                    data:[
                        {value:335, name:'直达'},
                        {value:310, name:'邮件营销'},
                        {value:234, name:'联盟广告'},
                        {value:135, name:'视频广告'},
                        {value:1048, name:'百度'},
                        {value:251, name:'谷歌'},
                        {value:147, name:'必应'},
                        {value:102, name:'其他'}
                    ]
                }
            ]
        };

        option2={
            tooltip: {
                trigger: 'item',
                formatter: "{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: 'left',
                
            },
            series: [
                {
                    name:'访问来源',
                    type:'pie',
                    selectedMode: 'single',
                    radius: [0, 0],

                    label: {
                        normal: {
                             backgroundColor: '#eee',
                             fontSize: 16,
                            position: 'center'
                        }
                    },
                    labelLine: {
                        normal: {
                            show: false
                        }
                    },
                    // data:[
                    //     { name:'车辆状态', selected:true},
                       
                    // ]
                },
                {
                    // name:'访问来源',
                    type:'pie',
                    radius: ['40%', '55%'],
                    label: {
                        normal: {
                            formatter: '{b}：{c}',
                            rich: {
                                b: {
                                    fontSize: 10,
                                     lineHeight: 20
                                },
                                per: {
                                    color: '#aaa',

                                    
                                    
                                    
                                }
                            }
                        }
                    },
                    data:[
                        {value:11, name:'电池高温报警'},
                        {value:4, name:'单体电池欠压报警'},
                        {value:4, name:'温度差异报警'},
                        {value:4, name:'单体电池液压报警'},
                        {value:2, name:'SOC低'},
                        {value:2, name:'车载储能装置类型过呀报警'},
                        
                    ]
                }
            ]
        }

        if (option && typeof option === "object") {
            myChart.setOption(option, true);
            myStatus.setOption(option,true);
        }

        if (option2 && typeof option2 === "object") {
            faultChart.setOption(option2, true);
            distributeChart.setOption(option2,true);
        }

        var oDiv = document.getElementById("container1");
        var myMap = echarts.init(oDiv);
        // var app = {};
        var option1 = null;
        function randomData() {
            return Math.round(Math.random()*600);
        }
        //故障类型分布图
        option1 = {
            title : {
                // text: '订单量',
                // subtext: '纯属虚构',
                x:'center'
            },
            tooltip : {
                trigger: 'item'
            },
            legend: {
                orient: 'vertical',
                x:'left',
                
            },
            dataRange: {
                x: 'left',
                y: 'bottom',
                splitList: [
                    // {start: 1500},
                    {start: 500},
                    {start: 201, end: 500},
                    {start: 51, end: 200},
                    // {start: 11, end: 50, label: '10 到 200（自定义label）'},
                    {start: 11, end: 50},
                    // {start: 5, end: 5, label: '5（自定义特殊颜色）', color: 'black'},
                    {end: 10}
                ],
                color: ['#e7c4c0',  '#d82823']
            },
            toolbox: {
                show: true,
                orient : 'vertical',
                x: 'right',
                y: 'center',
                feature : {
                    mark : {show: true},
                    dataView : {show: true, readOnly: false},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            roamController: {
                show: true,
                x: 'right',
                mapTypeControl: {
                    'china': true
                }
            },
            series : [
                {
                    name: '故障量',
                    type: 'map',
                    mapType: 'china',
                    roam: false,
                    itemStyle:{
                        normal:{
                            label:{
                                show:true,
                                textStyle: {
                                   color: "rgb(249, 249, 249)"
                                }
                            }
                        },
                        emphasis:{label:{show:true}}
                    },
                    data:[
                        {name: '北京',value: Math.round(Math.random()*600)},
                        {name: '天津',value: Math.round(Math.random()*600)},
                        {name: '上海',value: Math.round(Math.random()*600)},
                        {name: '重庆',value: Math.round(Math.random()*600)},
                        {name: '河北',value: 0},
                        {name: '河南',value: Math.round(Math.random()*600)},
                        {name: '云南',value: 5},
                        {name: '辽宁',value: 305},
                        {name: '黑龙江',value: Math.round(Math.random()*600)},
                        {name: '湖南',value: 200},
                        {name: '安徽',value: Math.round(Math.random()*600)},
                        {name: '山东',value: Math.round(Math.random()*600)},
                        {name: '新疆',value: Math.round(Math.random()*600)},
                        {name: '江苏',value: Math.round(Math.random()*600)},
                        {name: '浙江',value: Math.round(Math.random()*600)},
                        {name: '江西',value: Math.round(Math.random()*600)},
                        {name: '湖北',value: Math.round(Math.random()*600)},
                        {name: '广西',value: Math.round(Math.random()*600)},
                        {name: '甘肃',value: Math.round(Math.random()*600)},
                        {name: '山西',value: Math.round(Math.random()*600)},
                        {name: '内蒙古',value: Math.round(Math.random()*600)},
                        {name: '陕西',value: Math.round(Math.random()*600)},
                        {name: '吉林',value: Math.round(Math.random()*600)},
                        {name: '福建',value: Math.round(Math.random()*600)},
                        {name: '贵州',value: Math.round(Math.random()*600)},
                        {name: '广东',value: Math.round(Math.random()*600)},
                        {name: '青海',value: Math.round(Math.random()*600)},
                        {name: '西藏',value: Math.round(Math.random()*600)},
                        {name: '四川',value: Math.round(Math.random()*600)},
                        {name: '宁夏',value: Math.round(Math.random()*600)},
                        {name: '海南',value: Math.round(Math.random()*600)},
                        {name: '台湾',value: Math.round(Math.random()*600)},
                        {name: '香港',value: Math.round(Math.random()*600)},
                        {name: '澳门',value: Math.round(Math.random()*600)}
                    ]
                }
            ]
        };
                            
        if (option1 && typeof option1 === "object") {
            myMap.setOption(option1, true);
        }

        //在线车辆
        function init() {

            var head = {
                "service_name": "cn.dy.car.monitor.service.MonitorService",
                "operation_name": "getIncarInfo",
            }

            var param = {
                "cf": true
            }

            var options = {
                "handleError": true
            }

            function callBack(data) {
                //alert(data.content.result);
                $("#incar").text(data.content.result);
                
            }
            $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        }
        //总车辆
        function inittotal() {

            var head = {
                "service_name": "cn.dy.car.monitor.service.MonitorService",
                "operation_name": "getTotalcarInfo",
            }

            var param = {
                "cf": true
            }

            var options = {
                "handleError": true
            }

            function callBack(data) {
                //alert(data.content.result);
                $("#totalcar").text(data.content.result);
                
            }
            $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        }
        //离线车辆
        function initout() {

            var head = {
                "service_name": "cn.dy.car.monitor.service.MonitorService",
                "operation_name": "getOutcarInfo",
            }

            var param = {
                "cf": true
            }

            var options = {
                "handleError": true
            }

            function callBack(data) {
                //alert(data.content.result);
                $("#outcar").text(data.content.result);
                
            }
            $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        }
        //报警车辆
        function initalarmcar() {

            var head = {
                "service_name": "cn.dy.car.monitor.service.MonitorService",
                "operation_name": "getAlarmcarInfo",
            }

            var param = {
                "cf": true
            }

            var options = {
                "handleError": true
            }

            function callBack(data) {
                //alert(data.content.result);
                $("#alarmcar").text(data.content.result);
                
            }
            $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        }
        //数据初始化车辆定位车辆
        function initlocalcarid() {

            var head = {
                "service_name": "cn.dy.car.monitor.service.MonitorService",
                "operation_name": "getRedisuInfo",
            }

            var param = {
                //"cf": true
            }

            var options = {
                "handleError": true
            }

            function callBack(data) {
                //alert(data.content.result);
                //alert(data.content.result);
                //addMarker(data);//添加标注。
                addMarker(data);//添加标注。
                
            }
            $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        }
        //搜索框查询
        // function initsearchlocalcarid() {

        //     var head = {
        //         "service_name": "cn.dy.car.monitor.service.MonitorService",
        //         "operation_name": "getplatenumInfo",
        //     }

        //     var param = {
        //         "platenum":"12"
        //     }

        //     var options = {
        //         "handleError": true
        //     }

        //     function callBack(data) {
        //         //alert(data.content.result);
        //         alert(data.content.result);
        //         //addMarker(data);//添加标注。
        //         map.clearOverlays(); 
        //         addMarker(data);//添加标注。
                
        //     }
        //     $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        // }
        //显示信息窗口，显示标注点的信息。
        function showInfo(thisMaker,points){
        var sContent =
        '<ul class="info_ul">'
        +'<li class="info_li">'
        +'<span class="info_span">id：</span>' + points.car_id + '</li>'
        +'<li class="info_li">'
        +'<span class="info_span">名称：</span>' + points.latitude + '</li>'
        //+'<li class="info_li"><span class="info_span">查看：</span><a href="'+points.url+'" target="_blank">详情</a></li>'
        +'</ul>';
            var infoWindow = new BMap.InfoWindow(sContent);// 创建信息窗口对象
            thisMaker.openInfoWindow(infoWindow);//图片加载完毕重绘infowindow
        }
        function addMarker(data){  // 创建图标对象   
        var markers = [];
        var point = null;
        var carid = data.content.result
        //获取当前位置
        var geolocation = new BMap.Geolocation();  
        var pointsLen = carid.length
            // 创建标注对象并添加到地图   
            for(var i = 0;i <pointsLen;i++){
                point = new BMap.Point(carid[i].longitude,carid[i].latitude);    
                markers = new BMap.Marker(point);  
                map.addOverlay(markers); 
                //给标注点添加点击事件。使用立即执行函数和闭包
                (function() {
                    var thePoint = carid[i];
                    markers.addEventListener("click",function(){
                        showInfo(this,thePoint);
                        //getAddress(points);
                    });
                })();
            }
        }
        
           
        //alert(getBeforeDate(332));
        //页面加载完毕后 自动触发查询按钮
        //$("#btnQuery").click();




        window.onresize = function(){
             myMap.resize();
            myChart.resize();
            faultChart.resize();
             myStatus.resize();
            distributeChart.resize();
             provice_sales.resize();
        }



    })

 function initsearchlocalcarid() {

            var head = {
                "service_name": "cn.dy.car.monitor.service.MonitorService",
                "operation_name": "getplatenumInfo",
            }

            var param = {
                "platenum":"12"
            }

            var options = {
                "handleError": true
            }

            function callBack(data) {
                //alert(data.content.result);
                alert(data.content.result);
                //addMarker(data);//添加标注。
                map.clearOverlays(); 
                addMarker(data);//添加标注。
                
            }
            $.ServiceAgent.JSONInvoke(head, param, callBack, options);
        }





    
    
</script>
</body>
</html>
