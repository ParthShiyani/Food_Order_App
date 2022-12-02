import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/views/scrrens/bottoms/favorite_items_page.dart';
import 'package:food_order_app/views/scrrens/bottoms/product_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.location_solid,
              color: Colors.green,
              size: 25,
            ),
            Text(
              " Surat,GJ.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 19),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            CloudFirestoreHelper.cloudFirestoreHelper.insertPlate();
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 10, bottom: 5),
            height: 30,
            width: 45,
            decoration: BoxDecoration(
              // color: primaryColor,
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage("assets/images/man.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment(0.1, 1.05),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed("/cart_page");
          },
          backgroundColor: Colors.green,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: const Icon(
            CupertinoIcons.cart_fill,
            color: Colors.white,
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
              ),
              label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_outlined,
            ),
            label: "Notification",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border,
              ),
              label: "Favorite"),
        ],
        iconSize: 25,
        fixedColor: Colors.green,
        currentIndex: selected,
        enableFeedback: true,
        elevation: 0,
        unselectedIconTheme: IconThemeData(color: Colors.black),
        onTap: (index) {
          pageController.jumpToPage(index);
          setState(
            () {
              selected = index;
            },
          );
        },
      ),
      body: PageView(
        onPageChanged: (val) {
          pageController.jumpToPage(val);
          setState(() {
            selected = val;
          });
        },
        controller: pageController,
        children: [
          ProductPage(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Spacer(),
                Icon(
                  Icons.sentiment_dissatisfied_outlined,
                  size: 70,
                  color: Colors.green,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "You haven't any Messages yet.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Spacer(),
                Icon(
                  Icons.notifications_off,
                  size: 70,
                  color: Colors.green,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "You haven't any Notification yet.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          FavoriteItemPage(),
        ],
      ),
    );
  }
}
