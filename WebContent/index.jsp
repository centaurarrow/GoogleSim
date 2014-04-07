<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<s:if test="%{#session['isLoggedIN']}">
	<jsp:forward page="home.jsp"/>
</s:if>
<s:else>
	<s:include value="includes/public_header.jsp"/>
	   <div id="wrapper">
            <div id="content">
                <div id="box">
                   	<h3 id="adduser">Welcome to the Google Maps Simulator.</h3>
					<s:div style="margin:10px;">
						New Users, Please <a href="login.jsp">Login</a>
					</s:div>
					<s:div style="margin:10px;">
						Registered Users, Please <a href="registerUser.jsp">Register here</a>
					</s:div>
				</div>
			</div>
		</div>
	<s:include value="includes/public_footer.jsp"/>	
</s:else> 

