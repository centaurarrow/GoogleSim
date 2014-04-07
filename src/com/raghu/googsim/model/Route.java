package com.raghu.googsim.model;

import java.util.ArrayList;
import java.util.List;

public class Route {
	private List<Location> location = new ArrayList<Location>();

	public List<Location> getLocation() {
		return location;
	}

	public void setLocation(List<Location> location) {
		this.location = location;
	}

}
