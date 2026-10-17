class CountryStatItemEntity {
  final String? countryName;
  final String? countryCode;
  final String? province;
  final int count;

  const CountryStatItemEntity({
    this.countryName,
    this.countryCode,
    this.province,
    required this.count,
  });

  String get displayName {
    if (province != null && province!.trim().isNotEmpty) {
      return province!.trim();
    }
    if (countryName != null && countryName!.trim().isNotEmpty) {
      return countryName!.trim();
    }
    if (countryCode != null && countryCode!.trim().isNotEmpty) {
      return countryCode!.trim();
    }
    return "Unknown";
  }
}

class TopCountriesStatsEntity {
  final List<CountryStatItemEntity> petParents;
  final List<CountryStatItemEntity> doctors;
  final List<CountryStatItemEntity> labs;
  final List<CountryStatItemEntity> serviceProviders;

  const TopCountriesStatsEntity({
    this.petParents = const [],
    this.doctors = const [],
    this.labs = const [],
    this.serviceProviders = const [],
  });

  const TopCountriesStatsEntity.empty()
      : petParents = const [],
        doctors = const [],
        labs = const [],
        serviceProviders = const [];
}

class TopCountriesResponseEntity {
  final bool success;
  final String message;
  final TopCountriesStatsEntity data;

  const TopCountriesResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
