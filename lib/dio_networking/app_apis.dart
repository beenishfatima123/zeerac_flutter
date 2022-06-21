enum APIType {
  loginUser,
  registerUser,
  registerCompany,
  queryPropertiesList,
  loadMorePropertiesList,
  loadProjects,
  loadCompanies,
  loadCompanyPropertiesListing,
  loadAgents,
  agentzPropertyListing,
  loadBlogs,
  loadUserDetails
}

class ApiConstants {
  static var imageNetworkPlaceHolder =
      'https://rsjlawang.com/assets/images/lightbox/image-3.jpg';
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

  static const loadCompanyPropertiesListing = 'users/agency-listings/';
  static const loadAgents = '/users/agents/';
  static const agentzPropertyListing = '/users/agent-listings/';
  static const loadBlogs = '/users/blogs/';
  static const loadUserDetails = 'users/user/';
}
