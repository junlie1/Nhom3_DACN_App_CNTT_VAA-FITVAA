import 'package:dacn_nhom3_customer/controllers/banner_controller.dart';
import 'package:dacn_nhom3_customer/provider/banner_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class BannerWidget extends ConsumerStatefulWidget {
  const BannerWidget({super.key});

  @override
  ConsumerState<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends ConsumerState<BannerWidget> {

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    final BannerController bannerController = BannerController();
    try{
      final banners = await bannerController.loadBanners();
      ref.read(bannerProvider.notifier).setBanners(banners);
    }
    catch(e) {
      print("Lỗi $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8,0,8,10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(10)
        ),
        child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context,index) {
              final banner = banners[index];
              return Image.network(
                banner.image,
                fit: BoxFit.cover,
              );
            }
        )
      ),
    );
  }
}
