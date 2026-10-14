class PetParentUserEntity {
  final String? id;
  final String? image;
  final String? status;
  final List<String> roles;

  const PetParentUserEntity({
    this.id,
    this.image,
    this.status,
    this.roles = const [],
  });
}

class PetParentItemEntity {
  final String id;
  final int? autoIncrementId;
  final String? longAutoIncrementId;
  final PetParentUserEntity? user;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? gender;
  final String? email;
  final String? phone;
  final String? countryCode;
  final String? countryName;
  final String? address;
  final String? city;
  final String? province;
  final String? postOfficeCode;
  final int appointmentsBookedCount;
  final int labTestsBookedCount;
  final String? wallet;
  final bool isDeleted;
  final String? createdAt;

  const PetParentItemEntity({
    required this.id,
    this.autoIncrementId,
    this.longAutoIncrementId,
    this.user,
    this.fullName,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.bloodGroup,
    this.gender,
    this.email,
    this.phone,
    this.countryCode,
    this.countryName,
    this.address,
    this.city,
    this.province,
    this.postOfficeCode,
    this.appointmentsBookedCount = 0,
    this.labTestsBookedCount = 0,
    this.wallet,
    this.isDeleted = false,
    this.createdAt,
  });
}

class PetParentsListResponseEntity {
  final bool success;
  final String message;
  final List<PetParentItemEntity> docs;
  final int docsCount;
  final int pages;
  final int page;

  const PetParentsListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.pages,
    required this.page,
  });
}

class PetParentDetailResponseEntity {
  final bool success;
  final String message;
  final PetParentItemEntity? petParent;

  const PetParentDetailResponseEntity({
    required this.success,
    required this.message,
    this.petParent,
  });
}
