<%@page session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>

<s:if test="%{#session['isLoggedIN']}">
	<s:include value="header.jsp"></s:include>
	<h2 align="center">Home Page</h2>
	<s:property value="user.username"></s:property>
</s:if>
<s:else>
	<jsp:forward page="login.jsp"/>
</s:else> 
