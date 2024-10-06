class Store {
  String? imageUrl;
  String storeName;
  String contact;
  String location;
  String description;
  String openingTime;
  String closingTime;

  Store({
    this.imageUrl,
    required this.storeName,
    required this.contact,
    required this.location,
    required this.description,
    required this.openingTime,
    required this.closingTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'storeName': storeName,
      'contact': contact,
      'location': location,
      'description': description,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }
}
