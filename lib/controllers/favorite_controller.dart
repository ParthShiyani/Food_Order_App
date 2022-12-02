import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/models/food_model.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  void addOrRemoveFavorite({required item}) {
    if (item.isFav) {
      CloudFirestoreHelper.cloudFirestoreHelper.removeInFavorite(item: item);
    } else {
      CloudFirestoreHelper.cloudFirestoreHelper.insertInFavorite(item: item);
    }
  }
}
