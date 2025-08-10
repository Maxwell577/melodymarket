class Purchase {
  final String id;
  final String userId;
  final String albumId;
  final DateTime purchaseDate;
  final double price;

  Purchase({
    required this.id,
    required this.userId,
    required this.albumId,
    required this.purchaseDate,
    required this.price,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    id: json['id'],
    userId: json['userId'],
    albumId: json['albumId'],
    purchaseDate: DateTime.parse(json['purchaseDate']),
    price: (json['price'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'albumId': albumId,
    'purchaseDate': purchaseDate.toIso8601String(),
    'price': price,
  };

  String get formattedPrice => 'L${price.toStringAsFixed(2)}';
}