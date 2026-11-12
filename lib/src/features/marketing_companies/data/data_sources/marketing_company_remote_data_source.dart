import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class MarketingCompanyRemoteDataSource {
  Future<Response> getCompanies(Map<String, dynamic> queryParams);
  Future<Response> createCompany(Map<String, dynamic> payload);
  Future<Response> updateCompany(String id, Map<String, dynamic> payload);
  Future<Response> deleteCompany(String id);
}

class MarketingCompanyRemoteDataSourceImpl
    implements MarketingCompanyRemoteDataSource {
  final ApiServices apiServices;

  const MarketingCompanyRemoteDataSourceImpl({required this.apiServices});

  String get _baseUri => '${ApiEndpoints.apiUrl}${ApiEndpoints.marketingCompany}';

  @override
  Future<Response> getCompanies(Map<String, dynamic> queryParams) {
    final sanitizedParams = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitizedParams[key] = value.toString().trim();
      }
    });

    final uri = Uri.parse(_baseUri)
        .replace(
          queryParameters: sanitizedParams.isEmpty ? null : sanitizedParams,
        )
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> createCompany(Map<String, dynamic> payload) {
    return apiServices.postData(_baseUri, payload);
  }

  @override
  Future<Response> updateCompany(String id, Map<String, dynamic> payload) {
    return apiServices.patchData('$_baseUri/$id', payload);
  }

  @override
  Future<Response> deleteCompany(String id) {
    return apiServices.deleteData('$_baseUri/$id');
  }
}

