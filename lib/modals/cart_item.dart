class CartItem {
  final int productId;
  int quantity;
  final double priceAtPurchase;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
  });

  Map<String, dynamic> toJson(String userId) => {
    'user_id': userId,
    'product_id': productId,
    'quantity': quantity,
    'price_at_purchase': priceAtPurchase,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['product_id'],
    quantity: json['quantity'],
    priceAtPurchase: (json['price_at_purchase'] as num).toDouble(),
  );
}
