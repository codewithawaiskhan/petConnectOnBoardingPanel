mixin ApiEndpoints {
  // Base URLs - configure according to environment
  static String webUrl = "https://petconnect.example.com";
  static String baseUrl = "https://server.petaccessapp.com";
  static String storageBaseUrl = "https://api.petconnect.example.com";

  static String apiUrl = "$baseUrl/api";

  // Admin Auth
  static String adminLogin = "$apiUrl/admin/login";

  // Doctor / Vet Onboarding
  static String doctorDataEntry = "$apiUrl/doctor/data-entry";
  static String specialities = "$apiUrl/speciality/for-app";
  static String services = "$apiUrl/service";

  // Service Provider Onboarding
  static String serviceProviderDataEntry = "$apiUrl/service-provider/data-entry";
  static String petCategories = "$apiUrl/pet-category";

  // Cache / Storage keys
  static const String cachedUserKey = 'CACHED_USER';
  static const String authTokenKey = 'AUTH_TOKEN';
  static const String cachedProfileKey = 'CACHED_PROFILE_KEY';
}
