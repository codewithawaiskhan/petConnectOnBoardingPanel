import '../../domain/entities/pet_parent_entity.dart';

class RecordedAtRegistrationTimeModel extends RecordedAtRegistrationTimeEntity {
  const RecordedAtRegistrationTimeModel({
    super.latitude,
    super.longitude,
    super.countryCode,
    super.countryName,
    super.deviceOS,
  });

  factory RecordedAtRegistrationTimeModel.fromJson(Map<String, dynamic> json) {
    double? parseCoord(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return RecordedAtRegistrationTimeModel(
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
      deviceOS: json['deviceOS']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    if (countryCode != null) 'countryCode': countryCode,
    if (countryName != null) 'countryName': countryName,
    if (deviceOS != null) 'deviceOS': deviceOS,
  };
}

class PetParentUserModel extends PetParentUserEntity {
  const PetParentUserModel({
    super.id,
    super.image,
    super.status,
    super.roles = const [],
    super.lastLoginAt,
    super.recordedAtRegistrationTime,
  });

  factory PetParentUserModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedRoles = const [];
    if (json['roles'] is List) {
      parsedRoles = (json['roles'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    RecordedAtRegistrationTimeModel? parsedRegistrationTime;
    if (json['recordedAtRegistrationTime'] is Map<String, dynamic>) {
      parsedRegistrationTime = RecordedAtRegistrationTimeModel.fromJson(
        json['recordedAtRegistrationTime'] as Map<String, dynamic>,
      );
    }

    return PetParentUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      roles: parsedRoles,
      lastLoginAt: json['lastLoginAt']?.toString(),
      recordedAtRegistrationTime: parsedRegistrationTime,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (image != null) 'image': image,
    if (status != null) 'status': status,
    'roles': roles,
    if (lastLoginAt != null) 'lastLoginAt': lastLoginAt,
    if (recordedAtRegistrationTime != null)
      'recordedAtRegistrationTime':
          (recordedAtRegistrationTime is RecordedAtRegistrationTimeModel)
              ? (recordedAtRegistrationTime as RecordedAtRegistrationTimeModel)
                  .toJson()
              : {
                  if (recordedAtRegistrationTime!.latitude != null)
                    'latitude': recordedAtRegistrationTime!.latitude,
                  if (recordedAtRegistrationTime!.longitude != null)
                    'longitude': recordedAtRegistrationTime!.longitude,
                  if (recordedAtRegistrationTime!.countryCode != null)
                    'countryCode': recordedAtRegistrationTime!.countryCode,
                  if (recordedAtRegistrationTime!.countryName != null)
                    'countryName': recordedAtRegistrationTime!.countryName,
                  if (recordedAtRegistrationTime!.deviceOS != null)
                    'deviceOS': recordedAtRegistrationTime!.deviceOS,
                },
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
    } else if (json['user'] != null && json['user'] is String) {
      parsedUser = PetParentUserModel(id: json['user'].toString());
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

    final dynamic rawDocsCount = data['totalDocs'] ??
        data['docsCount'] ??
        data['total'] ??
        data['count'] ??
        json['totalDocs'] ??
        json['docsCount'] ??
        json['total'];

    final dynamic rawPages = data['totalPages'] ??
        data['pages'] ??
        json['totalPages'] ??
        json['pages'];

    final dynamic rawPage = data['page'] ??
        data['currentPage'] ??
        json['page'] ??
        json['currentPage'];

    final parsedDocsCount = rawDocsCount is int
        ? rawDocsCount
        : int.tryParse(rawDocsCount?.toString() ?? '') ?? parsedDocs.length;

    final parsedPages = rawPages is int
        ? rawPages
        : int.tryParse(rawPages?.toString() ?? '') ??
            (parsedDocsCount > 0 ? (parsedDocsCount / 10).ceil() : 1);

    final parsedPage = rawPage is int
        ? rawPage
        : int.tryParse(rawPage?.toString() ?? '') ?? 1;

    return PetParentsListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message:
          data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      pages: parsedPages > 0 ? parsedPages : 1,
      page: parsedPage > 0 ? parsedPage : 1,
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

class UpdatePetParentModel extends UpdatePetParentEntity {
  const UpdatePetParentModel({
    super.imageDataURI,
    super.fullName,
    super.phone,
    super.dateOfBirth,
    super.address,
    super.city,
    super.province,
    super.countryCode,
    super.countryName,
  });

  factory UpdatePetParentModel.fromEntity(UpdatePetParentEntity entity) {
    return UpdatePetParentModel(
      imageDataURI: entity.imageDataURI,
      fullName: entity.fullName,
      phone: entity.phone,
      dateOfBirth: entity.dateOfBirth,
      address: entity.address,
      city: entity.city,
      province: entity.province,
      countryCode: entity.countryCode,
      countryName: entity.countryName,
    );
  }

  factory UpdatePetParentModel.fromJson(Map<String, dynamic> json) {
    return UpdatePetParentModel(
      imageDataURI: json['imageDataURI']?.toString(),
      fullName: json['fullName']?.toString(),
      phone: json['phone']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      countryCode: json['countryCode']?.toString(),
      countryName: json['countryName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (imageDataURI != null && imageDataURI!.isNotEmpty)
      'imageDataURI': imageDataURI,
    if (fullName != null) 'fullName': fullName,
    if (phone != null) 'phone': phone,
    if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (province != null) 'province': province,
    if (countryCode != null) 'countryCode': countryCode,
    if (countryName != null) 'countryName': countryName,
  };
}

class UpdatePetParentPasswordModel extends UpdatePetParentPasswordEntity {
  const UpdatePetParentPasswordModel({
    required super.password,
    required super.confirmPassword,
  });

  factory UpdatePetParentPasswordModel.fromEntity(
    UpdatePetParentPasswordEntity entity,
  ) {
    return UpdatePetParentPasswordModel(
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  factory UpdatePetParentPasswordModel.fromJson(Map<String, dynamic> json) {
    return UpdatePetParentPasswordModel(
      password: json['password']?.toString() ?? '',
      confirmPassword: json['confirmPassword']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'password': password,
    'confirmPassword': confirmPassword,
  };
}

class PetParentActionResponseModel extends PetParentActionResponseEntity {
  const PetParentActionResponseModel({
    required super.success,
    required super.message,
  });

  factory PetParentActionResponseModel.fromJson(Map<String, dynamic> json) {
    String msg = json['message']?.toString() ?? '';
    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['message'] != null) {
        msg = data['message'].toString();
      }
    }
    return PetParentActionResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: msg,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
  };
}
