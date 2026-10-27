class AiAssessmentPetEntity {
  final String? id;
  final String? name;
  final String? image;

  const AiAssessmentPetEntity({
    this.id,
    this.name,
    this.image,
  });
}

class AiAssessmentResultEntity {
  final String? id;
  final String title;
  final String? matchType;
  final String? riskLevel;
  final String? overview;
  final String? treatmentOverview;
  final List<String> recommendedNextSteps;
  final List<String> whenToSeekImmediateCare;
  final List<String> breedNotes;
  final List<String> evidenceUrls;

  const AiAssessmentResultEntity({
    this.id,
    required this.title,
    this.matchType,
    this.riskLevel,
    this.overview,
    this.treatmentOverview,
    this.recommendedNextSteps = const [],
    this.whenToSeekImmediateCare = const [],
    this.breedNotes = const [],
    this.evidenceUrls = const [],
  });
}

class AiAssessmentEntity {
  final String id;
  final AiAssessmentPetEntity? pet;
  final String type;
  final String headline;
  final String triageLevel;
  final int detectedCount;
  final String? disclaimer;
  final Map<String, String> images;
  final List<AiAssessmentResultEntity> results;
  final String? createdAt;
  final String? updatedAt;

  const AiAssessmentEntity({
    required this.id,
    this.pet,
    required this.type,
    required this.headline,
    required this.triageLevel,
    this.detectedCount = 0,
    this.disclaimer,
    this.images = const {},
    this.results = const [],
    this.createdAt,
    this.updatedAt,
  });

  String get petName => pet?.name ?? "Unknown Pet";
  String? get petImage => pet?.image;
}
