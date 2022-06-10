import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/cities_model.dart';

class SearchFilterListingController extends GetxController {
  RxBool isLoading = false.obs;

  RxBool isBuying = false.obs;

  RxString selectedArea = 'Select Area'.obs;
  List<Predictions?>? selectedLocationsList;

  String selectedPurpose = '';
  RxString selectedPropertyType = ''.obs;
  String selectedBaths = '';
  String selectedBeds = '';

  ///purpose of property
  final purposes = ['For Rent', 'For Sale', 'For Installment'];

  ///properties type
  final propertiesType = ['Commercial', 'Residential', 'Apartment'];

  ///beds
  final beds = ['1', '2', '3', '4', '5', '5+'];

  ///baths
  final baths = ['1', '2', '3', '4', '5', '5+'];

  RxInt activePropertyTypeList = (0).obs;
  final propertiesTypeList = [
    ['Shop', 'Mall', 'Hostel', 'Building'],
    ['Single story', 'Complete house', 'Upper portion'],
    ['Studio apartment']
  ];

  var keywordsItems = [
    'Parking Space',
    'Air Condition',
    'Newly Constructed',
    'Verified by Zeerac'
  ];

  List<String?>? selectedKeyWordsList = [];

  var selectedPredictionCity = Predictions(description: 'Select City').obs;

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
}
