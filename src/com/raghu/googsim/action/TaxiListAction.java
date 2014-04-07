package com.raghu.googsim.action;

import java.sql.SQLException;
import java.util.List;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;
import com.raghu.googsim.model.TaxiUser;
import com.raghu.googsim.service.TaxiRouteService;

public class TaxiListAction extends ActionSupport implements ModelDriven<List<TaxiUser>> {
	private List<TaxiUser> taxiUserList;
	
	public String execute(){
		return SUCCESS;
	}
	
	public String TaxiByID(){
		
		return SUCCESS;
	}

	public String  AllTaxis() throws SQLException{
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		setTaxiUserList(taxiRouteService.getAllTaxis());
		return SUCCESS;
	}
	
	@Override
	public List<TaxiUser> getModel() {
		// TODO Auto-generated method stub
		return taxiUserList;
	}

	public List<TaxiUser> getTaxiUserList() {
		return taxiUserList;
	}

	public void setTaxiUserList(List<TaxiUser> taxiUserList) {
		this.taxiUserList = taxiUserList;
	}
}
