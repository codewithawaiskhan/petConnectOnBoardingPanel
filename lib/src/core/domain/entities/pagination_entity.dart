class PaginationEntity {
  bool isLoading;
  bool isLoadingMore;
  bool hasMoreData;
  int currentPage;

  PaginationEntity({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.currentPage = 1,
  });

  void reset() {
    isLoading = false;
    isLoadingMore = false;
    hasMoreData = true;
    currentPage = 1;
  }
}

class PaginationResult<T> {
  final List<T> items;
  final int totalPages;
  final int totalDocs;

  PaginationResult({
    required this.items,
    required this.totalPages,
    required this.totalDocs,
  });
}
