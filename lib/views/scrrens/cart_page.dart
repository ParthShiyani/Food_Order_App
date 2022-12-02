import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/cart_controller.dart';
import 'package:get/get.dart';
import '../../../controllers/favorite_controller.dart';
import '../../../controllers/foods_controller.dart';
import '../../../helpers/cloude_firestore_helper.dart';
import '../../../models/food_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int subTotal = 0;
  FavoriteController favoriteController = Get.put(FavoriteController());
  FoodsController foodsController = Get.put(FoodsController());
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Items"),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectCartList(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;

            List<QueryDocumentSnapshot> documents = data!.docs;
            List<FoodModel> foodModel =
                foodsController.turnIntoObjetct(list: documents);
            subTotal = cartController.subTotal(allCartItems: foodModel);

            return (documents.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Spacer(),
                        Icon(
                          Icons.food_bank_outlined,
                          size: 70,
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "You haven't added any item in cart yet.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    "Sub Total : ₹ ${subTotal}.00",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Total Product : ${foodModel.length}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 40),
                          child: GridView.builder(
                              itemCount: foodModel.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                mainAxisExtent: 240,
                                childAspectRatio: 0.10,
                              ),
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed('/detail_page',
                                        arguments: foodModel[i]);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      alignment: Alignment.center,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  favoriteController
                                                      .addOrRemoveFavorite(
                                                          item: foodModel[i]);
                                                },
                                                icon: (foodModel[i].isFav)
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 39,
                                                      )
                                                    : Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.grey,
                                                        size: 39,
                                                      )),
                                          ),
                                          Column(
                                            children: [
                                              const Spacer(),
                                              Image.asset(
                                                "assets/images/${foodModel[i].image}",
                                                fit: BoxFit.contain,
                                                height: 120,
                                                width: 120,
                                              ),
                                              Text(
                                                foodModel[i].name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  wordSpacing: 3,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  const Text(
                                                    "20 min",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 50,
                                                  ),
                                                  Text(
                                                    "⭐ ${foodModel[i].rating}",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "   ₹ ${foodModel[i].price}.00",
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(25),
                                                        bottomRight:
                                                            Radius.circular(25),
                                                      ),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        cartController
                                                            .removeFromCart(
                                                                item: foodModel[
                                                                    i]);
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              }),
                        ),
                      ),
                    ],
                  );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
