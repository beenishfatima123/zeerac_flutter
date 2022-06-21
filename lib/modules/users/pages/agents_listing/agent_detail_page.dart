import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/common_widgets.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/controllers/agent_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/company_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/models/agents_listing_response_model.dart';
import 'package:zeerac_flutter/modules/users/models/companies_response_model.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_listing_widgets.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import 'package:zeerac_flutter/utils/myAnimSearchBar.dart';
import '../../../../common/loading_widget.dart';
import '../../models/property_listing_model.dart';

class AgentDetailPage extends GetView<AgentDetailController> {
  AgentDetailPage({Key? key}) : super(key: key);
  static const id = '/AgentDetailPage';
  final AgentsModel? companyModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AgentDetailController>(
        initState: (state) {
          if (companyModel != null) {
            controller.initValues(companyModel!);
            controller.loadAgentzPropertiesFromServer();
          }
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                (controller.agentsModel == null)
                    ? Text('No Detail Found',
                        style: AppTextStyles.textStyleBoldBodyMedium)
                    : NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              expandedHeight: 300.h,
                              backgroundColor:
                                  AppColor.blackColor.withOpacity(0.5),
                              floating: false,
                              snap: false,
                              pinned: false,
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (controller.agentsModel?.username ?? ''),
                                    style: AppTextStyles.textStyleBoldBodyMedium
                                        .copyWith(color: AppColor.whiteColor),
                                  ),
                                  Text(
                                    controller.agentsModel?.area ?? '-',
                                    style: AppTextStyles.textStyleBoldBodySmall
                                        .copyWith(color: AppColor.whiteColor),
                                  ),
                                ],
                              ),
                              flexibleSpace: FlexibleSpaceBar(
                                title: Text(
                                    controller.agentsModel?.username ?? '',
                                    style: AppTextStyles
                                        .textStyleNormalBodyMedium
                                        .copyWith(color: AppColor.whiteColor)),
                                background: Opacity(
                                  opacity: 0.7,
                                  child: NetworkPlainImage(
                                    height: 350.h,
                                    url:
                                        "${ApiConstants.baseUrl}${controller.agentsModel?.photo ?? ''}",
                                  ),
                                ),
                                collapseMode: CollapseMode.pin,
                              ),
                              onStretchTrigger: () async {
                                controller.isSliverExpanded.value = true;
                              },
                            ),
                          ];
                        },
                        body: Column(
                          children: [
                            Expanded(
                              child: NotificationListener(
                                onNotification: controller.onScrollNotification,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ///description
                                        Text(
                                          controller.agentsModel?.address ?? '',
                                          style: AppTextStyles
                                              .textStyleNormalLargeTitle,
                                        ),

                                        ///location

                                        Text(
                                          controller.agentsModel?.area ?? '-',
                                          style: AppTextStyles
                                              .textStyleNormalBodyMedium,
                                        ),

                                        Text(
                                          "${controller.agentsModel?.city ?? '-'},${controller.agentsModel?.country ?? '-'}",
                                          style: AppTextStyles
                                              .textStyleNormalBodyMedium,
                                        ),
                                        const Divider(),
                                        Text(
                                          "Details",
                                          style: AppTextStyles
                                              .textStyleBoldSubTitleLarge,
                                        ),
                                        vSpace,
                                        keyValueRowWidget(
                                            title: "First Name",
                                            value: controller
                                                    .agentsModel?.firstName
                                                    .toString() ??
                                                '-',
                                            isGrey: true),

                                        keyValueRowWidget(
                                            title: "Last Name",
                                            value: controller
                                                    .agentsModel?.lastName
                                                    .toString() ??
                                                '-',
                                            isGrey: false),
                                        keyValueRowWidget(
                                            title: "Full Name",
                                            value: controller
                                                    .agentsModel?.fullName
                                                    .toString() ??
                                                '-',
                                            isGrey: true),

                                        keyValueRowWidget(
                                            title: "Email",
                                            value: controller.agentsModel?.email
                                                    .toString() ??
                                                '-',
                                            isGrey: false),
                                        keyValueRowWidget(
                                            title: "Agent Id",
                                            value: controller.agentsModel?.id
                                                    .toString() ??
                                                '-',
                                            isGrey: true),

                                        keyValueRowWidget(
                                            title: "Country",
                                            value: controller
                                                    .agentsModel?.country
                                                    .toString() ??
                                                '-',
                                            isGrey: false),
                                        keyValueRowWidget(
                                            title: "City",
                                            value: controller.agentsModel?.city
                                                    .toString() ??
                                                '-',
                                            isGrey: true),
                                        keyValueRowWidget(
                                            title: "Area",
                                            value: controller.agentsModel?.area
                                                    .toString() ??
                                                '-',
                                            isGrey: false),
                                        keyValueRowWidget(
                                            title: "Company",
                                            value: controller
                                                    .agentsModel?.company
                                                    .toString() ??
                                                '-',
                                            isGrey: true),
                                        keyValueRowWidget(
                                            title: "Active Listing",
                                            value: controller.agentsModel
                                                    ?.activeListingCount
                                                    .toString() ??
                                                '-',
                                            isGrey: true),

                                        vSpace, vSpace,
                                        vSpace, vSpace,

                                        ListView.builder(
                                            itemCount: controller
                                                    .agentsPropertiesList
                                                    ?.length ??
                                                0,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return propertiesWidget(controller
                                                      .agentsPropertiesList![
                                                  index]);
                                            }),

/*
                                        StreamBuilder(
                                            stream: controller
                                                .loadCompanyzPropertiesFromServer(),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        List<PropertyModel>?>
                                                    snapShot) {
                                              if (snapShot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              if (snapShot.hasError) {
                                                return const Center(
                                                    child: Text(
                                                        'An error occurred'));
                                              }

                                              if (snapShot.hasData &&
                                                  snapShot.data != null) {
                                                return snapShot.data!.isNotEmpty
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Listings',
                                                              style: AppTextStyles
                                                                  .textStyleBoldBodyMedium),
                                                          vSpace,
                                                          ListView.builder(
                                                              itemCount: snapShot
                                                                      .data
                                                                      ?.length ??
                                                                  0,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return propertiesWidget(
                                                                    snapShot.data![
                                                                        index]);
                                                              }),
                                                        ],
                                                      )
                                                    : const Center(
                                                        child:
                                                            Text('No Listing'));
                                              }

                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }),*/
                                        vSpace,
                                        vSpace, vSpace,
                                        vSpace,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            ///contact widgets
                            Container(
                              color: AppColor.alphaGrey,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  hSpace,
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    AppColor.primaryBlueColor)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.email_outlined),
                                            hSpace,
                                            Flexible(
                                              child: Text(
                                                "Email",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles
                                                    .textStyleBoldBodySmall,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  hSpace,
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    AppColor.primaryBlueColor)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.call),
                                            hSpace,
                                            Flexible(
                                                child: Text(
                                              "Call",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles
                                                  .textStyleBoldBodySmall,
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  hSpace,
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    AppColor.primaryBlueColor)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.message),
                                            hSpace,
                                            Flexible(
                                                child: Text(
                                              "Message",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles
                                                  .textStyleBoldBodySmall,
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  hSpace,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
