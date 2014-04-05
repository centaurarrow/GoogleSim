package com.raghu.googsim.action;

import java.sql.SQLException;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;
import com.raghu.googsim.model.User;
import com.raghu.googsim.service.LoginService;

public class LoginAction extends ActionSupport implements ModelDriven<User>,SessionAware {
	private User user;
    private Map<String, Object> sessionMap;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	public String execute() throws SQLException{
		LoginService loginService = new LoginService();
		if(user!=null){
		setUser(loginService.doLogin(user));
		}
		else{
			return ERROR;
		}
//		System.out.println("After Authentication"+user.getEmail());
		// This is to check whether login is successful by checking the Roles List in the User
		if((user.getRoles()!= null)&&(user.getRoles().contains(new String("USER")))){
			this.getSessionMap().put("isLoggedIN", "TRUE");
			this.getSessionMap().put("LoggedInUser",user);
			return SUCCESS;
		}
		else{
			return ERROR;
		}
	}
	
	public  String logout() throws SQLException{
		this.getSessionMap().remove("isLoggedIN");
		return SUCCESS;
	}

	@Override
	public User getModel() {
		// TODO Auto-generated method stub
		return user;
	}

	public Map getSessionMap() {
		return sessionMap;
	}

	public void setSessionMap(Map<String, Object> sessionMap) {
		this.sessionMap = sessionMap;
	}

	@Override
	public void setSession(Map<String, Object> map) {
		// TODO Auto-generated method stub
		this.sessionMap = map;
	}
}
