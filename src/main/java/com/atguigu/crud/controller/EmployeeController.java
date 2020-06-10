package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	/**
	 * 单个批量二合一
	 * 单个 1
	 * 批量 1-2-3	
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmpById(@PathVariable("ids") String ids) {
		if(ids.contains("-")){
			String[] str_ids = ids.split("-");
			ArrayList<Integer> arrayList = new ArrayList<Integer>();
			for(String id : str_ids){
				arrayList.add(Integer.parseInt(id));
			}
			employeeService.deleteBatch(arrayList);
		}else{
			employeeService.deleteEmp(Integer.parseInt(ids));
		}
		return Msg.success(); 
	}
	
	/**
	 * =====================
	 * 如果直接发送AJAX=PUT形式的请求
	 * 封装的数据
	 * 
	 * 问题，
	 * 请求体总有数据：但是Employee对象封装不上；
	 * update tbl_emp  where emp_id = 1014
	 * 
	 * 原因：
	 * 1.tomcat将请求体中的数据封装成一个map
	 * 2.request.getParameter("empName")就会从这个map中取值
	 * 3.SpringMVC封装POJO的时候，会把POJO中的每一个属性的值，request.getParameter("email")
	 * 
	 * 
	 * AJAX发送PUT请求引发的血案
	 * 	PUT请求，请求体中的数据，request.getParameter("email")拿不到值
	 * 	Tomcat一看是PUT 不会封装请求体中数据成map，只有POST才会。
	 * 
	 * 我们要能支持直接发送PUT请求还要能封装请求体中数据
	 * 配置HttpPutFormContentFilter，它的作用将请求体中数据包装成一个map
	 * request被重新包装，request.getParameter()被重写，就会从自己封装的map中取值
	 * 
	 * 
	 * 
	 * =====================
	 * 
	 * @param employee
	 * @return
	 */
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee,HttpServletRequest request) {
		System.out.println("email:"+request.getParameter("email"));
		System.out.println("封装的数据："+employee.toString());
		employeeService.saveEmp(employee);
		return Msg.success(); 
	}
	
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee); 
	}
	
	
	
	@RequestMapping(value="/checkuser")
	@ResponseBody
	public Msg checkUser(@RequestParam(value = "empName") String empName) {
		String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regex)){
			return Msg.fail().add("va_msg", "用户名必须是2-5位中文或者6-16位英文和数字的组合"); 
		}
		
		if(employeeService.checkUser(empName)){
			return Msg.success(); 
		}
		return Msg.fail().add("va_msg", "用户不可用"); 
	}
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg save(Employee employee) {
		employeeService.save(employee);
		return Msg.success();
	}
	
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(
			@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 引入PageHelper分页插件
		// 在查询之前调用查询
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 用PageInfo包装查询后的结果，只需将pageinfo交给页面就行了
		// 封装了详细的分页信息，包括有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps);
		return Msg.success().add("pageInfo",page);
	}

	// pn=pagenumber
	// @RequestMapping("/emps")
	public String getEmps(
			@RequestParam(value = "pn", defaultValue = "1") Integer pn,
			Model model) {
		// 引入PageHelper分页插件
		// 在查询之前调用查询
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是一个分页查询

		List<Employee> emps = employeeService.getAll();

		// 用PageInfo包装查询后的结果，只需将pageinfo交给页面就行了
		// 封装了详细的分页信息，包括有我们查询出来的数据,传入连续显示的页数
		PageInfo page = new PageInfo(emps);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
