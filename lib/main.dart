import 'dart:ui';

import 'package:dart_oop_demo/core/error/error_handler.dart';
import 'package:dart_oop_demo/core/error/logger_mixin.dart';
import 'package:dart_oop_demo/data/repositories/in_memory_product_repository.dart';
import 'package:dart_oop_demo/domain/entities/product.dart';
import 'package:dart_oop_demo/domain/factories/payment_factory.dart';
import 'package:dart_oop_demo/domain/repositories/product_repository.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // LÝ THUYẾT: Error boundary trong Flutter = 3 điểm chặn lỗi toàn cục.

  // Điểm 1: lỗi trong framework (build, layout, paint...)
  FlutterError.onError = (details) {
    ErrorHandler.instance.handle(
      details.exception,
      details.stack ?? StackTrace.current,
    );
  };

  // Điểm 2: lỗi async không ai bắt
  PlatformDispatcher.instance.onError = (error, stack) {
    ErrorHandler.instance.handle(error, stack);
    return true; // đã xử lý, app không sập
  };

  // Điểm 3: widget hiện thay cho màn hình đỏ khi build() bị lỗi
  ErrorWidget.builder = (details) => const Text(
        'Phần giao diện này bị lỗi',
        style: TextStyle(color: Colors.red),
      );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ErrorHandler handler = ErrorHandler.instance;

  // Khai báo kiểu abstract, gán object cụ thể: UI không biết data đến từ đâu.
  final ProductRepository repo = InMemoryProductRepository();
  final ProductRepository offlineRepo = InMemoryProductRepository(offline: true);

  bool showBroken = false;

  // Chạy hành động qua ErrorHandler, rồi hiện kết quả bằng SnackBar.
  void runAction<T>(T Function() action) {
    final result = handler.run(action);
    final text = result == null
        ? handler.lastUserMessage
        : 'Thành công: $result';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {});
  }

  // Lỗi async/build xảy ra sau một lúc, nên cập nhật lại màn hình sau đó.
  void refreshLater() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() {});
    });
  }

  Widget button(String label, VoidCallback onPressed) {
    return ElevatedButton(onPressed: onPressed, child: Text(label));
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
                button('Load id=1 (OK)', () => runAction(() => repo.getById(1))),
                button('Load id=999 (NotFound)',
                    () => runAction(() => repo.getById(999))),
                button('Mất mạng (Network)',
                    () => runAction(() => offlineRepo.getById(1))),
                button('JSON thiếu trường (factory constructor)',
                    () => runAction(() => Product.fromJson({'id': 3, 'price': 100}))),
                button('Tên rỗng (mixin)',
                    () => runAction(() => Product(4, '', 100))),
                button('Product.empty() (named constructor)',
                    () => runAction(() => Product.empty())),
                button('Pay "card" (Factory OK)',
                    () => runAction(() => PaymentFactory.create('card').pay(100000))),
                button('Pay "bitcoin" (Factory lỗi)',
                    () => runAction(() => PaymentFactory.create('bitcoin').pay(100000))),
                button('Lỗi lạ (bug)', () => runAction(() => [1, 2, 3][10])),
                button('Lỗi async không ai bắt', () {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    throw Exception('Lỗi async không ai bắt');
                  });
                  refreshLater();
                }),
                button('Bật/tắt widget lỗi', () {
                  setState(() => showBroken = !showBroken);
                  refreshLater();
                }),
                button('Xóa log', () => setState(() => LoggerMixin.logs.clear())),
              ],
            ),
            if (showBroken)
              SizedBox(
                height: 40,
                child: Builder(
                  builder: (context) => throw Exception('Lỗi giả lập trong build()'),
                ),
              ),
            const Divider(height: 24),
            const Text('Log:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: [
                  for (final line in LoggerMixin.logs.reversed)
                    Text(
                      line,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
