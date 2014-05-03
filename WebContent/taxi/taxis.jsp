<%@page session="true" %>
<%@ taglib uri="/struts-tags" prefix="s" %>
<%@taglib uri="http://displaytag.sf.net" prefix="display" %>

<s:if test="%{#session['isLoggedIN']}">
	<s:include value="../includes/header.jsp"></s:include>
	<script type="text/javascript">
		$(document).ready(function() 
		    { 
		        $("#myTable").tablesorter( {sortList: [[0,0], [1,0]]} ); 
		    } 
		); 
	</script>
	
        <div id="wrapper">
            <div id="content">
                <div id="box">
                   	<h3 id="adduser">Welcome</h3>
                   		This is a taxis page
			<!-- 	-->	<table class="tablesorter" id="myTable">
							<thead>
								<tr>
									<th width="40px"><a href="#">ID<img src="img/icons/arrow_down_mini.gif" width="16" height="16" align="absmiddle" /></a></th>
	                            	<th width="40px"><a href="#">Taxi ID</a></th>
	                            	<th><a href="#">Full Name</a></th>
	                                <th><a href="">View Routes</a></th>
	                                <th><a href="">Routes Cloud</a></th>
	                                <th><a href="">Predict Route</a></th>
	                            </tr>
							</thead>
							<tbody>
	          				<s:iterator value="taxiUserList" var="taxiList" status="stat">
								<tr>
									 <td class="a-center"><s:property value="#stat.count"/></td> 
	                            	<td class="a-center"><s:property value="#taxiList.getTaxiUserId()" /></td>
	                            	<td><s:property value="#taxiList.getTaxiUserName()" /></td>
	                                <td>
									   <s:url id="url" action="AllLocationsForTaxiAction" >
									      <s:param name="tUserId"><s:property value="#taxiList.getTaxiUserId()"/></s:param>
									    </s:url>
									    <s:a href="%{url}">View Routes</s:a>
									</td>
									<td> 
									   <s:url id="url" action="routescloud" >
									      <s:param name="tUserId"><s:property value="#taxiList.getTaxiUserId()"/></s:param>
									    </s:url>
									    <s:a href="%{url}">Routes Cloud</s:a>
									</td>
									<td> 
									   <s:url id="url" action="routespredict" >
									      <s:param name="tUserId"><s:property value="#taxiList.getTaxiUserId()"/></s:param>
									      <s:param name="tRouteId"><s:property value="-1"/></s:param>
									    </s:url>
									    <s:a href="%{url}">Predict Route</s:a>
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
