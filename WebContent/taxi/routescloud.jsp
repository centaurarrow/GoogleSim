<%@page session="true"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<s:set name="tId" value="%{#parameters['tUserId']}" />
<s:set name="trId" value="%{#parameters['tRouteId']}" />
<s:if test="%{#session['isLoggedIN']}">
	<s:include value="../includes/header.jsp"></s:include>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
#map-canvas {
	height: 100%;
	width: 100%
}
</style>
	<script type="text/javascript"
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8yIIQagPjfQkOJ9a4XE14z6g4EZ62dNY&sensor=true">
    </script>
	<script type="text/javascript">
	  var cenLat , cenLong;
	  var locationlist;
      
      var map;
      var markers= [];
      var cnt=0;;
      var json = {};
   
      var directionsDisplay;
      var directionsService = new google.maps.DirectionsService();

      var setIndex = function(ind,max){
				  if(ind < max){
					  return ind;
				  } else{
					 return setIndex(ind-1,max);
				  }
			  }

      function initialize(){
    	  //create the mapOptions object.
	 	//create directionsDisplay 
    	directionsDisplay = new google.maps.DirectionsRenderer();
    	  	
        var myLatLng = new google.maps.LatLng(37.7833, -122.4167);
        var source ;
        var destination ;
        
    	var mapOptions = {
    		center: myLatLng,
    		zoom : 12,
    		mapTypeId : google.maps.MapTypeId.ROADMAP 
   		};
    	
    	//create the map object
    	map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);
    	directionsDisplay.setMap(map);
    	directionsDisplay.setPanel(document.getElementById("directionsPanel"));
    	
    	var trafficLayer = new google.maps.TrafficLayer();

    	setTimeout(function() {
    	      // Do something after 5 seconds
        	$.getJSON('AllLocationsForAllRouteActionJson.action?tUserId=<s:property value="#tId"/>',function(data){
				
        		var routeList = data.taxiUser.routeList;
        		for(var i=0;i<routeList.length;i++){
        			var route = routeList[i];
        			var flightPlanCoordinates = new Array() ;

					for(var j=0;j<route.location.length;j++){
							locationlist = route.location;
							flightPlanCoordinates.push(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude)); 
						}
                    var flightPath = new google.maps.Polyline({
                        path: flightPlanCoordinates,
                        geodesic: true,
                        strokeColor: '#'+ ('000000' + (Math.random()*0xFFFFFF<<0).toString(16)).slice(-6),
                        strokeOpacity: 1.0,
                        strokeWeight: 2
                      });
                      flightPath.setMap(map);
        		}
   		   	}, 200);
       	
      	 });
    	     
      }
      
      //addMarker function
      function addMarker(location,title){
    	  var marker = new google.maps.Marker({
    		  position:location,
    		  map:map,
    		  draggable:true,
    		  title : title,
    		  animation:google.maps.Animation.DROP,
    	  });

      }
      
  	//create an event to load 
  	google.maps.event.addDomListener(window,'load',initialize);

  	</script>
	<div id="wrapper">
		<div id="content">
			<div id="box">
				<h3 id="adduser">Welcome</h3>
				This is a Routes page. Please
				<s:url id="url" action="AllLocationsForTaxiAction">
					<s:param name="tUserId">
						<s:property value="#tId" />
					</s:param>
				</s:url>
				<s:a href="%{url}" targer="_blank">click</s:a>
				here to go back
				<div id="directionsPanel" style=""></div>

			</div>
			<div id="map-canvas" />
		</div>
	</div>
	<s:include value="../includes/footer.jsp"></s:include>
</s:if>
<s:else>
	<jsp:forward page="login.jsp" />
</s:else>
