mixin ApiEndpoints {
  static String baseUrl = "https://server.petaccessapp.com";
  static String storageBaseUrl =
      "https://petaccessapp.s3.us-east-1.amazonaws.com";

  static String apiUrl = "$baseUrl/api";

  static String adminLogin = "$apiUrl/admin/login";

  static String adminDashboardData = "$apiUrl/dashboard/admin-dashboard-data";
  static String topCountries = "$apiUrl/dashboard/top-countries";

  static String doctorDataEntry = "$apiUrl/doctor/data-entry";
  static String specialities = "$apiUrl/speciality/for-app";
  static String services = "$apiUrl/service";

  static String serviceProviderDataEntry =
      "$apiUrl/service-provider/data-entry";
  static String petCategories = "$apiUrl/pet-category";

  static String doctors = "$apiUrl/doctor/";
  static String doctorDetail(String id) => "$apiUrl/doctor/$id";
  static String updateDoctor(String id) => "$apiUrl/doctor/$id";
  static String deleteDoctor(String id) => "$apiUrl/doctor/$id";
  static String serviceProviders = "$apiUrl/service-provider/";
  static String serviceProviderDetail(String id) =>
      "$apiUrl/service-provider/$id";
  static String updateServiceProvider(String id) =>
      "$apiUrl/service-provider/$id";
  static String deleteServiceProvider(String id) =>
      "$apiUrl/service-provider/$id";

  static String labs = "$apiUrl/lab/";
  static String labDetail(String id) => "$apiUrl/lab/$id";
  static String updateLab(String id) => "$apiUrl/lab/$id";
  static String deleteLab(String id) => "$apiUrl/lab/$id";
  static String labTestCategories = "$apiUrl/lab-test-category";
  static String labDataEntry = "$apiUrl/lab/data-entry";

  static String petParents = "$apiUrl/pet-parent/";
  static String petParentDetail(String id) => "$apiUrl/pet-parent/$id";
  static String updatePetParent(String id) => "$apiUrl/pet-parent/$id";
  static String updatePetParentPassword(String id) =>
      "$apiUrl/pet-parent/update-password/$id";
  static String pets = "$apiUrl/pet";
  static String petsByParent(String parentId) =>
      "$pets?petParentObjectId=$parentId";
  static String medicalRecords = "$apiUrl/medical-record/";
  static String medicalRecordsByUser(String userId) =>
      "$medicalRecords?user=$userId";
  static String reminders = "$apiUrl/v1/reminder/";
  static String remindersByUser(String userId) =>
      "$reminders?user=$userId";
  static String aiAssessments = "$apiUrl/v1/ai-assessments/";
  static String aiAssessmentsByUser(String userId) =>
      "$aiAssessments?user=$userId";
  static String petGallery = "$apiUrl/v1/pet-gallery/";
  static String petGalleryByUser(String userId) =>
      "$petGallery?user=$userId";

  static String postCategories = "$apiUrl/post-category";
  static String getPostCategories = "$apiUrl/post-category";
  static String postCategoryDetail(String id) => "$apiUrl/post-category/$id";
  static String updatePostCategory(String id) => "$apiUrl/post-category/$id";
  static String deletePostCategory(String id) => "$apiUrl/post-category/$id";

  static String posts = "$apiUrl/post";
  static String postDetail(String id) => "$apiUrl/post/$id";
  static String updatePost(String id) => "$apiUrl/post/$id";
  static String deletePost(String id) => "$apiUrl/post/$id";

  static String campaigns = "$apiUrl/campaign/";
  static String campaignDetail(String id) => "$apiUrl/campaign/$id";
  static String updateCampaign(String id) => "$apiUrl/campaign/$id";
  static String deleteCampaign(String id) => "$apiUrl/campaign/$id";

  static const String cachedUserKey = 'CACHED_USER';
  static const String authTokenKey = 'AUTH_TOKEN';
  static const String cachedProfileKey = 'CACHED_PROFILE_KEY';
}
