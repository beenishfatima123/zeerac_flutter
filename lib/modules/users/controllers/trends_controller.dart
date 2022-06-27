import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/dio_networking/api_client.dart';
import 'package:zeerac_flutter/dio_networking/api_response.dart';
import 'package:zeerac_flutter/modules/users/models/country_model.dart';
import 'package:zeerac_flutter/modules/users/models/trends_model.dart';
import 'package:zeerac_flutter/utils/app_pop_ups.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../models/cities_model.dart';

class TrendsController extends GetxController {
  RxBool isLoading = false.obs;

  Rxn<Predictions> selectedPredictionCity = Rxn<Predictions>();
  Rxn<Predictions> selectedPredictionArea = Rxn<Predictions>();
  Rxn<CountryModel> selectedCountry = Rxn<CountryModel>();
  List<TrendsModel> trendsModelList = [];

  Future<List<CountryModel>> getCountriesList() async {
    String data = await rootBundle.loadString('assets/all_countries.json');
    final List jsonResult = json.decode(data);
    return jsonResult.map((e) => CountryModel.fromJson(e)).toList();
  }

  void searchForTrends({required onComplete}) {
    isLoading.value = true;
    Map<String, dynamic> body = {
      "country": selectedCountry.value?.name ?? '',
      "city":
          selectedPredictionCity.value?.structuredFormatting?.mainText ?? '',
      "area":
          selectedPredictionArea.value?.structuredFormatting?.mainText ?? '',
    };

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.searchForTrends,
              body: body,
            ),
            create: () =>
                APIListResponse<TrendsModel>(create: () => TrendsModel()),
            apiFunction: searchForTrends)
        .then((response) {
      isLoading.value = false;
      if (response.response?.data != null) {
        trendsModelList.clear();
        trendsModelList.addAll(response.response!.data!);
      }
      if (trendsModelList.isNotEmpty) {
        onComplete();
      } else {
        AppPopUps.showDialog(
            title: 'Alert',
            description: 'No data found..',
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
