import 'package:dart_oop_demo/domain/exceptions/validation_exception.dart';
import 'package:dart_oop_demo/domain/mixins/validation_mixin.dart';

class Product with ValidationMixin {
  final int id;
  final String name;
  final double price;

  // Constructor thường: tạo object và kiểm tra dữ liệu bằng mixin.
  Product(this.id, this.name, this.price) {
    validateNotEmpty(name, 'Tên sản phẩm');
    validatePositive(price, 'Giá');
  }

 
  Product.empty()
      : id = 0,
        name = '',
        price = 0;

  
  factory Product.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('name') ||
        !json.containsKey('price')) {
      throw ValidationException('JSON thiếu trường id, name hoặc price: $json');
    }
    return Product(
      json['id'] as int,
      json['name'] as String,
      (json['price'] as num).toDouble(),
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}
