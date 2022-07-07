import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/modules/users/models/acutions_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/biding_list_response_model.dart';
import 'package:zeerac_flutter/utils/user_defaults.dart';
import '../../../dio_networking/api_client.dart';
import '../../../dio_networking/api_response.dart';
import '../../../dio_networking/api_route.dart';
import '../../../dio_networking/app_apis.dart';
import '../../../utils/app_pop_ups.dart';
import '../../../utils/helpers.dart';

class AuctionBidDetailController extends GetxController {
  RxBool isLoading = false.obs;
  AuctionFileModel? auctionFileModel;
  RxList<BidModel?> biddingList = <BidModel?>[].obs;

  TextEditingController bidPriceTextController = TextEditingController();
  TextEditingController bidFilesCountTextController = TextEditingController();

  ///pagination for bidings
  int pageToLoad = 1;
  bool hasNewPage = false;

  void initValues(AuctionFileModel auctionFileModel) {
    this.auctionFileModel = auctionFileModel;
  }

  ///load bidding of the selected auctions
  String propertyFieldId = '';

  void loadBiddingOfAuction(
      {bool showAlert = false, required String propertyFileId}) {
    biddingList.clear();
    isLoading.value = true;
    propertyFieldId = propertyFileId;
    Map<String, dynamic> body = {
      'property_file_id': propertyFileId,
      'page': pageToLoad.toString(),
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getPropertyFilesBid,
              body: body,
            ),
            create: () => APIResponse<BidingListResponseModel>(
                create: () => BidingListResponseModel()),
            apiFunction: loadBiddingOfAuction)
        .then((response) {
      isLoading.value = false;
      if ((response.response?.data?.results?.length ?? 0) > 0) {
        if ((response.response?.data?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        biddingList.addAll(response.response!.data!.results!);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No bidding found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      isLoading.value = false;

      ///not showing any dialog because this method will be called on the app start when controller gets initialized
      if (showAlert) {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: error.toString(),
            dialogType: DialogType.ERROR);
      }
      return Future.value(null);
    });
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");
        if (hasNewPage) {
          loadBiddingOfAuction(propertyFileId: propertyFieldId);
        }
      }
    }
    return false;
  }

  void placeYourBid() {
    isLoading.value = true;
    Map<String, dynamic> body = {
      'price': bidPriceTextController.text,
      'user_fk': UserDefaults.getCurrentUserId(),
      'property_files_fk': propertyFieldId,
      'file_count': bidFilesCountTextController.text,
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.placeYourPropertyBid,
              body: body,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: placeYourBid)
        .then((response) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Success',
          description: 'Your bid has been placed',
          dialogType: DialogType.SUCCES);
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);

      return Future.value(null);
    });
  }
}
