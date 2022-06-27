import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zeerac_flutter/common/spaces_boxes.dart';
import 'package:zeerac_flutter/common/styles.dart';
import 'package:zeerac_flutter/modules/users/controllers/trends_controller.dart';
import 'package:zeerac_flutter/modules/users/models/trends_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';
import '../../../../common/loading_widget.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
                Column(
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
                    /*  Expanded(
                      child: Container(
                        width: 500,
                        child: charts.PieChart<String>(
                          defaultRenderer: charts.ArcRendererConfig(
                            customRendererId: 'novoId',
                            arcRendererDecorators: [
                              charts.ArcLabelDecorator(
                                  labelPosition: charts.ArcLabelPosition.auto)
                            ],
                          ),
                          [
                            charts.Series<TrendsModel, String>(
                                id: "pieCharts",
                                displayName: 'Trends',
                                data: controller.trendsModelList,
                                labelAccessorFn: (TrendsModel row, _) =>
                                    '${row.type ?? "--"}',
                                domainFn: (TrendsModel grades, _) =>
                                    grades.propertyCount.toString() ?? '',
                                measureFn: (TrendsModel grades, _) =>
                                    grades.propertyCount ?? 0)
                          ],
                          animate: true,
                        ),
                      ),
                    ),*/
                    Expanded(
                        child: pie.PieChart(
                      dataMap: {
                        for (var item in controller.trendsModelList)
                          item.type ?? '': (item.propertyCount ?? 0).toDouble()
                      },
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 40,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,

                      initialAngleInDegree: 0,
                      chartType: pie.ChartType.ring,
                      ringStrokeWidth: 20,
                      centerText: controller.selectedPredictionCity.value
                              ?.structuredFormatting?.mainText ??
                          '-',
                      legendOptions: const pie.LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: pie.LegendPosition.top,
                        showLegends: true,
                        //legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      chartValuesOptions: const pie.ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                        decimalPlaces: 3,
                      ),
                      // gradientList: ---To add gradient colors---
                      // emptyColorGradient: ---Empty Color gradient---
                    )),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: 500.h,
                          width: 1000,
                          child: charts.BarChart(
                            behaviors: [charts.PanAndZoomBehavior()],
                            barRendererDecorator:
                                charts.BarLabelDecorator<String>(
                                    labelPosition:
                                        charts.BarLabelPosition.auto),
                            domainAxis: const charts.OrdinalAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(
                                  labelRotation: 60),
                            ),
                            [
                              charts.Series<TrendsModel, String>(
                                  id: 'Trends',
                                  colorFn: (_, __) =>
                                      charts.MaterialPalette.blue.shadeDefault,
                                  domainFn: (TrendsModel sales, _) =>
                                      sales.type ?? '-',
                                  measureFn: (TrendsModel sales, _) =>
                                      sales.propertyCount,
                                  data: controller.trendsModelList,
                                  labelAccessorFn: (TrendsModel trendsModel,
                                          _) =>
                                      "${trendsModel.area.toString()} (${trendsModel.propertyCount.toString()})"),
                            ],
                            animate: true,
                          ),
                        ),
                      ),
                    ),
                  ],
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
