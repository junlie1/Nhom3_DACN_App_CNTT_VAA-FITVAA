import 'package:dacn_nhom3_customer/controllers/category_controller.dart';
import 'package:dacn_nhom3_customer/controllers/subcategory_controller.dart';
import 'package:dacn_nhom3_customer/models/category.dart';
import 'package:dacn_nhom3_customer/models/sub_category.dart';
import 'package:dacn_nhom3_customer/views/screens/detail/screens/widgets/subcategory_tile_widget.dart';
import 'package:dacn_nhom3_customer/views/screens/nav_screen/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Category>> futureCategories;
  Category? _selectedCategory;
  //1 category có nhiều subcategories nên để 1 list
  List<SubCategory> _subcategories = [];
  final SubcategoryController _subcategoryController = SubcategoryController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryControllers().loadCategories();

//Đặt màn hình mặc định cho Category
    futureCategories.then((categories) {
      for(var category in categories) {
        if(category.name == "Fashions") {
          setState(() {
            _selectedCategory = category;
          });
          _loadSubcategories(category.name);
        }
      }
    });
  }

  //Hàm loadCategory:
  Future<void> _loadSubcategories(String categoryName) async{
    final subcategories = await _subcategoryController.getSubCategoryByCategoryName(categoryName);
    setState(() {
      _subcategories = subcategories;
    });
    print(subcategories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 20),
          child: const HeaderWidget()
      ),
      body: Row(
        children: [
/*Bên trái*/
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black12,
              child: FutureBuilder(future: futureCategories, builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState) {
                  return const CircularProgressIndicator();
                }
                else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Lỗi: ${snapshot.error}"
                    ),
                  );
                }
                else {
                  final categories = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index){
                      final category = categories[index];
                      return ListTile(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _loadSubcategories(category.name);
                        },
                        title: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _selectedCategory == category ? Colors.blue : Colors.black
                          ) ,
                        ),
                      );
                  });
                }
              }),
            ),
          ),

/*Bên phải*/
          Expanded(
            flex:5,
            child: _selectedCategory != null
  /*Hiển thị Danh sách gồm banner và subcategory name*/
                ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_selectedCategory!.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(_selectedCategory!.banner),
                                fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                        _subcategories.isNotEmpty
                            ? GridView.builder(
                          shrinkWrap: true,
                          itemCount: _subcategories.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 6,
                            childAspectRatio: 1.6/3
                          ),
                          itemBuilder: (context,index) {
                            final subcategory = _subcategories[index];
                            return SubcategoryTileWidget(image: subcategory.image, title: subcategory.subCategoryName);
                          }
                        )
                            : Center(
                          child: Text("Không có danh mục sản phẩm cho ${_selectedCategory!.name}"),
                        )
                      ],
              ),
            )
                : Container(
              child: Text("Danh mục này không có sản phẩm"),
            ),
          )
        ],
      ),
    );
  }
}
