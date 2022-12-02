class FoodModel {
  final String id;
  final String name;
  final String image;
  final String rating;
  final int price;
  final int quantity;
  final bool isFav;
  final bool isAdd;

  FoodModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.price,
    required this.quantity,
    required this.isFav,
    required this.isAdd,
  });

  factory FoodModel.fromMap({required data}) {
    return FoodModel(
      id: data.id,
      name: data['name'],
      image: data['image'],
      rating: data['rating'],
      price: data['price'],
      quantity: data['quantity'],
      isFav: data['isFav'],
      isAdd: data['isAdd'],
    );
  }
}
