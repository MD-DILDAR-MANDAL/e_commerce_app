import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/modals/cart_item.dart';
import 'package:e_commerce_app/widgets/order_summary_widget.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> demoCartItems = [
    CartItem(
      name: "Wireless Headphones",
      imageUrl:
          "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?q=80&w=715&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      quantity: 1,
      price: 2999.00,
    ),
    CartItem(
      name: "Watch",
      imageUrl:
          "https://images.unsplash.com/photo-1549972574-8e3e1ed6a347?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      quantity: 2,
      price: 1199.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: demoCartItems.length + 1,
        itemBuilder: (context, index) {
          if (index < demoCartItems.length) {
            CartItem item = demoCartItems[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: Image.network(
                    item.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Quantity: ${item.quantity}",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(
                    "₹ ${item.quantity * item.price}",
                    style: TextStyle(fontSize: 14, color: primary),
                  ),
                ),
              ),
            );
          } else {
            return OrderSummaryWidget(
              subtotal: 100,
              tax: 10,
              discount: 2,
              total: 200,
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text("Check Out", style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
