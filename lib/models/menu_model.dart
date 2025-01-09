class MenuModel {
  final String id;
  final String name;
  final String description;
  final double price;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  factory MenuModel.fromMap(String id, Map<String, dynamic> data) {
    return MenuModel(
      id: id,
      name: data['name'],
      description: data['description'],
      price: data['price'].toDouble()
    );
  }
}
