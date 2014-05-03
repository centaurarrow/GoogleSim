package com.raghu.googsim.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.CallableStatement;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.mysql.jdbc.Connection;
import com.raghu.googsim.model.Location;
import com.raghu.googsim.model.RegisteredUser;
import com.raghu.googsim.model.Route;
import com.raghu.googsim.model.RouteWithStartEnd;
import com.raghu.googsim.model.TaxiUser;
import com.raghu.googsim.model.TaxiUserWithStartEnd;

public class TaxiRouteService {
	private static final double AVERAGE_RADIUS_OF_EARTH = 6731;
	private TaxiUser taxiUser = new TaxiUser(); 
	private Connection connection = (Connection)ConnectionService.getConnection();

	public TaxiUser getLocationsForATaxi(TaxiUser taxiUser) throws SQLException{

		ResultSet rs;
		List<Location> list = new ArrayList<Location>();
		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_locations_for_taxis(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,taxiUser.getTaxiUserId());
		rs = callableStatement.executeQuery();

		while(rs.next()){
			Location loc = new Location();
			loc.setLatitude((double) rs.getDouble("latitude"));
			loc.setLongitude((double) rs.getDouble("longitude"));
			loc.setSpeed((double) rs.getDouble("speed"));
			loc.setDirection((double) rs.getDouble("direction"));
			loc.setDate(rs.getTimestamp("date_ts"));
			//	System.out.println(loc.getLatitude()+"--"+loc.getLongitude()+"--"+loc.getDate());
			list.add(loc);
		}

		Location previous = new Location();
		Location current = new Location();

		List<Route> routelist = new ArrayList<Route>();
		List<Location> locationlist = new ArrayList<Location>();

		Route route = new Route();

		for (int i=0 ; i < list.size()-1 ;i++){

			if((previous.getLatitude()== 0.0) && (previous.getLongitude() == 0.0) ){
				route = new Route();
				locationlist = new ArrayList<Location>();

				current = new Location();
				current.setLatitude(list.get(i).getLatitude());
				current.setLongitude(list.get(i).getLongitude());
				current.setSpeed(list.get(i).getSpeed());
				current.setDirection(list.get(i).getDirection());
				current.setDate(list.get(i).getDate());
				previous = current;

				locationlist.add(current); //first Location in the LocationList
			}
			else{ // If not the source of the trip
				if(getDateDiff(previous.getDate(),list.get(i).getDate(),TimeUnit.SECONDS)<180){ //3 minutes

					current = new Location();
					current.setLatitude(list.get(i).getLatitude());
					current.setLongitude(list.get(i).getLongitude());
					current.setSpeed(list.get(i).getSpeed());
					current.setDirection(list.get(i).getDirection());
					current.setDate(list.get(i).getDate());
					previous = current;

					locationlist.add(current);
				}
				else{ // if the threshold is greater than 3 minutes or 180 seconds. Then end the route.
					//			System.out.println("Route Ended. Route size is"+locationlist.size()+"Route Number"+routelist.size());
					previous = new Location();
					route.setLocation(locationlist);
					routelist.add(route);
				}
			} 
			//			System.out.println(getDateDiff(list.get(i).getDate(),list.get(i+1).getDate(),TimeUnit.SECONDS));
		} 

		//		System.out.println("Route Length is %d"+routelist.size());

		taxiUser.setLocationList(list);
		taxiUser.setRouteList(routelist);
		return taxiUser;

	}

	/* Get the locations for a given route */
	public Route getLocationsForARoute(Route route) throws SQLException{

		ResultSet rs;
		List<Location> list = new ArrayList<Location>();
		//		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_locations_for_route(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,route.getRouteid());
		rs = callableStatement.executeQuery();

		while(rs.next()){
			Location loc = new Location();
			loc.setLatitude((double) rs.getDouble("latitude"));
			loc.setLongitude((double) rs.getDouble("longitude"));
			loc.setSpeed((double) rs.getDouble("speed"));
			loc.setDirection((double) rs.getDouble("direction"));
			loc.setDate(rs.getTimestamp("date_ts"));
			//	System.out.println(loc.getLatitude()+"--"+loc.getLongitude()+"--"+loc.getDate());
			list.add(loc);
		}

		route.setLocation(list);
		return route;

	}
	
	/* Get the locations for a given route */
	public Route getStartEndLocationsForARoute(Route route) throws SQLException{

		ResultSet rs;
		List<Location> list = new ArrayList<Location>();
		//		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_top_floor_locations_for_route(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,route.getRouteid());
		rs = callableStatement.executeQuery();

		while(rs.next()){
			Location loc = new Location();
			loc.setLatitude((double) rs.getDouble("latitude"));
			loc.setLongitude((double) rs.getDouble("longitude"));
			loc.setSpeed((double) rs.getDouble("speed"));
			loc.setDirection((double) rs.getDouble("direction"));
			loc.setDate(rs.getTimestamp("date_ts"));
			System.out.println(route.getRouteid()+" "+loc.getLatitude()+"--"+loc.getLongitude()+"--"+loc.getDate());
			list.add(loc);
		}

		route.setLocation(list);
		return route;

	}


	public TaxiUser getRoutesForATaxiUser(TaxiUser taxiUser) throws SQLException{
		//		System.out.println("This is it");
		ResultSet rs;
		List<Location> list = new ArrayList<Location>();
		List<Route> routelist = new ArrayList<Route>();
		//	Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_routes(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,taxiUser.getTaxiUserId());
		rs = callableStatement.executeQuery();

		while(rs.next()){
			Route route = new Route();
			route.setRouteid(rs.getInt("routeid"));
			route.setRoutename(rs.getString("routename"));
			route.setTaxiuserid(rs.getInt("taxiuserid"));
			
			routelist.add(route);
		}

		taxiUser.setRouteList(routelist);
		return taxiUser;

	}
	
	public TaxiUserWithStartEnd getStartEndLocationsForRoutesForATaxiUser(TaxiUserWithStartEnd taxiUser) throws SQLException{
		//		System.out.println("This is it");
		ResultSet rs;
		List<Location> list = new ArrayList<Location>();
		List<RouteWithStartEnd> routelist = new ArrayList<RouteWithStartEnd>();
		//	Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_top_floor_locations_for_taxis(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,taxiUser.getTaxiUserId());
		rs = callableStatement.executeQuery();

		while(rs.next()){
			RouteWithStartEnd route = new RouteWithStartEnd();
			route.setRouteid(rs.getInt("routeid"));
			route.setRoutename("");
			route.setTaxiuserid(rs.getInt("taxiuserid"));
			route.setStartlat(rs.getDouble("startlat"));
			route.setStartlon(rs.getDouble("startlon"));
			route.setEndlat(rs.getDouble("endlat"));
			route.setEndlon(rs.getDouble("endlon"));
			
			routelist.add(route);
		}

		taxiUser.setRouteList(routelist);
		return taxiUser;

	}

	public TaxiUser getLocationsAndRoutesForATaxiUser(TaxiUser taxiUser) throws SQLException{
		//	System.out.println("This is it");
		ResultSet rs;
		List<Location> list = new ArrayList<Location>();
		List<Route> routelist = new ArrayList<Route>();
		//		Connection connection = (Connection) ConnectionService.getConnection();
		//get all the route locations for taxis
		String insertStoredProc = "{call usp_core_get_locations_for_taxis(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,taxiUser.getTaxiUserId());
		rs = callableStatement.executeQuery();
		int previousid = -1;
		int routeid = 0;

		while(rs.next()){

			Location loc = new Location();
			routeid = rs.getInt("routeid");
			loc.setLatitude((double) rs.getDouble("latitude"));
			loc.setLongitude((double) rs.getDouble("longitude"));
			loc.setSpeed((double) rs.getDouble("speed"));
			loc.setDirection((double) rs.getDouble("direction"));
			loc.setDate(rs.getTimestamp("date_ts"));
			if(previousid == -1){
				previousid = routeid;
			}

			if(previousid != routeid){ // new route
				Route route = new Route(); // set the location of the old route
				route.setRouteid(previousid);
				route.setRoutename("route"+previousid);
				route.setTaxiuserid(taxiUser.getTaxiUserId());
				route.setLocation(list);
				routelist.add(route);
				list = new ArrayList<Location>(); // set to new locationlist
				list.add(loc);
				previousid = routeid;
			}
			else{
				list.add(loc);
			}
		}

		taxiUser.setRouteList(routelist);
		return taxiUser;

	}


	public List<TaxiUser> getAllTaxis() throws SQLException{
		ResultSet rs;
		List<TaxiUser> taxiUserList = new ArrayList<TaxiUser>();
		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_taxis(null) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		rs = callableStatement.executeQuery();

		while(rs.next()){
			TaxiUser taxiUserTemp = new TaxiUser();
			taxiUserTemp.setTaxiUserId(rs.getInt("taxiuserid"));
			taxiUserTemp.setTaxiUserName(rs.getString("taxiusername"));
			//		System.out.println(taxiUserTemp.getTaxiUserId()+"--"+taxiUserTemp.getTaxiUserName());
			taxiUserList.add(taxiUserTemp);
			//	loc.setLatitude(rs.getString(""));
		}
		return taxiUserList;

	}
	public TaxiUser getTaxisAtGivenTime(TaxiUser taxiUser) throws SQLException{
		ResultSet rs;
		List<TaxiUser> taxiUserList = new ArrayList<TaxiUser>();
		//	taxiUserList = getAllTaxis();
		List<Location> list = new ArrayList<Location>();

		Connection connection = (Connection) ConnectionService.getConnection();

		String insertStoredProc11 = "{call usp_core_get_current_taxis() }";
		CallableStatement callableStatement11 = connection.prepareCall(insertStoredProc11);
		rs = callableStatement11.executeQuery();

		//	System.out.println("here "+(new Date()));
		while(rs.next()){
			Location loc = new Location();
			loc.setLatitude((double) rs.getDouble("latitude"));
			loc.setLongitude((double) rs.getDouble("longitude"));
			loc.setSpeed((double) rs.getDouble("speed"));
			loc.setDirection((double) rs.getDouble("direction"));
			loc.setDate(rs.getTimestamp("date_ts"));
			//		System.out.println(loc.getLatitude()+"--"+loc.getLongitude()+"--"+loc.getDate());
			list.add(loc);
		}
		//		System.out.println(list.size());
		taxiUser.setLocationList(list);
		return taxiUser;


	}

	public TaxiUser getSimilarRoutesForRouteID(TaxiUser taxiTempUser,int routeid) throws SQLException{

		TaxiUser taxiUser = getLocationsAndRoutesForATaxiUser(taxiTempUser);
		TaxiUser retTaxiUser = new TaxiUser();
		List<Route> retRouteList = new ArrayList<Route>();
		routeid-=1; // Array starts with 0
		// Using the For Loop
		double[][] distanceAB = new double[taxiUser.getRouteList().size()][taxiUser.getRouteList().size()];
		double[][] routeAB = new double[taxiUser.getRouteList().size()][taxiUser.getRouteList().size()];
		Map<Integer,String> map = new HashMap<Integer,String>();

		// find the distance of all the routes. 
		/*		for(int i=0;i<taxiUser.getRouteList().size() ;i++){
			double[] distance = new double[taxiUser.getRouteList().size()];;
			for(int k=0;k<taxiUser.getRouteList().get(i).getLocation().size()-1;k++){
				distance[i] = distance[i]+calculateDistance(taxiUser.getRouteList().get(i).getLocation().get(k).getLatitude(),
						taxiUser.getRouteList().get(i).getLocation().get(k).getLongitude(),
						taxiUser.getRouteList().get(i).getLocation().get(k+1).getLatitude(),
						taxiUser.getRouteList().get(i).getLocation().get(k+1).getLongitude());

			}
			System.out.println("distance for "+i+" is "+distance[i]);
		} */
		//	return retTaxiUser;
		for(int i=0;i<taxiUser.getRouteList().size() ;i++){ // For Every Route taxiUser.getRouteList().size() 
			//	if((routeid<0)||((routeid!=-1) && (i==routeid)))
			{ //get the similar routes only for routeid
				map.put(i,"");
				//	System.out.println(taxiUser.getRouteList().get(i).getLocation().size());

				for(int j=0;j<taxiUser.getRouteList().size() ;j++){
					double[][] multi = new double[taxiUser.getRouteList().get(i).getLocation().size()+1][taxiUser.getRouteList().get(j).getLocation().size()+1];
					double[] unique = new double[taxiUser.getRouteList().get(i).getLocation().size()+1];
					int eliminatedPoints = 0;
					if(i!=j){ // Should not compare two routes
						for(int k=0;k<taxiUser.getRouteList().get(i).getLocation().size();k++){
							unique[k] = 0;
							for(int l=0;l<taxiUser.getRouteList().get(j).getLocation().size();l++){
								multi[k][l] = calculateDistance(taxiUser.getRouteList().get(i).getLocation().get(k).getLatitude(),
										taxiUser.getRouteList().get(i).getLocation().get(k).getLongitude(),
										taxiUser.getRouteList().get(j).getLocation().get(l).getLatitude(),
										taxiUser.getRouteList().get(j).getLocation().get(l).getLongitude());
								if(unique[k] == 0){
									unique[k] = multi[k][l];
								}else if(unique[k]>multi[k][l]){ // adding the distances between i and j 
									unique[k]= multi[k][l];
								}
							}
						}

						for(int k=0;k<taxiUser.getRouteList().get(i).getLocation().size();k++){ // getting the distance vector
							if(unique[k]>(0.1*taxiUser.getRouteList().get(i).getLocation().size())){
								eliminatedPoints+=1;
							}
							else{
								distanceAB[i][j] = distanceAB[i][j]+unique[k];
							}
						}
						// get the minimum distance between two points
						distanceAB[i][j] = distanceAB[i][j]/(taxiUser.getRouteList().get(i).getLocation().size()-eliminatedPoints);
						//get the routeid of A 
						routeAB[i][j] = taxiUser.getRouteList().get(i).getRouteid();
						routeAB[j][i] = taxiUser.getRouteList().get(j).getRouteid();
					}
				}
			}
		}
		System.out.println("I am here");

		for(int i=0;i<taxiUser.getRouteList().size() ;i++){ // For Every Route taxiUser.getRouteList().size() 
			//	System.out.println(taxiUser.getRouteList().get(i).getLocation().size());
			if((routeid<0)||((routeid!=-1) && (taxiUser.getRouteList().get(i).getRouteid()==(routeid+1)))){ //get the similar routes only for routeid
				for(int j=0;j<taxiUser.getRouteList().size() ;j++){
					//		System.out.println((distanceAB[i][j]+distanceAB[j][i])/2);
					if(i!=j){
						if((distanceAB[i][j]+distanceAB[j][i])/2<=0.2){
							retRouteList.add(taxiUser.getRouteList().get(j));
							//		System.out.println("Simlarity Score of Route "+i+" and route "+j+" is "+ (distanceAB[i][j])+ " routeid is "+routeAB[i][j]);
							//		System.out.println("Simlarity Score of Route "+j+" and route "+i+" is "+ (distanceAB[j][i])+ " routeid is "+routeAB[j][i]);
						}
					}
				}
			}
		}
		retTaxiUser.setRouteList(retRouteList);
		System.out.println("Total Number of matched routes for the users "+taxiTempUser.getTaxiUserId()+" are "+retRouteList.size());
		return retTaxiUser; 
	}

	public TaxiUser getSimilarRoutesForCurrentRoute(TaxiUser taxiTempUser,Route route) throws SQLException{

		TaxiUser taxiUser = getLocationsAndRoutesForATaxiUser(taxiTempUser);
		TaxiUser retTaxiUser = new TaxiUser();
		List<Route> retRouteList = new ArrayList<Route>();
		int routeid= -1; // Array starts with 0
		// Using the For Loop
		double[][] distanceAB = new double[1][taxiUser.getRouteList().size()];
		double[][] routeAB = new double[1][taxiUser.getRouteList().size()];
		Map<Integer,String> map = new HashMap<Integer,String>();

		// find the distance of all the routes. 
		/*		for(int i=0;i<taxiUser.getRouteList().size() ;i++){
			double[] distance = new double[taxiUser.getRouteList().size()];;
			for(int k=0;k<taxiUser.getRouteList().get(i).getLocation().size()-1;k++){
				distance[i] = distance[i]+calculateDistance(taxiUser.getRouteList().get(i).getLocation().get(k).getLatitude(),
						taxiUser.getRouteList().get(i).getLocation().get(k).getLongitude(),
						taxiUser.getRouteList().get(i).getLocation().get(k+1).getLatitude(),
						taxiUser.getRouteList().get(i).getLocation().get(k+1).getLongitude());
			}
			System.out.println("distance for "+i+" is "+distance[i]);
		} */
		//	return retTaxiUser;
		for(int j=0;j<taxiUser.getRouteList().size() ;j++){
			double[][] multi = new double[route.getLocation().size()][taxiUser.getRouteList().get(j).getLocation().size()+1];
			double[] unique = new double[route.getLocation().size()];
			int eliminatedPoints = 0;
			for(int k=0;k<route.getLocation().size();k++){
				unique[k] = 0;
				for(int l=0;l<taxiUser.getRouteList().get(j).getLocation().size();l++){
					multi[k][l] = calculateDistance(route.getLocation().get(k).getLatitude(),
							route.getLocation().get(k).getLongitude(),
							taxiUser.getRouteList().get(j).getLocation().get(l).getLatitude(),
							taxiUser.getRouteList().get(j).getLocation().get(l).getLongitude());
			//		System.out.println("Mutlie value is "+multi[k][l]+" "+route.getLocation().get(k).getLatitude()+" "+route.getLocation().get(k).getLongitude());
					if(unique[k] == 0){
						unique[k] = multi[k][l];
					}else if(unique[k]>multi[k][l]){ // adding the distances between i and j 
						unique[k]= multi[k][l];
					}
				}
			}

			// Eliminating certain routes
			for(int k=0;k<route.getLocation().size();k++){ // getting the distance vector
		//		System.out.println("Unique value is "+unique[k]);
				if(unique[k]>(0.1*route.getLocation().size())){
					eliminatedPoints+=1;
				}
				else{
					distanceAB[0][j] = distanceAB[0][j]+unique[k];
				}
			}
			// get the minimum distance between two points
			distanceAB[0][j] = distanceAB[0][j]/(route.getLocation().size()-eliminatedPoints);
			//get the routeid of A 
			routeAB[0][j] = taxiUser.getRouteList().get(j).getRouteid();
		//	routeAB[j][i] = taxiUser.getRouteList().get(j).getRouteid();
		}

	//	System.out.println("I am here");

		for(int j=0;j<taxiUser.getRouteList().size() ;j++){
			//		System.out.println((distanceAB[i][j]+distanceAB[j][i])/2);
		//		System.out.println("The distance is "+distanceAB[0][j]);
				if((distanceAB[0][j])<=0.1){
							retRouteList.add(taxiUser.getRouteList().get(j));
					//		System.out.println("Simlarity Score of Route and route "+j+" is "+ (distanceAB[0][j])+ " routeid is "+routeAB[0][j]);
					//		System.out.println("Simlarity Score of Route "+j+" and route "+i+" is "+ (distanceAB[j][i])+ " routeid is "+routeAB[j][i]);
				}
		}

		retTaxiUser.setRouteList(retRouteList);
		System.out.println("Total Number of matched routes for the users "+taxiTempUser.getTaxiUserId()+" are "+retRouteList.size());
		return retTaxiUser; 
	}

	/* All the methods are insertion/updation methods */
	/* This method is called to update the routes table for each user by extracting from locations for each user
	 * This will reduce the size of the location table from 2M location points to */
	public void UpdateRoutesTable() throws SQLException{
		//		System.out.println("This is it");
		ResultSet rs;
		List<TaxiUser> taxiUserList = new ArrayList<TaxiUser>();
		taxiUserList = getAllTaxis();

		Connection connection = (Connection) ConnectionService.getConnection();

		for(int cnt=1235;cnt<taxiUserList.size();cnt++){

			String insertStoredProc = "{call usp_core_get_locations_for_taxis(?) }";
			CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
			callableStatement.setInt(1,taxiUserList.get(cnt).getTaxiUserId());
			rs = callableStatement.executeQuery();
			List<Location> list = new ArrayList<Location>();

			while(rs.next()){
				Location loc = new Location();
				loc.setLatitude((double) rs.getDouble("latitude"));
				loc.setLongitude((double) rs.getDouble("longitude"));
				loc.setSpeed((double) rs.getDouble("speed"));
				loc.setDirection((double) rs.getDouble("direction"));
				loc.setDate(rs.getTimestamp("date"));
				//		System.out.println(loc.getLatitude()+"--"+loc.getLongitude()+"--"+loc.getDate());
				list.add(loc);
			}

			Location previous = new Location();
			Location current = new Location();

			List<Route> routelist = new ArrayList<Route>();
			List<Location> locationlist = new ArrayList<Location>();

			Route route = new Route();

			for (int i=0 ; i < list.size()-1 ;i++){

				if((previous.getLatitude()== 0.0) && (previous.getLongitude() == 0.0) ){
					route = new Route();
					locationlist = new ArrayList<Location>();

					current = new Location();
					current.setLatitude(list.get(i).getLatitude());
					current.setLongitude(list.get(i).getLongitude());
					current.setSpeed(list.get(i).getSpeed());
					current.setDirection(list.get(i).getDirection());
					current.setDate(list.get(i).getDate());
					previous = current;

					locationlist.add(current); //first Location in the LocationList
				}
				else{ // If not the source of the trip
					if(getDateDiff(previous.getDate(),list.get(i).getDate(),TimeUnit.SECONDS)<180){ //3 minutes

						current = new Location();
						current.setLatitude(list.get(i).getLatitude());
						current.setLongitude(list.get(i).getLongitude());
						current.setSpeed(list.get(i).getSpeed());
						current.setDirection(list.get(i).getDirection());
						current.setDate(list.get(i).getDate());
						previous = current;

						locationlist.add(current);
					}
					else{ // if the threshold is greater than 3 minutes or 180 seconds. Then end the route.
						//			System.out.println("Route Ended. Route size is"+locationlist.size()+"Route Number"+routelist.size());
						previous = new Location();
						route.setLocation(locationlist);
						routelist.add(route);
					}
				} 
				//			System.out.println(getDateDiff(list.get(i).getDate(),list.get(i+1).getDate(),TimeUnit.SECONDS));
			} 

			System.out.println(cnt+". Number of routes for the user "+taxiUserList.get(cnt).getTaxiUserId()+" is "+routelist.size());
			for(int rtecnt = 0 ; rtecnt < routelist.size(); rtecnt++){
				// insert the routes into the database
				String insertStoredProc1 = "{call usp_sec_insert_route(?,?,?) }";
				CallableStatement callableStatement1 = connection.prepareCall(insertStoredProc1);
				callableStatement1.registerOutParameter(3, Types.INTEGER);
				callableStatement1.setString(1,"Route");
				callableStatement1.setInt(2,taxiUserList.get(cnt).getTaxiUserId());
				callableStatement1.executeUpdate();
				int result = callableStatement1.getInt(3);

				if(result>0){
					//			System.out.println("Route "+result+" has been inserted");
				}else{
					System.out.println("There is an Error in inserting");
					break;
				}

				for(int loccnt =0 ; loccnt < routelist.get(rtecnt).getLocation().size();loccnt++){

					String insertStoredProc11 = "{call usp_sec_insert_route_location(?,?,?,?,?,?,?) }";
					CallableStatement callableStatement11 = connection.prepareCall(insertStoredProc11);
					callableStatement11.setInt(1,result);
					callableStatement11.setInt(2,taxiUserList.get(cnt).getTaxiUserId());
					String sqlDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format((routelist.get(rtecnt).getLocation().get(loccnt).getDate().getTime()));
					callableStatement11.setString(3, (String) sqlDate);
					callableStatement11.setDouble(4,routelist.get(rtecnt).getLocation().get(loccnt).getLatitude());
					callableStatement11.setDouble(5,routelist.get(rtecnt).getLocation().get(loccnt).getLongitude());
					callableStatement11.setDouble(6,routelist.get(rtecnt).getLocation().get(loccnt).getSpeed());
					callableStatement11.setInt(7,(int) routelist.get(rtecnt).getLocation().get(loccnt).getDirection());
					int result1 = callableStatement11.executeUpdate();

					if(result1>0){
						//System.out.println("Inserted");
					}else{
						System.out.println("There is an error");
					}
				}
			}
		}
	}

	/* Insert users into the taxisusers table */
	public void InsertUsersintoTheTable(final File folder) throws FileNotFoundException, IOException, SQLException {
		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_sec_insert_taxiuser(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);

		for (final File fileEntry : folder.listFiles()) {
			if (fileEntry.isDirectory()) {
				InsertUsersintoTheTable(fileEntry);
			} else {
				if (fileEntry.getName().matches("new.*")) { 
					System.out.println(fileEntry.getName().split("new_")[1].split(".txt")[0]);
					callableStatement.setString(1,fileEntry.getName().split("new_")[1].split(".txt")[0]);
					int retVal = callableStatement.executeUpdate();
				}
				/*           try(BufferedReader br = new BufferedReader(new FileReader(fileEntry.getAbsolutePath()))) {
	                StringBuilder sb = new StringBuilder();
	                String line = br.readLine();

	                while (line != null) {
	                    sb.append(line);
	                    sb.append(System.lineSeparator());
	                    line = br.readLine();
	                }
	                String everything = sb.toString();
	                System.out.println(everything);
	            } */
			}

		}
	}


	/* All the methods are insertion/updation methods */

	/* This method is called to update the routes table for each user by extracting from locations for each user
	 * This will reduce the size of the location table from 2M location points to */
	public void InserRoutesAndLocationsForUsers() throws SQLException, FileNotFoundException, IOException{
		ResultSet rs;
		List<TaxiUser> taxiUserList = new ArrayList<TaxiUser>();
		taxiUserList = getAllTaxis();

		Connection connection = (Connection) ConnectionService.getConnection();
		System.out.println(taxiUserList.size());
		for(int cnt=70;cnt<taxiUserList.size();cnt++){

			String insertStoredProc = "{call usp_core_get_locations_for_taxis(?) }";
			CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
			//	callableStatement.setInt(1,taxiUserList.get(cnt).getTaxiUserId());
			//	rs = callableStatement.executeQuery();
			List<Location> list = new ArrayList<Location>();
			// read the text file and get the routes

			try(BufferedReader br = new BufferedReader(new FileReader("C:\\Users\\RaghuNandan\\Downloads\\cabspottingdata\\cabspottingdata\\"+"new_"+taxiUserList.get(cnt).getTaxiUserName()+".txt"))) {
				StringBuilder sb = new StringBuilder();
				String line = br.readLine();

				while (line != null) {
					sb.append(line);
					sb.append(System.lineSeparator());
					line = br.readLine();
					if(line!=null){
						//		System.out.println(line.split(" ")[0]);
						Location loc = new Location();
						loc.setLatitude(Double.parseDouble(line.split(" ")[0]));
						loc.setLongitude(Double.parseDouble(line.split(" ")[1]));
						loc.setSpeed('1');
						loc.setDirection(Double.parseDouble(line.split(" ")[2]));
						loc.setDate(new Date((Long.parseLong(line.split(" ")[3])*1000)));
						list.add(loc);
					}
				}

				//			String everything = sb.toString();
				//			System.out.println(everything);
			} 

			/*		while(rs.next()){
				Location loc = new Location();
				loc.setLatitude((double) rs.getDouble("latitude"));
				loc.setLongitude((double) rs.getDouble("longitude"));
				loc.setSpeed((double) rs.getDouble("speed"));
				loc.setDirection((double) rs.getDouble("direction"));
				loc.setDate(rs.getTimestamp("date"));
				//		System.out.println(loc.getLatitude()+"--"+loc.getLongitude()+"--"+loc.getDate());
				list.add(loc);
			} */

			Location previous = new Location();
			Location current = new Location();

			List<Route> routelist = new ArrayList<Route>();
			List<Location> locationlist = new ArrayList<Location>();

			Route route = new Route();

			for (int i=0 ; i < list.size()-1 ;i++){
				if(list.get(i).getDirection()==1){
					if((previous.getLatitude()== 0.0) && (previous.getLongitude() == 0.0) ){
						route = new Route();
						locationlist = new ArrayList<Location>();

						current = new Location();
						current.setLatitude(list.get(i).getLatitude());
						current.setLongitude(list.get(i).getLongitude());
						current.setSpeed(list.get(i).getSpeed());
						current.setDirection(list.get(i).getDirection());
						current.setDate(list.get(i).getDate());
						previous = current;

						locationlist.add(current); //first Location in the LocationList
					}
					else{ // If not the source of the trip
						current = new Location();
						current.setLatitude(list.get(i).getLatitude());
						current.setLongitude(list.get(i).getLongitude());
						current.setSpeed(list.get(i).getSpeed());
						current.setDirection(list.get(i).getDirection());
						current.setDate(list.get(i).getDate());
						previous = current;

						locationlist.add(current);
					} 
				}else{
					// if the threshold is greater than 3 minutes or 180 seconds. Then end the route.
					//			System.out.println("Route Ended. Route size is"+locationlist.size()+"Route Number"+routelist.size());
					if((previous.getLatitude()!= 0.0) && (previous.getLongitude() != 0.0) ){
						previous = new Location();
						route.setLocation(locationlist);
						//		System.out.println("Route Length is "+locationlist.size());
						if(locationlist.size()>10){
							routelist.add(route);
						}
					}
				}
				//System.out.println(getDateDiff(list.get(i).getDate(),list.get(i+1).getDate(),TimeUnit.SECONDS));
			} 

			System.out.println(cnt+". Number of routes for the user "+taxiUserList.get(cnt).getTaxiUserId()+" is "+routelist.size());
			for(int rtecnt = 0 ; rtecnt < routelist.size(); rtecnt++){
				// insert the routes into the database
				String insertStoredProc1 = "{call usp_sec_insert_route(?,?,?) }";
				CallableStatement callableStatement1 = connection.prepareCall(insertStoredProc1);
				callableStatement1.registerOutParameter(3, Types.INTEGER);
				callableStatement1.setString(1,"Route");
				callableStatement1.setInt(2,taxiUserList.get(cnt).getTaxiUserId());
				callableStatement1.executeUpdate();
				int result = callableStatement1.getInt(3);

				if(result>0){
					//			System.out.println("Route "+result+" has been inserted");
				}else{
					System.out.println("There is an Error in inserting");
					break;
				}

				for(int loccnt =0 ; loccnt < routelist.get(rtecnt).getLocation().size();loccnt++){

					String insertStoredProc11 = "{call usp_sec_insert_route_location(?,?,?,?,?,?,?) }";
					CallableStatement callableStatement11 = connection.prepareCall(insertStoredProc11);
					callableStatement11.setInt(1,result);
					callableStatement11.setInt(2,taxiUserList.get(cnt).getTaxiUserId());
					String sqlDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format((routelist.get(rtecnt).getLocation().get(loccnt).getDate().getTime()));
					callableStatement11.setString(3, (String) sqlDate);
					callableStatement11.setDouble(4,routelist.get(rtecnt).getLocation().get(loccnt).getLatitude());
					callableStatement11.setDouble(5,routelist.get(rtecnt).getLocation().get(loccnt).getLongitude());
					callableStatement11.setDouble(6,routelist.get(rtecnt).getLocation().get(loccnt).getSpeed());
					callableStatement11.setInt(7,(int) routelist.get(rtecnt).getLocation().get(loccnt).getDirection());
					int result1 = callableStatement11.executeUpdate();

					if(result1>0){
						//System.out.println("Inserted");
					}else{
						System.out.println("There is an error");
					}
				}
			} 
		}
	}	


	public static long getDateDiff(Date date1, Date date2, TimeUnit timeUnit) {
		long diffInMillies = date2.getTime() - date1.getTime();
		return timeUnit.convert(diffInMillies,TimeUnit.MILLISECONDS);
	}

	public static double calculateDistance(double userLat, double userLng, double venueLat, double venueLng) {

		double latDistance = Math.toRadians(userLat - venueLat);
		double lngDistance = Math.toRadians(userLng - venueLng);

		double a = (Math.sin(latDistance / 2) * Math.sin(latDistance / 2)) +
				(Math.cos(Math.toRadians(userLat))) *
				(Math.cos(Math.toRadians(venueLat))) *
				(Math.sin(lngDistance / 2)) *
				(Math.sin(lngDistance / 2));

		double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

		return (double) ((AVERAGE_RADIUS_OF_EARTH * c));

	}

}
