import 'package:dacn_nhom3_customer/controllers/category_controller.dart';
import 'package:dacn_nhom3_customer/provider/category_provider.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/inner_category_screen.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/reusable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryWidget extends ConsumerStatefulWidget {
  const CategoryWidget({super.key});

  @override
  ConsumerState<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends ConsumerState<CategoryWidget> {
  @override
  //initState sử dụng để thiết lập trạng thái ban đầu của widget hoặc khởi tạo các tác vụ bất đồng bộ
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async{
    final CategoryControllers categoryControllers = CategoryControllers();
    try {
      final categories = await categoryControllers.loadCategories();
      ref.read(categoryProvider.notifier).setCategories(categories);
    }
    catch(e) {
      print("Lỗi $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            ReusableTextWidget(title: "Categories", subtitle: "View all", onSubtitlePressed: () {}),

  //Danh sách categories
            Column(
              children: [
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context,index) {
                      final category = categories[index];
                      return InkWell(
                        //Goi sự kiện sang
                        //Detail/screen/inner_category
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return InnerCategoryScreen(category: category,);
                          }));
                        },
                        child: Column(
                          children: [
                            Image.network(height: 60, width: 60, category.image),
                            Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      );
                    }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
