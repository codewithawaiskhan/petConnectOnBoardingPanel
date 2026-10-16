class LabLocationEntity {
  final String? type;
  final List<double> coordinates;
  final double? latitude;
  final double? longitude;
  final String? address;

  const LabLocationEntity({
    this.type,
    this.coordinates = const [],
    this.latitude,
    this.longitude,
    this.address,
  });

  double? get calculatedLatitude {
    if (latitude != null) return latitude;
    if (coordinates.length >= 2) return coordinates[1];
    return null;
  }

  double? get calculatedLongitude {
    if (longitude != null) return longitude;
    if (coordinates.isNotEmpty) return coordinates[0];
    return null;
  }
}

class LabTestCategoryItemEntity {
  final String? id;
  final String? labTestCategory;
  final String title;
  final String? status;

  const LabTestCategoryItemEntity({
    this.id,
    this.labTestCategory,
    required this.title,
    this.status,
  });
}

class LabPetCategoryItemEntity {
  final String? id;
  final String? petCategory;
  final String title;

  const LabPetCategoryItemEntity({
    this.id,
    this.petCategory,
    required this.title,
  });
}

class LabLicenseItemEntity {
  final String? id;
  final String? state;
  final String? number;
  final String? image;
  final String? expiryDate;

  const LabLicenseItemEntity({
    this.id,
    this.state,
    this.number,
    this.image,
    this.expiryDate,
  });
}

class LabAvailableDayEntity {
  final String? day;
  final bool isAvailable;
  final String? openTime;
  final String? closeTime;

  const LabAvailableDayEntity({
    this.day,
    this.isAvailable = false,
    this.openTime,
    this.closeTime,
  });
}

class LabItemEntity {
  final String id;
  final String email;
  final String? phone;
  final String title;
  final String? designation;
  final String? bio;
  final String? labType;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String status;
  final String? statusChangeReason;
  final String? image;
  final List<LabTestCategoryItemEntity> labTestCategories;
  final List<LabPetCategoryItemEntity> petCategories;
  final List<LabLicenseItemEntity> licenses;
  final List<LabAvailableDayEntity> availableDays;
  final LabLocationEntity? location;
  final String? createdAt;
  final String? updatedAt;

  const LabItemEntity({
    required this.id,
    required this.email,
    this.phone,
    required this.title,
    this.designation,
    this.bio,
    this.labType,
    this.address,
    this.city,
    this.state,
    this.country,
    required this.status,
    this.statusChangeReason,
    this.image,
    this.labTestCategories = const [],
    this.petCategories = const [],
    this.licenses = const [],
    this.availableDays = const [],
    this.location,
    this.createdAt,
    this.updatedAt,
  });
}

class LabListResponseEntity {
  final bool success;
  final String message;
  final List<LabItemEntity> docs;
  final int docsCount;
  final int pages;
  final int page;

  const LabListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.pages,
    required this.page,
  });
}

class LabDetailResponseEntity {
  final bool success;
  final String message;
  final LabItemEntity? lab;

  const LabDetailResponseEntity({
    required this.success,
    required this.message,
    this.lab,
  });
}

class LabTestCategoryEntity {
  final String id;
  final String title;
  final String? status;

  const LabTestCategoryEntity({
    required this.id,
    required this.title,
    this.status,
  });
}

class LabTestCategoryListResponseEntity {
  final bool success;
  final String message;
  final List<LabTestCategoryEntity> docs;

  const LabTestCategoryListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
  });
}

class LabActionResponseEntity {
  final bool success;
  final String message;
  final LabItemEntity? lab;

  const LabActionResponseEntity({
    required this.success,
    required this.message,
    this.lab,
  });
}
