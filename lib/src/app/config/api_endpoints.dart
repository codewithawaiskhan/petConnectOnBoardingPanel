mixin ApiEndpoints {
  static String webUrl = "https://petconnect.example.com";
  static String baseUrl = "https://server.petaccessapp.com";
  static String storageBaseUrl = "https://api.petconnect.example.com";

  static String apiUrl = "$baseUrl/api";

  static String adminLogin = "$apiUrl/admin/login";

  static String adminDashboardData = "$apiUrl/dashboard/admin-dashboard-data";

  static String doctorDataEntry = "$apiUrl/doctor/data-entry";
  static String specialities = "$apiUrl/speciality/for-app";
  static String services = "$apiUrl/service";

  static String serviceProviderDataEntry =
      "$apiUrl/service-provider/data-entry";
  static String petCategories = "$apiUrl/pet-category";

  static String doctors = "$apiUrl/doctor/";
  static String doctorDetail(String id) => "$apiUrl/doctor/$id";
  static String serviceProviders = "$apiUrl/service-provider/";
  static String serviceProviderDetail(String id) =>
      "$apiUrl/service-provider/$id";

  static String labs = "$apiUrl/lab/";
  static String labDetail(String id) => "$apiUrl/lab/$id";
  static String labTestCategories = "$apiUrl/lab-test-category";
  static String labDataEntry = "$apiUrl/lab/data-entry";

  static String petParents = "$apiUrl/pet-parent/";
  static String petParentDetail(String id) => "$apiUrl/pet-parent/$id";

  static const String cachedUserKey = 'CACHED_USER';
  static const String authTokenKey = 'AUTH_TOKEN';
  static const String cachedProfileKey = 'CACHED_PROFILE_KEY';
}
