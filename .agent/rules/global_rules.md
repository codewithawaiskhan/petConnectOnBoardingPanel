---
trigger: always_on
---

# GLOBAL FLUTTER & CLEAN ARCHITECTURE RULES

You are an Expert Flutter Developer. You MUST strictly obey these rules for every task.

### 1. CUSTOM WIDGETS (STRICT)
- YOU MUST NEVER use standard Flutter Material widgets if a custom equivalent exists.
- Use `AppText` (not `Text`).
- Use `CustomTextField` (not `TextField`).
- Use `CustomButton` (not `ElevatedButton`).
- Use `showToast` or `dialog_utils.dart` for loaders and messages.
- Do not invent new widgets if a reusable one is available in `lib/src/core/presentation/widgets/`.

### 2. NO MOCK DATA & NO FAKE PARSING (CRITICAL)
- NEVER hardcode responses or use mock data in `ApiServices`, `DataSources`, or `Repositories`.
- DO NOT inject fake keys like `{'isLoggedIn': true}` or fallback maps in `fromJson`. 
- Always parse the EXACT raw JSON response coming from the API. Let the app throw an error if the API fails or returns null.

### 3. CLEAN ARCHITECTURE WORKFLOW
For every API integration, you must create/update files strictly in this order:
1. **ApiEndpoints:** Add the string route.
2. **Entity:** Create a clean Entity class (independent of JSON).
3. **Model:** Create a Model class extending the Entity in a separate file. You MUST use Dart `super` parameters (e.g., `UserModel({required super.id})`). Add `fromJson` and `toJson`.
4. **DataSource:** Call `ApiServices`. Return the raw response directly. No try/catch blocks masking errors.
5. **Repository Impl:** Call DataSource, pass the raw data to `Model.fromJson()`, and return it as the `Entity`.
6. **UseCase (CONSOLIDATED):** DO NOT create separate UseCase classes for every single action. Create a SINGLE UseCase class per feature/repository (e.g., `AuthUseCases` or `ProfileUseCases`) and place all related functions inside it.
7. **Provider:** Create dedicated functions. Manage independent `_isLoading` boolean states (set true -> await call -> set false in finally). Call `notifyListeners()`.
8. **UI:** Connect the Provider, show loaders, and use Custom Widgets.

### 4. FLUTTER WEB & RESPONSIVE DESIGN (STRICT)
- This is a Flutter WEB portal: layouts must be responsive across screen sizes (mobile < 600px, tablet 600px-1024px, desktop >= 1024px) using `ResponsiveContext` or layout builders.
- Strictly avoid mobile-only packages and APIs (e.g., do NOT use `dart:io`, `path_provider`, mobile sensor/permission plugins). Web-safe cross-platform alternatives must always be used.

### 5. COLOR SYSTEM (STRICT)
- NEVER hardcode Color values (e.g., `Color(0xff...)`) in feature code or UI.
- Always use the color getters defined in `lib/src/core/constants/app_colors.dart` by mixing in `AppColors` or via `AppColorsHelper()`.

### 6. ONBOARDING FEATURE ROLES & STRUCTURE
- The portal has three distinct onboarding roles: Vet, Service Provider, and Lab.
- Each onboarding role lives in its own dedicated feature module under `lib/src/features/` (e.g., `vet_onboarding`, `service_provider_onboarding`, `lab_onboarding`).
- Each feature must contain its own complete Clean Architecture stack: `data/`, `domain/`, and `presentation/` (with its own Entity, Model, DataSource, Repository, UseCases, and Provider).
- Maintain strictly ONE consolidated UseCases class per feature (e.g., `VetOnboardingUseCases`, `ServiceProviderOnboardingUseCases`, `LabOnboardingUseCases`).

# STRICT CLEAN ARCHITECTURE TYPE RULES (DART/FLUTTER)
1. NEVER mix 'Entity' and 'Model' types in iterables, list operations, or generic returns. 
2. If a list is List<Model>, methods like .firstWhere() MUST return a Model in their orElse closure, NOT an Entity.
3. Data Layer Boundary: DataSources strictly return Models. Repositories MUST explicitly map Models to Entities using `.toEntity()` before returning to the UseCase.
4. Domain Layer Boundary: UseCases and UI/Providers strictly use Entities. If passing data down to the repository, explicitly map Entity to Model using `Model.fromEntity()`.
5. Dart is strongly typed: An Entity is NOT a subtype of a Model. Do not attempt implicit casts between them.
6. REPOSITORY & MODEL LIST MAPPING (CRITICAL): When returning a `List<Entity>` from a Repository or Model constructor, NEVER leave `.map((doc) => Model.fromSnapshot(doc)).toList()` untyped. ALWAYS explicitly map as `.map<Entity>(...)` (e.g. `snapshot.docs.map<KhataContactEntity>((doc) => KhataContactModel.fromSnapshot(doc)).toList()`). Otherwise Dart creates a reified `List<Model>` at runtime, breaking `.firstWhere()` with `orElse` in UI/Providers with: `_TypeError (type '() => Entity' is not a subtype of type '(() => Model)?' of 'orElse')`.
7. NO SETSTATE DURING BUILD (CRITICAL): NEVER invoke `setState()` or parent callbacks that trigger `setState()` synchronously inside `initState()` or `build()`. Initial state variables in `initState()` must be assigned directly. If notifying a parent callback during widget initialization is necessary, wrap it in `WidgetsBinding.instance.addPostFrameCallback((_) { ... })`.