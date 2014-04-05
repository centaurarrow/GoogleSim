package com.raghu.googsim.service;

import java.sql.CallableStatement;
import java.sql.SQLException;

import com.mysql.jdbc.Connection;
import com.raghu.googsim.model.RegisteredUser;

public class RegisterService {
	private RegisteredUser registeredUser;

	public int doRegister(RegisteredUser registeredUser) throws SQLException{
		int retVal = 1;
		Connection connection = (Connection) ConnectionService.getConnection();
		String insertStoredProc = "{call usp_sec_insert_user(?,?,?,?,?,?) }";
		CallableStatement callableStatement = connection.prepareCall(insertStoredProc);
		callableStatement.setString(1,registeredUser.getUsername());
		callableStatement.setString(2,registeredUser.getFullname());
		callableStatement.setString(3,registeredUser.getPassword());
		callableStatement.setString(4,registeredUser.getEmail());
		callableStatement.setString(5,registeredUser.getGender());
		callableStatement.setString(6,registeredUser.getCountry());
		retVal = callableStatement.executeUpdate();
		return retVal;
	}

	public RegisteredUser getRegisteredUser() {
		return registeredUser;
	}

	public void setRegisteredUser(RegisteredUser registeredUser) {
		this.registeredUser = registeredUser;
	}
}
