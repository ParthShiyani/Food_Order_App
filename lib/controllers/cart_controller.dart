import 'package:flutter/material.dart';
import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/models/food_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  int subTotal({required List allCartItems}) {
    int total = 0;

    for (FoodModel foodModel in allCartItems) {
      total += foodModel.price;
    }
    return total;
  }

  void addToCart({required item}) {
    if (item.isAdd) {
      Get.snackbar(
          "Already In Cart List",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green.withOpacity(0.2),
          icon: Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
          mainButton: TextButton(
              onPressed: () {
                Get.toNamed("/cart_page");
              },
              child: Text("Cart"),
              style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          "You Can See ${item.name} From Cart Section");
    } else {
      CloudFirestoreHelper.cloudFirestoreHelper.insertInCart(item: item);
      Get.snackbar(
        "SuccessFully Added in Cart",
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.black,
        ),
        mainButton: TextButton(
            onPressed: () {
              Get.toNamed("/cart_page");
            },
            child: Text("Cart"),
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle:
                    TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        duration: Duration(seconds: 3),
        "You Can See ${item.name} From Cart Section",
      );
    }
  }

  void removeFromCart({required item}) {
    CloudFirestoreHelper.cloudFirestoreHelper.removeInCart(item: item);
  }
}
