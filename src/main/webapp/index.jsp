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
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" >
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" >修改员工</h4>
      </div>
      <div class="modal-body">
      
			<form class="form-horizontal">
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			        <p class="form-control-static" id="empName_update_static"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
				     <label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label  class="col-sm-2 control-label">deptName</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门Id即可 -->
					<select class="form-control" name="dId">
					</select>
			    </div>
			  </div>
			</form>		 
		 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
      </div>
    </div>
  </div>
</div>



<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">添加员工</h4>
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
					<select class="form-control" name="dId" >
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
   		<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
   	 </div>
  </div>
  	<!-- 显示表格数据 -->
  <div class="row">
  	<div class="col-md-12">
  		<table class="table table-hover" id="emps_tables">
  			<thead>
	  			<tr>
	  				
	  				<th><input type="checkbox" id="check_all"/></th>
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
	var totalRecord,currentPage;
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
			var checkBoxTd = $("<td><input type='checkbox' class='check_item' /></td>");
			var empIdTd = $("<td></td>").append(item.empId);
			var empNameTd = $("<td></td>").append(item.empName);
			var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
			var emailTd = $("<td></td>").append(item.email);
			var deptNameTd = $("<td></td>").append(item.department.deptName);
			
			var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").
			append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
			
			//用于修改时 修改数据的id标志
			editBtn.attr("edit-id",item.empId);
			
			
			var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").
			append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
			
			//用于删除时
			delBtn.attr("del-id",item.empId);
			
			
			var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
			
			$("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(genderTd).
			append(emailTd).append(deptNameTd).append(btnTd).appendTo("#emps_tables tbody");
			
		})
	} 
 	
 	function build_page_info(result){
 		clear_page_info();
 		$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"+result.extend.pageInfo.pages+
 				"页，总"+result.extend.pageInfo.total+"条记录");
 		totalRecord = result.extend.pageInfo.total;
 		currentPage = result.extend.pageInfo.pageNum;
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
 	function reset_form(ele){
 		$(ele)[0].reset();
 		$(ele).find("*").removeClass("has-success has-error");
 		$(ele).find(".help-block").text("");
 	}
 	$('#emp_add_modal_btn').click(function(){
 		reset_form("#myModal form");
 		//$("#myModal form")[0].reset();//[0] 容易错  因为是调用js
 		getDepts("#myModal select");
 		$('#myModal').modal({
 			backdrop:'static'
 		})
 	})
 	function getDepts(ele){
 		$(ele).empty();
		$.ajax({
			url:"${APP_PATH}/depts",
			type:"GET",
			success:function(result){
				//console.dir(result);
				$.each(result.extend.depts,function(index,item){
					//var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
					var optionEle = $("<option></option>").append(item.deptName).attr("value",item.deptId);
					optionEle.appendTo(ele);
					
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
 		
 		return true;
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
					$('#emp_save_btn').attr("ajax_va","success");
				}else{
					show_validate_msg("#empName_add_input","error",result.extend.va_msg);
					$('#emp_save_btn').attr("ajax_va","error");
				}
			}
		});
 	})
 	
 	$('#emp_save_btn').click(function(){
 		//校验
 		if(!validate_add_form()){
 			return false;
 		}
 		if($('#emp_save_btn').attr("ajax_va") == "error"){
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
 	
 	// 组件后加在也可以绑定
 	$(document).on("click",".edit_btn",function(){
 		getDepts("#empUpdateModal select");
 		
 		getEmp($(this).attr("edit-id"));
 		$("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
 		$('#empUpdateModal').modal({
 			backdrop:'static'
 		})
 	})
 	
 	$("#emp_update_btn").click(function(){
 		$.ajax({
			url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
			type:"PUT",
			data:$("#empUpdateModal form").serialize(),
			success:function(result){
				//console.dir(result);
				$('#empUpdateModal').modal('hide');
				to_page(currentPage);
			}
		});
 	})
 	
 	function getEmp(id){
 		$.ajax({
			url:"${APP_PATH}/emp/"+id,
			type:"GET",
			success:function(result){
				//console.dir(result);
				var empData = result.extend.emp;
				$("#empName_update_static").text(empData.empName);
				$("#email_update_input").val(empData.email);
				$("#empUpdateModal input[name=gender]").val([empData.gender]);
				$("#empUpdateModal select").val([empData.dId]);
				
			}
		});
 	}
 	
 	// 组件后加在也可以绑定
 	$(document).on("click",".delete_btn",function(){
 		console.dir($(this).parents("tr").find("td:eq(2)").text());
 		var empName = $(this).parents("tr").find("td:eq(2)").text();
 		if(confirm("确认删除【"+empName+"】吗？")){
 			$.ajax({
 				url:"${APP_PATH}/emp/"+$(this).attr("del-id"),
 				type:"DELETE",
 				success:function(result){
 					//console.dir(result);
 					alert(result.msg);
 					to_page(currentPage);
 					
 				}
 			});
 		}
 	})
 	
 	//全选/全部选
 	$("#check_all").click(function(){
 		/* attr获取checked是undefined
 		我们这些dom原生的属性：attr获取自定义属性的值
 		prop修改和读取dom原生属性的值 */
 		$(".check_item").prop("checked",$(this).prop("checked"));
 		
 	})
 	
 	
 	// 组件后加在也可以绑定
 	$(document).on("click",".check_item",function(){
 		var flag = $(".check_item:checked").length == $(".check_item").length;
 		$("#check_all").prop("checked",flag);
 	})
 	
 	$("#emp_delete_all_btn").click(function(){
 		var empNames = "";
 		var del_idstr = "";
 		$.each($(".check_item:checked"), function(){
 			empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
 			del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
 			
 		});
 		empNames = empNames.substring(0,empNames.length-1);
 		del_idstr = del_idstr.substring(0,del_idstr.length-1);
 		if(confirm("确认删除【"+empNames+"】吗？")){
 			$.ajax({
 				url:"${APP_PATH}/emp/"+del_idstr,
 				type:"DELETE",
 				success:function(result){
 					//console.dir(result);
 					alert(result.msg);
 					to_page(currentPage);
 					
 				}
 			});
 		}
 	})
 	
</script>

</html>
