import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/modules/users/models/user_preference_post_response_model.dart';

import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/user_defaults.dart';
import '../models/cities_model.dart';
import '../models/country_model.dart';
import '../models/user_model.dart';

class ChangeUserPreferenceController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt previousPreferenceValue = (-1).obs;

  RxString selectedSubPropertyType = ''.obs;
  RxString selectedPurpose = ''.obs;
  RxInt activePropertyTypeList = (0).obs;
  RxString propertyTypeMainValue = ''.obs;
  RxString selectedSpaceUnit = ''.obs;

  TextEditingController propertyBuiltYearController = TextEditingController();
  RxBool isNewlyConstructed = false.obs;

  Rxn<CountryModel> selectedCountry = Rxn<CountryModel>();
  Rxn<Predictions> selectedPredictionCity = Rxn<Predictions>();
  Rxn<Predictions> selectedPredictionArea = Rxn<Predictions>();

  Rx<RangeValues> propertyPriceRangeValue = const RangeValues(0, 100).obs;

  Rx<RangeValues> propertyPlotRangeValue = const RangeValues(0, 100).obs;

  void changeSelectedPropertyType(String value) {
    if (value == AppConstants.propertiesType[0]) {
      activePropertyTypeList.value = 0;
    } else if (value == AppConstants.propertiesType[1]) {
      activePropertyTypeList.value = 1;
    }
  }

  Future<List<CountryModel>> getCountriesList() async {
    String data = await rootBundle.loadString('assets/all_countries.json');
    final List jsonResult = json.decode(data);
    return jsonResult.map((e) => CountryModel.fromJson(e)).toList();
  }

  submitPreferences({required completion}) async {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {
      "price_min": propertyPriceRangeValue.value.start.round().toString(),
      "price_max": propertyPriceRangeValue.value.end.round().toString(),
      "year_build": propertyBuiltYearController.text,
      "space_min": propertyPlotRangeValue.value.start.round().toString(),
      "space_max": propertyPlotRangeValue.value.end.round().toString(),
      "unit": AppConstants.spaceUnits[selectedSpaceUnit.value],
      "city":
          selectedPredictionCity.value?.structuredFormatting?.mainText ?? '',
      "area":
          selectedPredictionArea.value?.structuredFormatting?.mainText ?? '',
      "country": selectedCountry.value?.name ?? '',
      "user_fk": (user?.id ?? 0),
      "newly_constructed": isNewlyConstructed.value,
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
              APIType.postUserPreference,
              body: body,
            ),
            create: () => APIResponse<UserPreferencePostModel>(
                create: () => UserPreferencePostModel()),
            apiFunction: submitPreferences)
        .then((response) {
      isLoading.value = false;

      UserPreferencePostModel? model = response.response?.data;
      print(model.toString());
      completion();
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialog(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void getPreferences() {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'user_id': user?.id ?? -0};

    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getUserPreferences,
              body: body,
            ),
            create: () => APIListResponse<UserPreferencePostModel>(
                create: () => UserPreferencePostModel()),
            apiFunction: submitPreferences)
        .then((response) {
      isLoading.value = false;

      UserPreferencePostModel? model = response.response?.data?.last;
      if (model != null) {
        _setValues(model);
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

  void _setValues(UserPreferencePostModel model) {
    previousPreferenceValue.value = model.id ?? -1;
    propertyBuiltYearController.text = model.yearBuild.toString();
    selectedPurpose.value = AppConstants.getTagName(model.tagFks![0].id ?? -1);
  }

  void updatePreference({required completion}) {}
}
