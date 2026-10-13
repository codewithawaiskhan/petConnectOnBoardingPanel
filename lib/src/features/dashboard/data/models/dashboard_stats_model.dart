import '../../domain/entities/dashboard_stats_entity.dart';

class DashboardStatsModel extends DashboardStatsEntity {
  const DashboardStatsModel({
    required super.totalPetParentsCount,
    required super.totalDoctorsCount,
    required super.totalLabsCount,
    required super.totalServiceProvidersCount,
    required super.newThisMonthPetParentsCount,
    required super.newThisMonthDoctorsCount,
    required super.newThisMonthLabsCount,
    required super.newThisMonthServiceProvidersCount,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      totalPetParentsCount:
          (json['totalPetParentsCount'] as num?)?.toInt() ?? 0,
      totalDoctorsCount: (json['totalDoctorsCount'] as num?)?.toInt() ?? 0,
      totalLabsCount: (json['totalLabsCount'] as num?)?.toInt() ?? 0,
      totalServiceProvidersCount:
          (json['totalServiceProvidersCount'] as num?)?.toInt() ?? 0,
      newThisMonthPetParentsCount:
          (json['newThisMonthPetParentsCount'] as num?)?.toInt() ?? 0,
      newThisMonthDoctorsCount:
          (json['newThisMonthDoctorsCount'] as num?)?.toInt() ?? 0,
      newThisMonthLabsCount:
          (json['newThisMonthLabsCount'] as num?)?.toInt() ?? 0,
      newThisMonthServiceProvidersCount:
          (json['newThisMonthServiceProvidersCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalPetParentsCount': totalPetParentsCount,
    'totalDoctorsCount': totalDoctorsCount,
    'totalLabsCount': totalLabsCount,
    'totalServiceProvidersCount': totalServiceProvidersCount,
    'newThisMonthPetParentsCount': newThisMonthPetParentsCount,
    'newThisMonthDoctorsCount': newThisMonthDoctorsCount,
    'newThisMonthLabsCount': newThisMonthLabsCount,
    'newThisMonthServiceProvidersCount': newThisMonthServiceProvidersCount,
  };
}

class DashboardStatsResponseModel extends DashboardStatsResponseEntity {
  const DashboardStatsResponseModel({
    required super.success,
    required super.message,
    required super.stats,
  });

  factory DashboardStatsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return DashboardStatsResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: json['message']?.toString() ?? '',
      stats: DashboardStatsModel.fromJson(data),
    );
  }
}
