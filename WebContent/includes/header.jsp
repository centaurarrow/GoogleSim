<%@page session="true"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<s:if test="%{#session['isLoggedIN']}">
	<s:if test="%{#session['LoggedInUser']}">
		<s:iterator value="%{#session['LoggedInUser']}" status="user">
			<s:set name="fullName" value="fullname" />
		</s:iterator>
	</s:if>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Users - Admin Template</title>
<link rel="stylesheet" type="text/css" href="css/theme.css" />
<link rel="stylesheet" type="text/css" href="css/style.css" />

<script type="text/javascript" charset="utf-8"  src="js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" charset="utf-8"  src="js/jquery.tablesorter.js"></script>
<script>
   var StyleFile = "theme" + document.cookie.charAt(6) + ".css";
   document.writeln('<link rel="stylesheet" type="text/css" href="css/' + StyleFile + '">');
</script>
<!--[if IE]>
<link rel="stylesheet" type="text/css" href="css/ie-sucks.css" />
<![endif]-->
</head>
<body>
	<div id="container">
    	<div id="header">
        	<h2>Google Maps Simulator</h2>
		    <div id="topmenu">
            	<ul>
	              	<li><a href="index.jsp">Home</a></li>
	              	<li><a href="allTaxisAction">Taxis</a></li>
	              	<li><a href="index.jsp">Routes</a></li>
	              	<li><a href="logoutAction">Logout</a></li>
       	      	</ul>
    	      </div>
    	 </div>			
    	 <div id="top-panel">
            <div id="panel">
                <ul>
					<li><a href="#" class="useradd"> Welcome <s:property value="fullName" /></a></li>
                </ul>
            </div>
        </div>
    	 
    	
</s:if>
<s:else>
	<jsp:forward page="login.jsp" />
</s:else>
