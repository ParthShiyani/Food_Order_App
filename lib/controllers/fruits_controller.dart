import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/models/food_model.dart';
import 'package:food_order_app/models/fruits_model.dart';
import 'package:get/get.dart';

class FruitsController extends GetxController {
  turnIntoObjetct({required List<QueryDocumentSnapshot> list}) {
    List<FruitsModel> fruitsModel =
        list.map((e) => FruitsModel.fromMap(data: e)).toList();

    return fruitsModel;
  }
}
