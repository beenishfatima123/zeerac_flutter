import 'package:get_storage/get_storage.dart';

class AppConstants {
  ///purpose of property     //1   //2      //11
  static final List<String> purposes = ['Buy', 'Rent', 'For Installment'];

  static final currenciesType = {
    'PKR': 'Pakistani Rupee',
    'TRY': 'Turkish Lira',
    'USD': 'US Dollar',
  };

  ///space Units
  static final spaceUnits = ['Marla', 'Square feet', 'Kanal'];

  ///beds
  static final beds = ['1', '2', '3', '4', '5', '5+'];

  ///baths
  static final baths = ['1', '2', '3', '4', '5', '5+'];

  ///properties type
  static final propertiesType = ['Commercial', 'Residential'];
  static final propertiesTypeList = [
    //3            //4      //5       //6
    ['Shop', 'Buildings', 'Offices', 'Plots'],
    //7          //8         //9          //10
    ['House', 'Flats', 'Upper portion', 'Single Story'],
  ];

  ///baths
  static final propertyCondition = ['New', 'Old', 'Refurbished'];

  static final propertyFeatures = [
    'furnished',
    'parking',
    'electricity',
    'suigas',
    'landline',
    'sewerage',
    'internet'
  ];

  static int getTagId(String key) {
    int value = 0;
    if (key == purposes[0]) {
      value = 1;
    } else if (key == purposes[1]) {
      value = 2;
    } else if (key == purposes[2]) {
      value = 11;
    } else if (key == propertiesTypeList[0][0]) {
      value = 3;
    } else if (key == propertiesTypeList[0][1]) {
      value = 4;
    } else if (key == propertiesTypeList[0][2]) {
      value = 5;
    } else if (key == propertiesTypeList[0][3]) {
      value = 6;
    } else if (key == propertiesTypeList[1][0]) {
      value = 7;
    } else if (key == propertiesTypeList[1][1]) {
      value = 8;
    } else if (key == propertiesTypeList[1][2]) {
      value = 9;
    } else if (key == propertiesTypeList[1][3]) {
      value = 10;
    }
    return value;
  }
}
