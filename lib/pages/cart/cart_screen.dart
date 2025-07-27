import 'package:e_commerce_app/modals/check_bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/service/cart_service.dart';
import 'package:e_commerce_app/widgets/order_summary_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartService>(context, listen: false).fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final itemList = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: itemList.length + 1,
        itemBuilder: (context, index) {
          if (index < itemList.length) {
            Map<String, dynamic> item = itemList[index].toJson();

            return FutureBuilder(
              future: Supabase.instance.client
                  .from('products')
                  .select()
                  .eq('product_id', item['product_id'])
                  .single(),
              builder: (contex, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No product found.');
                }
                final response = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: Image.network(
                        response['image_url'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        response['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Quantity: ${item['quantity']}",
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Icon(Icons.delete, color: Colors.red),
                            onTap: () {
                              cart.removeItem(response['product_id']);
                            },
                          ),
                          Text(
                            "₹ ${item['quantity'] * item['price_at_purchase']}",
                            style: TextStyle(fontSize: 14, color: primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            double subtotal = itemList.fold(
              0,
              (sum, item) => sum + item.priceAtPurchase * item.quantity,
            );
            double tax = subtotal * 0.10;
            double discount = 50;
            if (subtotal == 0) {
              discount = 0;
            }
            double total = subtotal + tax - discount;

            return OrderSummaryWidget(
              subtotal: subtotal,
              tax: tax,
              discount: discount,
              total: total,
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
          onPressed: () {
            double subtotal = itemList.fold(
              0,
              (sum, item) => sum + item.priceAtPurchase * item.quantity,
            );
            double tax = subtotal * 0.10;
            double discount = subtotal == 0 ? 0 : 50;
            double total = subtotal + tax - discount;

            final billObject = CheckBill(subtotal, tax, discount, total);

            Navigator.pushNamed(
              context,
              RouteManager.checkoutScreen,
              arguments: billObject,
            );
          },
          child: Text("Check Out", style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
