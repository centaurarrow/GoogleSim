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
	width: 100%;
	position : absolute;
	margin-left:-160px;
	margin-right :-300px;
}
#panel, #panel2 {
	padding:5px;
	margin:5px;
}
</style>
	<script type="text/javascript"
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8yIIQagPjfQkOJ9a4XE14z6g4EZ62dNY&sensor=true">
    </script>
	<script type="text/javascript">
	  //gloabal objects 
	  var cenLat , cenLong;
	  var locationlist;
      var map;
      var markers= [];
      var cnt=0;;
      var json = {};
      var directionsDisplay;
      var directionsService = new google.maps.DirectionsService();
      var markerArray = []; 
      var latLonJson = []; //  JSON Object that is sent to the user 
	  var flightPath = new google.maps.Polyline({
		    strokeColor: '#FF0000',
		    strokeOpacity: 1.0,
		    strokeWeight: 2
		  });
;
	  var flightPathArray = [];
      //Setting the index ??
      var setIndex = function(ind,max){
				  if(ind < max){
					  return ind;
				  } else{
					 return setIndex(ind-1,max);
				  }
			  };

      //Initialize the Google Maps Object and load the map
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
    	
    	// Get All routes with Start And End Location 
    	setTimeout(function() {
    	      // Do something after 5 seconds
        	$.ajax('startAndEndLocationsofRoutesForAUser.action', 
        			{
        				type: "post",
        				data : {
			        		tUserId : '<s:property value="#tId"/>',
			        		trId : '<s:property value="#trId"/>',
			        	}
        	}).done(function(data){
        		var routeList = data.taxiUserWithStartEnd.routeList;
				var sel = $('<select>').appendTo('#span1');
				sel.attr("id","routeselect");
	       		for(var i=0;i<routeList.length;i++){
        			var locationlist = routeList[i];
					var val = '('+locationlist.startlat +','+ locationlist.startlon +') to ('+locationlist.endlat +','+ locationlist.endlon +')';
					var text = 'route-'+locationlist.routeid ;
 				    sel.append($("<option>").attr('value',val).text(text));
	        	}
                document.getElementById("panel").style.display='block';
   		   	});
      	 },200); 
 /*	  	setTimeout(function() {
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
                document.getElementById("panel").style.display='block';
   		   	});
      	 },200); */
      }
     
      //create an event to load 
     google.maps.event.addDomListener(window,'load',initialize);

      // Send the Global data LatLon Object to the server and get the predicted routes for current given route
      function deployRoutePredict(){
   	      // Do something after 5 seconds
        	$.ajax('SimilarRoutesForCurrentRoute.action', 
        			{
        				type: "post",
        				data : {
			        		tUserId : '<s:property value="#tId"/>',
			        		trId : '<s:property value="#trId"/>',
			        		LatLng : JSON.stringify(latLonJson)
			        	}
        	}).done(function(data){
        		var routeList = data.taxiUser.routeList;
        		for(var i=0;i<routeList.length;i++){
        			var route = routeList[i];
        			var flightPlanCoordinates = new Array() ;
        			//flightPath.setMap(null);
					for(var j=0;j<route.location.length;j++){
							locationlist = route.location;
							flightPlanCoordinates.push(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude)); 
						}
                    flightPath = new google.maps.Polyline({
                        path: flightPlanCoordinates,
                        geodesic: true,
                     //   strokeColor: '#'+ ('000000' + (Math.random()*0xFFFFFF<<0).toString(16)).slice(-6),
                        strokeColor : "#FF0000" ,
                        strokeOpacity: 1.0,
                        strokeWeight: 2
                      });
                    flightPath.setMap(map);
                    flightPathArray.push(flightPath);
        		}
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
      
   // Calculates Route distance for given markeyArray 
      function calcRouteForRoutes(element){
    	  // clear out all the previous things. 
 	   	  for(var i=0;i< markerArray.length;i++){
 	   		  markerArray[i].setMap(null);
 	   	  }
 	   	  var strparts = $("#routeselect").val().split("to");
 	   	  var val = $("#routeselect").val();
 	   	  var routeID = $("#routeselect option:selected").text().split("-")[1];

 	   	  var start = strparts[0] ;
 	   	  var end = strparts[1] ;

 	   	  // draw the route by gettin the route locations 
 	   	  setTimeout(function() {
    	      // Do something after 5 seconds
        	$.getJSON('AllLocationsForRouteActionJson.action?tRouteId='+routeID,function(data){

        		var route = data.route;
    			var flightPlanCoordinates = new Array() ;

    			for(var j=0;j<route.location.length;j++){
						locationlist = route.location;
						flightPlanCoordinates.push(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude)); 
					}
                var flightPath = new google.maps.Polyline({
                    path: flightPlanCoordinates,
                    geodesic: true,
                    strokeColor: 'blue', //+ ('000000' + (Math.random()*0xFFFFFF<<0).toString(16)).slice(-6),
                    strokeOpacity: 1.0,
                    strokeWeight: 4
                  });
                  flightPath.setMap(map);
   		   	}, 200);
       	
      	 });
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
 	 //   		  var warnings = document.getElementById('warnings_panel');
 	 //  		  warnings.innerHTML = '<b>'+response.routes[0].warnings + '</b>';
 	   			  console.log(response);
 	   			  directionsDisplay.setDirections(response);
 	   			  showSteps(response);
 	   		  }
 	   	  });
 	   	  document.getElementById("directionsPanel").style.display="block";
 	   	  document.getElementById("map-canvas").style.width="70%";
      }
     
     // Calculates Route distance for given markeyArray 
     function calcRoute(){
   	  // clear out all the previous things. 
	   	  for(var i=0;i< markerArray.length;i++){
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
	 //   		  var warnings = document.getElementById('warnings_panel');
	 //  		  warnings.innerHTML = '<b>'+response.routes[0].warnings + '</b>';
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
   		  markerArray.push(marker);
   	  }
     }
     
     // This function is called while the user clicks the start trip button
     function starttrip(){
   	  var overview_path = directionResult.routes[0];
   	  var distance = directionResult.routes[0].legs[0].distance.value;
   	  var duration = directionResult.routes[0].legs[0].duration.value;
   	  
   	  // Set the car image
   	  var image = {
   			    url: '../images/ferrari.png',
   			    // This marker is 20 pixels wide by 32 pixels tall.
   			    size: new google.maps.Size(32, 32),
   			  };
   	  
   	  // Create the Vehicle Marker 
   	  var marker = new google.maps.Marker({
   		  position : myRoute.steps[0].start_location,
   		  map:map,
   		  icon: {
   		      path: google.maps.SymbolPath.CIRCLE,
   		      scale: 10
   		    }
   	  });
   	  
   	// var time = calcTime(distance,duration,overview_path.overview_path.length);

		for (var i = 0; i < overview_path.overview_path.length; i++) {
				(function(i) {
					var ltn = new google.maps.LatLng(
							overview_path.overview_path[i].k,
							overview_path.overview_path[i].A);
					// add the points into the global Latitude Longitude Array 

					setTimeout(function() {
						var item = {
								'lat' : overview_path.overview_path[i].k,
								'lon' : overview_path.overview_path[i].A
							};
						latLonJson.push(item); 
						// always send the last ten 
						if(latLonJson.length >15 ){
							 latLonJson.splice(0,1);
						}
						marker.setPosition(ltn);
						map.setCenter(ltn);
						map.setZoom(15);
						// clean old markers 
						 for (var j = 0; j < flightPathArray.length; j++ ) {
			    			  flightPathArray[j].setMap(null);
			    		  }
			    		  flightPathArray.length = 0;
						 // get the predicted routes at this point
						 if(latLonJson.length>=5)
						 	deployRoutePredict();
						//	alert(overview_path.overview_path[i].k +'   ' + overview_path.overview_path[i].A);
					}, i * 2500);
				})(i);
			}
			//	  alert(overview_path.overview_path.length);
		}

		function calcTime(distance, duration, numberOfSteps) {

			var avg = (duration / numberOfSteps) * 100;
			return avg;
		}

		function attachInstructionText(marker, text) {
			google.maps.event.addListener(marker, 'click', function() {
				stepDisplay.setContent(text);
				stepDisplay.open(map, marker);
			});
		}

		function findRoutes() {
			var str = document.getElementById('routeArray').value;
			var res = str.split(' ');
			//alert(res[0]);
			var lat = [];
			var lng = [];
			if ((res.length % 2) != 0) {
				alert('Please enter latitudes and longitudes');
			} else {
				for (i = 0, j = 0, k = 0; i < res.length; i++) {
					if (i % 2 == 0) {
						lat[j] = res[i];
						j++
					} else {
						lng[k] = res[i];
						k++
					}
				}
				for (k = 0; k < lat.length; k++) {
					if (k == 0 || k == lat.length - 1) {
						var marker = new google.maps.Marker({
							position : new google.maps.LatLng(lat[k], lng[k]),
							map : map,
							icon : {
								path : google.maps.SymbolPath.CIRCLE,
								scale : 10
							}
						});
						map.fitBounds(new google.maps.LatLng(lat[k], lng[k]));
					}

					else {
						var marker = new google.maps.Marker({
							position : new google.maps.LatLng(lat[k], lng[k]),
							map : map
						});

					}

				}
				map.setZoom(13);
				// map.setCenter(new google.maps.LatLng(lat[lat.length/2], lng[lat.length/2]));
			}
			// alert(str);
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
			<div id="panel2">
				Please select the route for the give user
				<span id="span1">
	    		</span>
				<input type="button" value="show directions" name="starttrip" onclick="calcRouteForRoutes(this)"/>
	    		<input type="button" value="start trip" name="starttrip" onclick="starttrip()"/>

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
				      <option value="Golden Gate National Recreation Area Marin County CA 94965">Golden Gate National Recreation Area</option>
				      <option value="San Francisco Magic Show Beach St San Francisco, CA 94133">San Francisco Magic Show</option>
				      <option value="Palace of Fine Arts Theatre 3301 Lyon St San Francisco, CA 94123">Palace of Fine Arts</option>
				      <option value="Twin Peaks 501 Twin Peaks Boulevard San Francisco, CA 94114">Twin Peaks</option>
				      <option value=" Golden Gate Park San Francisco, CA">Golden Gate Park</option>
				      <option value="The Walt Disney Family Museum 104 Montgomery St San Francisco, CA 94129">The Walt Disney Family</option>
		   		      <option value="Legion of Honor 100 34th Ave San Francisco, CA 94121">Legion of Honor</option>
		   		      <option value="San Francisco Opera 301 Van Ness Ave San Francisco, CA 94102">San Francisco Opera</option>
		   		      <option value="San Francisco International Airport San Francisco, CA 94128">San Francisco Airport</option>
   		   		      <option value="The exploratorium">The exploratorium</option>
  		   		      <option value="San Francisco Symphony">San Francisco Symphony</option>
  		   		      <option value="San francisco ballet ">San francisco ballet</option>
  		   		      <option value="angel island park ">San Francisco Airport</option>
   		   		      <option value="Musee Mecanique">Musee Mecanique</option>
   		   		      <option value="Calbe car Museum">Calbe car Museum</option>
  		   		      <option value="Grace Cathedral">Grace Cathedral</option>
  		   		      <option value="SF Jazz Center">SF Jazz Center</option> 
  		   		       <option value="Glide Memorial United Methodist Chruch">Glide Memorial United Methodist Chruch</option>
		   		      
		   		      <option value="37.7925,-122.393">Other Route</option>
		   		      
				      	   		      
				    </select>
				    <b>End: </b>
				    <select id="end" onchange="calcRoute();">
				      <option value="Golden Gate National Recreation Area California 94941">Golden Gate National Recreation Area</option>
				      <option value="Marrakech Magic Theater 419 O'Farrell St San Francisco, CA 94102">Marrakech Magic Theater</option>
				      <option value="Golden Gate Bridge San Francisco, CA 94129">Golden Gate Bridge</option>
				      <option value="Alcatraz Island San Francisco, CA 94133">Alcatraz</option>
				      <option value="AT&T Park 24 Willie Mays Plaza San Francisco, CA 94107">AT&T Park</option>
				      <option value="San Francisco Bay California">San Francisco Bay</option>
				      <option value="Beach Blanket Babylon 678 Green St San Francisco, CA 94133">Beach Blanket</option>					    
				      <option value="Golden Gate National Recreation Area Marin County CA 94965">Golden Gate National Recreation Area</option>
				      <option value="San Francisco Magic Show Beach St San Francisco, CA 94133">San Francisco Magic Show</option>
				      <option value="Palace of Fine Arts Theatre 3301 Lyon St San Francisco, CA 94123">Palace of Fine Arts</option>
				      <option value="Twin Peaks 501 Twin Peaks Boulevard San Francisco, CA 94114">Twin Peaks</option>
				      <option value=" Golden Gate Park San Francisco, CA">Golden Gate Park</option>
				      <option value="The Walt Disney Family Museum 104 Montgomery St San Francisco, CA 94129">The Walt Disney Family</option>
		   		      <option value="Legion of Honor 100 34th Ave San Francisco, CA 94121">Legion of Honor</option>
		   		      <option value="San Francisco Opera 301 Van Ness Ave San Francisco, CA 94102">San Francisco Opera</option>
		   		      <option value="San Francisco International Airport San Francisco, CA 94128">San Francisco Airport</option>
   		   		      <option value="The exploratorium">The exploratorium</option>
  		   		      <option value="San Francisco Symphony">San Francisco Symphony</option>
  		   		      <option value="San francisco ballet ">San francisco ballet</option>
  		   		      <option value="angel island park ">San Francisco Airport</option>
   		   		      <option value="Musee Mecanique">Musee Mecanique</option>
   		   		      <option value="Calbe car Museum">Calbe car Museum</option>
  		   		      <option value="Grace Cathedral">Grace Cathedral</option>
  		   		      <option value="SF Jazz Center">SF Jazz Center</option> 
  		   		       <option value="Glide Memorial United Methodist Chruch">Glide Memorial United Methodist Chruch</option>
		   		      <option value="37.6173,-122.385">Other Route2</option>
				    </select>
		    		<input type="button" value="start trip" name="starttrip" onclick="starttrip()"/>
		    		<input type="button" value="pause trip" name="pausetrip"/>
		    		<input type="button" value="end trip" name="endtrip"/>
		   			<input type="button" value="start trip" name="starttrip" onclick="findRoutes()"/>
		    </div>
			<div id="map-canvas" style="background-color:white;padding:5px;float:left;width:70%; height:100%">
			</div>
		<!-- <div id="directionsPanel" style="background-color:white;float:right;width:35%;height:100%;margin-right:-120px">
			</div> -->
		</div>
	</div>
	<s:include value="../includes/footer.jsp"></s:include>
</s:if>
<s:else>
	<jsp:forward page="login.jsp" />
</s:else>
