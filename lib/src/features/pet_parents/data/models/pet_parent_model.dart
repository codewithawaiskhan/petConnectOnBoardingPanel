import '../../domain/entities/pet_parent_entity.dart';

class PetParentUserModel extends PetParentUserEntity {
  const PetParentUserModel({
    super.id,
    super.image,
    super.status,
    super.roles = const [],
  });

  factory PetParentUserModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedRoles = const [];
    if (json['roles'] is List) {
      parsedRoles = (json['roles'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return PetParentUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      roles: parsedRoles,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (image != null) 'image': image,
    if (status != null) 'status': status,
    'roles': roles,
  };
}

class PetParentItemModel extends PetParentItemEntity {
  const PetParentItemModel({
    required super.id,
    super.autoIncrementId,
    super.longAutoIncrementId,
    super.user,
    super.fullName,
    super.firstName,
    super.lastName,
    super.dateOfBirth,
    super.bloodGroup,
    super.gender,
    super.email,
    super.phone,
    super.countryCode,
    super.countryName,
    super.address,
    super.city,
    super.province,
    super.postOfficeCode,
    super.appointmentsBookedCount = 0,
    super.labTestsBookedCount = 0,
    super.wallet,
    super.isDeleted = false,
    super.createdAt,
  });

  factory PetParentItemModel.fromJson(Map<String, dynamic> json) {
    PetParentUserModel? parsedUser;
    if (json['user'] is Map<String, dynamic>) {
      parsedUser = PetParentUserModel.fromJson(
        json['user'] as Map<String, dynamic>,
      );
    }

    int parsedAppointments = 0;
    if (json['appointmentsBookedCount'] != null) {
      parsedAppointments =
          int.tryParse(json['appointmentsBookedCount'].toString()) ?? 0;
    }

    int parsedLabTests = 0;
    if (json['labTestsBookedCount'] != null) {
      parsedLabTests =
          int.tryParse(json['labTestsBookedCount'].toString()) ?? 0;
    }

    int? parsedAutoIncrementId;
    if (json['autoIncrementId'] != null) {
      parsedAutoIncrementId = int.tryParse(json['autoIncrementId'].toString());
    }

    return PetParentItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoIncrementId,
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      user: parsedUser,
      fullName: json['fullName']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      bloodGroup: json['bloodGroup']?.toString(),
      gender: json['gender']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      postOfficeCode: json['postOfficeCode']?.toString(),
      appointmentsBookedCount: parsedAppointments,
      labTestsBookedCount: parsedLabTests,
      wallet: json['wallet'] is Map
          ? (json['wallet'] as Map)['_id']?.toString()
          : json['wallet']?.toString(),
      isDeleted: json['isDeleted'] == true || json['isDeleted'] == 'true',
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    if (autoIncrementId != null) 'autoIncrementId': autoIncrementId,
    if (longAutoIncrementId != null) 'longAutoIncrementId': longAutoIncrementId,
    if (user != null)
      'user': (user is PetParentUserModel)
          ? (user as PetParentUserModel).toJson()
          : {
              '_id': user!.id,
              'image': user!.image,
              'status': user!.status,
              'roles': user!.roles,
            },
    if (fullName != null) 'fullName': fullName,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    if (bloodGroup != null) 'bloodGroup': bloodGroup,
    if (gender != null) 'gender': gender,
    if (email != null) 'email': email,
    if (phone != null) 'phone': phone,
    if (countryCode != null) 'countryCode': countryCode,
    if (countryName != null) 'countryName': countryName,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (province != null) 'province': province,
    if (postOfficeCode != null) 'postOfficeCode': postOfficeCode,
    'appointmentsBookedCount': appointmentsBookedCount,
    'labTestsBookedCount': labTestsBookedCount,
    if (wallet != null) 'wallet': wallet,
    'isDeleted': isDeleted,
    if (createdAt != null) 'createdAt': createdAt,
  };
}

class PetParentsListResponseModel extends PetParentsListResponseEntity {
  const PetParentsListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.pages,
    required super.page,
  });

  factory PetParentsListResponseModel.fromJson(Map<String, dynamic> json) {
    final parsedDocs = <PetParentItemEntity>[];
    Map<String, dynamic> data = {};

    if (json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    } else if (json['docs'] is List) {
      data = json;
    }

    if (data['docs'] is List) {
      for (final doc in data['docs']) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(PetParentItemModel.fromJson(doc));
        }
      }
    } else if (json['docs'] is List) {
      for (final doc in json['docs']) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(PetParentItemModel.fromJson(doc));
        }
      }
    }

    return PetParentsListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message:
          data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: data['docsCount'] is int
          ? data['docsCount'] as int
          : int.tryParse(data['docsCount']?.toString() ?? '0') ??
              parsedDocs.length,
      pages: data['pages'] is int
          ? data['pages'] as int
          : int.tryParse(data['pages']?.toString() ?? '1') ?? 1,
      page: data['page'] is int
          ? data['page'] as int
          : int.tryParse(data['page']?.toString() ?? '1') ?? 1,
    );
  }
}

class PetParentDetailResponseModel extends PetParentDetailResponseEntity {
  const PetParentDetailResponseModel({
    required super.success,
    required super.message,
    super.petParent,
  });

  factory PetParentDetailResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? docMap;
    String msg = '';

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      msg = data['message']?.toString() ?? '';
      if (data['doc'] is Map<String, dynamic>) {
        docMap = data['doc'] as Map<String, dynamic>;
      } else if (data['docs'] is List && (data['docs'] as List).isNotEmpty) {
        final first = (data['docs'] as List).first;
        if (first is Map<String, dynamic>) docMap = first;
      } else if (data['_id'] != null || data['fullName'] != null) {
        docMap = data;
      }
    } else if (json['doc'] is Map<String, dynamic>) {
      docMap = json['doc'] as Map<String, dynamic>;
    } else if (json['_id'] != null || json['fullName'] != null) {
      docMap = json;
    }

    if (msg.isEmpty) {
      msg = json['message']?.toString() ?? '';
    }

    return PetParentDetailResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: msg,
      petParent: docMap != null ? PetParentItemModel.fromJson(docMap) : null,
    );
  }
}
