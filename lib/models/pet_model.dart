class PetModel {
  final String name;
  final int id;
  final int age;
  final double price;
  final String imageUrl;
  final String breed;
  final String category;
  final String? adoptedDate; 
  final String identifier;
  final String contactAt;
  final String collectPetFrom;

  PetModel({
    required this.name,
    required this.id,
    required this.age,
    required this.price,
    required this.imageUrl,
    required this.breed,
    required this.category,
    this.adoptedDate,
    required this.identifier,
    required this.contactAt,
    required this.collectPetFrom,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    price: (json['price'] as num).toDouble(), // Handle potential int/double
    imageUrl: json['image_url'],
    breed: json['breed'],
    category: json['category'],
    adoptedDate: json['adopted_date'],
    identifier: json['identifier'],
    contactAt: json['contact_at'],
    collectPetFrom: json['collect_pet_from'],
  );


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'price': price,
    'image_url': imageUrl,
    'breed': breed,
    'category': category,
    'adopted_date': adoptedDate,
    'identifier': identifier,
    'contact_at': contactAt,
    'collect_pet_from': collectPetFrom,
  };

  @override
  String toString() {
    return 'PetModel{name: $name, age: $age, price: $price, imageUrl: $imageUrl, breed: $breed, category: $category, adoptedDate: $adoptedDate, identifier: $identifier, contactAt: $contactAt, collectPetFrom: $collectPetFrom}';
  }
}
