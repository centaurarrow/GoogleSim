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
                   	<h3 id="adduser">Login Form</h3>
					<s:form id="form" action="loginAction">
                      	<s:textfield key="user.username" id="username" label="Enter your Username"/>
						<s:password key="user.password" label="Enter your password"/>
						<s:submit /> 
					</s:form>
				</div>
			</div>
		</div>
	<s:include value="includes/public_footer.jsp"/>	
</s:else> 

