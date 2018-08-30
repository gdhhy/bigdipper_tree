<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>传销查询系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->

    <!-- text fonts -->
    <!--<link rel="stylesheet" href="assets/css/ace-fonts.css"/>-->

    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>


    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]-->
    <script src="js/html5shiv/dist/html5shiv.js"></script>
    <script src="js/respond/dest/respond.min.js"></script>
    <!--[endif]-->


    <!-- basic scripts -->

    <!--[if !IE]> -->
    <!--<script src="components/jquery/dist/jquery.js"></script>-->
    <script src="js/jquery-3.2.0.min.js"></script>

    <!-- <![endif]-->

    <!--[if IE]-->
    <!--<script src="components/jquery.1x/dist/jquery.js"></script>-->
    <script src="js/jquery-1.11.3.min.js"></script>
    <!--[endif]-->
    <!--<script src="components/bootstrap/dist/js/bootstrap.js"></script>-->
    <script src="js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->


    <!-- static.html end-->

    <script src="js/datatables/jquery.dataTables.min.js"></script>

    <script src="js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>--%>
    <script src="js/accounting.min.js"></script>
    <script src="js/func.js"></script>
    <%--<script src="assets/js/jquery.validate.min.js"></script>--%>
    <%--<script src="../js/messages_cn.js"></script>--%>

    <%--<link href="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.css" rel="stylesheet">--%>
    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>


    <script src="assets/js/ace.js"></script>
    <link rel="stylesheet" href="components/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <script type="text/javascript" src="components/zTree_v3/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="components/zTree_v3/js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript" src="components/zTree_v3/js/jquery.ztree.exedit.js"></script>
    <script type="text/javascript">
        jQuery(function ($) {
            var setting = {
                async: {
                    enable: true,
                    url: "memberZTree.jspx",
                    autoParam: ["id", "name=n", "level=lv"],
                    otherParam: {"otherParam": "zTreeAsyncTest"}/*,
                    dataFilter: filter*/
                },
                callback: {
                    onClick: zTreeOnClick
                    , beforeAsync: beforeAsync,
                    onAsyncSuccess: onAsyncSuccess
                }
            };

            function beforeAsync() {
                curAsyncCount++;
            }

            function onAsyncSuccess(event, treeId, treeNode, msg) {
                curAsyncCount--;
                if (curStatus === "expand") {
                    expandNodes(treeNode.children);
                } else if (curStatus === "async") {
                    asyncNodes(treeNode.children);
                }

                if (curAsyncCount <= 0) {
                    curStatus = "";
                }
            }

            var curStatus = "init", curAsyncCount = 0, goAsync = false;


            function check() {
                return curAsyncCount <= 0;
            }

            function expandNodes(nodes) {
                if (!nodes) return;
                curStatus = "expand";
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                for (var i = 0, l = nodes.length; i < l; i++) {
                    zTree.expandNode(nodes[i], true, false, false);//展开节点就会调用后台查询子节点
                    if (nodes[i].isParent && nodes[i].zAsync) {
                        expandNodes(nodes[i].children);//递归
                    } else {
                        goAsync = true;
                    }
                }
            }

            $('button:first').click(function () {
                if (!check()) {
                    return;
                }
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                expandNodes(zTree.getNodes());
                if (!goAsync) {
                    curStatus = "";
                }
            });

           /* function filter(treeId, parentNode, childNodes) {
                if (!childNodes) return null;
                for (var i = 0, l = childNodes.length; i < l; i++) {
                    childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
                }
                return childNodes;
            }*/

            $.fn.zTree.init($("#treeDemo"), setting,
                {id: '<c:out value="${member.memberNo}"/>', name: '<c:out value="${member.realName}"/>', isParent:<c:out value="${member.directCount>0}"/> });

            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.expandNode(zTree.getNodes()[0], true, false, false);//展开节点就会调用后台查询子节点

            var row = '<div class="profile-info-row">' +
                '<div class="profile-info-name">{0}</div>' +
                '<div class="profile-info-value">{1}</div>' +
                '<div class="profile-info-name">{2}</div>' +
                '<div class="profile-info-value">{3}</div>' +
                '</div>';
            showMemberInfo(<c:out value="${member.memberNo}"/>);

            function zTreeOnClick(event, treeId, treeNode) {
                //alert(treeNode.id + ", " + treeNode.name);
                showMemberInfo(treeNode.id);
            }

            function showMemberInfo(memberNo) {
                $.getJSON("/listMember.jspx?memberNo=" + memberNo, function (result) { //https://www.cnblogs.com/liuling/archive/2013/02/07/sdafsd.html
                    if (result.data.length > 0) {
                        var html = "";
                        html += row.format("用户名：", result.data[0].realName, "证件号：", result.data[0].idCard);
                        html += row.format("用户ID ：", result.data[0].memberNo, "手机号码：", result.data[0].phone);

                        html += row.format("当前层级：", result.data[0].level, "下级深度：", result.data[0].childDepth);
                        html += row.format("全部下级数：", result.data[0].childTotal, " 直接下级数：", result.data[0].directCount);

                        $('#baseInfo').html(html);

                        html = "";

                        var keyVals = [];
                        var i = 0;
                        if (result.data[0].memberInfo)
                            $.each(JSON.parse(result.data[0].memberInfo), function (key, val) {
                                keyVals[i++] = {'key': key, 'value': val};
                            });
                        for (i = 0; i < keyVals.length; i += 2) {
                            if (keyVals[i + 1])
                                html += row.format(keyVals[i].key, keyVals[i].value, keyVals[i + 1].key, keyVals[i + 1].value);
                            else
                                html += row.format(keyVals[i].key, keyVals[i].value, '', '');
                        }

                        $('#memberInfo').html(html);

                        $('#memberInfo').find(".profile-info-row").each(function () {
                            for (var i = 0; i < 2; i++) {
                                var nameElement = $(this).find('.profile-info-name:eq(' + i + ')');
                                if (nameElement.text().indexOf("金") != -1 || nameElement.text().endWith("币")) {
                                    var valueElement = $(this).find('.profile-info-value:eq(' + i + ')');
                                    valueElement.text(accounting.formatMoney(valueElement.text()));
                                    valueElement.addClass("pull-right");
                                }

                                if (nameElement.text().endWith("上级")) {
                                    var valueElement = $(this).find('.profile-info-value:eq(' + i + ')');
                                    if (valueElement.text() != '0')
                                        valueElement.html("<a href='memberInfo.jspx?memberNo={0}'>{1}</a>".format(valueElement.text(), valueElement.text()));
                                }
                            }
                        });
                        $('#baseInfo').find(".profile-info-row").each(function () {
                            if ($(this).find('.profile-info-name:eq(0)').text() === "用户ID ：") {
                                var valueElement = $(this).find('.profile-info-value:eq(0)');

                                valueElement.html("<a href='memberInfo.jspx?memberNo={0}'>{1}</a>".format(valueElement.text(), valueElement.text()));
                            }
                        });
                    }
                });

            }

            $('button:last').click(function () {
                $(window).attr('location', 'member.jspx');
            });
        })
    </script>
</head>
<body class="no-skin">
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">

            <div class="page-content">
                <div class="row">
                    <div class="col-xs-12">
                        <!-- PAGE CONTENT BEGINS -->

                        <!-- #section:plugins/zTree -->
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="widget-box widget-color-blue2">
                                    <div class="widget-header">
                                        <h4 class="widget-title  smaller">
                                            <c:out value="${member.realName}"/> -<span class="smaller-80">
                                            当前层级：<c:out value="${member.level}"/>
                                            下级深度：<c:out value="${member.childDepth}"/>
                                            全部下级数：<c:out value="${member.childTotal}"/>
                                            直接下级数：<c:out value="${member.directCount}"/> </span>
                                        </h4>
                                        <button class="btn btn-warning btn-xs pull-right" id="expandTree">
                                            <i class="ace-icon  fa fa-folder-open-o  bigger-110 icon-only"></i>
                                            全部展开
                                        </button>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main padding-8">
                                            <div class="zTreeDemoBackground left">
                                                <ul id="treeDemo" class="ztree"></ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="widget-box widget-color-green2">
                                    <div class="widget-header">
                                        <h4 class="widget-title      smaller">
                                            成员详细信息
                                            <span class="smaller-80"></span>
                                        </h4>
                                        <button class="btn btn-info btn-xs pull-right">
                                            <i class="ace-icon fa fa-reply icon-only"></i>
                                            返回
                                        </button>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main padding-8">
                                            <!-- #section:pages/profile.info -->
                                            <div class="profile-user-info profile-user-info-striped" id="baseInfo">

                                            </div>
                                            <!-- /section:pages/profile.info -->
                                        </div>
                                        <div class="widget-main padding-8">
                                            <!-- #section:pages/profile.info -->
                                            <div class="profile-user-info profile-user-info-striped" id="memberInfo">
                                            </div>
                                            <!-- /section:pages/profile.info -->
                                        </div>
                                        <div class="widget-main padding-8">
                                            提示：点击用户ID、上级，可以查看该ID的成员信息。
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- /section:plugins/zTree -->

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

</body>
</html>