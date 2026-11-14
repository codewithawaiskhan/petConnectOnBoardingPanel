import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_services.dart';
import '../../features/admin_auth/di/admin_auth_injector.dart';
import '../../features/campaigns/di/campaign_injector.dart';
import '../../features/medical_records/di/medical_records_injector.dart';
import '../../features/reminders/di/reminders_injector.dart';
import '../../features/ai_assessments/di/ai_assessments_injector.dart';
import '../../features/pet_gallery/di/pet_gallery_injector.dart';
import '../../features/pets/di/pets_injector.dart';
import '../../features/dashboard/di/dashboard_injector.dart';
import '../../features/lab_onboarding/di/lab_onboarding_injector.dart';
import '../../features/pet_parents/di/pet_parents_injector.dart';
import '../../features/resource_categories/di/resource_categories_injector.dart';
import '../../features/resources/di/resource_injector.dart';
import '../../features/service_provider_onboarding/di/service_provider_onboarding_injector.dart';
import '../../features/vet_onboarding/di/vet_onboarding_injector.dart';
import '../../features/withdrawal_requests/di/withdrawal_injector.dart';
import '../../features/marketing_companies/di/marketing_companies_injector.dart';
import '../../features/commission_settings/di/commission_settings_injector.dart';
import '../../features/company_dashboard/di/company_dashboard_injector.dart';
import '../../features/my_team/di/my_team_injector.dart';
import '../../features/assignment_requests/di/assignment_requests_injector.dart';
import '../../features/company_wallet/di/company_wallet_injector.dart';
import '../../features/company_redemptions/di/company_redemptions_injector.dart';
import '../../features/company_payouts_admin/di/company_payouts_injector.dart';
import '../../shared/taxonomy/di/taxonomy_injector.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton<ApiServices>(() => ApiServices());

  initTaxonomyDependencies();

  initAdminAuthDependencies();
  initDashboardDependencies();
  initVetOnboardingDependencies();
  initServiceProviderOnboardingDependencies();
  initLabOnboardingDependencies();
  initPetParentsDependencies();
  initPetsDependencies();
  initMedicalRecordsDependencies();
  initRemindersDependencies();
  initAiAssessmentsDependencies();
  initPetGalleryDependencies();
  initResourceCategoriesDependencies();
  initResourceDependencies();
  initCampaignDependencies();
  initWithdrawalDependencies();
  initMarketingCompaniesDependencies();
  initCommissionSettingsDependencies();
  initCompanyDashboardDependencies();
  initMyTeamDependencies();
  initAssignmentRequestsDependencies();
  initCompanyWalletDependencies();
  initCompanyRedemptionsDependencies();
  initCompanyPayoutsDependencies();
}
