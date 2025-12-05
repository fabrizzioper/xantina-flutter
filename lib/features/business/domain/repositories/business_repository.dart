import '../entities/business.dart';

abstract class BusinessRepository {
  Future<List<Business>> getBusinesses();
  Future<Business> getBusinessById(String id);
  Future<Business> createBusiness({
    required String name,
    required String type,
    required String phone,
    required String address,
    String? description,
    String? logo,
  });
}
