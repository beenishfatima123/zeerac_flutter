import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:zeerac_flutter/common/app_constants.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/property_listing_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_model.dart';
import 'package:zeerac_flutter/modules/users/models/user_login_response_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';

import '../../../dio_networking/api_route.dart';
import '../models/acutions_listing_response_model.dart';
import '../models/cities_model.dart';
import '../models/country_model.dart';
import '../pages/auctions/acution_create_views.dart';
import '../pages/property_listing/property_create_views.dart';

class CreateAuctionController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController auctionPriceController = TextEditingController();

  TextEditingController auctionMaximumFiles = TextEditingController();
  TextEditingController auctionMinimumFiles = TextEditingController();

  TextEditingController auctionSpaceController = TextEditingController();

  TextEditingController auctionAddressController = TextEditingController();

  TextEditingController auctionDescriptionController = TextEditingController();
  TextEditingController auctionNeighborhoodController = TextEditingController();
  TextEditingController auctionTotalFilesController = TextEditingController();

  ///property type
  RxInt activePropertyTypeList = (0).obs;
  RxString propertyTypeMainValue = ''.obs;
  RxInt currentViewIndex = (0).obs;

  final viewsList = [
    AuctionBasicInformationWidget(),
    AuctionLocationPicker(),
    const AuctionPropertyFinalSubmitViewDetails()
  ];

  RxList<File> picturesList = <File>[].obs;

  RxBool isTermsAccepted = false.obs;

  Rxn<Predictions> selectedPredictionCity = Rxn<Predictions>();
  Rxn<Predictions> selectedPredictionArea = Rxn<Predictions>();
  Rxn<CountryModel> selectedCountry = Rxn<CountryModel>();

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

  String getValueFor(String key, PickResult? pickResult) {
    String result = 'not available';

    pickResult?.addressComponents?.forEach((element) {
      if (element.types.contains(key)) {
        result = element.longName;
      }
    });

    return result;
  }

  submit({required completion}) async {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {
      "user_fk": (user?.id ?? 0).toString(),
      "company_fk": (UserDefaults.getIsAdmin() ?? false) ? user!.id : "",
      "purpose": selectedPurpose.value,
      "type": selectedSubPropertyType.value,
      "price": auctionPriceController.text,
      "space": auctionSpaceController.text,
      "unit": AppConstants.spaceUnits[selectedSpaceUnit.value],
      "description": auctionDescriptionController.text,
      "neighborhood": auctionNeighborhoodController.text,
      "currency": selectedCurrencyType.value,
      "address": auctionAddressController.text,
      "country": selectedCountry.value?.name ?? '',
      "city":
          selectedPredictionCity.value?.structuredFormatting?.mainText ?? '',
      "area":
          selectedPredictionArea.value?.structuredFormatting?.mainText ?? '',
      "is_sold": false,
      "is_active_listing": true,
      "min_files": auctionMinimumFiles.text,
      "max_files": auctionMaximumFiles.text,
      "total_files": auctionTotalFilesController.text,
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
              APIType.createFile,
              body: body,
            ),
            create: () =>
                APIResponse<AuctionFileModel>(create: () => AuctionFileModel()),
            apiFunction: submit)
        .then((response) {
      AuctionFileModel? model = response.response?.data;

      if (model != null) {
        _uploadImages(
          model: model,
          onComplete: () {
            isLoading.value = false;
            completion();
          },
        );
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  ///properties images uploading/////
  void _uploadImages(
      {required onComplete, required AuctionFileModel model}) async {
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

    map['property_files_fk'] = model.id;
    map['len'] = picturesList.length;
    var data = dio.FormData.fromMap(map);

    printWrapped(data.fields.toString());
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.postFileImages,
              body: data,
            ),
            create: () => APIResponse<APIResponse>(decoding: false),
            apiFunction: _uploadImages)
        .then((response) {
      if ((response.response?.success ?? false)) {
        onComplete();
      } else {
        isLoading.value = false;
        AppPopUps.showDialogContent(
            title: 'Error',
            description: "Failed to post pictures",
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  Future<List<CountryModel>> getCountriesList() async {
    String data = await rootBundle.loadString('assets/all_countries.json');
    final List jsonResult = json.decode(data);
    return jsonResult.map((e) => CountryModel.fromJson(e)).toList();
  }
}
