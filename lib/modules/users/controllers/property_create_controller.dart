import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_route.dart';
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
  TextEditingController pickedLocationFormattedAddressController =
      TextEditingController();
  TextEditingController pickedLocationAddressController =
      TextEditingController();
  TextEditingController pickedLocationBlockController = TextEditingController();
  TextEditingController pickedLocationLatController = TextEditingController();
  TextEditingController pickedLocationLngController = TextEditingController();

  ///property type
  RxInt activePropertyTypeList = (0).obs;
  RxString propertyTypeMainValue = ''.obs;
  RxInt currentViewIndex = (0).obs;

  final viewsList = [
    PropertyBasicInformationWidget(),
    PropertyDetailWidget(),
    PropertyLocationPicker(),
    PropertyFeatures(),
    const PropertyFinalSubmitViewDetails()
  ];

  Rxn<PickResult> pickedLocationResult = Rxn<PickResult>();

  RxSet<String> selectedFeaturesSet = <String>{}.obs;

  Rxn<File?> thumbnailOfPropertyFile = Rxn<File>();
  RxList<File> picturesList = <File>[].obs;

  RxBool isTermsAccepted = false.obs;

  void changeSelectedPropertyType(String value) {
    if (value == AppConstants.propertiesType[0]) {
      activePropertyTypeList.value = 0;
    } else if (value == AppConstants.propertiesType[1]) {
      activePropertyTypeList.value = 1;
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

  /*Future<Position> determinePosition() async {
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
*/
  void setLocationPickedResult(PickResult? result) {
    pickedLocationResult.value = result;

    pickedLocationCountryController.text = getValueFor('country', result);
    pickedLocationCityController.text =
        getValueFor('administrative_area_level_2', result);
    pickedLocationAreaController.text =
        getValueFor('sublocality_level_1', result);
    pickedLocationAddressController.text = result?.formattedAddress ?? '';
    pickedLocationFormattedAddressController.text =
        result?.formattedAddress ?? '';
    pickedLocationBlockController.text =
        getValueFor('sublocality_level_2', result);

    pickedLocationLatController.text =
        result != null ? (result.geometry?.location.lat ?? 0).toString() : "";
    pickedLocationLngController.text =
        result != null ? (result.geometry?.location.lng ?? 0).toString() : "";
  }

  String getValueFor(String key, PickResult? pickResult) {
    String result = 'not available';

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

  submit({required completion}) async {
    UserLoginResponseModel? user = UserDefaults.getUserSession();
    Map<String, bool> features = {};
    for (var element in AppConstants.propertyFeatures) {
      if (selectedFeaturesSet.contains(element)) {
        features[element] = true;
      }
    }

    Map<String, dynamic> body = {
      "user": (user?.id ?? 0).toString(),
      "name": propertyNameController.text,
      "type": propertyTypeMainValue.value,
      "price": propertyPriceController.text,
      "space": propertySpaceController.text,
      "unit": selectedSpaceUnit.value,
      "description": propertyDescriptionController.text,
      "video": propertyVideoUrlController.text,
      "beds": selectedBeds.value,
      "bathrooms": selectedBaths.value,
      "condition": selectedCondition.value,
      "year": propertyBuiltYearController.text,
      "neighborhood": propertyNeighborhoodController.text,
      "lat": pickedLocationLatController.text,
      "lng": pickedLocationLngController.text,
      "address": pickedLocationAddressController.text,
      "city": pickedLocationCityController.text,
      "area": pickedLocationAreaController.text,
      "loca": pickedLocationFormattedAddressController.text, //formated address
      "country": pickedLocationCountryController.text,
      "block": pickedLocationBlockController.text,
      "is_active": true,
      "purpose": selectedPurpose.value,
      "region": pickedLocationAreaController.text,
      "period": propertyBuiltYearController.text,
      "currency": selectedCurrencyType.value,
      "features": features,
      'tag_fks': [
        AppConstants.getTagId(selectedPurpose.value),
        AppConstants.getTagId(selectedSubPropertyType.value)
      ]
    };

    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.createProperty,
              body: body,
            ),
            create: () =>
                APIResponse<PropertyModel>(create: () => PropertyModel()),
            apiFunction: submit)
        .then((response) {
      PropertyModel? propertyModel = response.response?.data;
      print(propertyModel.toString());
      if (propertyModel != null) {
        printWrapped("uploading thumbnail");
        _uploadPropertyThumbnail(
          property: propertyModel,
          onComplete: () {
            printWrapped('success');
            printWrapped("uploading images");
            _uploadPropertyImages(
              property: propertyModel,
              onComplete: () {
                isLoading.value = false;
                completion();
              },
            );
          },
        );
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

  ///properties thumbnail uploading/////
  void _uploadPropertyThumbnail(
      {required onComplete, required PropertyModel property}) async {
    var data = dio.FormData.fromMap({
      "thumbnail": await dio.MultipartFile.fromFile(
          thumbnailOfPropertyFile.value!.path,
          filename: "thumbnail.png"),
    });
    String url =
        "${ApiConstants.baseUrl}${ApiConstants.createProperty}${property.id!}/";
    var client = APIClient(isCache: false, baseUrl: url);
    client
        .request(
            route: APIRoute(
              APIType.updateProperty,
              body: data,
            ),
            create: () =>
                APIResponse<PropertyModel>(create: () => PropertyModel()),
            apiFunction: _uploadPropertyThumbnail)
        .then((response) {
      if (response.response?.data != null) {
        onComplete();
      } else {
        isLoading.value = false;
        AppPopUps.showDialog(
            title: 'Error',
            description: "Failed to create property",
            dialogType: DialogType.ERROR);
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

  ///properties images uploading/////
  void _uploadPropertyImages(
      {required onComplete, required PropertyModel property}) async {
    Map<String, dynamic> map = {};

    /* for (var i = 0; i < picturesList.length; i++) {
      map['file[$i]'] = await dio.MultipartFile.fromFile(picturesList[i].path,
          filename: "image");
    }*/

    int i = 0;
    await Future.forEach(picturesList, (element) async {
      map['file[$i]'] = await dio.MultipartFile.fromFile(picturesList[i].path,
          filename: "file[$i].png");
      i++;
    });

    map['property'] = property.id;
    map['len'] = picturesList.length;
    var data = dio.FormData.fromMap(map);

    printWrapped(data.fields.toString());
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.uploadImages,
              body: data,
            ),
            create: () => APIResponse<APIResponse>(decoding: false),
            apiFunction: _uploadPropertyImages)
        .then((response) {
      if ((response.response?.success ?? false)) {
        onComplete();
      } else {
        isLoading.value = false;
        AppPopUps.showDialog(
            title: 'Error',
            description: "Failed to create property",
            dialogType: DialogType.ERROR);
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
