import 'dart:convert';
import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/MD-DILDAR-MANDAL/e_commerce_app/refs/heads/main/demo.json',
      ),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Products",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: fetchProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 120,
                child: Center(child: Text("Error: ${snapshot.error}")),
              );
            }
            final productData = snapshot.data!;

            return GridView.builder(
              itemCount: productData.length,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.76,
              ),
              itemBuilder: (context, index) {
                final Map<String, dynamic> product = productData[index];

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteManager.productDetail,
                      arguments: product["id"],
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  product["image"],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 120,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.broken_image),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: FloatingActionButton.small(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: favColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          Text(
                            product["name"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 4),

                          Text(
                            "₹${product["price"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  backgroundColor: primary,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(36, 36),
                                ),
                                onPressed: () {
                                  print("pressed");
                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
