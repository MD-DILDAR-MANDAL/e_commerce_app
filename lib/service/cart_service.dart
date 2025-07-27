import 'package:e_commerce_app/modals/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  Future<int?> getOrCreateCartOrderId() async {
    final userId = _userId;
    if (userId == null) return null;
    final rows = await _supabase
        .from('orders')
        .select('order_id')
        .eq('customer_id', userId)
        .eq('status', 'pending')
        .maybeSingle();

    if (rows != null && rows['order_id'] != null) {
      return rows['order_id'];
    }

    final insert = await _supabase
        .from('orders')
        .insert({
          'customer_id': userId,
          'status': 'pending',
          'order_date': DateTime.now().toIso8601String(),
        })
        .select()
        .maybeSingle();
    return insert?['order_id'];
  }

  Future<void> fetchCart() async {
    final userId = _userId;
    if (userId == null) return;
    if (userId.isEmpty) return;
    final orderId = await getOrCreateCartOrderId();
    if (orderId == null) return;
    final res = await _supabase
        .from('order_items')
        .select()
        .eq('order_id', orderId);
    _items = (res as List).map((e) => CartItem.fromJson(e)).toList();
  }

  Future<void> addItem(int productId, double price) async {
    final userId = _userId;
    if (userId == null) return;
    final orderId = await getOrCreateCartOrderId();
    if (orderId == null) return;
    final existing = _items.firstWhere(
      (i) => i.productId == productId,
      orElse: () =>
          CartItem(productId: productId, quantity: 0, priceAtPurchase: price),
    );
    if (_items.contains(existing)) {
      await updateItemQuantity(productId, existing.quantity + 1);
    } else {
      final newItem = CartItem(
        productId: productId,
        quantity: 1,
        priceAtPurchase: price,
      );
      final newAdd = newItem.toJson();
      await _supabase.from('order_items').insert({
        'order_id': orderId,
        'product_id': newAdd['product_id'],
        'quantity': newAdd['quantity'],
        'price_at_purchase': newAdd['price_at_purchase'],
      });
      _items.add(newItem);
      notifyListeners();
    }
  }

  Future<void> updateItemQuantity(int productId, int quantity) async {
    final orderId = await getOrCreateCartOrderId();
    final idx = _items.indexWhere((e) => e.productId == productId);
    if (idx == -1 || orderId == null) return;
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }
    _items[idx].quantity = quantity;
    await _supabase
        .from('order_items')
        .update({'quantity': quantity})
        .eq('order_id', orderId)
        .eq('product_id', productId);
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    final orderId = await getOrCreateCartOrderId();
    if (orderId == null) return;
    _items.removeWhere((e) => e.productId == productId);
    await _supabase
        .from('order_items')
        .delete()
        .eq('order_id', orderId)
        .eq('product_id', productId);
    notifyListeners();
  }

  Future<void> clearCart() async {
    final orderId = await getOrCreateCartOrderId();
    _items.clear();
    if (orderId != null) {
      await _supabase.from('order_items').delete().eq('order_id', orderId);
    }
    notifyListeners();
  }
}
