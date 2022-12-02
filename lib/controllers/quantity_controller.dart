import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/models/food_model.dart';
import 'package:get/get.dart';

class QuantityController extends GetxController {
  void addQuantity({required FoodModel item}) {
    int value = item.quantity;
    value += 1;
    CloudFirestoreHelper.cloudFirestoreHelper
        .addQuantity(item: item, newVal: value);
  }

  void removeQuantity({required FoodModel item}) {
    int value = item.quantity;
    value -= 1;
    CloudFirestoreHelper.cloudFirestoreHelper
        .removeQuantity(item: item, newVal: value);
  }
}
