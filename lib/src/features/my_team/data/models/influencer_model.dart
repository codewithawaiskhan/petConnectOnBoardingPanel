import '../../domain/entities/influencer_entity.dart';

class InfluencerModel extends InfluencerEntity {
  const InfluencerModel({
    required super.id,
    super.autoIncrementId = 0,
    required super.longAutoIncrementId,
    required super.fullName,
    required super.email,
    super.username,
    required super.status,
    required super.createdAt,
  });

  factory InfluencerModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : <String, dynamic>{};
    final userIdMap = userMap['userId'] is Map<String, dynamic>
        ? userMap['userId'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawAutoId = json['autoIncrementId'];
    final parsedAutoId = rawAutoId is int
        ? rawAutoId
        : int.tryParse(rawAutoId?.toString() ?? '') ?? 0;

    return InfluencerModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      longAutoIncrementId: json['longAutoIncrementId']?.toString() ?? '',
      fullName: userIdMap['fullName']?.toString() ?? '',
      email: userIdMap['email']?.toString() ??
          userMap['email']?.toString() ??
          '',
      username: userIdMap['username']?.toString(),
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  InfluencerEntity toEntity() {
    return InfluencerEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      longAutoIncrementId: longAutoIncrementId,
      fullName: fullName,
      email: email,
      username: username,
      status: status,
      createdAt: createdAt,
    );
  }
}

class InfluencerListResponseModel extends InfluencerListResponseEntity {
  const InfluencerListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.totalPages,
    required super.currentPage,
  });

  factory InfluencerListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawDocs = data['docs'] as List<dynamic>? ?? <dynamic>[];

    final List<InfluencerEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<InfluencerEntity>((e) => InfluencerModel.fromJson(e).toEntity())
        .toList();

    final dynamic rawDocsCount = data['docsCount'] ??
        data['totalDocs'] ??
        data['total'] ??
        data['count'] ??
        json['docsCount'];
    final dynamic rawPages =
        data['pages'] ?? data['totalPages'] ?? json['pages'];
    final dynamic rawPage =
        data['currentPage'] ?? data['page'] ?? json['currentPage'];

    final parsedDocsCount = rawDocsCount is int
        ? rawDocsCount
        : int.tryParse(rawDocsCount?.toString() ?? '') ?? parsedDocs.length;
    final parsedPages = rawPages is int
        ? rawPages
        : int.tryParse(rawPages?.toString() ?? '') ?? 1;
    final parsedPage = rawPage is int
        ? rawPage
        : int.tryParse(rawPage?.toString() ?? '') ?? 1;

    return InfluencerListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      totalPages: parsedPages > 0 ? parsedPages : 1,
      currentPage: parsedPage > 0 ? parsedPage : 1,
    );
  }

  InfluencerListResponseEntity toEntity() {
    return InfluencerListResponseEntity(
      success: success,
      message: message,
      docs: List<InfluencerEntity>.from(docs),
      docsCount: docsCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

class ReferredUserLookupModel extends ReferredUserLookupEntity {
  const ReferredUserLookupModel({
    required super.id,
    required super.fullName,
    super.email,
    super.image,
    super.referralCode,
  });

  static ReferredUserLookupModel? fromResponseJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final doc = data['doc'] is Map<String, dynamic>
        ? data['doc'] as Map<String, dynamic>
        : data;
    final user = doc['user'] is Map<String, dynamic>
        ? doc['user'] as Map<String, dynamic>
        : doc;

    final id = user['_id']?.toString() ??
        user['id']?.toString() ??
        doc['_id']?.toString() ??
        doc['id']?.toString() ??
        '';
    if (id.isEmpty) return null;

    return ReferredUserLookupModel(
      id: id,
      fullName:
          user['fullName']?.toString() ?? user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? doc['email']?.toString(),
      image: user['image']?.toString(),
      referralCode:
          user['referralCode']?.toString() ?? doc['referralCode']?.toString(),
    );
  }

  ReferredUserLookupEntity toEntity() {
    return ReferredUserLookupEntity(
      id: id,
      fullName: fullName,
      email: email,
      image: image,
      referralCode: referralCode,
    );
  }
}

