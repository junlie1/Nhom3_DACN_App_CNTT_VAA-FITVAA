import 'package:dacn_nhom3_customer/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends StateNotifier<User?> {
  /* constructor UserProvider khởi tạo với một đối tượng User mặc định.
     super:gọi đến constructor của lớp StateNotifier
   */
  UserProvider() : super (
    User(
        id: '',
        fullName: '',
        email: '',
        city: '',
        locality: '',
        phoneNumber: '',
        password: '',
        token: ''
    )
  );

  /*Getter method dùng để truy xuất value từ object*/
  User? get user => state;

  /* cập nhật trạng thái User từ JSON */
  void setUser(String userJson){
    state = User.fromJson(userJson);
  }

  /* Xóa thông tin User để logout */
  void signOut() {
    state = null;
  }

  /*Hàm khởi tạo lại trạng thái user*/
  void recreateUserState({
   required String city,
   required String locality,
   required String phoneNumber
}) {
    if(state != null) {
      state = User(
          id: state!.id,
          fullName: state!.fullName,
          email: state!.email,
          city: city,
          locality: locality,
          phoneNumber: phoneNumber,
          password: state!.password,
          token: state!.token
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());