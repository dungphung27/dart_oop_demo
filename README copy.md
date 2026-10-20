# dart_oop_demo

Chủ đề 01 - Lập trình Đa nền tảng: OOP nâng cao & Design Patterns trong Dart kết hợp xử lý ngoại lệ tập trung.

Nhóm: Phùng Đức Dũng, Phan Văn Đức Hiếu.

## Nội dung

- OOP nâng cao: named constructor, factory constructor, mixin, generics
- Domain Layer tách biệt, áp dụng Repository Pattern và Factory Pattern
- Centralized Error Handling Pipeline: phân loại, ghi log, tạo message cho người dùng
- Error boundary trong Flutter: `FlutterError.onError`, `PlatformDispatcher.onError`, `ErrorWidget.builder`

## Cấu trúc thư mục

```
lib/
  domain/    exceptions, mixins, entities, repositories, payments, factories
  data/      InMemoryProductRepository
  core/      LoggerMixin, ErrorHandler
  main.dart  giao diện Flutter web để bấm nút gây lỗi và xem log
bin/main.dart   bản chạy bằng Dart thuần (10 kịch bản, in ra console)
```

## Cài đặt và chạy

Yêu cầu: Flutter SDK (bản có Dart >= 3.0). Dự án không dùng biến môi trường (.env)
hay google-services.json.

```
flutter pub get
flutter run -d chrome        # chạy trên web
dart run bin/main.dart       # chạy bản console
```

Nếu thư mục chưa có hỗ trợ web: `flutter create --platforms=web .` rồi chạy lại.

## Phân công

| Thành viên | Vai trò |
|---|---|
| Phùng Đức Dũng | Business Logic (Domain Layer), Database/API (Repository), báo cáo phần lý thuyết |
| Phan Văn Đức Hiếu | UI Design, State Management, Error Handling Pipeline, slide phần demo |
