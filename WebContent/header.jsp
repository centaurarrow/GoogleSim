<%@page session="true"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<s:if test="%{#session['isLoggedIN']}">
	<s:if test="%{#session['LoggedInUser']}">
		<s:iterator value="%{#session['LoggedInUser']}" status="user">
			<s:set name="fullName" value="fullname" />
		</s:iterator>
	</s:if>
	<html>
	<head>
		<style>
			ul {
				list-style-type: none;
				margin: 0;
				padding: 0;
				overflow: hidden;
			}
			
			li {
				float: left;
			}
			
			a {
				display: block;
				width: 60px;
				background-color: #dddddd;
			}
		</style>
	</head>
	<body>
		<s:div style="margin-left:400px">
			<font face="arier" size="6"> Google Map Simulator Application </font>
			<br clear="all" />
			<br clear="all" />
		</s:div>
		<ul style="margin-left: 400px;">
			<li><a class="menu" href="home.jsp">Home</a></li>
			<li><a class="menu" href="home.jsp">Products</a></li>
			<li><a class="menu" href="home.jsp">Admin</a></li>
			<li><a class="menu" href="logoutAction.action">Logout</a></li>
			<li>Welcome <s:property value="fullName" /></li>
		</ul>
</s:if>
<s:else>
	<jsp:forward page="login.jsp" />
</s:else>
