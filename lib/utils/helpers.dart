import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../common/styles.dart';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach(
      // ignore: avoid_print
      (match) => print("***${match.group(0)}***"));
}

String formatDateTime(DateTime? dateTime) {
  return DateFormat('dd-MM-yyyy').format(dateTime ?? DateTime.now());
}

int daysDifference({required DateTime from, required DateTime to}) {
// get the difference in term of days, and not just a 24h difference
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);

  return to.difference(from).inDays;
}

myAppBar(
    {String? title,
    Color backGroundColor = AppColor.whiteColor,
    List<Widget>? actions,
    BuildContext? context,
    bool goBack = true,
    onBacKTap}) {
  return AppBar(
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColor.blackColor),
    actions: actions ?? [],
    automaticallyImplyLeading: goBack,
    backgroundColor: backGroundColor,
    title: Text(
      title ?? "",
      style: AppTextStyles.textStyleBoldBodyMedium,
    ),
  );
}

mySwitch(
    {onTap,
    Color? fillColor,
    bool isActive = false,
    Color? checkColor,
    required String message,
    Color? messageColor}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: fillColor ?? AppColor.whiteColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            Icons.check,
            size: 15.0,
            color: isActive ? (checkColor ?? Colors.black) : fillColor,
          ),
        ),
        SizedBox(
          width: 50.w,
        ),
        Text(
          message,
          style: AppTextStyles.textStyleNormalBodySmall
              .copyWith(color: messageColor ?? AppColor.whiteColor),
        )
      ],
    ),
  );
}

Future<void> showDatePickerDialog(
    {required BuildContext context,
    required Function(dynamic date) onDateSelected,
    DatePickerMode initialDatePickerMode = DatePickerMode.day}) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: initialDatePickerMode,
      initialDate: DateTime.now(),
      firstDate: DateTime(1905),
      lastDate: DateTime(3905));
  if (picked != null && picked != DateTime.now()) {
    onDateSelected(DateFormat('yyyy-MM-dd').format(picked));
  }
}

Future pickDateRange({
  required BuildContext context,
  DateTimeRange? initialRange,
  required Function(DateTimeRange date) onRangeSelect,
}) async {
  DateTime now = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: now,
    end: DateTime(now.year, now.month, now.day + 1),
  );

  DateTimeRange? newDateRange = await showDateRangePicker(
    context: context,
    initialDateRange: initialRange ?? dateRange,
    firstDate: DateTime(2019),
    lastDate: DateTime(2023),
  );

  if (newDateRange != null) {
    onRangeSelect(newDateRange);
  }
}

Future<void> showMyTimePicker(
    {required BuildContext context,
    required Function(dynamic date) onTimeSelected,
    TimePickerEntryMode initialDatePickerMode =
        TimePickerEntryMode.dial}) async {
  final TimeOfDay? picked =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (picked != null) {
    onTimeSelected(picked.format(context));
  }
}

Future<void> showMyMonthPicker(
    {required BuildContext context,
    required DateTime initialDate,
    required Function(dynamic date) onMonthSelected,
    TimePickerEntryMode initialDatePickerMode =
        TimePickerEntryMode.dial}) async {
  DateTime? result = await showMonthYearPicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2022),
    lastDate: DateTime(2026),
  );

  if (result != null) {
    onMonthSelected(result);
  }
}
