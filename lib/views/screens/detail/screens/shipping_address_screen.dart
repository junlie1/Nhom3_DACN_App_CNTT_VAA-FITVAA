
import 'package:dacn_nhom3_customer/controllers/auth_controller.dart';
import 'package:dacn_nhom3_customer/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late TextEditingController _cityController;
  late TextEditingController _localityController;
  late TextEditingController _phoneNumberController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*Read the current user in user provider*/
    final user = ref.read(userProvider);

    // Khởi tạo các controller với dữ liệu hiện tại nếu có
    // nếu dữ liệu người dùng không có sẵn, khởi tạo với chuỗi rỗng
    _cityController = TextEditingController(text: user?.city ?? "");
    _localityController = TextEditingController(text: user?.locality ?? "");
    _phoneNumberController = TextEditingController(text: user?.phoneNumber ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final updateUser = ref.read(userProvider.notifier);
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Shipping address"
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black12
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Hãy nhập địa chỉ của bạn ở đây",style: TextStyle(fontSize: 20,color: Colors.deepPurpleAccent),),
                const SizedBox(height: 100,),
                TextFormField(
                  controller: _cityController,
                  validator: (value) {
                    if(value!.isEmpty) {
                      return "Hãy nhập thành phố của bạn";
                    }
                    else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
                const SizedBox(height: 30,),
                TextFormField(
                  controller: _localityController,
                  validator: (value) {
                    if(value!.isEmpty) {
                      return "Hãy nhập địa chỉ của bạn ";
                    }
                    else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Locality",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),

                const SizedBox(height: 30,),
                TextFormField(
                  controller: _phoneNumberController,
                  validator: (value) {
                    if(value!.isEmpty) {
                      return "Hãy nhập số điện thoại của bạn ";
                    }
                    else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async{
          if(_formKey.currentState!.validate()) {
            print("Click");
            await _authController.updateUserLocation(
                context: context,
                userId: ref.read(userProvider)!.id,
                city: _cityController.text,
                locality: _localityController.text,
                phoneNumber: _phoneNumberController.text,
            ).whenComplete(() {
              Navigator.pop(context);
            });
            updateUser.recreateUserState(
              city: _cityController.text,
              locality: _localityController.text,
              phoneNumber: _phoneNumberController.text,
            );
          }
          else {
            print("Lỗi");
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Center(
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
