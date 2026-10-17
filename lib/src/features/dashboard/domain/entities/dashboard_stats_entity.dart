class DashboardStatsEntity {
  final int totalPetParentsCount;
  final int totalDoctorsCount;
  final int totalLabsCount;
  final int totalServiceProvidersCount;
  final int newThisMonthPetParentsCount;
  final int newThisMonthDoctorsCount;
  final int newThisMonthLabsCount;
  final int newThisMonthServiceProvidersCount;

  final int totalAndroidUsersCount;
  final int totaliOSUsersCount;

  const DashboardStatsEntity({
    required this.totalPetParentsCount,
    required this.totalDoctorsCount,
    required this.totalLabsCount,
    required this.totalServiceProvidersCount,
    required this.newThisMonthPetParentsCount,
    required this.newThisMonthDoctorsCount,
    required this.newThisMonthLabsCount,
    required this.newThisMonthServiceProvidersCount,
    this.totalAndroidUsersCount = 0,
    this.totaliOSUsersCount = 0,
  });

  const DashboardStatsEntity.empty()
    : totalPetParentsCount = 0,
      totalDoctorsCount = 0,
      totalLabsCount = 0,
      totalServiceProvidersCount = 0,
      newThisMonthPetParentsCount = 0,
      newThisMonthDoctorsCount = 0,
      newThisMonthLabsCount = 0,
      newThisMonthServiceProvidersCount = 0,
      totalAndroidUsersCount = 0,
      totaliOSUsersCount = 0;
}

class DashboardStatsResponseEntity {
  final bool success;
  final String message;
  final DashboardStatsEntity stats;

  const DashboardStatsResponseEntity({
    required this.success,
    required this.message,
    required this.stats,
  });
}
