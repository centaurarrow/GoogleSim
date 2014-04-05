package com.raghu.googsim.action;

import java.sql.SQLException;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;
import com.raghu.googsim.model.RegisteredUser;
import com.raghu.googsim.service.RegisterService;

public class RegisterAction extends ActionSupport implements ModelDriven<RegisteredUser>,SessionAware {
	
	private RegisteredUser registeredUser = new RegisteredUser();
	private Map<String, Object> sessionMap;
	@Override
	public RegisteredUser getModel() {
		// TODO Auto-generated method stub
		return registeredUser;
	}
	
	public String execute() throws SQLException{
		RegisterService registeredService = new RegisterService();
		int isRegistered =0;
		if(registeredUser!=null){
			isRegistered = registeredService.doRegister(registeredUser);
		}
		else{
			return ERROR;
		}

		if(isRegistered == 1){
			this.getSessionMap().put("isLoggedIN", "TRUE");
			this.getSessionMap().put("LoggedInUser",registeredUser);
			return SUCCESS;
		}
		else
			return ERROR;
	}

	public RegisteredUser getRegisteredUser() {
		return registeredUser;
	}

	public void setRegisteredUser(RegisteredUser registeredUser) {
		this.registeredUser = registeredUser;
	}

	@Override
	public void setSession(Map<String, Object> sessionMap) {
		// TODO Auto-generated method stub
		this.sessionMap = sessionMap;
	}

	public Map<String, Object> getSessionMap() {
		return sessionMap;
	}

	public void setSessionMap(Map<String, Object> sessionMap) {
		this.sessionMap = sessionMap;
	}
	
}
