import 'package:food_order_app/models/food_model.dart';
import 'package:get/get.dart';

class FoodsController extends GetxController {
  turnIntoObjetct({required List list}) {
    List<FoodModel> foodModel =
        list.map((e) => FoodModel.fromMap(data: e)).toList();

    return foodModel;
  }
}
