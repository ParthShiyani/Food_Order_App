import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_model.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference foodsRef;
  late CollectionReference fruitsRef;
  late CollectionReference favoritesRef;
  late CollectionReference cartRef;

  //connection with collection==================================================

  connectWithFoodsCollection() {
    foodsRef = firebaseFirestore.collection('foods');
  }

  connectWithFruitsCollection() {
    fruitsRef = firebaseFirestore.collection('fruits');
  }

  connectWithFavoritesCollection() {
    favoritesRef = firebaseFirestore.collection('favorites');
  }

  connectWithCartsCollection() {
    cartRef = firebaseFirestore.collection('carts');
  }

  insertPlate() async {
    connectWithFruitsCollection();

    // await fruitsRef.doc("9").set({
    //   'name': "Fresh Apple",
    //   'price': 150,
    //   'rating': "4.0",
    //   'quantity': 1,
    //   'image': "f1_apple.png",
    //   'isFav': false,
    //   'isAdd': false,
    // });
  }

  // insert===============================

  insertInFavorite({required FoodModel item}) async {
    connectWithFavoritesCollection();
    connectWithFoodsCollection();
    connectWithCartsCollection();

    await favoritesRef.doc(item.id).set({
      'name': item.name,
      'price': item.price,
      'rating': item.rating,
      'quantity': item.quantity,
      'image': item.image,
      'isFav': true,
      'isAdd': item.isAdd,
    });

    await foodsRef.doc(item.id.toString()).update({
      'isFav': true,
    });

    await cartRef.doc(item.id.toString()).update({
      'isFav': true,
    });
  }

  insertInCart({required FoodModel item}) async {
    connectWithCartsCollection();
    connectWithFoodsCollection();

    await cartRef.doc(item.id).set({
      'name': item.name,
      'price': item.price,
      'rating': item.rating,
      'quantity': item.quantity,
      'image': item.image,
      'isFav': item.isFav,
      'isAdd': true,
    });

    await foodsRef.doc(item.id.toString()).update({
      'isAdd': true,
    });
  }

  //fetch data ==============================================
  Stream<QuerySnapshot> selectFood() {
    connectWithFoodsCollection();
    print("connetcted with foods*********************************");

    return foodsRef.snapshots();
  }

  Stream<QuerySnapshot> selectFruits() {
    connectWithFruitsCollection();
    print("connetcted with foods*********************************");

    return fruitsRef.snapshots();
  }

  Stream<QuerySnapshot> selectFavoriteList() {
    connectWithFavoritesCollection();
    print("connetcted with fav*********************************");

    return favoritesRef.snapshots();
  }

  Stream<QuerySnapshot> selectCartList() {
    connectWithCartsCollection();
    print("connetcted with Carts*********************************");

    return cartRef.snapshots();
  }

  //remove =======================================================

  removeInFavorite({required FoodModel item}) async {
    connectWithFoodsCollection();
    connectWithFavoritesCollection();
    connectWithCartsCollection();

    await favoritesRef.doc(item.id).delete();
    await foodsRef.doc(item.id).update({
      'isFav': false,
    });

    await cartRef.doc(item.id).update({
      'isFav': false,
    });
  }

  removeInCart({required FoodModel item}) async {
    connectWithFoodsCollection();
    connectWithCartsCollection();

    await cartRef.doc(item.id).delete();
    await foodsRef.doc(item.id).update({
      'isAdd': false,
    });
  }

  //update========================================================
  addQuantity({required FoodModel item, required int newVal}) async {
    connectWithFoodsCollection();
    connectWithFavoritesCollection();
    connectWithCartsCollection();

    await foodsRef.doc(item.id).update({
      'quantity': newVal,
    });

    await favoritesRef.doc(item.id).update({
      'quantity': newVal,
    });

    await cartRef.doc(item.id).update({
      'quantity': newVal,
    });
  }

  removeQuantity({required FoodModel item, required int newVal}) async {
    connectWithFoodsCollection();
    connectWithFavoritesCollection();
    connectWithCartsCollection();

    await foodsRef.doc(item.id).update({
      'quantity': newVal,
    });

    await favoritesRef.doc(item.id).update({
      'quantity': newVal,
    });

    await cartRef.doc(item.id).update({
      'quantity': newVal,
    });
  }
}
