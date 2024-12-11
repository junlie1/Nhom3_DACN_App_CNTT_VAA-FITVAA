import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String city;
  final String locality;
  final String phoneNumber;
  final String password;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.city,
    required this.locality,
    required this.phoneNumber,
    required this.password,
    required this.token
  });

  //sử dụng khi cần tuần tự hóa đối tượng User hoặc truyền nó qua các API
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      'fullName': fullName,
      'email': email,
      'city': city,
      'locality': locality,
      'phoneNumber': phoneNumber,
      'password': password,
      'token': token
    };
  }

  // Mỗi thuộc tính của User được lấy từ cặp khóa-giá trị tương ứng trong Map.
  // Nếu bất kỳ khóa nào không tồn tại trong Map, nó sẽ được mặc định là chuỗi rỗng ("").
  factory User.fromMap(Map<String,dynamic> map) {
    return User (
      id: map['_id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      phoneNumber: map['phoneNumber'] as String? ?? "",
      password: map['password'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }
  //Convert object User to json
  //Từ user -> Map,dùng encode để chuyển thằng map thành json
  String toJson() => jsonEncode(toMap());

  //nhận dữ liệu JSON từ một API
  //chuyển đổi nó thành đối tượng User trong ứng dụng.
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}