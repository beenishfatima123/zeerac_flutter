enum APIType {
  loginUser,
  registerUser,
  registerCompany,
  queryPropertiesList,
  loadMorePropertiesList,
  loadProjects,
  loadCompanies,
}

class ApiConstants {
  static var imageNetworkPlaceHolder =
      'https://demofree.sirv.com/nope-not-here.jpg';
  static const googleApiKey = 'AIzaSyC0-5OqwY75sPwoncSujsbkJD6wDU7BvOw';
  static const baseUrl = "https://api.zeerac.com/";
  static const loginUser = 'users/api/login';
  static const registerUser = 'users/user/';
  static const registerCompany = 'users/company/';
  static const queryPropertiesList = 'users/property/';
  static const loadProjects = '/users/project/';
  static const googleNearByPlacesSearch =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  static const loadCompanies = '/users/company/';
}
