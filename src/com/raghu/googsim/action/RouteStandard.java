package com.raghu.googsim.action;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.SQLException;

import com.raghu.googsim.model.TaxiUser;
import com.raghu.googsim.service.TaxiRouteService;

public class RouteStandard {
	public final static double AVERAGE_RADIUS_OF_EARTH = 6371; // in KiloMeters

	public static void main(String[] args) throws SQLException, FileNotFoundException, IOException {
		// TODO Auto-generated method stub
		TaxiRouteService taxiRouteService = new TaxiRouteService();
		TaxiUser taxiTempUser = new TaxiUser();
		for(int i=0;i<10;i++){
		taxiTempUser.setTaxiUserId(i);
		taxiRouteService.getSimilarRoutesForRouteID(taxiTempUser, -1);
		}

		//	taxiRouteService.UpdateRoutesTable();
		final File folder = new File("C:\\Users\\RaghuNandan\\Downloads\\cabspottingdata\\cabspottingdata");
		//taxiRouteService.InsertUsersintoTheTable(folder);
		//	taxiRouteService.InserRoutesAndLocationsForUsers();
	}


}
