package com.raghu.googsim.service;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mysql.jdbc.Connection;
import com.raghu.googsim.model.Location;
import com.raghu.googsim.model.RegisteredUser;
import com.raghu.googsim.model.TaxiUser;

public class TaxiRouteService {
	private TaxiUser taxiUser;

	public TaxiUser getLocationsForATaxi(TaxiUser taxiUser) throws SQLException{
		ResultSet rs;
		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_core_get_taxis(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setInt(1,taxiUser.getTaxiUserId());
		rs = callableStatement.executeQuery();

		while(rs.next()){
			Location loc = new Location();
		//	loc.setLatitude(rs.getString(""));
		}
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
			System.out.println(taxiUserTemp.getTaxiUserId()+"--"+taxiUserTemp.getTaxiUserName());
			taxiUserList.add(taxiUserTemp);
		//	loc.setLatitude(rs.getString(""));
		}
		return taxiUserList;

	}
}
