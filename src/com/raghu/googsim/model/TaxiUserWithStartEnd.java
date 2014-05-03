package com.raghu.googsim.model;

import java.util.List;

public class TaxiUserWithStartEnd {
	private int taxiUserId;
	private String taxiUserName;
	private List<RouteWithStartEnd> routeList;
	
	public int getTaxiUserId() {
		return taxiUserId;
	}
	public void setTaxiUserId(int taxiUserId) {
		this.taxiUserId = taxiUserId;
	}
	public String getTaxiUserName() {
		return taxiUserName;
	}
	public void setTaxiUserName(String taxiUserName) {
		this.taxiUserName = taxiUserName;
	}

	public List<RouteWithStartEnd> getRouteList() {
		return routeList;
	}
	public void setRouteList(List<RouteWithStartEnd> routeList) {
		this.routeList = routeList;
	}
}
