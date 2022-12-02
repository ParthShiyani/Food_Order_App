import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/cart_controller.dart';
import 'package:food_order_app/controllers/favorite_controller.dart';
import 'package:food_order_app/controllers/foods_controller.dart';
import 'package:food_order_app/globals/Global.dart';
import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/models/food_model.dart';
import 'package:get/get.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  FavoriteController favoriteController = Get.put(FavoriteController());
  FoodsController foodsController = Get.put(FoodsController());
  CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
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

            var find;

            for (int index = 0; index < documents.length; index++) {
              find = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            }

            List<FoodModel> foodModel =
                foodsController.turnIntoObjetct(list: documents);

            List<FoodModel> searched =
                foodsController.turnIntoObjetct(list: Global.searchResults);

            if (searched.isEmpty) {
              return Container(
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
                          Get.toNamed('/food_detail_page',
                              arguments: foodModel[i]);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(25)),
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      onPressed: () {
                                        favoriteController.addOrRemoveFavorite(
                                            item: foodModel[i]);
                                      },
                                      icon: (foodModel[i].isFav)
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 39,
                                            )
                                          : const Icon(
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
                                            fontWeight: FontWeight.w800,
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
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "   ₹ ${foodModel[i].price}.00",
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              cartController.addToCart(
                                                  item: foodModel[i]);
                                            },
                                            icon: const Icon(
                                              Icons.add,
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
              );
            }
            // if (searched.isNotEmpty) {
            //   return Container(
            //     margin: const EdgeInsets.only(
            //         top: 10, left: 10, right: 10, bottom: 40),
            //     child: GridView.builder(
            //         itemCount: Global.searchResults.length,
            //         gridDelegate:
            //             const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2,
            //           mainAxisSpacing: 5,
            //           crossAxisSpacing: 5,
            //           mainAxisExtent: 240,
            //           childAspectRatio: 0.10,
            //         ),
            //         itemBuilder: (context, i) {
            //           return GestureDetector(
            //             onTap: () {
            //               Get.toNamed('/food_detail_page',
            //                   arguments: searched[i]);
            //             },
            //             child: Container(
            //                 decoration: BoxDecoration(
            //                     color: Colors.grey.shade100,
            //                     borderRadius: BorderRadius.circular(25)),
            //                 alignment: Alignment.center,
            //                 child: Stack(
            //                   children: [
            //                     Align(
            //                       alignment: Alignment.topRight,
            //                       child: IconButton(
            //                           onPressed: () {
            //                             favoriteController.addOrRemoveFavorite(
            //                                 item: searched[i]);
            //                           },
            //                           icon: (searched[i].isFav)
            //                               ? const Icon(
            //                                   Icons.favorite,
            //                                   color: Colors.red,
            //                                   size: 39,
            //                                 )
            //                               : const Icon(
            //                                   Icons.favorite_border,
            //                                   color: Colors.grey,
            //                                   size: 39,
            //                                 )),
            //                     ),
            //                     Column(
            //                       children: [
            //                         const Spacer(),
            //                         Image.asset(
            //                           "assets/images/${searched[i].image}",
            //                           fit: BoxFit.contain,
            //                           height: 120,
            //                           width: 120,
            //                         ),
            //                         Text(
            //                           searched[i].name,
            //                           style: const TextStyle(
            //                             fontSize: 18,
            //                             wordSpacing: 3,
            //                             fontWeight: FontWeight.w800,
            //                           ),
            //                         ),
            //                         const SizedBox(
            //                           height: 10,
            //                         ),
            //                         Row(
            //                           children: [
            //                             const Spacer(),
            //                             const Text(
            //                               "20 min",
            //                               style: TextStyle(
            //                                 fontSize: 15,
            //                                 color: Colors.grey,
            //                                 fontWeight: FontWeight.w800,
            //                               ),
            //                             ),
            //                             const SizedBox(
            //                               width: 50,
            //                             ),
            //                             Text(
            //                               "⭐ ${searched[i].rating}",
            //                               style: const TextStyle(
            //                                 fontSize: 15,
            //                                 color: Colors.grey,
            //                                 fontWeight: FontWeight.w800,
            //                               ),
            //                             ),
            //                             const Spacer(),
            //                           ],
            //                         ),
            //                         const Spacer(),
            //                         Row(
            //                           children: [
            //                             Align(
            //                               alignment: Alignment.topLeft,
            //                               child: Text(
            //                                 "   ₹ ${searched[i].price}.00",
            //                                 style: const TextStyle(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.w800,
            //                                 ),
            //                               ),
            //                             ),
            //                             const Spacer(),
            //                             Container(
            //                               height: 45,
            //                               width: 45,
            //                               decoration: const BoxDecoration(
            //                                 color: Colors.green,
            //                                 borderRadius: BorderRadius.only(
            //                                   topLeft: Radius.circular(25),
            //                                   bottomRight: Radius.circular(25),
            //                                 ),
            //                               ),
            //                               child: IconButton(
            //                                 onPressed: () {
            //                                   cartController.addToCart(
            //                                       item: searched[i]);
            //                                 },
            //                                 icon: const Icon(
            //                                   Icons.add,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                             ),
            //                           ],
            //                         )
            //                       ],
            //                     ),
            //                   ],
            //                 )),
            //           );
            //         }),
            //   );
            // }
            return Center(
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
                    "No food available here...!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  Spacer(),
                ],
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
  }
}
