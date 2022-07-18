import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/SearchScreen.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/Assistants/assistanceMethods.dart';
import 'package:rider_app/DataHandler/appData.dart';

import '../AllWidgets/progressDialog.dart';



class MainScreen extends StatefulWidget {


  static const String idScreen ="mainScreen ";


  @override

  _MainScreenState createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> {


  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scffloldkey = new  GlobalKey<ScaffoldState>();
  List<LatLng> plineCoordinate = [];
  Set<Polyline> ploylineSet = {} ;
  late Position currentPosition  ;
  var geolocator = Geolocator();

  double buttomPaddingofMap = 0;

  Set <Marker> markerSet ={};
  Set<Circle> circlesSet = {};
  double rideDetailContainerHeight = 0;
  double searchContainerHeight =300.0;
  void displayrideDetailContainer() async{

    await getPlaceDirection();
    setState(() {
    rideDetailContainerHeight = 240;
    searchContainerHeight = 0;
    buttomPaddingofMap =230.0;
    });
  }


  void locatePosition () async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new  CameraPosition(target: latLatPosition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition) );

    String address = await AssistantMethods.searchCoordinteAddress(position,context);
    print(address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scffloldkey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child:DrawerHeader(
                  decoration:   BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name", style: TextStyle(
                        fontSize: 16.0,
                            fontFamily: "Brand-Bold"
                          ),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile")
                        ],
                      )
                    ],
                  ),
                ) ,
              ),
              DividerWidget(),
              SizedBox(height: 12,),
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History",style: TextStyle(fontSize: 15),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile",style: TextStyle(fontSize: 15),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About",style: TextStyle(fontSize: 15),),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: buttomPaddingofMap ),
            initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            polylines: ploylineSet,
            markers: markerSet,
            circles: circlesSet,
            onMapCreated:(GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                buttomPaddingofMap = 300.0;
              });

              locatePosition();
            },
          ),
          //Haberger Button
          Positioned(
            top: 45.0,
            left: 22.0,
            child:   GestureDetector(
                onTap: (){
                  scffloldkey.currentState?.openDrawer();
                },
                child:Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:  BorderRadius.circular(18.0),
                    boxShadow:[
                      BoxShadow(
                          color:Colors.black,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7,0.7)
                      )
                    ]
                ),
                child: CircleAvatar (
                  backgroundColor: Colors.white,
                  child:Icon(Icons.menu,color: Colors.black,) ,
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight ,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
                  boxShadow:[
                    BoxShadow(
                      color:Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7)
                    )
                  ]
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0 ),
                  child: Column(
                    children: [
                      SizedBox(height: 6.0,),
                      Text("Hi there",
                      style: TextStyle(
                        fontSize: 10.0
                      ),
                      ),
                      Text("Where to?",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Brand-Bold"
                      ),
                      ),
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: () async{
                        var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                        if(res=="obtainDirection"){

                         displayrideDetailContainer();
                        }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:  BorderRadius.circular(5.0),
                              boxShadow:[
                                BoxShadow(
                                    color:Colors.black54,
                                    blurRadius: 6.0,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7,0.7)
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.search,color: Colors.blueAccent ,),
                                SizedBox(width: 10.0,),
                                Text("Search Drop off")
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.0,),
                      Row(
                        children: [
                          Icon(Icons.home,color: Colors.grey ,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                              (Provider.of<AppData>(context).pickuplocation?.placeName??"Add Home")
                              ),
                              SizedBox(height: 4.0,),
                              Text("Your Living home address",style: TextStyle(color: Colors.black54,fontSize: 12.0),),

                            ],
                          )

                        ],
                      ),

                      SizedBox(height: 10.0,),
                      DividerWidget(),
                      SizedBox(height: 16.0,),
                      Row(
                        children: [
                          Icon(Icons.work,color: Colors.grey ,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add work"),
                              SizedBox(height: 4.0,),
                              Text("Your Office address",style: TextStyle(color: Colors.black54,fontSize: 12.0),),

                            ],
                          )

                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(

                height: rideDetailContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius:  BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0)),
                boxShadow:[
                BoxShadow(
                color:Colors.black,
                blurRadius: 16.0,
                spreadRadius: 0.5,
    offset: Offset(0.7,0.7)
    )
  ]  ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17.0 ) ,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Image.asset("images/taxi.png",
                              height: 70.0,width: 80.0,),
                              SizedBox(width: 16,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Car",style: TextStyle(fontSize: 18.0 ,fontFamily: "Brand-Bold"),),
                                  Text("10km",style: TextStyle(fontSize: 18.0 ,color: Colors.grey ),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24,),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt,size: 18.0,color: Colors.black54,),
                            SizedBox(width: 16,),
                            Text("Cash"),
                            SizedBox(width: 6,),
                            Icon(Icons.keyboard_arrow_down,color: Colors.black54,size: 16,),


                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child:  RaisedButton(
                        onPressed: (){
                        print("i got you");
                        },
                        color: Theme.of(context).colorScheme.secondary,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Request",style:TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white) ,
                              ),
                              Icon(FontAwesomeIcons.taxi,color: Colors.white,size: 26.0,)
                            ],
                          ),
                        ),
                      ),
                    ),

                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos = Provider
        .of<AppData>(context, listen: false)
        .pickuplocation;
    var finalPos = Provider
        .of<AppData>(context, listen: false)
        .dropOfflocation;

    var pickupLatlng = LatLng(
        initialPos?.latitude ?? 0.0, initialPos?.longitude ?? 0.0);
    var dropOFFLatlng = LatLng(
        finalPos?.latitude ?? 0.0, finalPos?.longitude ?? 0.0);


    showDialog(context: context,
        builder: (BuildContext context) =>
            ProgressDialog(Message: "setting route, please wait........"));
    var detail = await AssistantMethods.obtainPlaceDirectionDetails(
        pickupLatlng, dropOFFLatlng);
    Navigator.pop(context);
    print("This is Encoded Point ::");
    print(detail?.encodedPoint ?? 'not here');
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointResult = polylinePoints.decodePolyline(
        detail?.encodedPoint ?? "");
    plineCoordinate.clear();
    if (decodePolyLinePointResult.isNotEmpty) {
      decodePolyLinePointResult.forEach((PointLatLng pointLatLng) {
        plineCoordinate.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    ploylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(polylineId: PolylineId("PolylineID"),
        color: Colors.pink,
        jointType: JointType.round,
        points: plineCoordinate,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,

      );
      ploylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickupLatlng.latitude > dropOFFLatlng.latitude &&
        pickupLatlng.longitude > dropOFFLatlng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOFFLatlng, northeast: pickupLatlng);
    }
    else if (pickupLatlng.longitude > dropOFFLatlng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickupLatlng.latitude, dropOFFLatlng.longitude),
          northeast: LatLng(dropOFFLatlng.latitude, pickupLatlng.longitude));
    } else if (pickupLatlng.latitude > dropOFFLatlng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOFFLatlng.latitude, pickupLatlng.longitude),
          northeast: LatLng(pickupLatlng.latitude, dropOFFLatlng.longitude));
    }
    else {
      latLngBounds =
          LatLngBounds(southwest: pickupLatlng, northeast: dropOFFLatlng);
    }
    newGoogleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 70));
    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos?.placeName,snippet: "my location"),
      position: pickupLatlng,
      markerId: MarkerId("pickUpId"),

    );
    Marker dorpOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos?.placeName,snippet: "DorpOff location"),
      position: dropOFFLatlng,
      markerId: MarkerId("dorpOffId"),

    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dorpOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(fillColor: Colors.blueAccent,
    center:   pickupLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );
    Circle dorpOffLocCircle = Circle(fillColor: Colors.deepPurple,
    center:   dropOFFLatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dorpOffId"),
    );
    setState(() {
      circlesSet.add(pickUpLocCircle);
          circlesSet.add(dorpOffLocCircle);
    });
  }
}
