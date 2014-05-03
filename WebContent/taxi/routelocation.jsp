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
        	$.getJSON('AllLocationsForRouteActionJson.action?tRouteId=<s:property value="#trId"/>',function(data){

        		var route = data.route;
    			var flightPlanCoordinates = new Array() ;
    			var latlngbounds = new google.maps.LatLngBounds();

				for(var j=0;j<route.location.length;j++){
						locationlist = route.location;
						flightPlanCoordinates.push(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude)); 
						latlngbounds.extend(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude));

						if(j == 0)
						{
							source = new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude);
						}
						if(j == route.location.length-1)
						{
							destination = new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude);
						}
	
		//	  	    addMarker(new google.maps.LatLng(locationlist[j].latitude, locationlist[j].longitude),locationlist[j].latitude+' '+locationlist[j].longitude+' '+locationlist[j].date);
					}
				map.fitBounds(latlngbounds);
                var flightPath = new google.maps.Polyline({
                    path: flightPlanCoordinates,
                    geodesic: true,
                    strokeColor: '#FF0000', //+ ('000000' + (Math.random()*0xFFFFFF<<0).toString(16)).slice(-6),
                    strokeOpacity: 1.0,
                    strokeWeight: 2
                  });
                  flightPath.setMap(map);

   	      	  // creating the directionsRequest object
   	      	  var request = {
   	  			  origin:source,
   	  			  destination:destination,
   	  			  travelMode:google.maps.TravelMode.DRIVING,
   	  			  provideRouteAlternatives : true,
   	  			  durationInTraffic:false
   	      	  };
  		/*  	      	  
   	      	  directionsService.route(request,function(response,status){
   	      		  if(status == google.maps.DirectionsStatus.OK){
   	      			  console.log(response);
   	      		//	  alert(response.routes.length);
   	      		//	  alert(route.location.length);
   	      			  var difference = new Array(response.routes.length);
   	      			  for(var i=0 ;i<response.routes.length;i++){
   	      				  
   	      				  var tempArray = new Array(route.location.length);
   	      			      for(var arrlen = 0; arrlen < tempArray.length; arrlen++)
		   	      		    {
   	      			   			tempArray[arrlen] = new Array(2);
		   	      		    }
   	      				  var interval = Math.round(response.routes[i].overview_path.length/route.location.length);
   	      				  difference[i] = 0 ;
   	      				  for(var k=0;k<route.location.length;k++){
	      					  var index = setIndex(k*interval,response.routes[i].overview_path.length);
   	      				//	  alert(index);
   	      					
   	      					  tempArray[k][0] = response.routes[i].overview_path[index]['k'];
	  						  tempArray[k][1] = response.routes[i].overview_path[index]['A'];
	     					  difference[i] = difference[i]+ (tempArray[k][0]-route.location[k].latitude);
   	      				//	  console.log(k+' '+tempArray[k][0]+' '+route.location[k].latitude+' '+'Latitude Difference is '+(tempArray[k][0]-route.location[k].latitude));
   	      				  }
   	      				  console.log("difference is " + difference[i]);
   	      			  }
   	      			  var magnitude =0;
   	      			  var index = 0;
   	      			  for(var i=0 ;i<response.routes.length;i++){
   	      				  if(magnitude == 0){
   	      					  magnitude = Math.abs(difference[i]);
   	      					  index = i;
   	      				  }
   	      				  else{
   	      					  if(magnitude > Math.abs(difference[i])){
   	      						  magnitude = Math.abs(difference[i]);
   	      						  index = i;
   	      					  }
   	      				  }
   	      			  }
   	      			  directionsDisplay.setDirections(response);
	      			  directionsDisplay.setRouteIndex(index);
   	      		  }
   	      	  }); */
   					
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
              	<s:url id="url" action="AllLocationsForTaxiAction" >
			      <s:param name="tUserId"><s:property value="#tId"/></s:param>
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
