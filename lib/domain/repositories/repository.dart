// LÝ THUYẾT: Generics
// <T> là "ô trống kiểu dữ liệu", điền sau. Viết 1 lần, dùng cho nhiều kiểu:
//
//   Repository<Product>  -> getById trả về Product
//   Repository<User>     -> getById trả về User
//
// Không có generics thì phải viết ProductRepository, UserRepository... lặp lại.
abstract class Repository<T> {
  T getById(int id);
  List<T> getAll();
}
