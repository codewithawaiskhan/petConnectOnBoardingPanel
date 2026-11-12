import '../entities/marketing_company_entity.dart';

abstract class MarketingCompanyRepository {
  Future<MarketingCompanyListResponseEntity> getCompanies(
    Map<String, dynamic> queryParams,
  );

  Future<MarketingCompanyEntity?> createCompany(Map<String, dynamic> payload);

  Future<MarketingCompanyEntity?> updateCompany(
    String id,
    Map<String, dynamic> payload,
  );

  Future<void> deleteCompany(String id);
}

