<%@page session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<s:set name="tId" value="%{#parameters['tUserId']}"/>
<s:if test="%{#session['isLoggedIN']}">
	<s:include value="../includes/header.jsp"></s:include>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
      #map-canvas { height: 100% ; width:100%}
    </style>
    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8yIIQagPjfQkOJ9a4XE14z6g4EZ62dNY&sensor=true">
    </script>
        <div id="wrapper">
            <div id="content">
                <div id="box">
                   	<h3 id="adduser">Welcome</h3>
                   		This is a Routes page
						<table class="tablesorter" id="myTable">
							<thead>
								<tr>
									<th width="40px"><a href="#">ID<img src="img/icons/arrow_down_mini.gif" width="16" height="16" align="absmiddle" /></a></th>
	                            	<th width="40px"><a href="#">Route ID</a></th>
	                            	<th><a href="#">Route Name</a></th>
	                                <th><a href="#">View Locations</a></th>
	                                <th><a href="#">Similar Routes</a></th>
	                            </tr>
							</thead>
							<tbody>
	       				   <s:iterator value="taxiUser.getRouteList()" var="route" status="stat">
								<tr>
									<td class="a-center"><s:property value="#stat.count"/></td> 
	                            	<td class="a-center"><s:property value="%{#route.routeid}" /></td>
	                            	<td><s:property value="%{#route.routename}" /></td>
	                                <td>
	                                	<s:url id="url" action="routelocation" >
									      <s:param name="tRouteId"><s:property value="%{#route.routeid}"/></s:param>
									      <s:param name="tUserId"><s:property value="%{#route.taxiuserid}"/></s:param>
									    </s:url>
									    <s:a href="%{url}" targer="_blank">View Location</s:a>
									</td>
	                                <td>
	                                	<s:url id="url" action="routessimilar" >
									      <s:param name="tRouteId"><s:property value="%{#route.routeid}"/></s:param>
									      <s:param name="tUserId"><s:property value="%{#route.taxiuserid}"/></s:param>
									    </s:url>
									    <s:a href="%{url}" targer="_blank">Similar Route</s:a>
									</td>
                            	</tr>
							</s:iterator>
							</tbody>
						</table> 
                </div>
             </div>
        </div>
	<s:include value="../includes/footer.jsp"></s:include>
</s:if>
<s:else>
	<jsp:forward page="login.jsp"/>
</s:else> 
