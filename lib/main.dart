import 'package:dacn_nhom3_customer/provider/user_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/authenication_screen/login_screen.dart';
import 'package:dacn_nhom3_customer/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = ("pk_test_51QQAS0FV5SaBBPCRndFJSvbMnxFlEe5jYa8qJtxqVnD7D7idtj7ghRj29YX9mbFVtJkV718GgYxGHrXMdNAuRYDz00uwtfLqcm");
  await Stripe.instance.applySettings();
  //Chạy flutter app trong ProviderScropr để quản lý trạng thái User
  runApp(const ProviderScope(child: MyApp()));
}

/* Hàm check thông tin User
 ref được dùng để đọc và cập nhật trạng thái người dùng từ userProvider
 */
Future<void> _checkTokenUser(WidgetRef ref) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String? token = preferences.getString('auth_token');
  String? userJson = preferences.getString('user');
  //Kiểm tra có token và user chưa
  if(token != null && userJson != null ) {
    ref.read(userProvider.notifier).setUser(userJson);
  }
  else {
    ref.read(userProvider.notifier).signOut();
  }
}

  /*Dùng ConsumerWidget dễ dàng lấy dữ liệu các Provider hơn*/
class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JunWoan Clothes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _checkTokenUser(ref),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final user = ref.watch(userProvider);
          return user != null ? const MainScreen() : const LoginScreen();
        }
      ),
    );
  }
}

