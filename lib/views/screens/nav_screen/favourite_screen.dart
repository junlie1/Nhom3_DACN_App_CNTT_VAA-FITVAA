import 'package:dacn_nhom3_customer/provider/favourite_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
class FavouriteScreen extends ConsumerStatefulWidget {
  const FavouriteScreen({super.key});

  @override
  ConsumerState<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final wishItemData = ref.watch(favouriteProvider);
    final wishListProvider = ref.read(favouriteProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sản phẩm yêu thích"
        ),
      ),
      body: wishItemData.isEmpty
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Chưa có sản phẩm yêu thích \n Nhấn vào trang chủ để thêm sản phẩm',
                  style: GoogleFonts.montserrat(
                    fontSize: 17,
                    letterSpacing: 1.7,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context,
                        ) {
                      return const MainScreen();
                    }));
                  },
                  child: const Text('Trang chủ'),
                ),
              ],
            ),
          )
      : ListView.builder(
        itemCount: wishItemData.length,
        itemBuilder: (context,index) {
          final wishData = wishItemData.values.toList()[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Container(
                width: 335,
                height: 96,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 336,
                          height: 97,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(
                                0xFFEFF0F2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 13,
                        top: 9,
                        child: Container(
                          width: 78,
                          height: 78,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBCC5FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 250,
                        top: 16,
                        child: Text(
                          '${wishData.productPrice.toStringAsFixed(2)} đ',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(
                              0xFF0B0C1F,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 101,
                        top: 14,
                        child: SizedBox(
                          width: 162,
                          child: Text(
                            wishData.productName,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 23,
                        top: 14,
                        child: Image.network(
                          wishData.image[0],
                          width: 56,
                          height: 67,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 284,
                        top: 47,
                        child: IconButton(
                          onPressed: () {
                            wishListProvider.removeFavouriteItem(wishData.productId);
                          },
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      )
    );
  }
}
