<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<s:if test="%{#session['isLoggedIN']}">
	<jsp:forward page="home.jsp">
		<jsp:param value="user" name="user"/>
	</jsp:forward>
</s:if>
<s:else>
	<jsp:include page="public_header.jsp"/>
		<s:div style="margin-left:400px;">
			<h2 style="margin-left:150px;">Registration Form</h2>
			<s:form action="registerAction">
					<s:textfield key="registeredUser.fullname" label="Enter your Fullname"/>
					<s:textfield key="registeredUser.username" label="Enter your Username"/>
					<s:password key="registeredUser.password" label="Enter your password"/>
					<s:textfield key="registeredUser.email" label="Enter your Email"/>
					<s:textfield key="registeredUser.gender" label="Enter your Gender"/>
					<s:textfield key="registeredUser.country" label="Enter your Country"/>
					<s:submit /> 
			</s:form>
		</s:div>
	<jsp:include page="public_footer.jsp"/>
</s:else>
