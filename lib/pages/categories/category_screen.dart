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
    return categoryList.map((dynamic item) {
      return Category.fromJson(item);
    }).toList();
  }

  void _getCategoryList() async {
    await _getCategories().then((value) {
      setState(() {
        categories = value;
        filteredCategories = categories;
      });
    });
  }

  void _filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) =>
              GlobalFunction.convertVietnameseString(category.catName).toLowerCase().contains(GlobalFunction.convertVietnameseString(query).toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    _getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // TODO: Implement add category functionality
              final result = await Get.to(() => AddCategoryScreen());
              if (true) {
                _getCategoryList();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm danh mục',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                _filterCategories(value);
              },
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
                  return ListTile(
                    title: Text(filteredCategories[index].catName),
                    leading: // category image from server
                    Image.network(
                      'http://14.160.33.94:3010/category_images/${c.shopID.value}_${filteredCategories[index].catCode}.jpg',
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
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await  Get.to(() => EditCategoryScreen(selectedCategory: filteredCategories[index]));
                        if (true) {
                          _getCategoryList();
                        }
                      },
                    ),  
                    onTap: () {
                      // TODO: Implement edit category functionality
                    },
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

