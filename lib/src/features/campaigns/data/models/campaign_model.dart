import '../../domain/entities/campaign_entity.dart';

class CampaignUserModel extends CampaignUserEntity {
  const CampaignUserModel({
    required super.id,
    super.name,
    super.email,
    super.phone,
    super.profilePicture,
  });

  factory CampaignUserModel.fromJson(Map<String, dynamic> json) {
    return CampaignUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['fullName']?.toString() ??
          (json['firstName'] != null
              ? "${json['firstName']} ${json['lastName'] ?? ''}".trim()
              : null),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      profilePicture: json['profilePicture']?.toString() ??
          json['avatar']?.toString() ??
          json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (profilePicture != null) 'profilePicture': profilePicture,
    };
  }

  CampaignUserEntity toEntity() {
    return CampaignUserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      profilePicture: profilePicture,
    );
  }

  factory CampaignUserModel.fromEntity(CampaignUserEntity entity) {
    return CampaignUserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      profilePicture: entity.profilePicture,
    );
  }
}

class CampaignModel extends CampaignEntity {
  const CampaignModel({
    required super.id,
    super.autoIncrementId,
    super.longAutoIncrementId,
    super.user,
    required super.frequency,
    super.weekDay,
    required super.title,
    required super.body,
    super.attachment,
    super.featuredImage,
    required super.userType,
    super.countryName,
    super.countryCode,
    super.link,
    super.isDeleted = false,
    super.createdAt,
    super.updatedAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    CampaignUserModel? userModel;
    final rawUser = json['user'];
    if (rawUser is Map<String, dynamic>) {
      userModel = CampaignUserModel.fromJson(rawUser);
    }

    int? parsedWeekDay;
    if (json['weekDay'] != null) {
      if (json['weekDay'] is num) {
        parsedWeekDay = (json['weekDay'] as num).toInt();
      } else {
        parsedWeekDay = int.tryParse(json['weekDay'].toString());
      }
    }

    int? parsedAutoIncrementId;
    if (json['autoIncrementId'] != null) {
      if (json['autoIncrementId'] is num) {
        parsedAutoIncrementId = (json['autoIncrementId'] as num).toInt();
      } else {
        parsedAutoIncrementId = int.tryParse(json['autoIncrementId'].toString());
      }
    }

    return CampaignModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoIncrementId,
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      user: userModel?.toEntity(),
      frequency: json['frequency']?.toString() ?? 'Onetime',
      weekDay: parsedWeekDay,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      attachment: json['attachment']?.toString(),
      featuredImage: json['featuredImage']?.toString(),
      userType: json['userType']?.toString() ?? 'all',
      countryName: json['countryName']?.toString(),
      countryCode: json['countryCode']?.toString(),
      link: json['link']?.toString(),
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (autoIncrementId != null) 'autoIncrementId': autoIncrementId,
      if (longAutoIncrementId != null) 'longAutoIncrementId': longAutoIncrementId,
      if (user != null && user is CampaignUserModel)
        'user': (user as CampaignUserModel).toJson(),
      'frequency': frequency,
      if (weekDay != null) 'weekDay': weekDay,
      'title': title,
      'body': body,
      if (attachment != null) 'attachment': attachment,
      if (featuredImage != null) 'featuredImage': featuredImage,
      'userType': userType,
      if (countryName != null) 'countryName': countryName,
      if (countryCode != null) 'countryCode': countryCode,
      if (link != null) 'link': link,
      'isDeleted': isDeleted,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  CampaignEntity toEntity() {
    return CampaignEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      longAutoIncrementId: longAutoIncrementId,
      user: user,
      frequency: frequency,
      weekDay: weekDay,
      title: title,
      body: body,
      attachment: attachment,
      featuredImage: featuredImage,
      userType: userType,
      countryName: countryName,
      countryCode: countryCode,
      link: link,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory CampaignModel.fromEntity(CampaignEntity entity) {
    return CampaignModel(
      id: entity.id,
      autoIncrementId: entity.autoIncrementId,
      longAutoIncrementId: entity.longAutoIncrementId,
      user: entity.user,
      frequency: entity.frequency,
      weekDay: entity.weekDay,
      title: entity.title,
      body: entity.body,
      attachment: entity.attachment,
      featuredImage: entity.featuredImage,
      userType: entity.userType,
      countryName: entity.countryName,
      countryCode: entity.countryCode,
      link: entity.link,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

class CampaignsResponseModel extends CampaignsResponseEntity {
  const CampaignsResponseModel({
    required super.status,
    required super.success,
    required super.message,
    required super.campaigns,
    required super.docsCount,
    required super.pages,
  });

  factory CampaignsResponseModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString() ?? '';
    final success = json['success'] == true;
    final data = json['data'];

    List rawDocs = const [];
    int docsCount = 0;
    int pages = 1;
    String message = json['message']?.toString() ?? '';

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'].toString();
      }
      if (data['docs'] is List) {
        rawDocs = data['docs'] as List;
      } else if (data['campaigns'] is List) {
        rawDocs = data['campaigns'] as List;
      }
      docsCount = (data['docsCount'] is num)
          ? (data['docsCount'] as num).toInt()
          : (data['total'] is num
              ? (data['total'] as num).toInt()
              : rawDocs.length);
      pages = (data['pages'] is num) ? (data['pages'] as num).toInt() : 1;
    } else if (data is List) {
      rawDocs = data;
      docsCount = rawDocs.length;
      pages = 1;
    } else if (json['docs'] is List) {
      rawDocs = json['docs'] as List;
      docsCount = (json['docsCount'] is num)
          ? (json['docsCount'] as num).toInt()
          : rawDocs.length;
      pages = (json['pages'] is num) ? (json['pages'] as num).toInt() : 1;
    }

    final campaigns = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<CampaignEntity>(
            (item) => CampaignModel.fromJson(item).toEntity())
        .toList();

    return CampaignsResponseModel(
      status: status,
      success: success,
      message: message,
      campaigns: campaigns,
      docsCount: docsCount,
      pages: pages,
    );
  }
}

class CreateUpdateCampaignModel extends CreateUpdateCampaignEntity {
  const CreateUpdateCampaignModel({
    required super.userType,
    required super.frequency,
    super.weekDay,
    required super.title,
    required super.body,
    super.attachmentDataURI,
    super.featuredImageDataURI,
    super.countryName,
    super.countryCode,
    super.link,
  });

  factory CreateUpdateCampaignModel.fromEntity(
      CreateUpdateCampaignEntity entity) {
    return CreateUpdateCampaignModel(
      userType: entity.userType,
      frequency: entity.frequency,
      weekDay: entity.weekDay,
      title: entity.title,
      body: entity.body,
      attachmentDataURI: entity.attachmentDataURI,
      featuredImageDataURI: entity.featuredImageDataURI,
      countryName: entity.countryName,
      countryCode: entity.countryCode,
      link: entity.link,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userType': userType,
      'frequency': frequency,
      if (weekDay != null) 'weekDay': weekDay,
      'title': title,
      'body': body,
      if (attachmentDataURI != null && attachmentDataURI!.trim().isNotEmpty)
        'attachmentDataURI': attachmentDataURI!.trim(),
      if (featuredImageDataURI != null && featuredImageDataURI!.trim().isNotEmpty)
        'featuredImageDataURI': featuredImageDataURI!.trim(),
      if (countryName != null && countryName!.trim().isNotEmpty)
        'countryName': countryName!.trim(),
      if (countryCode != null && countryCode!.trim().isNotEmpty)
        'countryCode': countryCode!.trim(),
      if (link != null && link!.trim().isNotEmpty) 'link': link!.trim(),
    };
  }
}
