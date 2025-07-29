import 'package:e_commerce_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/modals/check_bill.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({required this.billData, super.key});
  CheckBill billData;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String address = "set address";
  bool isLoading = false;
  late Razorpay _razorpay;

  Future<void> fetchGeolocation() async {
    setState(() {
      isLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "location permission denied",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String foundAddress =
            "${place.street}" +
            ", " +
            "${place.locality}" +
            ", " +
            "${place.administrativeArea}" +
            ", " +
            "${place.postalCode}" +
            ", " +
            "${place.country}";

        setState(() {
          address = foundAddress;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final email = authService.user?.email;
    final data = widget.billData;

    DateTime dateNow = DateTime.now().add(Duration(days: 7));
    String formattedDate = DateFormat('EEE, d MMM').format(dateNow);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Check Out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
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
                  title: Text(address),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.my_location),
                            title: Text("current location"),
                            onTap: () async {
                              await fetchGeolocation();
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text("choose on map"),
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                RouteManager.osmMapPickerScreen,
                              );
                              if (result != null && result is Map) {
                                setState(() {
                                  address = result['address'];
                                });
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.access_time_filled_outlined,
                    size: 46,
                    color: primary,
                  ),
                  title: Text(formattedDate),
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
                  child: ListTile(
                    tileColor: Colors.amber,
                    leading: Icon(Icons.payment),
                    title: Text("Pay with Razorpay (UPI/Card/NetBanking)"),
                    onTap: () {
                      _startRazorpayPayment(
                        context,
                        data.total,
                        email.toString(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: const Color.fromARGB(45, 3, 3, 3),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Successful! Transaction ID: ${response.paymentId}',
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment Failed: ${response.message} \nDescription: ${response.message}',
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
      ),
    );
  }

  void _startRazorpayPayment(
    BuildContext context,
    double amount,
    String email,
  ) {
    var options = {
      'key': dotenv.env['razorpay_key_id'],
      'amount': amount.toInt(),
      'name': 'Ecommerce Store',
      'description': 'Order Payment',
      //'order_id': '',
      'prefill': {'email': email},
    };
    _razorpay.open(options);
  }
}
