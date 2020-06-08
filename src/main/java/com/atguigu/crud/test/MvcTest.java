package com.atguigu.crud.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.atguigu.crud.bean.Employee;
import com.github.pagehelper.PageInfo;

/**
 * 注意：Spring4测试的时候，需要servlet3.0的支持
 * 使用Spring测试模块提供的测试请求功能，测试CRUD请求的正确行
 * @author Administrator
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations={"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {

	//传入springmvc的ioc容器
	@Autowired
	WebApplicationContext webApplicationContext;
	
	//虚拟MVC请求，获取到处理结果
	MockMvc mockMvc;
	
	@Before
	public void initMockMvc(){
		mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
	}
	
	@Test
	public void testPage() throws Exception{
		//模拟请求拿到返回值
		MvcResult  result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "10"))
		.andReturn();
		//请求成功以后，请求域中含有pageInfo，验证pageInfo即可
		MockHttpServletRequest request = result.getRequest();
		PageInfo pageInfo = (PageInfo) request.getAttribute("pageInfo");
		
		System.out.println("=================printPageInfo");
		printPageInfo(pageInfo);
		
		
		System.out.println("=================printNavigatepageNums");
		printNavigatepageNums(pageInfo);
		
		System.out.println("=================printEmps");
		printEmps(pageInfo.getList());
	}
	
	
	public void printPageInfo(PageInfo pageInfo ){
		System.out.println("当前页码："+pageInfo.getPageNum());
		System.out.println("总页码："+pageInfo.getPages());
		System.out.println("总记录数："+pageInfo.getTotal());
	}
	
	public void printNavigatepageNums(PageInfo pageInfo ){
		System.out.println("在页面需要连续显示的页码");
		int[] nums = pageInfo.getNavigatepageNums();
		for(int i : nums){
			System.out.print(" "+i);
		}
		System.out.println();
	}
	
	public void printEmps(List<Employee> list){
		for(Employee employee : list){
			System.out.println("ID: "+ employee.getEmpId() +" NAME:"+employee.getEmpName());
		}
	}
}
