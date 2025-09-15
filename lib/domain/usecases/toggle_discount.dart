import '../repositories/product_repository.dart';

class ToggleDiscount {
  final ProductRepository repository;
  ToggleDiscount(this.repository);

  Future<void> call(String id) async {
    return repository.toggleDiscount(id);
  }
}
