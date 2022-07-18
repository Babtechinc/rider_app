

import 'package:flutter/cupertino.dart';
import 'package:rider_app/Models/address.dart';

class AppData extends ChangeNotifier{
 Address? pickuplocation;
 Address? dropOfflocation;

void updatePickUplocationAddress(Address pickupAddress){
  pickuplocation = pickupAddress;
  notifyListeners();
}
void updateDropOfflocationAddress(Address dropOffAddress){
  dropOfflocation = dropOffAddress;
  notifyListeners();
}

}