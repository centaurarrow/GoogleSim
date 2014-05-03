package com.raghu.googsim.model;

import java.util.ArrayList;
import java.util.List;

public class RouteWithStartEnd {
	private int routeid;
	private String routename;
	private double startlat ;
	private double startlon ;
	private double endlat ;
	private double endlon ;
	private int taxiuserid;

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

	public double getStartlat() {
		return startlat;
	}

	public void setStartlat(double startlat) {
		this.startlat = startlat;
	}

	public double getStartlon() {
		return startlon;
	}

	public void setStartlon(double startlon) {
		this.startlon = startlon;
	}

	public double getEndlat() {
		return endlat;
	}

	public void setEndlat(double endlat) {
		this.endlat = endlat;
	}

	public double getEndlon() {
		return endlon;
	}

	public void setEndlon(double endlon) {
		this.endlon = endlon;
	}

}
