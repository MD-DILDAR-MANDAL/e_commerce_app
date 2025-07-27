import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/modals/check_bill.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({required this.billData, super.key});
  CheckBill billData;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final data = widget.billData;

    return Scaffold(
      appBar: AppBar(title: Text('Check Out'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(
                Icons.share_location_outlined,
                size: 46,
                color: primary,
              ),
              title: Text("address"),
            ),
            ListTile(
              leading: Icon(
                Icons.access_time_filled_outlined,
                size: 46,
                color: primary,
              ),
              title: Text("date, time"),
            ),
            Divider(),
            ListTile(
              title: Text("Amount Payable"),
              trailing: Text(
                "₹ ${data.total.toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text("Subtotal"),
              trailing: Text("₹${data.subtotal.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("Tax (10%)"),
              trailing: Text("₹${data.tax.toStringAsFixed(2)}"),
            ),
            ListTile(
              title: Text("Discount"),
              trailing: Text("-₹${data.discount.toStringAsFixed(2)}"),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Payment Options",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(000),
              ),
              child: ListTile(
                tileColor: Colors.amber,
                leading: Icon(Icons.payment),
                title: Text("Pay with Razorpay (UPI/Card/NetBanking)"),
                onTap: () {
                  //   _startRazorpayPayment(context, total);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
