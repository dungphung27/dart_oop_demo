import 'package:flutter/material.dart';
import 'package:dart_oop_demo/core/error/error_handler.dart';
import 'package:dart_oop_demo/core/error/logger_mixin.dart';
import 'package:dart_oop_demo/data/repositories/in_memory_product_repository.dart';
import 'package:dart_oop_demo/domain/entities/product.dart';
import 'package:dart_oop_demo/domain/factories/payment_factory.dart';
import 'package:dart_oop_demo/domain/repositories/product_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final handler = ErrorHandler.instance;

  // Khai báo kiểu abstract, gán object cụ thể (Repository Pattern).
  final ProductRepository repo = InMemoryProductRepository();
  final ProductRepository offlineRepo =
      InMemoryProductRepository(offline: true);

  String result = '';

  @override
  void initState() {
    super.initState();
    // Có log mới thì vẽ lại màn hình.
    // microtask: đợi code hiện tại chạy xong rồi mới setState cho an toàn.
    LoggerMixin.onLog = () {
      Future.microtask(() {
        if (mounted) {
          setState(() {});
        }
      });
    };
  }

  @override
  void dispose() {
    LoggerMixin.onLog = null;
    super.dispose();
  }

  // Chạy một demo: mọi lỗi đều đi qua ErrorHandler.
  void runDemo(String name, Object? Function() action) {
    LoggerMixin.history.add('--- $name ---');
    final value = handler.run(action);
    setState(() {
      result = value == null ? 'Có lỗi (xem log bên dưới)' : 'Kết quả: $value';
    });
  }

  Widget demoButton(String label, Object? Function() action) {
    return ElevatedButton(
      onPressed: () => runDemo(label, action),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OOP + Centralized Error Handling')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                demoButton('1. Thành công', () => repo.getById(1)),
                demoButton('2. NotFound', () => repo.getById(999)),
                demoButton('3. Network', () => offlineRepo.getById(1)),
                demoButton('4. Validation (JSON thiếu)',
                    () => Product.fromJson({'id': 3, 'price': 100})),
                demoButton('5. Validation (tên rỗng)', () => Product(4, '', 100)),
                demoButton('6. Named constructor', () => Product.empty()),
                demoButton('7. Factory: card',
                    () => PaymentFactory.create('card').pay(100000)),
                demoButton('8. Factory: bitcoin',
                    () => PaymentFactory.create('bitcoin').pay(100000)),
                demoButton('9. Lỗi lạ (bug)', () => [1, 2, 3][10]),
                ElevatedButton(
                  onPressed: () {
                    LoggerMixin.history.add('--- 10. Lỗi async không ai bắt ---');
                    // Không qua handler.run: lỗi này rơi vào error boundary trong main.dart
                    Future.delayed(const Duration(milliseconds: 100), () {
                      throw Exception('Lỗi async không ai bắt');
                    });
                    setState(() {});
                  },
                  child: const Text('10. Lỗi async không ai bắt'),
                ),
                OutlinedButton(
                  onPressed: () {
                    LoggerMixin.history.clear();
                    setState(() {
                      result = '';
                    });
                  },
                  child: const Text('Xóa log'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              result,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text('Log:'),
            Expanded(
              // reverse: true để luôn thấy dòng log mới nhất ở dưới cùng
              child: SingleChildScrollView(
                reverse: true,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    LoggerMixin.history.join('\n'),
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
