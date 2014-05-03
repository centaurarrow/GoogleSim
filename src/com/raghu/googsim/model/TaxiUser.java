package com.raghu.googsim.model;

import java.util.List;

public class TaxiUser {
	private int taxiUserId;
	private String taxiUserName;
	private List<Route> routeList;
	private List<Location> locationList;
	
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

	public List<Location> getLocationList() {
		return locationList;
	}
	public void setLocationList(List<Location> locationList) {
		this.locationList = locationList;
	}
	public List<Route> getRouteList() {
		return routeList;
	}
	public void setRouteList(List<Route> routeList) {
		this.routeList = routeList;
	}
}
