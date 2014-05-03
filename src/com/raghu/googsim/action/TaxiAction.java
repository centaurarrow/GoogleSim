package com.raghu.googsim.action;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;
import com.raghu.googsim.model.Location;
import com.raghu.googsim.model.Route;
import com.raghu.googsim.model.TaxiUser;
import com.raghu.googsim.model.TaxiUserWithStartEnd;
import com.raghu.googsim.service.TaxiRouteService;

public class TaxiAction extends ActionSupport implements ModelDriven<TaxiUser>,ServletRequestAware {
	private TaxiUser taxiUser;
	private TaxiUserWithStartEnd taxiUserWithStartEnd;
	private HttpServletRequest request;
	

	@Override
	public void setServletRequest(HttpServletRequest servletRequest) {
	    // TODO Auto-generated method stub
	    this.request = servletRequest;
	}
	
	public TaxiUser getTaxiUser() {
		return taxiUser;
	}

	public void setTaxiUser(TaxiUser taxiUser) {
		this.taxiUser = taxiUser;
	}

	public String execute() throws SQLException{
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser temptaxiUser = new TaxiUser() ;
		temptaxiUser.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));
		taxiUser = (taxiRouteService.getRoutesForATaxiUser(temptaxiUser));
		return SUCCESS;
	}
	
	public String LocationsForRoute() throws SQLException{
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser temptaxiUser = new TaxiUser() ;
		temptaxiUser.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));
		taxiUser = (taxiRouteService.getLocationsForATaxi(temptaxiUser));
		return SUCCESS;
	}
	
	public String TaxisAtGivenTime() throws SQLException{
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser temptaxiUser = new TaxiUser() ;
		temptaxiUser.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));
		taxiUser = (taxiRouteService.getTaxisAtGivenTime(temptaxiUser));
		System.out.println(taxiUser.getLocationList().size());
		return SUCCESS;
	}
	
	public String AllLocationsForAllRoutes() throws SQLException{ 
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser temptaxi = new TaxiUser() ;
		temptaxi.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));
		
		taxiUser = ((taxiRouteService.getLocationsAndRoutesForATaxiUser(temptaxi)));
		return SUCCESS;
	}

	public String SimilarRoutesForRouteID() throws SQLException{ 
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser temptaxi = new TaxiUser() ;
		temptaxi.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));

		taxiUser = ((taxiRouteService.getSimilarRoutesForRouteID(temptaxi,Integer.parseInt(request.getParameter("trId")))));
		return SUCCESS;
	}
	
	// This method is for getting the similar routes for the given current route. Every time the user moves a new latitude
	// longitude set is generated and this is used to compare against the old database. 
	
	public String SimilarRoutesForCurrentRoute() throws SQLException{ 
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser temptaxi = new TaxiUser() ;
		temptaxi.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));
		Route route = new Route();
		try {
			JSONParser parser = new JSONParser();
			Object obj = parser.parse(request.getParameter("LatLng"));
			JSONArray jsonarray = (JSONArray) obj;
			List<Location> loclist = new ArrayList<Location>();
			for(int i=0;i < jsonarray.size();i++){
				JSONObject row = (JSONObject) jsonarray.get(i);
				Location loc = new Location();
				loc.setLatitude(Double.parseDouble(row.get("lat").toString()));
				loc.setLongitude(Double.parseDouble(row.get("lon").toString()));
				loclist.add(loc);
			}
			route.setLocation(loclist);
			
			System.out.println(loclist.size()+" "+jsonarray);
			taxiUser = ((taxiRouteService.getSimilarRoutesForCurrentRoute(temptaxi,route)));
			return SUCCESS;

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ERROR;
		}

	}

	// get the routes with start and end location. this is used by the routespredict page to add them in the drop down
	public String startAndEndLocationsofRoutesForAUser() throws SQLException{
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUserWithStartEnd temptaxiUser = new TaxiUserWithStartEnd() ;
		temptaxiUser.setTaxiUserId(Integer.parseInt(request.getParameter("tUserId")));
		taxiUserWithStartEnd = (taxiRouteService.getStartEndLocationsForRoutesForATaxiUser(temptaxiUser));
		return SUCCESS;
	}



	@Override
	public  TaxiUser getModel() {
		// TODO Auto-generated method stub
		return taxiUser;
	}

	public TaxiUserWithStartEnd getTaxiUserWithStartEnd() {
		return taxiUserWithStartEnd;
	}

	public void setTaxiUserWithStartEnd(TaxiUserWithStartEnd taxiUserWithStartEnd) {
		this.taxiUserWithStartEnd = taxiUserWithStartEnd;
	}
}
