import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zeerac_flutter/modules/users/controllers/add_new_agent_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/agent_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/agents_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/blog_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/blog_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/company_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/company_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/dash_board_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/google_map_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/home_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/projects_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_create_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_detail_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/property_listing_page_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/search_filter_listing_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/signup_controller.dart';
import 'package:zeerac_flutter/modules/users/controllers/user_profile_controller.dart';
import 'package:zeerac_flutter/modules/users/pages/agents_listing/agent_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/agents_listing/agents_page.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/blogs/blog_listing_page.dart';
import 'package:zeerac_flutter/modules/users/pages/company_listing/company_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/dashboard/dashboard_page.dart';
import 'package:zeerac_flutter/modules/users/pages/google_map_nearby_places_page.dart';
import 'package:zeerac_flutter/modules/users/pages/home/search_filter_listing_page.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_create_page.dart';
import 'package:zeerac_flutter/modules/users/pages/property_listing/property_detail_page.dart';
import 'package:zeerac_flutter/modules/users/pages/sign_up/sign_up_page.dart';
import 'package:zeerac_flutter/modules/users/pages/user_profile/user_profile_page.dart';
import '../modules/users/controllers/login_controller.dart';
import '../modules/users/controllers/project_detail_controller.dart';
import '../modules/users/pages/agents_listing/add_new_agent_page.dart';
import '../modules/users/pages/login/login_page.dart';
import '../modules/users/pages/projects_listing/project_details_page.dart';
import '../modules/users/pages/property_listing/property_listing_page.dart';

appRoutes() {
  return [
    GetPage(
        name: LoginPage.id,
        page: () => LoginPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(
            () => LoginController(),
          );
        })),
    GetPage(
        name: SignupPage.id,
        page: () => const SignupPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SignupController>(
            () => SignupController(),
          );
        })),
    GetPage(
        name: DashBoardPage.id,
        page: () => DashBoardPage(),
        binding: BindingsBuilder(() {
          Get.put(DashBoardController());
          Get.put(HomeController());
          Get.put(ProjectsController());
          Get.put(CompanyListingController());
          Get.put(AgentsListingController());
          Get.put(BlogListingController());
        })),
    GetPage(
        name: SearchFilterListingPage.id,
        page: () => const SearchFilterListingPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SearchFilterListingController>(
            () => SearchFilterListingController(),
          );
        })),
    GetPage(
        name: PropertyListingPage.id,
        page: () => PropertyListingPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<PropertyListingPageController>(
            () => PropertyListingPageController(),
          );
        })),
    GetPage(
        name: PropertyDetailsPage.id,
        page: () => PropertyDetailsPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<PropertyDetailController>(
            () => PropertyDetailController(),
          );
        })),
    GetPage(
        name: GoogleMapPageNearByPlaces.id,
        page: () => GoogleMapPageNearByPlaces(),
        binding: BindingsBuilder(() {
          Get.lazyPut<MyGoogleMapController>(
            () => MyGoogleMapController(),
          );
        })),
    GetPage(
        name: ProjectDetailPage.id,
        page: () => ProjectDetailPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ProjectDetailController>(
            () => ProjectDetailController(),
          );
        })),
    GetPage(
        name: CompanyDetailPage.id,
        page: () => CompanyDetailPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<CompanyDetailController>(
            () => CompanyDetailController(),
          );
        })),
    GetPage(
        name: AgentDetailPage.id,
        page: () => AgentDetailPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AgentDetailController>(
            () => AgentDetailController(),
          );
        })),
    GetPage(
        name: AddNewAgentPage.id,
        page: () => AddNewAgentPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AddNewAgentController>(
            () => AddNewAgentController(),
          );
        })),
    GetPage(
        name: BlogDetailPage.id,
        page: () => BlogDetailPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<BlogDetailController>(
            () => BlogDetailController(),
          );
        })),
    GetPage(
        name: UserProfilePage.id,
        page: () => UserProfilePage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<UserProfileController>(
            () => UserProfileController(),
          );
        })),
    GetPage(
        name: PropertyCreatePage.id,
        page: () => PropertyCreatePage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<PropertyCreateController>(
            () => PropertyCreateController(),
          );
        })),
  ];
}
