import '../entities/marketing_company_entity.dart';
import '../repositories/marketing_company_repository.dart';

class GetMarketingCompaniesUseCase {
  final MarketingCompanyRepository repository;

  const GetMarketingCompaniesUseCase({required this.repository});

  Future<MarketingCompanyListResponseEntity> call(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getCompanies(queryParams);
  }
}

class CreateMarketingCompanyUseCase {
  final MarketingCompanyRepository repository;

  const CreateMarketingCompanyUseCase({required this.repository});

  Future<MarketingCompanyEntity?> call(Map<String, dynamic> payload) {
    return repository.createCompany(payload);
  }
}

class UpdateMarketingCompanyUseCase {
  final MarketingCompanyRepository repository;

  const UpdateMarketingCompanyUseCase({required this.repository});

  Future<MarketingCompanyEntity?> call(
    String id,
    Map<String, dynamic> payload,
  ) {
    return repository.updateCompany(id, payload);
  }
}

class DeleteMarketingCompanyUseCase {
  final MarketingCompanyRepository repository;

  const DeleteMarketingCompanyUseCase({required this.repository});

  Future<void> call(String id) {
    return repository.deleteCompany(id);
  }
}

