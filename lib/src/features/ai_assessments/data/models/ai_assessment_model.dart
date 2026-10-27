import '../../domain/entities/ai_assessment_entity.dart';

class AiAssessmentPetModel extends AiAssessmentPetEntity {
  const AiAssessmentPetModel({
    super.id,
    super.name,
    super.image,
  });

  factory AiAssessmentPetModel.fromJson(Map<String, dynamic> json) {
    return AiAssessmentPetModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (name != null) 'name': name,
    if (image != null) 'image': image,
  };

  AiAssessmentPetEntity toEntity() => AiAssessmentPetEntity(
    id: id,
    name: name,
    image: image,
  );
}

class AiAssessmentResultModel extends AiAssessmentResultEntity {
  const AiAssessmentResultModel({
    super.id,
    required super.title,
    super.matchType,
    super.riskLevel,
    super.overview,
    super.treatmentOverview,
    super.recommendedNextSteps = const [],
    super.whenToSeekImmediateCare = const [],
    super.breedNotes = const [],
    super.evidenceUrls = const [],
  });

  factory AiAssessmentResultModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return const [];
    }

    List<String> evidenceUrls = const [];
    if (json['evidence'] is List) {
      evidenceUrls = (json['evidence'] as List)
          .map((e) {
            if (e is Map && e['url'] != null) {
              return e['url'].toString();
            } else if (e is String) {
              return e;
            }
            return '';
          })
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return AiAssessmentResultModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: json['title']?.toString() ?? 'Assessment Finding',
      matchType: json['matchType']?.toString() ?? json['match_type']?.toString(),
      riskLevel: json['riskLevel']?.toString() ?? json['risk_level']?.toString(),
      overview: json['overview']?.toString(),
      treatmentOverview: json['treatmentOverview']?.toString() ??
          json['treatment_overview']?.toString(),
      recommendedNextSteps: parseStringList(
        json['recommendedNextSteps'] ?? json['recommended_next_steps'],
      ),
      whenToSeekImmediateCare: parseStringList(
        json['whenToSeekImmediateCare'] ?? json['when_to_seek_immediate_care'],
      ),
      breedNotes: parseStringList(
        json['breedNotes'] ?? json['breed_notes'],
      ),
      evidenceUrls: evidenceUrls,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'title': title,
    if (matchType != null) 'matchType': matchType,
    if (riskLevel != null) 'riskLevel': riskLevel,
    if (overview != null) 'overview': overview,
    if (treatmentOverview != null) 'treatmentOverview': treatmentOverview,
    'recommendedNextSteps': recommendedNextSteps,
    'whenToSeekImmediateCare': whenToSeekImmediateCare,
    'breedNotes': breedNotes,
    'evidenceUrls': evidenceUrls,
  };

  AiAssessmentResultEntity toEntity() => AiAssessmentResultEntity(
    id: id,
    title: title,
    matchType: matchType,
    riskLevel: riskLevel,
    overview: overview,
    treatmentOverview: treatmentOverview,
    recommendedNextSteps: recommendedNextSteps,
    whenToSeekImmediateCare: whenToSeekImmediateCare,
    breedNotes: breedNotes,
    evidenceUrls: evidenceUrls,
  );
}

class AiAssessmentModel extends AiAssessmentEntity {
  const AiAssessmentModel({
    required super.id,
    super.pet,
    required super.type,
    required super.headline,
    required super.triageLevel,
    super.detectedCount = 0,
    super.disclaimer,
    super.images = const {},
    super.results = const [],
    super.createdAt,
    super.updatedAt,
  });

  factory AiAssessmentModel.fromJson(Map<String, dynamic> json) {
    AiAssessmentPetModel? parsedPet;
    if (json['pet'] is Map<String, dynamic>) {
      parsedPet = AiAssessmentPetModel.fromJson(
        json['pet'] as Map<String, dynamic>,
      );
    } else if (json['pet'] is String) {
      parsedPet = AiAssessmentPetModel(id: json['pet'].toString());
    }

    Map<String, String> parsedImages = {};
    if (json['images'] is Map) {
      (json['images'] as Map).forEach((k, v) {
        if (v is Map && v['url'] != null) {
          parsedImages[k.toString()] = v['url'].toString();
        } else if (v is String) {
          parsedImages[k.toString()] = v;
        }
      });
    }

    List<AiAssessmentResultModel> parsedResults = const [];
    if (json['results'] is List) {
      parsedResults = (json['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => AiAssessmentResultModel.fromJson(item))
          .toList();
    }

    int parseCount(dynamic val) {
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return AiAssessmentModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      pet: parsedPet,
      type: json['type']?.toString() ?? 'general',
      headline: json['headline']?.toString() ?? 'Assessment Complete',
      triageLevel: json['triageLevel']?.toString() ??
          json['triage_level']?.toString() ??
          'routine',
      detectedCount: parseCount(json['detectedCount'] ?? json['detected_count']),
      disclaimer: json['disclaimer']?.toString(),
      images: parsedImages,
      results: parsedResults,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    if (pet != null && pet is AiAssessmentPetModel)
      'pet': (pet as AiAssessmentPetModel).toJson(),
    'type': type,
    'headline': headline,
    'triageLevel': triageLevel,
    'detectedCount': detectedCount,
    if (disclaimer != null) 'disclaimer': disclaimer,
    'images': images,
    'results': results
        .whereType<AiAssessmentResultModel>()
        .map((r) => r.toJson())
        .toList(),
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
  };

  AiAssessmentEntity toEntity() => AiAssessmentEntity(
    id: id,
    pet: pet != null && pet is AiAssessmentPetModel
        ? (pet as AiAssessmentPetModel).toEntity()
        : pet,
    type: type,
    headline: headline,
    triageLevel: triageLevel,
    detectedCount: detectedCount,
    disclaimer: disclaimer,
    images: images,
    results: results
        .map((r) => r is AiAssessmentResultModel ? r.toEntity() : r)
        .toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
