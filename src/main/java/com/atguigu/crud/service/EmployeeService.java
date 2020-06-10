package com.atguigu.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.bean.EmployeeExample.Criteria;
import com.atguigu.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;
	
	public List<Employee> getAll() {
		return employeeMapper.selectByExampleWithDept(null);
	}

	public void save(Employee employee) {
		employeeMapper.insertSelective(employee);
	}

	public boolean checkUser(String empName) {
		EmployeeExample employeeExample = new EmployeeExample();
		Criteria createCriteria = employeeExample.createCriteria();
		createCriteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(employeeExample);
		return count == 0 ;
	}

	public Employee getEmp(Integer id) {
		return employeeMapper.selectByPrimaryKey(id);
	}

	public void saveEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}

	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}

	public void deleteBatch(List<Integer> ids) {
		EmployeeExample employeeExample = new EmployeeExample();
		Criteria createCriteria = employeeExample.createCriteria();
		//delete from xx where emp_id in(1,2,3)
		createCriteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(employeeExample);
		
		
	}

	
}
