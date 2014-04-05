<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<s:if test="%{#session['isLoggedIN']}">
	<jsp:forward page="home.jsp"/>
</s:if>
<s:else>
	<s:include value="public_header.jsp"/>
		<s:div style="margin-left:400px;">
			<h2 >Login Form</h2>
			<s:form action="loginAction">
					<s:textfield key="user.username" label="Enter your Username"/>
					<s:password key="user.password" label="Enter your password"/>
					<s:submit /> 
			</s:form>
		</s:div>
	<s:include value="public_footer.jsp"/>	
</s:else> 

