import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/cart_controller.dart';
import 'package:food_order_app/controllers/favorite_controller.dart';
import 'package:food_order_app/controllers/foods_controller.dart';
import 'package:food_order_app/controllers/quantity_controller.dart';
import 'package:food_order_app/models/food_model.dart';
import 'package:get/get.dart';

import '../../../helpers/cloude_firestore_helper.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage({Key? key}) : super(key: key);

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  FavoriteController favoriteController = Get.find<FavoriteController>();
  FoodsController foodsController = Get.find<FoodsController>();
  CartController cartController = Get.find<CartController>();
  QuantityController quantityController = Get.put(QuantityController());

  @override
  Widget build(BuildContext context) {
    FoodModel args = Get.arguments;
    int id = int.parse(args.id);
    int finalId = id - 1;
    return Scaffold(
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectFood(),
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

            return (documents.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Spacer(),
                        Icon(
                          Icons.food_bank,
                          size: 70,
                          color: Colors.green,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "No Food Available here...!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.green,
                      title: const Text("Food Details"),
                      centerTitle: true,
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
                      actions: [
                        InkWell(
                          onTap: () {
                            favoriteController.addOrRemoveFavorite(
                                item: foodModel[finalId]);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: (foodModel[finalId].isFav)
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    body: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: const Alignment(0, -1.6),
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            height: MediaQuery.of(context).size.height * 0.68,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 100),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          foodModel[finalId].name,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            wordSpacing: 3,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "₹ ${foodModel[finalId].price}.00",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 50,
                                      width: 115,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (foodModel[finalId].quantity >
                                                  0)
                                                quantityController
                                                    .removeQuantity(
                                                        item:
                                                            foodModel[finalId]);
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            foodModel[finalId]
                                                .quantity
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              quantityController.addQuantity(
                                                  item: foodModel[finalId]);
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "⭐ ${foodModel[finalId].rating}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Text(
                                      "🩸 100 Kcal",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Text(
                                      "🕛 20 min",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text(
                                  "About food  ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 29),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: (foodModel[finalId].isAdd)
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: const StadiumBorder(),
                                          ),
                                          onPressed: () {
                                            cartController.removeFromCart(
                                                item: foodModel[finalId]);
                                          },
                                          child: const Text(
                                            "Remove From cart",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: const StadiumBorder(),
                                          ),
                                          onPressed: () {
                                            cartController.addToCart(
                                                item: foodModel[finalId]);
                                          },
                                          child: const Text(
                                            "Add to cart",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          Container(
                            child: Image.asset(
                              "assets/images/${foodModel[finalId].image}",
                              fit: BoxFit.contain,
                              height: 200,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
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
    // return Scaffold(
    //   backgroundColor: Colors.green,
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: Colors.green,
    //     title: const Text("Food Details"),
    //     centerTitle: true,
    //     leading: InkWell(
    //       onTap: () {
    //         Get.back();
    //       },
    //       child: Container(
    //         margin: const EdgeInsets.all(10),
    //         height: 50,
    //         width: 50,
    //         decoration: BoxDecoration(
    //           color: Colors.white.withOpacity(0.3),
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: const Center(
    //           child: Icon(
    //             Icons.arrow_back_ios_new_rounded,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //     actions: [
    //       InkWell(
    //         onTap: () {
    //           favoriteController.addOrRemoveFavorite(item: data);
    //         },
    //         child: Container(
    //           margin: const EdgeInsets.all(10),
    //           height: 50,
    //           width: 50,
    //           decoration: BoxDecoration(
    //             color: Colors.white.withOpacity(0.3),
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           child: (data.isFav)
    //               ? const Icon(
    //                   Icons.favorite,
    //                   color: Colors.red,
    //                   size: 30,
    //                 )
    //               : const Icon(
    //                   Icons.favorite_border,
    //                   color: Colors.grey,
    //                   size: 30,
    //                 ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   body: Align(
    //     alignment: Alignment.bottomCenter,
    //     child: Stack(
    //       alignment: const Alignment(0, -1.6),
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
    //           height: MediaQuery.of(context).size.height * 0.68,
    //           width: MediaQuery.of(context).size.width,
    //           decoration: const BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.only(
    //               topRight: Radius.circular(40),
    //               topLeft: Radius.circular(40),
    //             ),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const SizedBox(height: 100),
    //               Row(
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         data.name,
    //                         style: const TextStyle(
    //                           fontSize: 22,
    //                           wordSpacing: 3,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                       const SizedBox(
    //                         height: 10,
    //                       ),
    //                       Text(
    //                         "₹ ${data.price}.00",
    //                         style: const TextStyle(
    //                           color: Colors.green,
    //                           fontSize: 17,
    //                           fontWeight: FontWeight.w800,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   const Spacer(),
    //                   Container(
    //                     height: 50,
    //                     width: 110,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(20),
    //                       color: Colors.green,
    //                     ),
    //                     child: Row(
    //                       children: [
    //                         IconButton(
    //                           onPressed: () {},
    //                           icon: const Icon(
    //                             Icons.remove,
    //                             size: 20,
    //                             color: colorWhite,
    //                           ),
    //                         ),
    //                         Text(
    //                           data.quantity.toString(),
    //                           style: const TextStyle(
    //                             fontSize: 20,
    //                             color: colorWhite,
    //                           ),
    //                         ),
    //                         IconButton(
    //                           onPressed: () {},
    //                           icon: const Icon(
    //                             Icons.add,
    //                             size: 20,
    //                             color: colorWhite,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(
    //                 height: 30,
    //               ),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   Text(
    //                     "⭐ ${data.rating}",
    //                     style: const TextStyle(
    //                       fontSize: 15,
    //                       color: Colors.grey,
    //                       fontWeight: FontWeight.w800,
    //                     ),
    //                   ),
    //                   const Text(
    //                     "🩸 100 Kcal",
    //                     style: TextStyle(
    //                       fontSize: 15,
    //                       color: Colors.grey,
    //                       fontWeight: FontWeight.w800,
    //                     ),
    //                   ),
    //                   const Text(
    //                     "🕛 20 min",
    //                     style: TextStyle(
    //                       fontSize: 15,
    //                       color: Colors.grey,
    //                       fontWeight: FontWeight.w800,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               const SizedBox(
    //                 height: 30,
    //               ),
    //               const Text(
    //                 "About food  ",
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
    //               ),
    //               const SizedBox(
    //                 height: 10,
    //               ),
    //               const Text(
    //                 "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the",
    //                 style: TextStyle(
    //                   color: Colors.grey,
    //                 ),
    //               ),
    //               const Spacer(),
    //               SizedBox(
    //                 width: double.infinity,
    //                 height: 50,
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.green,
    //                     shape: const StadiumBorder(),
    //                   ),
    //                   onPressed: () {},
    //                   child: const Text(
    //                     "Add to cart",
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.white,
    //                       fontSize: 16,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 20),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           child: Image.asset(
    //             "assets/images/${data.image}",
    //             fit: BoxFit.contain,
    //             height: 200,
    //             width: 200,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
