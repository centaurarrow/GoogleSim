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
#panel {
	padding:5px;
	margin:5px;
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
      var markerArray = []; 

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
    		mapTypeId : google.maps.MapTypeId.SATELLITE 
   		};
    	
    	//create the map object
    	map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);
    	directionsDisplay.setMap(map);
    	directionsDisplay.setPanel(document.getElementById("directionsPanel"));
    	
    	var trafficLayer = new google.maps.TrafficLayer();

    	var data1 = [{"lat":"1",lon:"1"},{"lat":"2",lon:"2"},{"lat":"3","lon":"3"}];
    	setTimeout(function() {
    	      // Do something after 5 seconds
        	$.ajax('SimilarRoutesForRouteID.action', 
        			{
        				type: "post",
        				data : {
			        		tUserId : '<s:property value="#tId"/>',
			        		trId : '<s:property value="#trId"/>',
			        		LatLng : JSON.stringify(data1)
			        	}
        	}).done(function(data){
				
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
  	 function calcRoute(){
   	  // clear out all the previous things. 
   	  for(i=0;i< markerArray.length;i++){
   		  markerArray[i].setMap(null);
   	  }
   	  
   	  var start = document.getElementById('start').value;
   	  var end = document.getElementById('end').value;
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
 //   			  var warnings = document.getElementById('warnings_panel');
 //  			  warnings.innerHTML = '<b>'+response.routes[0].warnings + '</b>';
   			  console.log(response);
   			  directionsDisplay.setDirections(response);
   			  showSteps(response);
   		  }
   	  });
   	  
   	  document.getElementById("directionsPanel").style.display="block";
   	  document.getElementById("map-canvas").style.width="70%";
     }
     
     function showSteps(directionResults){
   	  myRoute = directionResults.routes[0].legs[0];
   	  directionResult = directionResults;
   	  for(var i=1; i < myRoute.steps.length;i++){
   		  var marker = new google.maps.Marker({
   			  position : myRoute.steps[i].start_location,
   			  map:map
   		  });
   		  attachInstructionText(marker,myRoute.steps[i].instructions);
   		  markerArray[i] = marker;
   	  }
     }
     
     function starttrip(){
   	  var overview_path = directionResult.routes[0];
   	  var distance = directionResult.routes[0].legs[0].distance.value;
   	  var duration = directionResult.routes[0].legs[0].duration.value;
   	  var image = {
   			    url: '../images/ferrari.png',
   			    // This marker is 20 pixels wide by 32 pixels tall.
   			    size: new google.maps.Size(32, 32),
   			  };
   	  
   	  var marker = new google.maps.Marker({
   		  position : myRoute.steps[0].start_location,
   		  map:map,
   		  icon: {
   		      path: google.maps.SymbolPath.CIRCLE,
   		      scale: 10
   		    }
   	  });
   	  
   	//  var time = calcTime(distance,duration,overview_path.overview_path.length);
   	  for(var i=0;i<overview_path.overview_path.length;i++){
   		 (function(i){
   			 var ltn = new google.maps.LatLng(overview_path.overview_path[i].k, overview_path.overview_path[i].A);
   			 setTimeout(function(){ 
   			 marker.setPosition(ltn);	 
   			 map.setCenter(ltn);
   			 map.setZoom(20);
   		//	alert(overview_path.overview_path[i].k +'   ' + overview_path.overview_path[i].A);
				},i*2500);
   		 })(i);
   		 
   	  }
   //	  alert(overview_path.overview_path.length);
     }
     
     function calcTime(distance,duration,numberOfSteps){
   	  
   	  var avg = (duration/numberOfSteps)*100;
   	  return avg;
     }
     
     function attachInstructionText(marker, text) {
   	  google.maps.event.addListener(marker, 'click', function() {
   	    stepDisplay.setContent(text);
   	    stepDisplay.open(map, marker);
   	  });
   	}
     
     function findRoutes(){
   	  var str = document.getElementById('routeArray').value;
   	  var res = str.split(' ');
   	  //alert(res[0]);
   	  var lat = [];
   	  var lng = [];
   	  if((res.length%2)!=0){
   		alert('Please enter latitudes and longitudes');
   	  }
   	  else{
   		  for(i=0,j=0,k=0;i<res.length;i++)
   			  {
   				  if(i%2==0){
   					  lat[j] = res[i];
   					  j++
   				  }
   				  else{
   					  lng[k] = res[i];
   					  k++
   				  }
   			  }
   		  for(k=0;k<lat.length;k++){
   			  if(k==0 || k==lat.length-1){
       			  var marker = new google.maps.Marker({
       	    		  position : new google.maps.LatLng(lat[k], lng[k]),
       	    		  map:map,
       	    		  icon: {
       	    		      path: google.maps.SymbolPath.CIRCLE,
       	    		      scale: 10
       	    		    }
       	    	  });
     				map.fitBounds(new google.maps.LatLng(lat[k], lng[k]));

   			  }
   			  else{
       			  var marker = new google.maps.Marker({
       	    		  position : new google.maps.LatLng(lat[k], lng[k]),
       	    		  map:map
       	    	  });

   			  }

   		  }
   		  map.setZoom(13);
   		 // map.setCenter(new google.maps.LatLng(lat[lat.length/2], lng[lat.length/2]));
   	  }
   	  //alert(str);
   	  
     }
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
	<!-- 			<div id="directionsPanel" style=""></div> -->
			</div>
			<div id="panel">
			    <b>Start: </b>
				    <select id="start" >
				      <option value="Golden Gate National Recreation Area California 94941">Golden Gate National Recreation Area</option>
				      <option value="Marrakech Magic Theater 419 O'Farrell St San Francisco, CA 94102">Marrakech Magic Theater</option>
				      <option value="Golden Gate Bridge San Francisco, CA 94129">Golden Gate Bridge</option>
				      <option value="Alcatraz Island San Francisco, CA 94133">Alcatraz</option>
				      <option value="AT&T Park 24 Willie Mays Plaza San Francisco, CA 94107">AT&T Park</option>
				      <option value="San Francisco Bay California">San Francisco Bay</option>
				      <option value="Beach Blanket Babylon 678 Green St San Francisco, CA 94133">Beach Blanket</option>		      		      
				    </select>
				    <b>End: </b>
				    <select id="end" onchange="calcRoute();">
				      <option value="Golden Gate National Recreation Area Marin County CA 94965">Golden Gate National Recreation Area</option>
				      <option value="San Francisco Magic Show Beach St San Francisco, CA 94133">San Francisco Magic Show</option>
				      <option value="Palace of Fine Arts Theatre 3301 Lyon St San Francisco, CA 94123">Palace of Fine Arts</option>
				      <option value="Twin Peaks 501 Twin Peaks Boulevard San Francisco, CA 94114">Twin Peaks</option>
				      <option value=" Golden Gate Park San Francisco, CA">Golden Gate Park</option>
				      <option value="The Walt Disney Family Museum 104 Montgomery St San Francisco, CA 94129">The Walt Disney Family</option>
		   		      <option value="Legion of Honor 100 34th Ave San Francisco, CA 94121">Legion of Honor</option>
		   		      <option value="San Francisco Opera 301 Van Ness Ave San Francisco, CA 94102">San Francisco Opera</option>
				      
				    </select>
		    		<input type="button" value="start trip" name="starttrip" onclick="starttrip()"/>
		    		<input type="button" value="pause trip" name="pausetrip"/>
		    		<input type="button" value="end trip" name="endtrip"/>
		   			<input type="button" value="start trip" name="starttrip" onclick="findRoutes()"/>
		    </div>
			<div id="map-canvas" />
		</div>
	</div>
	<s:include value="../includes/footer.jsp"></s:include>
</s:if>
<s:else>
	<jsp:forward page="login.jsp" />
</s:else>
