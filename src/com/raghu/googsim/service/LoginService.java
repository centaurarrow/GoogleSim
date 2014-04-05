package com.raghu.googsim.service;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mysql.jdbc.Connection;
import com.raghu.googsim.model.User;

public class LoginService {
	private User User;

	public User doLogin(User user) throws SQLException{
		ResultSet rs;
		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_sec_get_user(?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setString(1,user.getUsername());

		rs = callableStatement.executeQuery();
		System.out.println("After the Resultset");
		if (rs.last()) {
			  System.out.println("User size is "+rs.getRow());
			  rs.beforeFirst(); // not rs.first() because the rs.next() below will move on, missing the first element
			}
		while(rs.next()){
			System.out.println("User is Authenticated");
			String p_password = rs.getString("password");
			if(p_password.equals(user.getPassword())){
				user.setCountry(rs.getString("country"));
				user.setUserid(rs.getString("userid"));
				user.setFullname(rs.getString("fullname"));
				user.setEmail(rs.getString("email"));
				user.setGender(rs.getString("gender"));
				List<String> roles = new ArrayList<String>();
				roles.add("USER");
				user.setRoles(roles);
				user.setPassword(""); //Remove the password
			}
			else{
				user.setPassword("");
			}
		}
		return user;
	}


}
