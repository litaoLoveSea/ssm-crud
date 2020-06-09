package com.atguigu.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
	@RequestMapping(value="/checkuser")
	@ResponseBody
	public Msg checkUser(@RequestParam(value = "empName") String empName) {
		if(employeeService.checkUser(empName)){
			return Msg.success(); 
		}
		return Msg.fail(); 
	}
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(Employee employee) {
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
