import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/presentation/layout/providers/sidebar_provider.dart';
import '../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../features/lab_onboarding/presentation/providers/lab_detail_provider.dart';
import '../features/lab_onboarding/presentation/providers/lab_onboarding_provider.dart';
import '../features/lab_onboarding/presentation/providers/labs_list_provider.dart';
import '../features/pet_parents/presentation/providers/pet_parent_detail_provider.dart';
import '../features/pet_parents/presentation/providers/pet_parents_list_provider.dart';
import '../features/ai_assessments/presentation/providers/ai_assessments_provider.dart';
import '../features/pet_gallery/presentation/providers/pet_gallery_provider.dart';
import '../features/reminders/presentation/providers/reminders_provider.dart';
import '../features/medical_records/presentation/providers/medical_records_provider.dart';
import '../features/pets/presentation/providers/pets_provider.dart';
import '../features/campaigns/presentation/providers/campaign_provider.dart';
import '../features/resource_categories/presentation/providers/resource_category_provider.dart';
import '../features/resources/presentation/providers/resource_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_provider_detail_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_provider_onboarding_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_providers_list_provider.dart';
import '../features/vet_onboarding/presentation/providers/doctor_onboarding_provider.dart';
import '../features/vet_onboarding/presentation/providers/vet_detail_provider.dart';
import '../features/vet_onboarding/presentation/providers/vets_list_provider.dart';
import 'di/injector.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<AdminAuthProvider>.value(
    value: sl<AdminAuthProvider>(),
  ),
  ChangeNotifierProvider<SidebarProvider>(create: (_) => SidebarProvider()),
  ChangeNotifierProvider<DashboardProvider>(
    create: (_) => sl<DashboardProvider>(),
  ),
  ChangeNotifierProvider<DoctorOnboardingProvider>(
    create: (_) => sl<DoctorOnboardingProvider>(),
  ),
  ChangeNotifierProvider<VetsListProvider>(
    create: (_) => sl<VetsListProvider>(),
  ),
  ChangeNotifierProvider<VetDetailProvider>(
    create: (_) => sl<VetDetailProvider>(),
  ),
  ChangeNotifierProvider<ServiceProviderOnboardingProvider>(
    create: (_) => sl<ServiceProviderOnboardingProvider>(),
  ),
  ChangeNotifierProvider<ServiceProvidersListProvider>(
    create: (_) => sl<ServiceProvidersListProvider>(),
  ),
  ChangeNotifierProvider<ServiceProviderDetailProvider>(
    create: (_) => sl<ServiceProviderDetailProvider>(),
  ),
  ChangeNotifierProvider<LabsListProvider>(
    create: (_) => sl<LabsListProvider>(),
  ),
  ChangeNotifierProvider<LabDetailProvider>(
    create: (_) => sl<LabDetailProvider>(),
  ),
  ChangeNotifierProvider<LabOnboardingProvider>(
    create: (_) => sl<LabOnboardingProvider>(),
  ),
  ChangeNotifierProvider<PetParentsListProvider>(
    create: (_) => sl<PetParentsListProvider>(),
  ),
  ChangeNotifierProvider<PetParentDetailProvider>(
    create: (_) => sl<PetParentDetailProvider>(),
  ),
  ChangeNotifierProvider<ResourceCategoryProvider>(
    create: (_) => sl<ResourceCategoryProvider>(),
  ),
  ChangeNotifierProvider<ResourceProvider>(
    create: (_) => sl<ResourceProvider>(),
  ),
  ChangeNotifierProvider<CampaignProvider>(
    create: (_) => sl<CampaignProvider>(),
  ),
  ChangeNotifierProvider<PetsProvider>(
    create: (_) => sl<PetsProvider>(),
  ),
  ChangeNotifierProvider<MedicalRecordsProvider>(
    create: (_) => sl<MedicalRecordsProvider>(),
  ),
  ChangeNotifierProvider<RemindersProvider>(
    create: (_) => sl<RemindersProvider>(),
  ),
  ChangeNotifierProvider<AiAssessmentsProvider>(
    create: (_) => sl<AiAssessmentsProvider>(),
  ),
  ChangeNotifierProvider<PetGalleryProvider>(
    create: (_) => sl<PetGalleryProvider>(),
  ),
];
