import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/modals/check_bill.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({required this.billData, super.key});
  CheckBill billData;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String address = "set address";
  bool isLoading = false;

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
  Widget build(BuildContext context) {
    final data = widget.billData;
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
        ),
        if (isLoading)
          Container(
            color: const Color.fromARGB(45, 3, 3, 3),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
