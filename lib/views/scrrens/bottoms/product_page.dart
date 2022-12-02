import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/globals/Global.dart';
import 'package:food_order_app/views/scrrens/tabs/food_page.dart';
import '../tabs/fruites_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  searchFromFirebase({required String query}) async {
    final result = await FirebaseFirestore.instance
        .collection('foods')
        .where('name', arrayContains: query)
        .get();

    print("fegtched***************************");
    print("result ${result.docs.first}");
    setState(() {
      Global.searchResults = result.docs.map((e) => e.data()).toList();
    });
    print(Global.searchResults);
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hii Parth",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Find Your Food",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onChanged: (val) {
                  print(
                      "calllesd+________________${val}____________________________");
                  setState(() {
                    searchFromFirebase(query: val);
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.green.shade100,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                  suffixIcon: const Icon(
                    Icons.segment,
                    color: Colors.green,
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              TabBar(
                controller: tabController,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.green,
                isScrollable: true,
                indicatorWeight: 1,
                tabs: const [
                  Tab(text: " Food "),
                  Tab(text: " Fruits "),
                  Tab(text: " Vegetables "),
                  Tab(text: " Grocery's "),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    const FoodPage(),
                    FruitsPage(),
                    Container(
                      color: Colors.deepPurple,
                    ),
                    Container(
                      color: Colors.orangeAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
