

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/ConfigMaps.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';

import '../Models/directionDetail.dart';

class AssistantMethods{
  static Future<String> searchCoordinteAddress(Position position,context) async{
    String placeAddress = "";
    String st1,st2,st3,st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";
  var response = await RequestAssistant.getReguest(url);
  if(response!="Failed"){
    // placeAddress = response["results"][0]["formatted_address"];
     st1 = response["results"][0]["address_components"][0]["long_name"];
     st2 = response["results"][0]["address_components"][1]["long_name"];
     st3 = response["results"][0]["address_components"][5]["long_name"];
     st4 = response["results"][0]["address_components"][6]["long_name"];
     placeAddress = st1  +", "+st2  +", "+st3  +", "+st4;
    Address userPickUpAddress = new Address(placeName: placeAddress);
    userPickUpAddress.latitude= position.latitude;
    userPickUpAddress.longitude = position.longitude;
    Provider.of<AppData>(context,listen: false).updatePickUplocationAddress(userPickUpAddress);
  }
return placeAddress;
  }



  static   Future<DirectionDetail?> obtainPlaceDirectionDetails(LatLng initalPosition ,LatLng finalLocation) async{
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initalPosition.latitude},${initalPosition.longitude}&destination=${finalLocation.latitude},${finalLocation.longitude}&key=AIzaSyAhsrT_qKMK8LtBqohKDEsequRSOy3X7Xc";
    var res = await RequestAssistant.getReguest(directionUrl);


    if (res == "failed") {
      return null;
    }
    if(res["status"] =="OK" ){

      DirectionDetail directionDetail =DirectionDetail();

      directionDetail.encodedPoint = res["routes"][0]["overview_polyline"]["points"];

      directionDetail.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];

      directionDetail.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

      directionDetail.durationText = res["routes"][0]["legs"][0]["duration"]["text"];

      directionDetail.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

      return directionDetail;

    }
  }

}