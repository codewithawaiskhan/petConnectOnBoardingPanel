class CampaignUserEntity {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profilePicture;

  const CampaignUserEntity({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.profilePicture,
  });
}

class CampaignEntity {
  final String id;
  final int? autoIncrementId;
  final String? longAutoIncrementId;
  final CampaignUserEntity? user;
  final String frequency;
  final int? weekDay;
  final String title;
  final String body;
  final String? attachment;
  final String? featuredImage;
  final String userType;
  final String? countryName;
  final String? countryCode;
  final String? link;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;

  const CampaignEntity({
    required this.id,
    this.autoIncrementId,
    this.longAutoIncrementId,
    this.user,
    required this.frequency,
    this.weekDay,
    required this.title,
    required this.body,
    this.attachment,
    this.featuredImage,
    required this.userType,
    this.countryName,
    this.countryCode,
    this.link,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });
}

class CampaignsResponseEntity {
  final String status;
  final bool success;
  final String message;
  final List<CampaignEntity> campaigns;
  final int docsCount;
  final int pages;

  const CampaignsResponseEntity({
    required this.status,
    required this.success,
    required this.message,
    required this.campaigns,
    required this.docsCount,
    required this.pages,
  });
}

class CreateUpdateCampaignEntity {
  final String userType;
  final String frequency;
  final int? weekDay;
  final String title;
  final String body;
  final String? attachmentDataURI;
  final String? featuredImageDataURI;
  final String? countryName;
  final String? countryCode;
  final String? link;

  const CreateUpdateCampaignEntity({
    required this.userType,
    required this.frequency,
    this.weekDay,
    required this.title,
    required this.body,
    this.attachmentDataURI,
    this.featuredImageDataURI,
    this.countryName,
    this.countryCode,
    this.link,
  });
}
