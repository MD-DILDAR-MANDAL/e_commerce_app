import 'package:e_commerce_app/global_colors.dart';
import 'package:flutter/material.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
  });

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: greyBackground,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            _buildRow('Subtotal', "₹${subtotal.toStringAsFixed(2)}"),
            _buildRow('Tax', "₹${tax.toStringAsFixed(2)}"),
            _buildRow('Discount', "₹${discount.toStringAsFixed(2)}"),
            Divider(height: 24, thickness: 1),
            _buildRow('Total', "₹${total.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
