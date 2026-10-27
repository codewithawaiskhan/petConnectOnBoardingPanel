import 'package:flutter/material.dart';
import '../../domain/entities/pet_gallery_entity.dart';
import '../../domain/usecases/pet_gallery_usecases.dart';

class PetGalleryProvider extends ChangeNotifier {
  final PetGalleryUseCases useCases;

  PetGalleryProvider({required this.useCases});

  bool _isGalleryLoading = false;
  bool get isGalleryLoading => _isGalleryLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<PetGalleryEntity> _galleryItems = const [];
  List<PetGalleryEntity> get galleryItems => _galleryItems;

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  String _selectedPetFilter = 'All';
  String get selectedPetFilter => _selectedPetFilter;

  List<String> get availablePetFilters {
    final Set<String> pets = {'All'};
    for (final item in _galleryItems) {
      if (item.petName.isNotEmpty) {
        pets.add(item.petName);
      }
    }
    return pets.toList();
  }

  List<PetGalleryEntity> get filteredGalleryItems {
    if (_selectedPetFilter == 'All') return _galleryItems;
    return _galleryItems
        .where((item) =>
            item.petName.toLowerCase() == _selectedPetFilter.toLowerCase())
        .toList();
  }

  void setSelectedPetFilter(String filter) {
    if (_selectedPetFilter != filter) {
      _selectedPetFilter = filter;
      notifyListeners();
    }
  }

  Future<void> fetchPetGallery(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (userId.isEmpty) return;

    if (!forceRefresh && _currentUserId == userId && _galleryItems.isNotEmpty) {
      return;
    }

    _currentUserId = userId;
    _isGalleryLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await useCases.getPetGalleryByUserId(userId);
      _galleryItems = results;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isGalleryLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _galleryItems = const [];
    _currentUserId = null;
    _errorMessage = null;
    _selectedPetFilter = 'All';
    _isGalleryLoading = false;
  }
}
