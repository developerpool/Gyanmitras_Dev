/*
   CREATED BY   : Vinish
   CREATED DATE : 2020-06-01 11:15 AM 
   PURPOSE      : GOOGLE APIs
*/

/* Global Variable */
var _mapOptions;
var _map;
var _marker;
var _markerArray = [];
var _infowindow;
var _content;
var _InfoboxContent = [];
var _counter = 0;
var _SetInterval;
var _bPlay;
var _bPause;
var _vehPath;
var _RoutePath;
var trHTML = ''
var loc;
var bounds = new google.maps.LatLngBounds();
var chkZoom = false;
var chkZommChange = false;
var lastzoom = 0;
var _zoomDefault = [6, 12, 13, 14, 16, 17, 18, 49, 21, 9, 19, 22]
var markerCluster;

var trafficLayer;

/**
 * The CenterControl adds a control to the map that recenters the map on
 * Chicago.
 * @constructor
 * @param {!Element} controlDiv
 * @param {!google.maps.Map} map
 * @param {?google.maps.LatLng} center
 */
function CenterControl(controlDiv, map, center) {
    // We set up a variable for this since we're adding event listeners
    // later.
    var control = this;

    // Set the center property upon construction
    control.center_ = center;
    controlDiv.style.clear = 'both';

    // Set CSS for the control border
    var goCenterUI = document.createElement('div');
    goCenterUI.id = 'goCenterUI';
    //goCenterUI.title = 'Click to recenter the map';
    controlDiv.appendChild(goCenterUI);

    // Set CSS for the control interior
    var goCenterText = document.createElement('img');
    goCenterText.id = 'goCenterText';
    goCenterText.src = '/Images/Traffic.png';
    goCenterText.innerHTML = 'Center Map';
    goCenterUI.appendChild(goCenterText);

    // Set CSS for the setCenter control border
    var setCenterUI = document.createElement('div');
    setCenterUI.id = 'setCenterUI';
    setCenterUI.style.display = "none";
    //setCenterUI.title = 'Click to change the center of the map';
    controlDiv.appendChild(setCenterUI);

    // Set CSS for the control interior
    var setCenterText = document.createElement('div');
    setCenterText.id = 'setCenterText';
    setCenterText.innerHTML = 'Set Center';
    setCenterText.style.display = "none";
    setCenterUI.appendChild(setCenterText);

    // Set up the click event listener for 'Center Map': Set the center of
    // the map
    // to the current center of the control.
    goCenterUI.addEventListener('click', function () {
        //var currentCenter = control.getCenter();
        //map.setCenter(currentCenter);
        toggleTraffic();
    });

    // Set up the click event listener for 'Set Center': Set the center of
    // the control to the current center of the map.
    setCenterUI.addEventListener('click', function () {
        //var newCenter = map.getCenter();
        //control.setCenter(newCenter);
    });
}

/**
 * Define a property to hold the center state.
 * @private
 */
CenterControl.prototype.center_ = null;

/**
 * Gets the map center.
 * @return {?google.maps.LatLng}
 */
CenterControl.prototype.getCenter = function () {
    return this.center_;
};

/**
 * Sets the map center.
 * @param {?google.maps.LatLng} center
 */
CenterControl.prototype.setCenter = function (center) {
    this.center_ = center;
};

/*CREATED BY: Vinish - Function to load blank map*/
function initMap(MapControlID, Zoom, CenterLat, CenterLng) {

    try{
        _mapOptions = {
            zoom: parseInt(Zoom),
            center: { lat: CenterLat, lng: CenterLng },
            disableDefaultUI: false,
            draggable: true,
            scrollwheel: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }


        _map = new google.maps.Map(document.getElementById(MapControlID), _mapOptions);


        trafficLayer = new google.maps.TrafficLayer();
        //google.maps.event.addDomListener(document.getElementById('goCenterUI'), 'click', toggleTraffic);




        // Create the DIV to hold the control and call the CenterControl()
        // constructor
        // passing in this DIV.
        var centerControlDiv = document.createElement('div');
        var centerControl = new CenterControl(centerControlDiv, _map, { lat: CenterLat, lng: CenterLng });

        centerControlDiv.index = 1;
        centerControlDiv.style['padding'] = '10px 10px 0 0';
        _map.controls[google.maps.ControlPosition.RIGHT_TOP].push(centerControlDiv);


        google.maps.event.addListenerOnce(_map, 'idle', function () {
            google.maps.event.trigger(_map, 'resize');
        });

        google.maps.event.addListener(_map, 'zoom_changed', function () {
            if ((chkZommChange == true && (_zoomDefault.indexOf(_map.zoom) != -1))) {
                if (lastzoom == 0) {
                    chkZoom = false;
                }
                else {
                    chkZoom = true;
                }
            }
            else {
                chkZoom = true;
            }
        })
    }
    catch (Error) { }
   
}



/*CREATED BY: Vinish - Function to load blank map*/
function initMap1232(MapControlID, Zoom, CenterLat, CenterLng) {

    try {
        _mapOptions = {
            zoom: parseInt(Zoom),
            center: { lat: CenterLat, lng: CenterLng },
            disableDefaultUI: false,
            draggable: true,
            scrollwheel: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }

        _map = new google.maps.Map(document.getElementById(MapControlID), _mapOptions);
        trafficLayer = new google.maps.TrafficLayer();
        google.maps.event.addDomListener(document.getElementById('trafficToggle'), 'click', toggleTraffic);


        _map = new google.maps.Map(document.getElementById(MapControlID),
             _mapOptions);
        google.maps.event.addListenerOnce(_map, 'idle', function () {
            google.maps.event.trigger(_map, 'resize');
        });

        google.maps.event.addListener(_map, 'zoom_changed', function () {
            if ((chkZommChange == true && (_zoomDefault.indexOf(_map.zoom) != -1))) {
                if (lastzoom == 0) {
                    chkZoom = false;
                }
                else {
                    chkZoom = true;
                }
            }
            else {
                chkZoom = true;
            }
        })


    } catch (Error) { }
}

function toggleTraffic() {
    if (trafficLayer.getMap() == null) {
        //traffic layer is disabled.. enable it
        trafficLayer.setMap(_map);
    } else {
        //traffic layer is enabled.. disable it
        trafficLayer.setMap(null);
    }


}


/*CREATED BY: Vinish - Function to load WithMovingDirection*/
function DrawMarkerWithMovingDirection(MapControlID, Zoom, CenterLat, CenterLng, InfoboxContent) {
    try {

        var iVar = 0;
        if (_markerArray.length > 0) {
            markerCluster.removeMarkers(_markerArray);
        }

        ClearMap();

        if (InfoboxContent.length != 0) {
            for (var i = 0; i <= InfoboxContent.length - 1; i++) {
                CreateMarkerWithInfoBoxWithDirection(InfoboxContent[i])
                loc = new google.maps.LatLng(InfoboxContent[i].Lat, InfoboxContent[i].Long);
                bounds.extend(loc)
            }

            markerCluster = new MarkerClusterer(_map, _markerArray, { imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m' });

            chkZommChange = false;
            if (chkZoom == false) {
                chkZommChange = true;
                lastzoom = _map.zoom;
                _map.fitBounds(bounds);
                //_map.panToBounds(bounds);
            }
            else {
                chkZommChange = false;
                lastzoom = 0;
                _map.fitBounds(bounds);
            }

        } else {
            // alert("Marker list not pass !");
        }
    } catch (Error) {
        // alert("Problem in Draw Marker :" + Error.message);
    }
}


/*Create Marker With InfoBox With Direction*/ //USED
function CreateMarkerWithInfoBoxWithDirection(InfoboxContent, bOpenNewInfoBox, bClosePreviousInfoBox) {

    //added new
    var latLng = new google.maps.LatLng(49.47805, -123.84716);
    var homeLatLng = new google.maps.LatLng(49.47805, -123.84716);

    var pictureLabel = document.createElement("img");
    pictureLabel.src = "home.jpg";

    var _marker = new MarkerWithLabel({
        position: new google.maps.LatLng(InfoboxContent.Lat, InfoboxContent.Long),
        map: _map,
        draggable: false,
        raiseOnDrag: false,
        labelContent: InfoboxContent.RegistrationNo,
        labelInBackground: true,
        labelAnchor: new google.maps.Point(-18, 52),
        labelClass: "labels",
        //labelStyle: { opacity: 0.75 }
    });

    _marker.setIcon('/Images/' + InfoboxContent.Icon);

    if (_infowindow && (bClosePreviousInfoBox == "1" || bClosePreviousInfoBox == "")) {
        _infowindow.close();
    }
    var livetrack = "display:none;";

    if (InfoboxContent.Status == 'P') {
        livetrack = "display:inline-block;"
    }
    else {
        livetrack = "display:inline-block;"
    }



    _infowindow = new google.maps.InfoWindow();

    var HeaderValue = InfoboxContent.RegistrationNo + "</br>" + InfoboxContent.CustomerName;

    _content = "<div class='titleHeader'>" + HeaderValue + "</div><div class='popup'>"
    + "<table class='info-table' style='width:250px;' width='100%'><tr align='left'><td width='110px' align='left'><b>Driver Name</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.DriverName + "</td></tr><tr><td  align='left'><b>Driver Mob</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.DriverMobileNo + "</td> </tr><tr><td  align='left'><b>Last GPS Update</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.DeviceDateTime + "</td> </tr><tr><td align='left'><b>Speed</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.Speed + "&nbsp;&nbsp;Km/Hr</td> </tr><tr><td align='left'><b>Device No.</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.DeviceNo + "</td> </tr><tr><td align='left'><b>IMEI No.</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.IMEINo + "</td> </tr><tr><td align='left'><b>Sim No.</b></td><td><b>:</b></td><td align='left'>"
     + InfoboxContent.SIMNo
     + "</td></tr>"
     + '<tr><td align="left"></td><td></td><td align="left">'
     //+ '<tr><td align="left"></td><td align="left"><a style=' + livetrack + '  href=javascript:void(0);" onclick="SendLiveTracking(' + InfoboxContent.FK_VehicleId + ',' + InfoboxContent.AccountId + ',' + InfoboxContent.FK_CustomerId + ');">Live Tracking</a>'
     + "</td></tr> </table></div>";

    google.maps.event.addListener(_marker, 'click', (function (_marker, _content) {
        return function () {
            _infowindow.setContent(_content);
            _infowindow.open(_map, _marker);
        }
    })(_marker, _content));

    if (bOpenNewInfoBox == "1") {
        _infowindow.setContent(_content);
        _infowindow.open(_map, _marker);
    }
    _markerArray.push(_marker);
}

/*Function to load WithMovingDirection*/
function CreateMarkerWithInfoBox(InfoboxContent, bOpenNewInfoBox, bClosePreviousInfoBox) {

    // var img='http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld='+A|FF0000|000000'

    _marker = new google.maps.Marker({
        map: _map,
        icon: '/App_Images/' + InfoboxContent.icon,

        position: new google.maps.LatLng(InfoboxContent.latitude, InfoboxContent.longitude)
    });


    if (_infowindow && (bClosePreviousInfoBox == "1" || bClosePreviousInfoBox == "")) {
        _infowindow.close();
    }
    var livetrack = "display:none;";
    //if (InfoboxContent.Status == 'P') {
    //    livetrack = "display:inline-block;"
    //}
    _infowindow = new google.maps.InfoWindow();

    _content = "<div class='titleHeader'></div><div class='popup'><table class='info-table' width='100%'><tr align='left'><td colspan='2'><b>"
    + InfoboxContent.registrationNo + "</b></td><td><b>"
    + "" + "</b></td></tr><tr nowrap><td width='90px' align='left'><b>Driver Name:</b></td><td align='left'>"
    + InfoboxContent.chauffeurName + "</td></tr><tr><td  align='left'><b>Driver Mob:</b></td><td align='left'>"
    + InfoboxContent.chauffeurMobileNo + "</td> </tr><tr><td  align='left'><b>Recorded :</b></td><td align='left'>"
    + InfoboxContent.receivedTime + "</td> </tr><tr><td align='left'><b>Speed :</b></td><td align='left'>"
      + InfoboxContent.speed + " Km/Hr</td> </tr><tr><td align='left'><b>Device No. :</b></td><td align='left'>"

    //    + InfoboxContent.deviceNo + "</td></tr>" //<tr><td align='left'><b>IMEI No. :</b></td><td align='left'>"
    //    //+ InfoboxContent.IMEINo + "</td> </tr><tr><td align='left'><b>Sim No. :</b></td><td align='left'>"
    ////+ InfoboxContent.SIMNo
    ////+ "</td></tr>"

    //+ '<tr><td align="left"></td><td align="left"><a style=' + livetrack + '  href="#" onclick="SendLiveTracking(\'' + InfoboxContent.RegistrationNo + '\'' + ',' + InfoboxContent.FK_CompanyId + ');">Live Tracking</a>'
    //+ "</td></tr> 

    + "</table></div>";
    //  + "<tr><td align='left'></td><td align='left'><a href='#' onclick='SendLiveTracking(''+RegNo,CompId)'>Live Tracking</a>"
    google.maps.event.addListener(_marker, 'click', (function (_marker, _content) {
        return function () {
            _infowindow.setContent(_content);
            _infowindow.open(_map, _marker);
        }
    })(_marker, _content));

    if (bOpenNewInfoBox == "1") {
        _infowindow.setContent(_content);
        _infowindow.open(_map, _marker);
    }

    _markerArray.push(_marker);

}

function DrawTripMarker(MapControlID, Zoom, CenterLat, CenterLng, InfoboxContent) {
    try {

        var iVar = 0;
        ClearMap();

        if (InfoboxContent.length != 0) {
            for (var i = 0; i <= InfoboxContent.length - 1; i++) {
                CreateTripMarkerWithInfoBox(InfoboxContent[i])
                loc = new google.maps.LatLng(InfoboxContent[i].Lat, InfoboxContent[i].Long);
                bounds.extend(loc)

            }
            //chkZommChange = false;
            //   if (IsfitBounds != false) {
            //if (chkZoom == false) {
            //    chkZommChange = true;
            //    lastzoom = _map.zoom;
            _map.fitBounds(bounds);
            _map.panToBounds(bounds);
            //}
            //else {
            //    chkZommChange = false;
            //    lastzoom = 0;
            //}

        } else {
            // alert("Marker list not pass !");
        }
    } catch (Error) {
        // alert("Problem in Draw Marker :" + Error.message);
    }
}

function CreateTripMarkerWithInfoBoxforLiveTracking(InfoboxContent, bOpenNewInfoBox, bClosePreviousInfoBox, id) {

    _marker = new google.maps.Marker({
        map: _map,
        position: new google.maps.LatLng(InfoboxContent.Lat, InfoboxContent.Long)
    });
    //  _marker.id = InfoboxContent.length;
    var str = RotateIcon.makeIcon('/App_Images/' + InfoboxContent.Icon).setRotation({ deg: InfoboxContent.Heading }).getUrl();
    // alert(str);


    //By Vinish, Suggested by Deepak SIR, on 9June_14:40PM  :: Previously just below code block was implemented
    if (endsWith(str, "AD12TscoAAAAAElFTkSuQmCC")) {
        _marker.setIcon('/App_Images/' + InfoboxContent.Icon);
    }
    else {
        _marker.setIcon(RotateIcon.makeIcon('/App_Images/' + InfoboxContent.Icon).setRotation({ deg: InfoboxContent.Heading }).getUrl());
    }


    //Commented by Vinish, Suggested by Deepak SIR, on 9June_14:40PM
    //if (str.endsWith("AD12TscoAAAAAElFTkSuQmCC"))
    //    _marker.setIcon('../../App_Images/' + InfoboxContent.Icon);
    //else
    //    _marker.setIcon(RotateIcon.makeIcon('/App_Images/' + InfoboxContent.Icon).setRotation({ deg: InfoboxContent.Heading }).getUrl());





    if (_infowindow && (bClosePreviousInfoBox == "1" || bClosePreviousInfoBox == "")) {
        _infowindow.close();
    }
    var livetrack = "display:none;";
    if (InfoboxContent.Status == 'P') {
        livetrack = "display:inline-block;"
    }
    _infowindow = new google.maps.InfoWindow();

    _content =
        "<div class='titleHeader'></div><div class='popup' style='width:450px;'><table class='info-table' width='100%'><tr align='left'><td colspan='4'><b style='margin-bottom:5px;display:block;font-size:14px;color:#e90a0b'>" + InfoboxContent.Route_Name + "</b></td></tr><tr align='left'><td width='90px' align='left'><b>Vehicle No.:</b></td><td  colspan='3'><b>"
    + InfoboxContent.Registration_No + "</b></td></tr><tr nowrap><td width='90px' align='left'><b>Driver Name:</b></td><td align='left'>"
    + InfoboxContent.DriverName + "</td><td  align='left'><b>Driver Mob:</b></td><td align='left'>"
    + InfoboxContent.DriverMobileNo + "</td> </tr><tr><td  align='left'><b>Recorded :</b></td><td align='left'>"
    + InfoboxContent.DeviceDateTime + "</td>"//<tr><td align='left'><b>Device No. :</b></td><td align='left'>"
    + "<td align='left'><b>Trip No. :</b></td><td align='left'>"
    + InfoboxContent.Trip_No
    + "</td></tr><tr><td align='left'><b>ETD :</b></td><td align='left'>"
    + InfoboxContent.ETD
    + "</td><td align='left'><b>ETA :</b></td><td align='left'>"
    + InfoboxContent.ExpectedDtofArrival
    + "</td></tr><tr><td align='left'><b>RTA :</b></td><td align='left'>"
    + InfoboxContent.RTA
    + "</td><td align='left'><b>Travel Date :</b></td><td align='left'>"
    + InfoboxContent.Travel_Date
    + "</td></tr><tr><td align='left'><b>ATD :</b></td><td align='left'>"
    + InfoboxContent.ATD
    + "</td></tr>"//<tr><td align='left'><b>ATA:</b></td><td align='left'>"
    //+ InfoboxContent.ATA
    //+ "</td></tr>"
      + "</td></tr><tr><td align='left'><b>Alarm :</b></td><td colspan='3' align='left'>"
    + InfoboxContent.AlarmDesc
    + "</td></tr>"
    //comment by anjani
      + '<tr><td align="left"></td><td align="left"><a href="#" onclick="ShowTrafficOnMap(\'' + InfoboxContent.Trip_No + '\');">Live Traffic</a>'
    + "</td></tr>"
    + "</table></div>";
    google.maps.event.addListener(_marker, 'click', (function (_marker, _content) {
        return function () {
            _infowindow.setContent(_content);
            _infowindow.open(_map, _marker);
        }
    })(_marker, _content));

    if (bOpenNewInfoBox == "1") {
        _infowindow.setContent(_content);
        _infowindow.open(_map, _marker);
    }
    _map.setCenter(new google.maps.LatLng(InfoboxContent.Lat, InfoboxContent.Long));


    _markerArray.push(_marker);


}

function CreateRouteWithoutMarker(MapControlID, Zoom, CenterLat, CenterLng, InfoboxContent, PathColor, PathOpacity, PathWeight) {


    try {

        ClearRoute()

        var prelat;
        var prelong;
        var preISGSM = 'OFF'
        var j = 0;
        var k = 0;
        var goto = 0;
        if (InfoboxContent.length != 0) {
            for (var i = 0; i <= InfoboxContent.length - 1; i++) {
                PathColor = '#006fe6'
                if (i == 0 || i == InfoboxContent.length - 1) {
                    CreateMarkerWithInfoBoxLiveTracking(InfoboxContent[i])
                }
                if (i > 0) {
                    if (InfoboxContent[i].ISGSM == 'ON' && preISGSM == 'OFF') {
                        k = i - 1;
                        preISGSM = 'ON';
                        goto = 1;
                    }
                    else
                        if (InfoboxContent[i].ISGSM == 'ON' && preISGSM == 'ON') {
                            preISGSM = 'ON';
                            goto = 1;
                        }
                        else if (InfoboxContent[i].ISGSM == 'OFF' && preISGSM == 'ON') {
                            preISGSM = 'OFF';
                            goto = 0;

                        } else if (InfoboxContent[i].ISGSM == 'OFF' && preISGSM == 'OFF') {
                            k = 0;
                            preISGSM = 'OFF';
                            goto = 0;
                        }
                    if (InfoboxContent[i].icon == 'pin_yellow.png') {
                        PathColor = '#F3971E'
                    }
                    if (InfoboxContent[i].icon == 'pin_green.png') {
                        PathColor = '#65D873'
                    }
                    if (InfoboxContent[i].icon == 'pin_blue.png') {
                        PathColor = '#2191ED'
                    }
                    if (InfoboxContent[i].icon == 'pin_red.png') {
                        PathColor = '#EA0000'
                    }

                    if (goto < 1) {
                        if (k > 0) {
                            var _vehTrackCoordinates = [new google.maps.LatLng(InfoboxContent[i].latitude,
                                                InfoboxContent[i].longitude),
                                            new google.maps.LatLng(InfoboxContent[k].latitude,
                                                InfoboxContent[k].longitude)
                            ];

                        }
                            //else if (InfoboxContent[i].ISGSM == 'OFF') {
                        else {

                            var _vehTrackCoordinates = [new google.maps.LatLng(InfoboxContent[i].latitude,
                                                     InfoboxContent[i].longitude),
                                                 new google.maps.LatLng(InfoboxContent[i - 1].latitude,
                                                     InfoboxContent[i - 1].longitude)
                            ];
                        }

                        _RoutePath = new google.maps.Polyline({
                            path: _vehTrackCoordinates,
                            strokeColor: PathColor,//"#CC3300",
                            strokeOpacity: PathOpacity,//80,
                            strokeWeight: PathWeight,//2,
                            icons: [{

                                icon: {
                                    path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                                    scale: 2,
                                    //rotation: heading,
                                    strokeColor: PathColor,
                                    fillColor: PathColor,
                                    fillOpacity: 3
                                },
                                repeat: '150px',
                                path: _vehTrackCoordinates
                            }]
                        });
                        _RoutePath.setMap(_map);
                    }
                }
            }

            if (InfoboxContent.length > 0) {
                var endlenth = InfoboxContent.length;
                _markerArray[0].setAnimation(google.maps.Animation.BOUNCE);
                //_markerArray[endlenth - 1].setAnimation(google.maps.Animation.BOUNCE);
                _map.setCenter(new google.maps.LatLng(InfoboxContent[InfoboxContent.length - 1].latitude, InfoboxContent[InfoboxContent.length - 1].longitude));
            }

        } else {
            // alert("Marker list not pass !");
        }
    } catch (Error) {
        // alert("Problem in Create Route :" + Error.message);
    }
}

/*Function to load WithMovingDirection*/
function CreateMarkerWithInfoBoxLiveTracking(InfoboxContent, bOpenNewInfoBox, bClosePreviousInfoBox) {
    // var img='http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld='+A|FF0000|000000'

    _marker = new google.maps.Marker({
        map: _map,
        icon: '/App_Images/' + InfoboxContent.icon,

        position: new google.maps.LatLng(InfoboxContent.latitude, InfoboxContent.longitude)
    });


    if (_infowindow && (bClosePreviousInfoBox == "1" || bClosePreviousInfoBox == "")) {
        _infowindow.close();
    }
    var livetrack = "display:none;";
    if (InfoboxContent.Status == 'P') {
        livetrack = "display:inline-block;"
    }
    _infowindow = new google.maps.InfoWindow();


   
    _content = "<div class='titleHeader'></div><div class='popup'><table class='info-table'><tr align='left'><td colspan='2'><b>"
  + InfoboxContent.registrationNo + "</b></td><td><b>"
  + "" + "</b></td></tr><tr nowrap><td width='90px' align='left'><b>Driver Name:</b></td><td align='left'>"
  + InfoboxContent.DriverName + "</td></tr><tr><td  align='left'><b>Driver Mob:</b></td><td align='left'>"
  + InfoboxContent.DriverMobileNo + "</td> </tr><tr><td  align='left'><b>Recorded :</b></td><td align='left'>"
  + InfoboxContent.InsertedDateTime + "</td> </tr><tr><td align='left'><b>Speed :</b></td><td align='left'>"
    + InfoboxContent.Speed + " Km/Hr</td> </tr><tr><td align='left'><b>Device No. :</b></td><td align='left'>"
  + "</table></div>";
   
    google.maps.event.addListener(_marker, 'click', (function (_marker, _content) {
        return function () {
            _infowindow.setContent(_content);
            _infowindow.open(_map, _marker);
        }
    })(_marker, _content));

    if (bOpenNewInfoBox == "1") {
        _infowindow.setContent(_content);
        _infowindow.open(_map, _marker);
    }

    _markerArray.push(_marker);

}



/*CREATED BY: Vinish - Creates Marker & Polyline On History Tracking Page*/
function CreateRouteWithoutMarkerForHistoryTracking(MapControlID, Zoom, CenterLat, CenterLng, InfoboxContent, PathColor, PathOpacity, PathWeight) {
   
    try {

        ClearRoute()

        var prelat;
        var prelong;
        var preISGSM = 'OFF'
        var j = 0;
        var k = 0;
        var goto = 0;

        if (InfoboxContent.length != 0) {

            for (var i = 0; i <= InfoboxContent.length - 1; i++) {

                PathColor = '#006fe6'

                if (i == 0 || i == InfoboxContent.length - 1) {
                    CreateMarkerWithInfoBoxForHistoryTracking(InfoboxContent[i])
                }

                if (i > 0) {

                    //if (InfoboxContent[i].ISGSM == 'ON' && preISGSM == 'OFF') {
                    //    k = i - 1;
                    //    preISGSM = 'ON';
                    //    goto = 1;
                    //}
                    //else
                    //    if (InfoboxContent[i].ISGSM == 'ON' && preISGSM == 'ON') {
                    //        preISGSM = 'ON';
                    //        goto = 1;
                    //    }
                    //    else if (InfoboxContent[i].ISGSM == 'OFF' && preISGSM == 'ON') {
                    //        preISGSM = 'OFF';
                    //        goto = 0;
                    //    } else if (InfoboxContent[i].ISGSM == 'OFF' && preISGSM == 'OFF') {
                    //        k = 0;
                    //        preISGSM = 'OFF';
                    //        goto = 0;
                    //    }

                    if (InfoboxContent[i].icon == 'pin_yellow.png') {
                        PathColor = '#F3971E'
                    }
                    if (InfoboxContent[i].icon == 'pin_green.png') {
                        PathColor = '#65D873'
                    }
                    if (InfoboxContent[i].icon == 'pin_blue.png') {
                        PathColor = '#2191ED'
                    }
                    if (InfoboxContent[i].icon == 'pin_red.png') {
                        PathColor = '#EA0000'
                    }

                    if (goto < 1) {
                        if (k > 0) {
                            var _vehTrackCoordinates = [
                                                            new google.maps.LatLng(InfoboxContent[i].latitude, InfoboxContent[i].longitude),
                                                            new google.maps.LatLng(InfoboxContent[k].latitude, InfoboxContent[k].longitude)
                            ];

                        }
                            //else if (InfoboxContent[i].ISGSM == 'OFF') {
                        else {

                            var _vehTrackCoordinates = [
                                                            new google.maps.LatLng(InfoboxContent[i].latitude, InfoboxContent[i].longitude),
                                                            new google.maps.LatLng(InfoboxContent[i - 1].latitude, InfoboxContent[i - 1].longitude)
                            ];
                        }

                        _RoutePath = new google.maps.Polyline({
                            path: _vehTrackCoordinates,
                            strokeColor: PathColor,//"#CC3300",
                            strokeOpacity: PathOpacity,//80,
                            strokeWeight: PathWeight,//2,
                            icons: [{

                                icon: {
                                    path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                                    scale: 2,
                                    //rotation: heading,
                                    strokeColor: PathColor,
                                    fillColor: PathColor,
                                    fillOpacity: 3
                                },
                                repeat: '150px',
                                path: _vehTrackCoordinates
                            }]
                        });
                        _RoutePath.setMap(_map);
                    }

                }

            }

            if (InfoboxContent.length > 0) {
                var endlenth = InfoboxContent.length;
                _markerArray[0].setAnimation(google.maps.Animation.BOUNCE);
                //_markerArray[endlenth - 1].setAnimation(google.maps.Animation.BOUNCE);
                _map.setCenter(new google.maps.LatLng(InfoboxContent[InfoboxContent.length - 1].latitude, InfoboxContent[InfoboxContent.length - 1].longitude));
            }

        }
        else {
            // alert("Marker list not pass !");
        }
    }
    catch (Error) {
        // alert("Problem in Create Route :" + Error.message);
    }
}

/*CREATED BY: Vinish - Creates Marker On History Tracking Page*/
function CreateMarkerWithInfoBoxForHistoryTracking(InfoboxContent, bOpenNewInfoBox, bClosePreviousInfoBox) {
    //debugger

    _marker = new google.maps.Marker({
        map: _map,
        icon: '/App_Images/' + InfoboxContent.icon,

        position: new google.maps.LatLng(InfoboxContent.latitude, InfoboxContent.longitude)
    });


    if (_infowindow && (bClosePreviousInfoBox == "1" || bClosePreviousInfoBox == "")) {
        _infowindow.close();
    }
    var livetrack = "display:none;";
    //if (InfoboxContent.Status == 'P') {
    //    livetrack = "display:inline-block;"
    //}
    _infowindow = new google.maps.InfoWindow();

    _content = "<div class='titleHeader'></div><div class='popup'><table class='info-table' width='100%'><tr align='left'><td colspan='2'><b>"
    + InfoboxContent.registrationNo + "</b></td><td><b>"
    + "" + "</b></td></tr><tr nowrap><td width='90px' align='left'><b>Driver Name:</b></td><td align='left'>"
    + InfoboxContent.chauffeurName + "</td></tr><tr><td  align='left'><b>Driver Mob:</b></td><td align='left'>"
    + InfoboxContent.chauffeurMobileNo + "</td> </tr><tr><td  align='left'><b>Recorded :</b></td><td align='left'>"
    + InfoboxContent.receivedTime + "</td> </tr><tr><td align='left'><b>Speed :</b></td><td align='left'>"
      + InfoboxContent.speed + " Km/Hr</td> </tr><tr><td align='left'><b>Device No. :</b></td><td align='left'>"
        + InfoboxContent.deviceNo + "</td></tr>" //<tr><td align='left'><b>IMEI No. :</b></td><td align='left'>"
        //+ InfoboxContent.imeino + "</td> </tr><tr><td align='left'><b>Sim No. :</b></td><td align='left'>"
    //+ InfoboxContent.SIMNo
    //+ "</td></tr>"
    + '<tr><td align="left"></td><td align="left"><a style=' + livetrack + '  href="#" onclick="SendLiveTracking(\'' + InfoboxContent.registrationNo + '\'' + ',' + "InfoboxContent.FK_CompanyId" + ');">Live Tracking</a>'
    + "</td></tr> </table></div>";
    //  + "<tr><td align='left'></td><td align='left'><a href='#' onclick='SendLiveTracking(''+RegNo,CompId)'>Live Tracking</a>"
    google.maps.event.addListener(_marker, 'click', (function (_marker, _content) {
        return function () {
            _infowindow.setContent(_content);
            _infowindow.open(_map, _marker);
        }
    })(_marker, _content));

    if (bOpenNewInfoBox == "1") {
        _infowindow.setContent(_content);
        _infowindow.open(_map, _marker);
    }

    _markerArray.push(_marker);

}

function PlayRouteWithoutMarker(MapControlID, Zoom, CenterLat, CenterLng, InfoboxContent, PathColor, PathOpacity, PathWeight, TimerIntervalMS, bAlwayOpenInfoBox, IsPanEnable) {

    try {

        ClearMap();
        _counter = !_counter ? 0 : _counter;
        _InfoboxContent = InfoboxContent;
        trHTML = '';

        _SetInterval = setInterval('PlayWithoutMarker(' + '"' + PathColor + '",' + PathOpacity + ',' + PathWeight + ',' + bAlwayOpenInfoBox + ',' + IsPanEnable + ')', TimerIntervalMS);
    } catch (Error) {
        // alert("Problem in Create Route :" + Error.message);
    }
}

var _mycounter = 0;
function PlayWithoutMarker(PathColor, PathOpacity, PathWeight, bAlwayOpenInfoBox, IsPanEnable) {
    //debugger
    if (_counter <= _InfoboxContent.length - 1) {
        _mycounter++;

        if ($("#myplaybutton" + slotId + "").attr('myval') && !$("#fast" + slotId + "").attr('myval')) {
            return false;
        }
        if (_InfoboxContent.length == _mycounter) {


            $("#myplaybutton" + slotId + "").removeAttr('val');
            $("#myplaybutton" + slotId + "").attr('val', 'play');
            $("#myplaybutton" + slotId + "").find('i').removeAttr('class');
            $("#myplaybutton" + slotId + "").find('i').attr('class', 'la la-play');

            clearInterval(_SetInterval);

        }
        else {

        }
        var mydata = _InfoboxContent[_mycounter - 1];
        if (mydata) {
            $("#datadiv" + slotId + "").show();
            $("#ANDCriteria" + slotId + "").show();
            $("#iconsdata" + slotId + "").show();
            $("#datadiv" + slotId + "").find('#from_to').text(mydata.receivedTime);
            $("#datadiv" + slotId + "").find('#engineon').text(mydata.gpstime);
            $("#datadiv" + slotId + "").find('#speed').text(mydata.speed);
            $("#datadiv" + slotId + "").find('#distance').text(mydata.Distance);
            $("#datadiv" + slotId + "").find('#add').text(mydata.location + " ," + mydata.latitude + " ," + mydata.longitude);

        }
        else {
            //            $("#datadiv").hide();
        }




        ///Progress Bar Incremental
        if ($("#btnIncrementBar" + slotId + "").attr('aria-valuemax')) {
            $("#btnIncrementBar" + slotId + "").removeAttr('aria-valuemax');
            $("#btnIncrementBar" + slotId + "").attr('aria-valuemax', _InfoboxContent.length);
        }
        var t = (parseInt(_counter) + 1);


        var oneperce = 100 / (_InfoboxContent.length);
        t = oneperce * t;



        t = t + '%';

        $("#btnIncrementBar" + slotId + "").css({ 'width': t, 'background-color': '#393b4a' });
        $("#btnIncrementBar" + slotId + "").removeAttr('aria-valuenow');
        $("#btnIncrementBar" + slotId + "").attr('aria-valuenow', (_counter + 1));
        //$("#btnIncrementBar").text(t);

        var prelat;
        var prelong;
        var preISGSM = 'OFF'
        var j = 0;
        var k = 0;
        var goto = 0;

        if (_counter == 0 || _counter == _InfoboxContent.length - 1) {
            CreateMarkerWithInfoBox(_InfoboxContent[_counter]);
            if (_InfoboxContent.length > 1) {
                CreateMarkerWithInfoBoxForLast(_InfoboxContent[_InfoboxContent.length - 1]);
            }

        }

        //CreateTableHistoryBody(_InfoboxContent[_counter]);

        PathColor = '#006fe6'

        if (_counter > 0) {
            if (_InfoboxContent[_counter].ISGSM == 'ON' && preISGSM == 'OFF') {
                k = _counter - 1;
                preISGSM = 'ON';
                goto = 1;
            }
            else
                if (_InfoboxContent[_counter].ISGSM == 'ON' && preISGSM == 'ON') {
                    preISGSM = 'ON';
                    goto = 1;
                }
                else if (_InfoboxContent[_counter].ISGSM == 'OFF' && preISGSM == 'ON') {
                    preISGSM = 'OFF';
                    goto = 0;

                } else if (_InfoboxContent[_counter].ISGSM == 'OFF' && preISGSM == 'OFF') {
                    k = 0;
                    preISGSM = 'OFF';
                    goto = 0;
                }
            //if (_InfoboxContent[_counter].Icon == 'pin_yellow.png') {
            //    PathColor = '#F3971E'
            //}
            //if (_InfoboxContent[_counter].Icon == 'pin_green.png') {
            //    PathColor = '#65D873'
            //}
            //if (_InfoboxContent[_counter].Icon == 'pin_blue.png') {
            //    PathColor = '#2191ED'
            //}
            //if (_InfoboxContent[_counter].Icon == 'pin_red.png') {
            //    PathColor = '#EA0000'
            //}




            /*
            
            if (goto < 1) {
                        if (k > 0) {
                            var _vehTrackCoordinates =  [
                                                            new google.maps.LatLng(InfoboxContent[i].latitude, InfoboxContent[i].longitude),
                                                            new google.maps.LatLng(InfoboxContent[k].latitude, InfoboxContent[k].longitude) 
                                                        ];

                        }
                        //else if (InfoboxContent[i].ISGSM == 'OFF') {
                        else{

                            var _vehTrackCoordinates =  [
                                                            new google.maps.LatLng(InfoboxContent[i].latitude, InfoboxContent[i].longitude),
                                                            new google.maps.LatLng(InfoboxContent[i - 1].latitude, InfoboxContent[i - 1].longitude)
                                                        ];
                        }

                        _RoutePath = new google.maps.Polyline({
                            path: _vehTrackCoordinates,
                            strokeColor: PathColor,//"#CC3300",
                            strokeOpacity: PathOpacity,//80,
                            strokeWeight: PathWeight,//2,
                            icons: [{

                                icon: {
                                    path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                                    scale: 2,
                                    //rotation: heading,
                                    strokeColor: PathColor,
                                    fillColor: PathColor,
                                    fillOpacity: 3
                                },
                                repeat: '150px',
                                path: _vehTrackCoordinates
                            }]
                        });
                        _RoutePath.setMap(_map);
                    }
            
            */









            if (goto < 1) {

                if (k > 0) {
                    var _vehTrackCoordinates = [
                                                           new google.maps.LatLng(_InfoboxContent[_counter].latitude, _InfoboxContent[_counter].longitude),
                                                           new google.maps.LatLng(_InfoboxContent[k].latitude, _InfoboxContent[k].longitude)
                    ];


                }
                    //else if (InfoboxContent[i].ISGSM == 'OFF') {
                else {

                    var _vehTrackCoordinates = [
                                                    new google.maps.LatLng(_InfoboxContent[_counter].latitude, _InfoboxContent[_counter].longitude),
                                                    new google.maps.LatLng(_InfoboxContent[_counter - 1].latitude, _InfoboxContent[_counter - 1].longitude)
                    ];
                }

                _RoutePath = new google.maps.Polyline({
                    path: _vehTrackCoordinates,
                    strokeColor: PathColor,//"#CC3300",
                    strokeOpacity: PathOpacity,//80,
                    strokeWeight: PathWeight,//2,
                    icons: [{

                        icon: {
                            path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
                            scale: 2,
                            //rotation: heading,
                            strokeColor: PathColor,
                            fillColor: PathColor,
                            fillOpacity: 3
                        },
                        repeat: '150px',
                        path: _vehTrackCoordinates
                    }]
                });

                if (IsPanEnable = 1) {
                    _map.panTo(new google.maps.LatLng(_InfoboxContent[_counter].latitude,
                                                   _InfoboxContent[_counter].longitude));
                }

                _RoutePath.setMap(_map);
            }
        }
    }///////////////////////////////

    //if (InfoboxContent.length > 0) {
    //    var endlenth = InfoboxContent.length;
    //    _markerArray[0].setAnimation(google.maps.Animation.BOUNCE);
    //    _markerArray[endlenth - 1].setAnimation(google.maps.Animation.BOUNCE);
    //    _map.setCenter(new google.maps.LatLng(InfoboxContent[InfoboxContent.length - 1].Lat, InfoboxContent[InfoboxContent.length - 1].Long));
    //}

    //} else {
    // alert("Marker list not pass !");
    //}


    _counter++;

}

/*Plays Route Without Markers END*//*Function to load from play WithoutMarker*/
function CreateMarkerWithInfoBoxForLast(InfoboxContent, bOpenNewInfoBox, bClosePreviousInfoBox) {

    _marker = new google.maps.Marker({
        map: _map,
        icon: '/App_Images/' + InfoboxContent.Icon,

        position: new google.maps.LatLng(InfoboxContent.Lat, InfoboxContent.Long)
    });


    if (_infowindow && (bClosePreviousInfoBox == "1" || bClosePreviousInfoBox == "")) {
        _infowindow.close();
    }
    var livetrack = "display:none;";
    if (InfoboxContent.Status == 'P') {
        livetrack = "display:inline-block;"
    }
    _infowindow = new google.maps.InfoWindow();

    _content = "<div class='titleHeader'></div><div class='popup'><table class='info-table' width='100%'><tr align='left'><td colspan='2'><b>"
    + InfoboxContent.RegistrationNo + "</b></td><td><b>"
    + InfoboxContent.ModelName + "</b></td></tr><tr nowrap><td width='90px' align='left'><b>Driver Name:</b></td><td align='left'>"
    + InfoboxContent.DriverName + "</td></tr><tr><td  align='left'><b>Driver Mob:</b></td><td align='left'>"
    + InfoboxContent.DriverMobileNo + "</td> </tr><tr><td  align='left'><b>Recorded :</b></td><td align='left'>"
    + InfoboxContent.DeviceDateTime + "</td> </tr><tr><td align='left'><b>Speed :</b></td><td align='left'>"
      + InfoboxContent.Speed + " Km/Hr</td> </tr><tr><td align='left'><b>Device No. :</b></td><td align='left'>"
        + InfoboxContent.DeviceNo + "</td></tr>" //<tr><td align='left'><b>IMEI No. :</b></td><td align='left'>"
        //+ InfoboxContent.IMEINo + "</td> </tr><tr><td align='left'><b>Sim No. :</b></td><td align='left'>"
    //+ InfoboxContent.SIMNo
    //+ "</td></tr>"
    + '<tr><td align="left"></td><td align="left"><a style=' + livetrack + '  href="#" onclick="SendLiveTracking(\'' + InfoboxContent.RegistrationNo + '\'' + ',' + InfoboxContent.FK_CompanyId + ');">Live Tracking</a>'
    + "</td></tr> </table></div>";
    //  + "<tr><td align='left'></td><td align='left'><a href='#' onclick='SendLiveTracking(''+RegNo,CompId)'>Live Tracking</a>"
    google.maps.event.addListener(_marker, 'click', (function (_marker, _content) {
        return function () {
            _infowindow.setContent(_content);
            _infowindow.open(_map, _marker);
        }
    })(_marker, _content));

    if (bOpenNewInfoBox == "1") {
        _infowindow.setContent(_content);
        _infowindow.open(_map, _marker);
    }
}


/****************************GOOG MAP UTILITY FINCTIONS STARTS****************************/

/*CREATED BY: Vinish - Removes All Object On Map*/
function ClearMap() {
    removeLine();
    setMapOnAll(null);
}

/*CREATED BY: Vinish - Called From ClearMap() Function */
function removeLine() {
    if (typeof _vehPath === 'undefined') { } else {
        _vehPath.setMap(null);
    }
}

/*CREATED BY: Vinish - Called From ClearMap() Function */
function setMapOnAll(map) {

    if (typeof _markerArray === 'undefined') { } else {
        for (var i = 0; i < _markerArray.length; i++) {
            _markerArray[i].setMap(map);
        }

        _markerArray = [];
    }
}
/*CREATED BY: Vinish - Called From ClearMap() Function */
function ClearRoute() {

    if (typeof _RoutePath != 'undefined') {
        _RoutePath.setMap(null);
    }
    setMapOnAll(null);
    //if (typeof _vehPath === 'undefined') { } else {
    //    _vehPath.setMap(null);
    //}
}

/****************************GOOG MAP UTILITY FINCTIONS ENDS****************************/

/*CREATED BY: Vinish - Called From Link Vehicle Marker's Infobox */
function SendLiveTracking(_FK_VehicleId, _AccountId, _CustomerId) {

    $.ajax({
        url: '../TrackOnMap/LiveTracking',
        type: "GET",
        dataType: "JSON",
        data: { AccountId: _AccountId, CustomerId: _CustomerId, FK_VehicleId: _FK_VehicleId },
        success: function (r) {
            //alert(r);
            if (r == 1) {
                window.location.href = "../TrackOnMap/Index";
            }
        }
    });
}


/*CREATED BY: Vinish - CREARS THE INTERVAL */
function Pause() {
    clearTimeout(_SetInterval);
    // ClearMap();
}



/*CREATE MARKER WITH ICON*/
//This method is called inside "initMap()" method to add new markers.

function Addmarkers(latLongArray, MarkerTitle, imagePath) {
    //debugger
    if (latLongArray != null && latLongArray.length > 0) {

        for (let i = 0; i < latLongArray.length; i++) {
            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(latLongArray[i].latitude, latLongArray[i].longitude),
                title: MarkerTitle,
                draggable: false,
                map: _map,
                icon: imagePath
            });
        }
    }


}

function AddSingleMarker(Lat, Long, MarkerTitle, imagePath) {
    //debugger

    if (imagePath!="") {
        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(Lat, Long),
          //  title: MarkerTitle,
            draggable: false,
            map: _map,
            //icon: imagePath
        });
    }

    else {
        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(Lat, Long),
          //  title: MarkerTitle,
            draggable: false,
            map: _map
        });
    }


    


}