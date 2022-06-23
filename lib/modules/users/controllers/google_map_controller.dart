import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zeerac_flutter/dio_networking/app_apis.dart';
import 'package:zeerac_flutter/modules/users/models/google_nearby_search_place_response_model.dart';
import 'package:zeerac_flutter/utils/helpers.dart';

class MyGoogleMapController extends GetxController {
  RxBool isLoading = false.obs;
  Set<Circle>? circles;
  late LatLng propertyLatLng;
  Set<Marker> markers = {};
  RxDouble radiusForCircle = (500.0).obs;
  GoogleMapController? googleMapController;
  late CameraPosition propertyPosition;
  final items = ['school', 'restaurant', 'hospital', 'pharmacy', 'museum'];
  RxInt selectedItem = (-1).obs;
  String? propertyName;

/////////////////////////////
  void initialize(
      {required double lat,
      required double lng,
      required String? propertyName}) {
    this.propertyName = propertyName;
    propertyLatLng = LatLng(lat, lng);

    propertyPosition = CameraPosition(
      ///if not found then showing office address
      target: propertyLatLng,
      zoom: 14.4746,
    );
    addMarker(propertyLatLng, propertyName ?? '-', '');
    setCircleRadius();
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void addMarker(LatLng mLatLng, String mTitle, String mDescription) {
    markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(("${mTitle}_${markers.length}").toString()),
      position: mLatLng,
      infoWindow: InfoWindow(
        title: mTitle,
        snippet: mDescription,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void setCircleRadius() {
    circles = {
      Circle(
        circleId: const CircleId('radius'),
        center: propertyLatLng,
        radius: radiusForCircle.value,
        fillColor: Colors.blue.shade100.withOpacity(0.5),
        strokeColor: Colors.blue.shade100.withOpacity(0.1),
      )
    };
  }

  void searchForLocation({required String type}) async {
    isLoading.value = true;
    Map<String, dynamic> query = {
      'type': type,
      'location':
          "${propertyLatLng.latitude.toString()},${propertyLatLng.longitude.toString()}",
      'radius': radiusForCircle.value,
      'key': ApiConstants.googleApiKey,
    };
    dio.Response response = await dio.Dio()
        .get(ApiConstants.googleNearByPlacesSearch, queryParameters: query);
    if (response.statusCode == 200) {
      try {
        GoogleNearBySearchResponseModel responseModel =
            GoogleNearBySearchResponseModel.fromJson(response.data);
        markers.clear();
        List<LatLng> list = [];

        addMarker(propertyLatLng, propertyName ?? 'Location', '');
        // 31.4713968,74.2705732
        responseModel.results?.forEach((element) {
          printWrapped(element.name ?? '-');

          list.add(LatLng(element.geometry?.location?.lat ?? 31.4713968,
              element.geometry?.location?.lng ?? 74.2705732));

          addMarker(
              LatLng(element.geometry?.location?.lat ?? 31.4713968,
                  element.geometry?.location?.lng ?? 74.2705732),
              element.name ?? '-',
              element.vicinity ?? '--');
        });

        if (list.length > 1 && googleMapController != null) {
          LatLngBounds bounds = _boundsFromLatLngList(list);
          CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);
          await checkCameraLocation(cameraUpdate, googleMapController!);
        }
      } finally {
        isLoading.value = false;
      }
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > (x1 ?? 0)) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > (y1 ?? 0)) y1 = latLng.longitude;
        if (latLng.longitude < (y0 ?? double.infinity)) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1 ?? 0, y1 ?? 0),
      southwest: LatLng(x0 ?? 0, y0 ?? 0),
    );
  }

  /////not being used
  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
}
