class Product {
  final String? id; // id is optional and nullable
  final String name;
  final String description;
  final double price;
  final String image; // keep non-nullable but assign default if null
  final String category;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'], // MongoDB id field (adjust if your backend uses another key)
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '', // <-- Here assign empty string if null
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "image": image,
    "category": category,
  };
}
