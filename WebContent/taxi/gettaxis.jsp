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
    	  	
        var myLatLng = new google.maps.LatLng(39.909473, 116.459181);
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
    //	directionsDisplay.setPanel(document.getElementById("directionsPanel"));
    	
    	var trafficLayer = new google.maps.TrafficLayer();

      }

      function drawMap(){
    	  var start = document.getElementById('source').value;
    	  var end = document.getElementById('destination').value;
    	  // creating the directionsRequest object
    	  var request = {
			  origin:start,
			  destination:end,
			  travelMode:google.maps.TravelMode.DRIVING,
			  provideRouteAlternatives : true,
			  durationInTraffic:false
    	  };
    	  
    	  directionsService.route(request,function(response,status){
    		  if(status == google.maps.DirectionsStatus.OK){
    			  directionsDisplay.setDirections(response);
    		  }
    	  });

    	  setInterval(function() {
    	      // Do something after 5 seconds
			  clearMarkers();
    	      $.getJSON('getTaxisAtGivenTime.action?tUserId=-1',function(data){

        		var route = data.taxiUser;
				for(var j=0;j<route.locationList.length;j++){
						locationlist = route.locationList;
	
				  	    addMarker(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude),locationlist[j].latitude+' '+locationlist[j].longitude+' '+locationlist[j].date);
					}
   		   	});
       	
      	 },5000);
    	  
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
    	  markers.push(marker);

      }
      //set the map on all markers in the array
      function setAllMap(map) {
    	  for(var i=0;i<markers.length;i++){
    		  markers[i].setMap(map);
    	  }
      }
      
   // Removes the markers from the map, but keeps them in the array.
      function clearMarkers() {
        setAllMap(null);
      }
 
  	//create an event to load 
  	google.maps.event.addDomListener(window,'load',initialize);

  	</script>
	<div id="wrapper">
		<div id="content">
			<div id="box">
				<h3 id="adduser">Welcome</h3>
				This is a Routes page. Please 
              	<s:url id="url" action="AllLocationsForTaxiAction" >
			      <s:param name="tUserId"><s:property value="#tId"/></s:param>
			    </s:url>
			    <s:a href="%{url}" targer="_blank">click</s:a>
				 here to go back
				<div id="directionsPanel" style=""></div>
			</div>
			<form name="getDirections" id="getDirections">
				Source : <input type="text" name="source" id="source" width="400px">
				Destination : <input type="text" name="destination" id="destination" width="400px">
				<input type="button" name="route" value="route" onclick="drawMap()" >
			</form>
			<div id="map-canvas" />
		</div>
	</div>
	<s:include value="../includes/footer.jsp"></s:include>
</s:if>
<s:else>
	<jsp:forward page="login.jsp" />
</s:else>
