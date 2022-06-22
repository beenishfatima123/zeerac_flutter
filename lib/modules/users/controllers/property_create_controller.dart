import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

import '../pages/property_listing/property_create_views.dart';

class PropertyCreateController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController propertyNameController = TextEditingController();
  TextEditingController propertyPriceController = TextEditingController();

  TextEditingController propertySpaceController = TextEditingController();
  TextEditingController propertyVideoUrlController = TextEditingController();
  TextEditingController propertyDescriptionController = TextEditingController();
  TextEditingController propertyBuiltYearController = TextEditingController();
  TextEditingController propertyNeighborhoodController =
      TextEditingController();

  TextEditingController pickedLocationCountryController =
      TextEditingController();
  TextEditingController pickedLocationCityController = TextEditingController();
  TextEditingController pickedLocationAreaController = TextEditingController();
  TextEditingController pickedLocationAddressController =
      TextEditingController();
  TextEditingController pickedLocationBlockController = TextEditingController();
  TextEditingController pickedLocationLatController = TextEditingController();
  TextEditingController pickedLocationLngController = TextEditingController();

  ///property type
  RxInt activePropertyTypeList = (0).obs;
  RxString propertyTypeMainValue = 'Commercial'.obs;

  RxInt currentViewIndex = (0).obs;

  final viewsList = const [
    PropertyBasicInformationWidget(),
    PropertyDetailWidget(),
    PropertyLocationPicker(),
    PropertyFeatures(),
    PropertyFinalSubmitViewDetails()
  ];

  Rxn<PickResult> pickedResult = Rxn<PickResult>();

  RxSet<String> selectedFeaturesSet = <String>{}.obs;

  Rxn<File?> thumbnailOfPropertyFile = Rxn<File>();
  RxList<File> picturesList = <File>[].obs;

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

  ///attributes details
  RxString selectedCurrencyType = ''.obs;
  RxString selectedSpaceUnit = ''.obs;
  RxString selectedBeds = ''.obs;
  RxString selectedBaths = ''.obs;
  RxString selectedCondition = ''.obs;
  RxString selectedSubPropertyType = ''.obs;
  RxString selectedPurpose = ''.obs;

  void goForward() {
    if (currentViewIndex.value < viewsList.length - 1) {
      currentViewIndex++;
    }
  }

  Future<bool> goBackWard() {
    if (currentViewIndex.value > 0) {
      currentViewIndex--;
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void setLocationPickedResult(PickResult? result) {
    pickedResult.value = result;

    pickedLocationCountryController.text = getValueFor('country', result);
    pickedLocationCityController.text =
        getValueFor('administrative_area_level_2', result);
    pickedLocationAreaController.text =
        getValueFor('sublocality_level_1', result);
    pickedLocationAddressController.text = result?.formattedAddress ?? '';

    pickedLocationBlockController.text =
        getValueFor('sublocality_level_2', result);

    pickedLocationLatController.text =
        result != null ? (result.geometry?.location.lat ?? 0).toString() : "";
    pickedLocationLngController.text =
        result != null ? (result.geometry?.location.lng ?? 0).toString() : "";
  }

  String getValueFor(String key, PickResult? pickResult) {
    String result = '';

    pickResult?.addressComponents?.forEach((element) {
      if (element.types.contains(key)) {
        result = element.longName;
      }
    });

    return result;
  }

  void handleFeature(String feature) {
    if (selectedFeaturesSet.contains(feature)) {
      selectedFeaturesSet.remove(feature);
    } else {
      selectedFeaturesSet.add(feature);
    }
  }

  void submit() {}
}
