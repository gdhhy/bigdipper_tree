<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>北斗传销查询系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="components/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->
    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/> <!--重要-->


    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]-->
    <script src="js/html5shiv/dist/html5shiv.js"></script>
    <script src="js/respond/dest/respond.min.js"></script>
    <!--[endif]-->


    <!-- basic scripts -->

    <script src="js/jquery-3.2.0.min.js"></script>

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
    <%--<script src="js/jquery.form.js"></script>--%>
    <script src="js/func.js"></script>

    <%--<link href="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.css" rel="stylesheet">--%>
    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>

    <script type="text/javascript">
        jQuery(function ($) {
            $.fn.dataTable.pipeline = function (opts) {
                // Configuration options
                var conf = $.extend({
                    pages: 5,     // number of pages to cache
                    url: '',      // script url
                    data: null,   // function or object with parameters to send to the server
                                  // matching how `ajax.data` works in DataTables
                    method: 'GET' // Ajax HTTP method
                }, opts);

                // Private variables for storing the cache
                var cacheLower = -1;
                var cacheUpper = null;
                var cacheLastRequest = null;
                var cacheLastJson = null;

                return function (request, drawCallback, settings) {
                    var ajax = false;
                    var requestStart = request.start;
                    var drawStart = request.start;
                    var requestLength = request.length;
                    var requestEnd = requestStart + requestLength;

                    if (settings.clearCache) {
                        // API requested that the cache be cleared
                        ajax = true;
                        settings.clearCache = false;
                    }
                    else if (cacheLower < 0 || requestStart < cacheLower || requestEnd > cacheUpper) {
                        // outside cached data - need to make a request
                        ajax = true;
                    }
                    else if (JSON.stringify(request.order) !== JSON.stringify(cacheLastRequest.order) ||
                        JSON.stringify(request.columns) !== JSON.stringify(cacheLastRequest.columns) ||
                        JSON.stringify(request.search) !== JSON.stringify(cacheLastRequest.search)
                    ) {
                        // properties changed (ordering, columns, searching)
                        ajax = true;
                    }

                    // Store the request for checking next time around
                    cacheLastRequest = $.extend(true, {}, request);

                    if (ajax) {
                        // Need data from the server
                        if (requestStart < cacheLower) {
                            requestStart = requestStart - (requestLength * (conf.pages - 1));

                            if (requestStart < 0) {
                                requestStart = 0;
                            }
                        }

                        cacheLower = requestStart;
                        cacheUpper = requestStart + (requestLength * conf.pages);

                        request.start = requestStart;
                        request.length = requestLength * conf.pages;

                        // Provide the same `data` options as DataTables.
                        if (typeof conf.data === 'function') {
                            // As a function it is executed with the data object as an arg
                            // for manipulation. If an object is returned, it is used as the
                            // data object to submit
                            var d = conf.data(request);
                            if (d) {
                                $.extend(request, d);
                            }
                        }
                        else if ($.isPlainObject(conf.data)) {
                            // As an object, the data given extends the default
                            $.extend(request, conf.data);
                        }

                        settings.jqXHR = $.ajax({
                            "type": conf.method,
                            "url": conf.url,
                            "data": request,
                            "dataType": "json",
                            "cache": false,
                            "success": function (json) {
                                cacheLastJson = $.extend(true, {}, json);

                                if (cacheLower !== drawStart) {
                                    json.data.splice(0, drawStart - cacheLower);
                                }
                                if (requestLength >= -1) {
                                    json.data.splice(requestLength, json.data.length);
                                }

                                drawCallback(json);
                            }
                        });
                    }
                    else {
                        json = $.extend(true, {}, cacheLastJson);
                        json.draw = request.draw; // Update the echo for each response
                        /* console.log("(requestStart - cacheLower)):"+ (requestStart - cacheLower));
                         // console.log("cacheLower:"+cacheLower);
                         console.log("requestLength:"+requestLength);*/
                        if (json.data) {
                            json.data.splice(0, requestStart - cacheLower);
                            json.data.splice(requestLength, json.data.length);

                            drawCallback(json);
                            // console.log("json.data.length:"+json.data.length);
                        }
                    }
                }
            };

// Register an API method that will empty the pipelined data, forcing an Ajax
// fetch on the next draw (i.e. `table.clearPipeline().draw()`)
            $.fn.dataTable.Api.register('clearPipeline()', function () {
                return this.iterator('table', function (settings) {
                    settings.clearCache = true;
                });
            });

            var myTable = $('#dynamic-table')
            //.wrap("<div class='dataTables_borderWrap' />")   //if you are applying horizontal scrolling (sScrollX)
                .DataTable({
                    bAutoWidth: false,
                    "columns": [
                        {"data": "memberId", "sClass": "center"},
                        {"data": "memberNo", "sClass": "center"},
                        {"data": "realName", "sClass": "center"},
                        {"data": "idCard", "sClass": "center"},
                        {"data": "phone", "sClass": "center"},
                        {"data": "parentNo", "sClass": "center"},
                        {"data": "level", "sClass": "center"},
                        {"data": "childTotal", "sClass": "center"},
                        {"data": "childDepth", "sClass": "center"},
                        {"data": "directCount", "sClass": "center"}
                    ],

                    'columnDefs': [
                        {"orderable": false, "searchable": false, className: 'text-center', "targets": 0},
                        {
                            "orderable": false, className: 'text-center', "targets": 1, render: function (data, type, row, meta) {
                                return '<a href="#" name="memberNo">{0}</a>'.format(data);
                            }
                        },
                        {
                            "orderable": false, className: 'text-center', "targets": 2, render: function (data, type, row, meta) {
                                return '<a href="#"  name="realName">{0}</a>'.format(data);
                            }
                        },
                        {
                            "orderable": false, className: 'text-center', "targets": 3, render: function (data, type, row, meta) {
                                return '<a href="#"  name="idCard">{0}</a>'.format(data);
                            }
                        },
                        {
                            "orderable": false, className: 'text-center', "targets": 4, render: function (data, type, row, meta) {
                                return '<a href="#"  name="phone">{0}</a>'.format(data);
                            }
                        },
                        {
                            "orderable": false, "searchable": false, className: 'text-center', "targets": 5, render: function (data, type, row, meta) {
                                return '<a href="#"   name="parentNo">{0}</a>'.format(data);
                            }
                        },
                        {"orderable": false, 'targets': 6, 'searchable': false},
                        {"orderable": false, "searchable": false, className: 'text-center', "targets": 7},
                        {"orderable": false, "searchable": false, className: 'text-center', "targets": 8},
                        {"orderable": false, 'searchable': false, 'targets': 9}

                    ],
                    "aLengthMenu": [[20, 100], ["20", "100"]],//二组数组，第一组数量，第二组说明文字;
                    "aaSorting": [],//"aaSorting": [[ 4, "desc" ]],//设置第5个元素为默认排序
                    language: {
                        url: '/js/datatables/datatables.chinese.json'
                    },
                    searching: false,
                    "ajax": "/listMember.jspx",
                    "processing": true,
                    "serverSide": true,
                    /*"ajax": $.fn.dataTable.pipeline({
                        url: "/listMember.jspx",
                        //length:10,
                        pages: 5 // number of pages to cache
                    }),*/

                    select: {style: 'single'}
                });

            myTable.on('order.dt search.dt', function () {
                myTable.column(0, {search: 'applied', order: 'applied'}).nodes().each(function (cell, i) {
                    cell.innerHTML = i + 1;
                });
            });//.draw();
            myTable.on('draw', function () {
                $('#dynamic-table tr').find('a:eq(0)').click(function () {
                    var url = "/memberInfo.jspx?memberNo={0}".format($(this).text());
                    $(window).attr('location', url);
                });
                $('#dynamic-table tr').find('a:gt(0)').click(function () {
                    var url = "/listMember.jspx?{0}={1}".format($(this).attr("name"), $(this).text());
                    $('.form-search')[0].reset();
                    $('input[name="' + $(this).attr("name") + '"]').val($(this).text());
                    myTable.ajax.url(encodeURI(url)).load();
                });
            });
            $('.btn-success').click(function () {
                search();
            });
            $('.form-search :text:lt(2)').each(function () {
                $(this).width(80);
            });
            $('.form-search :text:gt(2)').each(function () {
                $(this).width(100);
            });
            $('.form-search :text').keydown(function (event) {
                //console.log("keyCode:" + event.keyCode);
                if (event.keyCode === 13)
                    search();
            });

            function search() {
                var data = myTable.ajax.params();
                data.search.value = "&threeThirty2=" + true;
                //alert('Search term was: ' + data.search.value);

                var url = "/listMember.jspx";//myTable.ajax.url() --
                var searchParam = "";
                $('.form-search :text').each(function () {
                    if ($(this).val())
                        searchParam += "&" + $(this).attr("name") + "=" + $(this).val();
                });
                console.log("checkBox:" + $('#three_thirty').is(':checked'));
                //if($('#three_thirty').is(':checked'))
                searchParam += "&threeThirty=" + $('#three_thirty').is(':checked');
                //console.log("searchParam:"+searchParam);
                if (searchParam !== "")
                    url = "/listMember.jspx" + searchParam.replace(/&/, "?");
                myTable.ajax.url(encodeURI(url)).load();
            }
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

            <div class="breadcrumbs" id="breadcrumbs">
                <ul class="breadcrumb">
                    <form class="form-search form-inline">
                        <label>用户ID ：</label>
                        <input type="text" name="memberNo" placeholder="用户ID……" class="nav-search-input" autocomplete="off"/>
                        姓名：
                        <input type="text" name="realName" placeholder="姓名……" class="nav-search-input" autocomplete="off"/>
                        证件号：
                        <input type="text" name="idCard" placeholder="证件号……" class="nav-search-input" autocomplete="off"/>
                        手机号：
                        <input type="text" name="phone" placeholder="手机号……" class="nav-search-input" autocomplete="off"/>
                        上级ID ：
                        <input type="text" name="parentNo" placeholder="上级用户ID……" class="nav-search-input" autocomplete="off"/>&nbsp;&nbsp;&nbsp;
                        三层30人：
                        <input type="checkbox" id="three_thirty">&nbsp;&nbsp;&nbsp;
                        <button class="btn btn-sm btn-reset" type="reset">
                            <i class="ace-icon fa fa-undo bigger-110"></i>
                            复位
                        </button>
                    </form>
                </ul>
                <!-- #section:basics/content.searchbox -->
                <div class="nav-search" id="nav-search">
                    <button type="button" class="btn btn-sm btn-success">
                        搜索
                        <i class="ace-icon fa fa-arrow-right icon-on-right bigger-110"></i>
                    </button>
                </div><!-- /.nav-search -->


                <!-- /section:basics/content.searchbox -->
            </div>
            <!-- /section:basics/content.breadcrumbs -->
            <div class="page-content">

                <div class="row">
                    <div class="col-xs-12">

                        <div class="row">

                            <div class="col-xs-12">
                                <%-- <div class="table-header">
                                     成员列表 "全部列表"
                                     <div class="pull-right tableTools-container"></div>
                                 </div>--%>
                                <!-- div.table-responsive -->

                                <!-- div.dataTables_borderWrap -->
                                <div>
                                    <table id="dynamic-table" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>用户ID</th>
                                            <th>姓名</th>
                                            <th>身份证号</th>
                                            <th>电话</th>
                                            <th>上级ID</th>
                                            <th>当前层级</th>
                                            <th>最深级数</th>
                                            <th>下级总数</th>
                                            <th>直接下级数</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
</div><!-- /.main-container -->

</body>
</html>