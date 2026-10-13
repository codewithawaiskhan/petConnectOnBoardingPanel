class ServiceProviderUserEntity {
  final String id;
  final String? image;
  final String? status;
  final List<String> roles;

  const ServiceProviderUserEntity({
    required this.id,
    this.image,
    this.status,
    this.roles = const [],
  });
}

class ServiceProviderPriceEntity {
  final num? price;
  final String? currencyCode;

  const ServiceProviderPriceEntity({this.price, this.currencyCode});
}

class ServiceProviderLicenseItemEntity {
  final String? id;
  final String? state;
  final String? stateAbbreviation;
  final String? number;
  final String? image;
  final String? expiryDate;

  const ServiceProviderLicenseItemEntity({
    this.id,
    this.state,
    this.stateAbbreviation,
    this.number,
    this.image,
    this.expiryDate,
  });
}

class ServiceProviderPetCategoryItemEntity {
  final String? id;
  final String? petCategory;
  final String? title;

  const ServiceProviderPetCategoryItemEntity({
    this.id,
    this.petCategory,
    this.title,
  });
}

class ServiceProviderOfferedServiceItemEntity {
  final String? id;
  final String? serviceProviderService;
  final String? title;

  const ServiceProviderOfferedServiceItemEntity({
    this.id,
    this.serviceProviderService,
    this.title,
  });
}

class ServiceProviderItemEntity {
  final String id;
  final int? autoIncrementId;
  final String? longAutoIncrementId;
  final String? slug;
  final ServiceProviderUserEntity? user;
  final String? gender;
  final String? bio;
  final String fullName;
  final String? displayName;
  final String? designation;
  final String? address;
  final String? city;
  final String? province;
  final String? countryCode;
  final String? countryName;
  final String? latitude;
  final String? longitude;
  final num? starsSum;
  final int? totalReviews;
  final num? averageRating;
  final int? favourites;
  final int? bookingsCompleted;
  final int? yearsOfWorkExperience;
  final List<String> knownLanguages;
  final String? wallet;
  final String status;
  final String? statusChangeReason;
  final String? businessEmail;
  final String? businessName;
  final dynamic businessZIPCode;
  final String? businessPhone;
  final String email;
  final String? phone;
  final String? businessImage;
  final String? timeZone;
  final ServiceProviderPriceEntity? pricePerAppointment;
  final ServiceProviderPriceEntity? startingPricePerAppointment;
  final List<ServiceProviderLicenseItemEntity> licenses;
  final List<ServiceProviderPetCategoryItemEntity> petCategories;
  final List<String> serviceLocations;
  final List<ServiceProviderOfferedServiceItemEntity> servicesOffered;
  final String? otherService;
  final String? createdAt;
  final String? updatedAt;

  const ServiceProviderItemEntity({
    required this.id,
    this.autoIncrementId,
    this.longAutoIncrementId,
    this.slug,
    this.user,
    this.gender,
    this.bio,
    required this.fullName,
    this.displayName,
    this.designation,
    this.address,
    this.city,
    this.province,
    this.countryCode,
    this.countryName,
    this.latitude,
    this.longitude,
    this.starsSum,
    this.totalReviews,
    this.averageRating,
    this.favourites,
    this.bookingsCompleted,
    this.yearsOfWorkExperience,
    this.knownLanguages = const [],
    this.wallet,
    required this.status,
    this.statusChangeReason,
    this.businessEmail,
    this.businessName,
    this.businessZIPCode,
    this.businessPhone,
    required this.email,
    this.phone,
    this.businessImage,
    this.timeZone,
    this.pricePerAppointment,
    this.startingPricePerAppointment,
    this.licenses = const [],
    this.petCategories = const [],
    this.serviceLocations = const [],
    this.servicesOffered = const [],
    this.otherService,
    this.createdAt,
    this.updatedAt,
  });
}

class ServiceProviderListResponseEntity {
  final bool success;
  final String message;
  final List<ServiceProviderItemEntity> docs;
  final int docsCount;
  final int pages;
  final int page;

  const ServiceProviderListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.pages,
    required this.page,
  });
}

class ServiceProviderDetailResponseEntity {
  final bool success;
  final String message;
  final ServiceProviderItemEntity? serviceProvider;

  const ServiceProviderDetailResponseEntity({
    required this.success,
    required this.message,
    this.serviceProvider,
  });
}
