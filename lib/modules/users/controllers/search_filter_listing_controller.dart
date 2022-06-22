import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/api_route.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import '../../../dio_networking/api_client.dart';
import '../../../utils/user_defaults.dart';

class SearchFilterListingController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool isBuying = false.obs;

  var selectedPredictionArea = Predictions(description: '').obs;
  var selectedPredictionCity = Predictions(description: '').obs;

  List<Predictions?>? selectedLocationsList;

  RxString selectedPurpose = 'For Rent'.obs;
  RxString selectedPropertyType = ''.obs;
  RxString propertyTypeMainValue = 'Commercial'.obs;

  String selectedBaths = '';
  String selectedBeds = '';

  RxInt activePropertyTypeList = (0).obs;

  var keywordsItems = [
    'Parking Space',
    'Air Condition',
    'Newly Constructed',
    'Verified by Zeerac'
  ];

//  List<String>? selectedKeyWordsList = [];
  RxList<String> selectedKeyWordsList = <String>[].obs;

  void changeSelectedPropertyType(String value) {
    switch (value) {
      case 'Commercial':
        activePropertyTypeList.value = 0;
        break;
      case 'Residential':
        activePropertyTypeList.value = 1;
        break;
      case 'Apartment':
        activePropertyTypeList.value = 2;
        break;
    }
  }

  void resetValues() {
    isLoading.value = false;
    isBuying.value = false;
    selectedPredictionArea.value = Predictions(description: '');
    selectedPredictionCity.value = Predictions(description: '');
    activePropertyTypeList.value = 0;
    selectedPropertyType.value = '';
    selectedPurpose.value = 'For Rent';
    propertyTypeMainValue.value = 'Commercial';
    selectedLocationsList?.clear();
    selectedKeyWordsList.clear();
    update();
  }

  void loadListings({required onComplete}) {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "city": selectedPredictionCity.value.structuredFormatting?.mainText ?? '',
      "area": selectedPredictionArea.value.structuredFormatting?.mainText ?? '',
      "loca": selectedLocationsList?.join(','),
      "bathrooms": selectedBaths,
      "beds": selectedBeds,
      "type": selectedPropertyType.value,

//status:
//
//space:
//

//condition:
//year:
//neighborhood:
//furnished:
//parking:
//electricity:
//suigas:
//landline:
//sewerage:
//internet:
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.queryPropertiesList,
              body: body,
            ),
            create: () => APIResponse<PropertyListingResponseModel>(
                create: () => PropertyListingResponseModel()),
            apiFunction: loadListings)
        .then((response) {
      isLoading.value = false;
      if ((response.response?.data?.count ?? 0) > 0) {
        onComplete(response.response?.data);
      } else {
        AppPopUps.showDialog(
            title: 'Alert',
            description: 'No result found',
            dialogType: DialogType.INFO);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialog(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
