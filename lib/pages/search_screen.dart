import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTextController = TextEditingController();

  String _query = '';

  List<dynamic> _results = [];

  void _searchProducts() async {
    if (_query.trim().isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    final response = await Supabase.instance.client
        .from('products')
        .select()
        .ilike('name', "%$_query%");
    setState(() {
      _results = response;
    });
  }

  @override
  void initState() {
    super.initState;
    _searchTextController.addListener(() {
      setState(() {
        _query = _searchTextController.text;
      });
      _searchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _searchTextController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 225, 225, 225),
                  hintText: "Search products...",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.search, size: 43),
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchTextController.clear();
                          },
                        )
                      : null,

                  border: InputBorder.none,

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                ),
              ),
            ),
            _results.isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("no results", style: TextStyle(fontSize: 30)),
                        Icon(Icons.store_outlined, size: screenHeight * 0.2),
                      ],
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      itemCount: _results.length,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 0.76,
                      ),
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> product = _results[index];

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteManager.productDetail,
                              arguments: product["product_id"],
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
                                          product["image_url"],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 120,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: FloatingActionButton.small(
                                          heroTag: "fab_search$index",
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
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
