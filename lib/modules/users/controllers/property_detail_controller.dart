import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';

class PropertyDetailController extends GetxController {
  RxBool isLoading = false.obs;

  List<String> featuresList = [];

  void initValues(Results property) {
    featuresList.clear();
    if (property.features?.internet ?? false) {
      featuresList.add('Internet');
    }
    if (property.features?.electricity ?? false) {
      featuresList.add('Electricity');
    }
    if (property.features?.furnished ?? false) {
      featuresList.add('Furnished');
    }
    if (property.features?.landline ?? false) {
      featuresList.add('Landline');
    }
    if (property.features?.parking ?? false) {
      featuresList.add('Parking');
    }
    if (property.features?.sewerage ?? false) {
      featuresList.add('Sewerage');
    }
    if (property.features?.suigas ?? false) {
      featuresList.add('Sui Gas');
    }
  }
}
