package com.raghu.googsim.action;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;
import com.raghu.googsim.model.Route;
import com.raghu.googsim.model.TaxiUser;
import com.raghu.googsim.service.TaxiRouteService;

public class RouteAction extends ActionSupport implements ModelDriven<Route> {
	private Route route;
	private int tRouteId = Integer.parseInt(ServletActionContext.getRequest().getParameter("tRouteId"));
	
	public String execute() throws SQLException{
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		Route tempRoute = new Route() ;
		tempRoute.setRouteid(tRouteId);
		
		setRoute((taxiRouteService.getLocationsForARoute(tempRoute)));
		return SUCCESS;
	}
	
	
	@Override
	public  Route getModel() {
		// TODO Auto-generated method stub
		return route;
	}

	public Route getRoute() {
		return route;
	}

	public void setRoute(Route route) {
		this.route = route;
	}


}
