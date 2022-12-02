import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/fruits_controller.dart';
import 'package:food_order_app/helpers/cloude_firestore_helper.dart';
import 'package:food_order_app/models/fruits_model.dart';
import 'package:get/get.dart';

class FruitsPage extends StatefulWidget {
  const FruitsPage({Key? key}) : super(key: key);

  @override
  State<FruitsPage> createState() => _FruitsPageState();
}

class _FruitsPageState extends State<FruitsPage> {
  FruitsController fruitsController = Get.put(FruitsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectFruits(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;

            List<QueryDocumentSnapshot> documents = data!.docs;
            List<FruitsModel> fruitsModel =
                fruitsController.turnIntoObjetct(list: documents);

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
                          "No Fruits Available here...!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 40),
                    child: GridView.builder(
                        itemCount: fruitsModel.length,
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
                              // Get.toNamed('/detail_page',
                              //     arguments: fruitsModel[i]);
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
                                            // favoriteController
                                            //     .addOrRemoveFavorite(
                                            //         item: fruitsModel[i]);
                                          },
                                          icon: (fruitsModel[i].isFav)
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
                                          "assets/images/${fruitsModel[i].image}",
                                          fit: BoxFit.contain,
                                          height: 120,
                                          width: 120,
                                        ),
                                        Text(
                                          fruitsModel[i].name,
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
                                              "⭐ ${fruitsModel[i].rating}",
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
                                                "   ₹ ${fruitsModel[i].price}.00",
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
                                                  bottomRight:
                                                      Radius.circular(25),
                                                ),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  // cartController.addToCart(
                                                  //     item: fruitsModel[i]);
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
