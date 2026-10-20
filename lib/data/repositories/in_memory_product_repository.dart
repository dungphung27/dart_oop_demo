import 'package:dart_oop_demo/core/error/logger_mixin.dart';
import 'package:dart_oop_demo/domain/entities/product.dart';
import 'package:dart_oop_demo/domain/exceptions/network_exception.dart';
import 'package:dart_oop_demo/domain/exceptions/not_found_exception.dart';
import 'package:dart_oop_demo/domain/repositories/product_repository.dart';

// Bản cài đặt cụ thể của ProductRepository: dữ liệu để trong List.
class InMemoryProductRepository with LoggerMixin implements ProductRepository {
  // offline = true: giả lập mất mạng, để demo NetworkException.
  final bool offline;

  InMemoryProductRepository({this.offline = false});

  final List<Product> _items = [
    Product(1, 'Bàn phím', 850000),
    Product(2, 'Chuột', 320000),
  ];

  // LÝ THUYẾT: try-catch-finally
  //   try      : đoạn code có thể lỗi
  //   catch    : bắt lỗi nếu có
  //   finally  : LUÔN chạy, dù thành công hay lỗi (hợp để dọn dẹp, ghi log)
  //
  // Ở đây ta không catch, mà để lỗi "bay lên" cho ErrorHandler xử lý tập trung.
  // finally vẫn chạy trên đường lỗi bay đi.
  @override
  Product getById(int id) {
    log('getById($id) bắt đầu');
    try {
      if (offline) {
        throw NetworkException('Mất kết nối mạng');
      }
      for (final p in _items) {
        if (p.id == id) return p;
      }
      throw NotFoundException('Không tìm thấy sản phẩm id=$id');
    } finally {
      log('getById($id) kết thúc');
    }
  }

  @override
  List<Product> getAll() => _items;
}
