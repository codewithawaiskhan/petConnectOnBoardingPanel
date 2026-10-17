import '../../domain/entities/top_countries_entity.dart';

class CountryStatItemModel extends CountryStatItemEntity {
  const CountryStatItemModel({
    super.countryName,
    super.countryCode,
    super.province,
    required super.count,
  });

  factory CountryStatItemModel.fromJson(Map<String, dynamic> json) {
    return CountryStatItemModel(
      countryName: json['countryName']?.toString(),
      countryCode: json['countryCode']?.toString(),
      province: json['province']?.toString(),
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    if (countryName != null) 'countryName': countryName,
    if (countryCode != null) 'countryCode': countryCode,
    if (province != null) 'province': province,
    'count': count,
  };
}

class TopCountriesStatsModel extends TopCountriesStatsEntity {
  const TopCountriesStatsModel({
    super.petParents = const [],
    super.doctors = const [],
    super.labs = const [],
    super.serviceProviders = const [],
  });

  factory TopCountriesStatsModel.fromJson(Map<String, dynamic> json) {
    List<CountryStatItemEntity> parseList(dynamic rawList) {
      if (rawList is! List) return const [];
      return rawList
          .whereType<Map<String, dynamic>>()
          .map<CountryStatItemEntity>(
              (item) => CountryStatItemModel.fromJson(item))
          .toList();
    }

    return TopCountriesStatsModel(
      petParents: parseList(json['petParents']),
      doctors: parseList(json['doctors']),
      labs: parseList(json['labs']),
      serviceProviders: parseList(json['serviceProviders']),
    );
  }

  Map<String, dynamic> toJson() => {
    'petParents': petParents
        .map((e) => (e is CountryStatItemModel)
            ? e.toJson()
            : {
                if (e.countryName != null) 'countryName': e.countryName,
                if (e.countryCode != null) 'countryCode': e.countryCode,
                if (e.province != null) 'province': e.province,
                'count': e.count,
              })
        .toList(),
    'doctors': doctors
        .map((e) => (e is CountryStatItemModel)
            ? e.toJson()
            : {
                if (e.countryName != null) 'countryName': e.countryName,
                if (e.countryCode != null) 'countryCode': e.countryCode,
                if (e.province != null) 'province': e.province,
                'count': e.count,
              })
        .toList(),
    'labs': labs
        .map((e) => (e is CountryStatItemModel)
            ? e.toJson()
            : {
                if (e.countryName != null) 'countryName': e.countryName,
                if (e.countryCode != null) 'countryCode': e.countryCode,
                if (e.province != null) 'province': e.province,
                'count': e.count,
              })
        .toList(),
    'serviceProviders': serviceProviders
        .map((e) => (e is CountryStatItemModel)
            ? e.toJson()
            : {
                if (e.countryName != null) 'countryName': e.countryName,
                if (e.countryCode != null) 'countryCode': e.countryCode,
                if (e.province != null) 'province': e.province,
                'count': e.count,
              })
        .toList(),
  };
}

class TopCountriesResponseModel extends TopCountriesResponseEntity {
  const TopCountriesResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory TopCountriesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return TopCountriesResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: json['message']?.toString() ?? '',
      data: TopCountriesStatsModel.fromJson(data),
    );
  }
}
