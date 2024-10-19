import 'package:debt_manager/controller/APIRequest.dart';
import 'package:debt_manager/controller/GetXController.dart';
import 'package:debt_manager/controller/GlobalFunction.dart';
import 'package:debt_manager/model/DataInterfaceClass.dart';
import 'package:debt_manager/pages/categories/add_category_screen.dart';
import 'package:debt_manager/pages/categories/edit_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  TextEditingController searchController = TextEditingController();
  final GlobalController c = Get.put(GlobalController());

  Future<List<Category>> _getCategories() async {
    List<dynamic> categoryList = [];
    await API_Request.api_query('getCategoryList', {'SHOP_ID': c.shopID.value})
        .then((value) {
      categoryList = value['data'] ?? [];
    });
    return categoryList.map((dynamic item) => Category.fromJson(item)).toList();
  }

  void _getCategoryList() async {
    final value = await _getCategories();
    setState(() {
      categories = value;
      filteredCategories = categories;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
              GlobalFunction.convertVietnameseString(category.catName)
                  .toLowerCase()
                  .contains(GlobalFunction.convertVietnameseString(query).toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(color: Colors.white)),
        //change back arrow color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),  
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              await Get.to(() => AddCategoryScreen());
              _getCategoryList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search categories',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              onChanged: _filterCategories,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                 _getCategoryList();
              },
              child: ListView.builder(
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = filteredCategories[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        category.catName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://14.160.33.94:3010/category_images/${c.shopID.value}_${category.catCode}.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                              child: Icon(Icons.category, color: Colors.grey[600]),
                            );
                          },
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Get.to(() => EditCategoryScreen(selectedCategory: category));
                          _getCategoryList();
                        },
                      ),
                      onTap: () {
                        // TODO: Implement category details view
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
