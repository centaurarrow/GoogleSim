<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<s:if test="%{#session['isLoggedIN']}">
	<jsp:forward page="home.jsp"/>
</s:if>
<s:else>
	<s:include value="public_header.jsp"/>
		<s:div style="margin-left:400px;">
			Welcome to the Google Maps Simulator.
			<s:div style="margin:10px;">
				New Users, Please <a href="login.jsp">Login</a>
			</s:div>
			<s:div style="margin:10px;">
				Registered Users, Please <a href="registerUser.jsp">Register here</a>
			</s:div>
		</s:div>
	<s:include value="public_footer.jsp"/>	
</s:else> 

