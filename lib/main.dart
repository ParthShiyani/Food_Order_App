import 'package:flutter/material.dart';
import 'package:food_order_app/views/scrrens/bottoms/favorite_items_page.dart';
import 'package:food_order_app/views/scrrens/cart_page.dart';
import 'package:food_order_app/views/scrrens/detals_pages/food_details_page.dart';
import 'package:food_order_app/views/scrrens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_order_app/views/scrrens/bottoms/product_page.dart';
import 'package:food_order_app/views/scrrens/splash_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/intro_page',
    getPages: <GetPage>[
      GetPage(name: '/', page: () => const HomePage()),
      GetPage(name: '/intro_page', page: () => const SplashScreenPage()),
      GetPage(name: '/product_page', page: () => const ProductPage()),
      GetPage(name: '/food_detail_page', page: () => const FoodDetailsPage()),
      GetPage(
          name: '/favorite_items_page', page: () => const FavoriteItemPage()),
      GetPage(name: '/cart_page', page: () => const CartPage()),
    ],
  ));
}
