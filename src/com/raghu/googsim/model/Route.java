package com.raghu.googsim.model;

import java.util.ArrayList;
import java.util.List;

public class Route {
	private int routeid;
	private String routename;
	private int taxiuserid ; 
	private List<Location> location = new ArrayList<Location>();

	public List<Location> getLocation() {
		return location;
	}

	public void setLocation(List<Location> location) {
		this.location = location;
	}

	public int getRouteid() {
		return routeid;
	}

	public void setRouteid(int routeid) {
		this.routeid = routeid;
	}

	public String getRoutename() {
		return routename;
	}

	public void setRoutename(String routename) {
		this.routename = routename;
	}

	public int getTaxiuserid() {
		return taxiuserid;
	}

	public void setTaxiuserid(int taxiuserid) {
		this.taxiuserid = taxiuserid;
	}

}
