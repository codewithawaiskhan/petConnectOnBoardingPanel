import '../../domain/entities/lab_entity.dart';

class LabLocationModel extends LabLocationEntity {
  const LabLocationModel({
    super.type,
    super.coordinates = const [],
    super.latitude,
    super.longitude,
    super.address,
  });

  factory LabLocationModel.fromJson(Map<String, dynamic> json) {
    List<double> parsedCoords = const [];
    if (json['coordinates'] is List) {
      parsedCoords = (json['coordinates'] as List)
          .map((e) => double.tryParse(e.toString()) ?? 0.0)
          .toList();
    }

    double? lat;
    if (json['latitude'] != null) {
      lat = double.tryParse(json['latitude'].toString());
    } else if (parsedCoords.length >= 2) {
      lat = parsedCoords[1];
    }

    double? lng;
    if (json['longitude'] != null) {
      lng = double.tryParse(json['longitude'].toString());
    } else if (parsedCoords.isNotEmpty) {
      lng = parsedCoords[0];
    }

    return LabLocationModel(
      type: json['type']?.toString(),
      coordinates: parsedCoords,
      latitude: lat,
      longitude: lng,
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': coordinates,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
  };
}

class LabTestCategoryItemModel extends LabTestCategoryItemEntity {
  const LabTestCategoryItemModel({
    super.id,
    super.labTestCategory,
    required super.title,
    super.status,
  });

  factory LabTestCategoryItemModel.fromJson(Map<String, dynamic> json) {
    String parsedTitle = '';
    String? categoryId;

    if (json['title'] != null && json['title'].toString().trim().isNotEmpty) {
      parsedTitle = json['title'].toString().trim();
    }

    if (json['labTestCategory'] is Map<String, dynamic>) {
      final nested = json['labTestCategory'] as Map<String, dynamic>;
      categoryId = nested['_id']?.toString() ?? nested['id']?.toString();
      if (parsedTitle.isEmpty && nested['title'] != null) {
        parsedTitle = nested['title'].toString().trim();
      } else if (parsedTitle.isEmpty && nested['name'] != null) {
        parsedTitle = nested['name'].toString().trim();
      }
    } else if (json['labTestCategory'] != null) {
      categoryId = json['labTestCategory'].toString();
    }

    if (parsedTitle.isEmpty && json['name'] != null) {
      parsedTitle = json['name'].toString().trim();
    }

    return LabTestCategoryItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      labTestCategory: categoryId,
      title: parsedTitle,
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (labTestCategory != null) 'labTestCategory': labTestCategory,
    'title': title,
    if (status != null) 'status': status,
  };
}

class LabPetCategoryItemModel extends LabPetCategoryItemEntity {
  const LabPetCategoryItemModel({
    super.id,
    super.petCategory,
    required super.title,
  });

  factory LabPetCategoryItemModel.fromJson(Map<String, dynamic> json) {
    String parsedTitle = '';
    String? categoryId;

    if (json['title'] != null && json['title'].toString().trim().isNotEmpty) {
      parsedTitle = json['title'].toString().trim();
    }

    if (json['petCategory'] is Map<String, dynamic>) {
      final nested = json['petCategory'] as Map<String, dynamic>;
      categoryId = nested['_id']?.toString() ?? nested['id']?.toString();
      if (parsedTitle.isEmpty && nested['title'] != null) {
        parsedTitle = nested['title'].toString().trim();
      } else if (parsedTitle.isEmpty && nested['name'] != null) {
        parsedTitle = nested['name'].toString().trim();
      }
    } else if (json['petCategory'] != null) {
      categoryId = json['petCategory'].toString();
    }

    if (parsedTitle.isEmpty && json['name'] != null) {
      parsedTitle = json['name'].toString().trim();
    }

    return LabPetCategoryItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      petCategory: categoryId,
      title: parsedTitle,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (petCategory != null) 'petCategory': petCategory,
    'title': title,
  };
}

class LabLicenseItemModel extends LabLicenseItemEntity {
  const LabLicenseItemModel({
    super.id,
    super.state,
    super.number,
    super.image,
    super.expiryDate,
  });

  factory LabLicenseItemModel.fromJson(Map<String, dynamic> json) {
    return LabLicenseItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      state: json['state']?.toString(),
      number: json['number']?.toString(),
      image: json['image']?.toString(),
      expiryDate: json['expiryDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (state != null) 'state': state,
    if (number != null) 'number': number,
    if (image != null) 'image': image,
    if (expiryDate != null) 'expiryDate': expiryDate,
  };
}

class LabAvailableDayModel extends LabAvailableDayEntity {
  const LabAvailableDayModel({
    super.day,
    super.isAvailable = false,
    super.openTime,
    super.closeTime,
  });

  factory LabAvailableDayModel.fromJson(Map<String, dynamic> json) {
    return LabAvailableDayModel(
      day: json['day']?.toString(),
      isAvailable: json['isAvailable'] == true || json['isAvailable'] == 'true',
      openTime: json['openTime']?.toString(),
      closeTime: json['closeTime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (day != null) 'day': day,
    'isAvailable': isAvailable,
    if (openTime != null) 'openTime': openTime,
    if (closeTime != null) 'closeTime': closeTime,
  };
}

class LabItemModel extends LabItemEntity {
  const LabItemModel({
    required super.id,
    required super.email,
    super.phone,
    required super.title,
    super.designation,
    super.bio,
    super.labType,
    super.address,
    super.city,
    super.state,
    super.country,
    required super.status,
    super.statusChangeReason,
    super.image,
    super.labTestCategories = const [],
    super.petCategories = const [],
    super.licenses = const [],
    super.availableDays = const [],
    super.location,
    super.createdAt,
    super.updatedAt,
  });

  factory LabItemModel.fromJson(Map<String, dynamic> json) {
    final testCats = <LabTestCategoryItemEntity>[];
    if (json['labTestCategories'] is List) {
      for (final item in json['labTestCategories']) {
        if (item is Map<String, dynamic>) {
          testCats.add(LabTestCategoryItemModel.fromJson(item));
        } else if (item is String) {
          testCats.add(LabTestCategoryItemModel(id: item, title: item));
        }
      }
    }

    final petCats = <LabPetCategoryItemEntity>[];
    if (json['petCategories'] is List) {
      for (final item in json['petCategories']) {
        if (item is Map<String, dynamic>) {
          petCats.add(LabPetCategoryItemModel.fromJson(item));
        } else if (item is String) {
          petCats.add(LabPetCategoryItemModel(id: item, title: item));
        }
      }
    }

    final lics = <LabLicenseItemEntity>[];
    if (json['licenses'] is List) {
      for (final item in json['licenses']) {
        if (item is Map<String, dynamic>) {
          lics.add(LabLicenseItemModel.fromJson(item));
        }
      }
    }

    final days = <LabAvailableDayEntity>[];
    if (json['availableDays'] is List) {
      for (final item in json['availableDays']) {
        if (item is Map<String, dynamic>) {
          days.add(LabAvailableDayModel.fromJson(item));
        }
      }
    }

    LabLocationModel? loc;
    if (json['location'] is Map<String, dynamic>) {
      loc = LabLocationModel.fromJson(json['location'] as Map<String, dynamic>);
    }

    return LabItemModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      title: json['title']?.toString() ?? '',
      designation: json['designation']?.toString(),
      bio: json['bio']?.toString(),
      labType: json['labType']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      status: json['status']?.toString() ?? 'Pending',
      statusChangeReason: json['statusChangeReason']?.toString(),
      image: json['image']?.toString() ?? json['logo']?.toString(),
      labTestCategories: testCats,
      petCategories: petCats,
      licenses: lics,
      availableDays: days,
      location: loc,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'email': email,
    'phone': phone,
    'title': title,
    'designation': designation,
    'bio': bio,
    'labType': labType,
    'address': address,
    'city': city,
    'state': state,
    'country': country,
    'status': status,
    'statusChangeReason': statusChangeReason,
    'image': image,
    'labTestCategories':
        labTestCategories
            .map(
              (e) => e is LabTestCategoryItemModel
                  ? e.toJson()
                  : {'_id': e.id, 'title': e.title},
            )
            .toList(),
    'petCategories':
        petCategories
            .map(
              (e) => e is LabPetCategoryItemModel
                  ? e.toJson()
                  : {'_id': e.id, 'title': e.title},
            )
            .toList(),
    'licenses':
        licenses
            .map(
              (e) => e is LabLicenseItemModel
                  ? e.toJson()
                  : {'number': e.number, 'state': e.state},
            )
            .toList(),
    'availableDays':
        availableDays
            .map(
              (e) => e is LabAvailableDayModel
                  ? e.toJson()
                  : {'day': e.day, 'isAvailable': e.isAvailable},
            )
            .toList(),
    'location': location is LabLocationModel
        ? (location as LabLocationModel).toJson()
        : null,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class LabListResponseModel extends LabListResponseEntity {
  const LabListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.pages,
    required super.page,
  });

  factory LabListResponseModel.fromJson(Map<String, dynamic> json) {
    final parsedDocs = <LabItemEntity>[];

    Map<String, dynamic> data = {};
    if (json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    } else if (json['docs'] is List) {
      data = json;
    }

    if (data['docs'] is List) {
      for (final doc in data['docs']) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(LabItemModel.fromJson(doc));
        }
      }
    } else if (json['docs'] is List) {
      for (final doc in json['docs']) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(LabItemModel.fromJson(doc));
        }
      }
    }

    return LabListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message:
          data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount:
          data['docsCount'] is int
              ? data['docsCount'] as int
              : int.tryParse(data['docsCount']?.toString() ?? '0') ??
                  parsedDocs.length,
      pages:
          data['pages'] is int
              ? data['pages'] as int
              : int.tryParse(data['pages']?.toString() ?? '1') ?? 1,
      page:
          data['page'] is int
              ? data['page'] as int
              : int.tryParse(data['page']?.toString() ?? '1') ?? 1,
    );
  }
}

class LabDetailResponseModel extends LabDetailResponseEntity {
  const LabDetailResponseModel({
    required super.success,
    required super.message,
    super.lab,
  });

  factory LabDetailResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? docMap;
    String msg = '';

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      msg = data['message']?.toString() ?? '';
      if (data['doc'] is Map<String, dynamic>) {
        docMap = data['doc'] as Map<String, dynamic>;
      } else if (data['docs'] is List && (data['docs'] as List).isNotEmpty) {
        final first = (data['docs'] as List).first;
        if (first is Map<String, dynamic>) {
          docMap = first;
        }
      } else if (data['_id'] != null || data['title'] != null) {
        docMap = data;
      }
    } else if (json['doc'] is Map<String, dynamic>) {
      docMap = json['doc'] as Map<String, dynamic>;
    } else if (json['_id'] != null || json['title'] != null) {
      docMap = json;
    }

    if (msg.isEmpty) {
      msg = json['message']?.toString() ?? '';
    }

    return LabDetailResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: msg,
      lab: docMap != null ? LabItemModel.fromJson(docMap) : null,
    );
  }
}

class LabTestCategoryModel extends LabTestCategoryEntity {
  const LabTestCategoryModel({
    required super.id,
    required super.title,
    super.status,
  });

  factory LabTestCategoryModel.fromJson(Map<String, dynamic> json) {
    return LabTestCategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    if (status != null) 'status': status,
  };
}

class LabTestCategoryListResponseModel
    extends LabTestCategoryListResponseEntity {
  const LabTestCategoryListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
  });

  factory LabTestCategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    final parsedDocs = <LabTestCategoryEntity>[];
    Map<String, dynamic> data = {};

    if (json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    } else if (json['docs'] is List) {
      data = json;
    }

    if (data['docs'] is List) {
      for (final doc in data['docs']) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(LabTestCategoryModel.fromJson(doc));
        }
      }
    } else if (json['docs'] is List) {
      for (final doc in json['docs']) {
        if (doc is Map<String, dynamic>) {
          parsedDocs.add(LabTestCategoryModel.fromJson(doc));
        }
      }
    }

    return LabTestCategoryListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message:
          data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
    );
  }
}
