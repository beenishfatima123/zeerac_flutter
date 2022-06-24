import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/trends_controller.dart';
import 'package:zeerac_flutter/modules/users/models/trends_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';

class TrendsDetailPage extends GetView<TrendsController> {
  const TrendsDetailPage({Key? key}) : super(key: key);
  static const id = '/TrendsDetailPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'Trends'),
      body: GetX<TrendsController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 50.w, vertical: 5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      vSpace,
                      Text(controller.selectedCountry.value?.name ?? '',
                          style: AppTextStyles.textStyleBoldBodyMedium),
                      Text(
                          controller.selectedPredictionCity.value
                                  ?.structuredFormatting?.mainText ??
                              '',
                          style: AppTextStyles.textStyleNormalBodyXSmall),
                      Text(
                          controller.selectedPredictionArea.value
                                  ?.structuredFormatting?.mainText ??
                              '',
                          style: AppTextStyles.textStyleNormalBodyXSmall),
                      vSpace,
                      Container(
                        child: SfCartesianChart(series: <ChartSeries>[
                          SplineSeries<TrendsModel, String>(
                              dataSource: controller.trendsModelList,
                              // Type of spline
                              splineType: SplineType.cardinal,
                              cardinalSplineTension: 0.9,
                              xValueMapper: (TrendsModel data, _) => data.area,
                              yValueMapper: (TrendsModel data, _) =>
                                  data.propertyCount)
                        ]),
                      )
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
