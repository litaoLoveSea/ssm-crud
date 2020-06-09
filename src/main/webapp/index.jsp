<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>员工列表</title>
<% 
pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- Web路径
不以/开始的相对路径，找资源，以当前资源的路径为准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306);需要加上项目名
http://localhost:3306/crud

 -->
<script src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

</head>
<body>





<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
      
			<form class="form-horizontal">
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
			       <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
				     <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门Id即可 -->
					<select class="form-control" name="dId" id="dept_add_select">
					</select>
			    </div>
			  </div>
			</form>		 
		 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
      </div>
    </div>
  </div>
</div>






<!-- 搭建显示界面  -->
<div class="container">

	<!-- 标题 -->
  <div class="row">
  	<div class="col-md-12">
  		<h1>SSM-CRUD</h1>
  	</div>
  </div>
  	<!-- 按钮 -->
  <div class="row">
   	<div class="col-md-4 col-md-offset-8">
   		<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
   		<button class="btn btn-danger">删除</button>
   	 </div>
  </div>
  	<!-- 显示表格数据 -->
  <div class="row">
  	<div class="col-md-12">
  		<table class="table table-hover" id="emps_tables">
  			<thead>
	  			<tr>
	  				<th>#</th>
	  				<th>empName</th>
	  				<th>gender</th>
	  				<th>email</th>
	  				<th>deptName</th>
	  				<th>操作</th>
	  			</tr>
  			</thead>
  			<tbody>
  			
  			</tbody>
  			
  			
  		</table>
  	
  	</div>
  </div>
  	<!-- 显示分页信息 -->
  <div class="row">
  	
  	<!-- 显示分页信息 -->
  	<div class="col-md-5" id="page_info_area">	
  	</div>
  	<!-- 分页条信息 -->
  	<div class="col-md-7" id="page_nav_area">
  		
  	</div>
  </div>
</div>
</body>


<script type="text/javascript">
	var totalRecord;
	$(function(){
		to_page(1);
	});
	
	function clear_table(){
		$("#emps_tables tbody").empty();
	}
	function clear_page_info(){
		$("#page_info_area").empty();
	}
	function clear_page_nav(){
		$("#page_nav_area").empty();
	}
	
	function to_page(pn){
		$.ajax({
			url:"${APP_PATH}/emps",
			data:"pn="+pn,
			type:"GET",
			success:function(result){
				build_emp_table(result);
				build_page_info(result)
				build_page_nav(result);
			}
		});
	}
	
 	function build_emp_table(result){
 		clear_table();
		var emps = result.extend.pageInfo.list;
		$.each(emps,function(index,item){
			var empIdTd = $("<td></td>").append(item.empId);
			var empNameTd = $("<td></td>").append(item.empName);
			var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
			var emailTd = $("<td></td>").append(item.email);
			var deptNameTd = $("<td></td>").append(item.department.deptName);
			
			var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm").
			append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
			
			var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm").
			append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
			
			var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
			
			$("<tr></tr>").append(empIdTd).append(empNameTd).append(genderTd).
			append(emailTd).append(deptNameTd).append(btnTd).appendTo("#emps_tables tbody");
			
		})
	} 
 	
 	function build_page_info(result){
 		clear_page_info();
 		$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"+result.extend.pageInfo.pages+
 				"页，总"+result.extend.pageInfo.total+"条记录");
 		totalRecord = result.extend.pageInfo.total;
 	}
 	
 	function build_page_nav(result){
 		clear_page_nav();
 		var ul = $("<ul></ul>").addClass("pagination");
 		var firstPageli = $("<li></li>").append( $("<a></a>").append("首页").attr("href","#") );
 		var prePageli = $("<li></li>").append( $("<a></a>").append("&laquo;") );
 		
 		if(result.extend.pageInfo.hasPreviousPage == false){
 			firstPageli.addClass("disabled");
 			prePageli.addClass("disabled");
 		}else{
 			firstPageli.click(function(){
 				to_page(1);	
 			})
 	 		prePageli.click(function(){
 				to_page(result.extend.pageInfo.pageNum-1);	
 			})
 		}
 		
 		var nextPageli = $("<li></li>").append( $("<a></a>").append("&raquo;") );
 		var lastPageli = $("<li></li>").append( $("<a></a>").append("尾页").attr("href","#") );
 		
		if(result.extend.pageInfo.hasNextPage == false){
			nextPageli.addClass("disabled");
			lastPageli.addClass("disabled");
 		}else{
 			nextPageli.click(function(){
 				to_page(result.extend.pageInfo.pageNum+1);	
 			})
 	 		lastPageli.click(function(){
 				to_page(result.extend.pageInfo.pages);	
 			})
 		}
		
 		ul.append(firstPageli).append(prePageli);
 		
 		$.each(result.extend.pageInfo.navigatepageNums, function(index,item){
 			var numLi = $("<li></li>").append( $("<a></a>").append(item) );
 			if(result.extend.pageInfo.pageNum == item){
 				numLi.addClass("active");
 			}
 			numLi.click(function(){
				to_page(item);	
			})
 			ul.append(numLi);
 		})
 		ul.append(nextPageli).append(lastPageli);
 		
 		var navEle = $("<nav></nav>").append(ul);
 		navEle.appendTo("#page_nav_area");
	} 
 	$('#emp_add_modal_btn').click(function(){
 		getDepts();
 		$('#myModal').modal({
 			backdrop:'static'
 		})
 	})
 	function getDepts(){
		$.ajax({
			url:"${APP_PATH}/depts",
			type:"GET",
			success:function(result){
				//console.dir(result);
				$.each(result.extend.depts,function(index,item){
					//var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
					var optionEle = $("<option></option>").append(item.deptName).attr("value",item.deptId);
					optionEle.appendTo("#myModal select");
					
				})
			}
		});
	}
 	function validate_add_form(){
 		var empName = $("#empName_add_input").val();
 		var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
 		if(!regName.test(empName)){
 			show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
 			//alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
 			//$("#empName_add_input").parent().addClass("has-error");
 			//$("#empName_add_input").next("span").text("用户名可以是2-5位中文或者6-16位英文和数字的组合");
 			return false;
 		}else{
 			show_validate_msg("#empName_add_input","success","");
 			//$("#empName_add_input").parent().addClass("has-success");
 			//$("#empName_add_input").next("span").text("");
 		}
 		
 		var email = $("#email_add_input").val();
 		var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 		if(!regEmail.test(email)){
 			alert("邮箱格式不正确");
 			return false;
 		}
 		
 		return false;
 	}
 	
 	function show_validate_msg(ele,statu,msg){
 		$(ele).parent().removeClass("has-success has-error");
 		$(ele).next("span").text("");
 		if(statu=="success"){
 			$(ele).parent().addClass("has-success");
 		}else if(statu=="error"){
 			$(ele).parent().addClass("has-error");
 		}
 		$(ele).next("span").text(msg);
 	}
 	$("#empName_add_input").change(function(){
 		var empName = this.value;
 		$.ajax({
			url:"${APP_PATH}/checkuser",
			data:"empName="+empName,
			type:"POST",
			success:function(result){
				
				//console.dir(123);
				if(result.code == 100 ){
					show_validate_msg("#empName_add_input","success","用户名可用");
				}else{
					show_validate_msg("#empName_add_input","fail","用户名不可用");
				}
			}
		});
 	})
 	
 	$('#emp_save_btn').click(function(){
 		//校验
 		if(!validate_add_form()){
 			return false;
 		}
 		//console.dir($("#myModal form").serialize());
 		$.ajax({
			url:"${APP_PATH}/emp",
			type:"POST",
			data:$("#myModal form").serialize(),
			success:function(result){
				//console.dir(result);
				$('#myModal').modal('hide');
				to_page(totalRecord);
				
			}
		});
 	})
 	
 	
</script>

</html>
