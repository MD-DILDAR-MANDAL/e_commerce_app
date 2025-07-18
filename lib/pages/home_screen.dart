import 'package:e_commerce_app/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final _searchTextController = TextEditingController();

    final List<Map<String, String>> features = [
      {'icon': '🌟', 'title': 'Fast Shipping', 'subtitle': 'Get items quickly'},
      {
        'icon': '🔒',
        'title': 'Secure Payments',
        'subtitle': 'Your data is safe',
      },
      {'icon': '🔥', 'title': 'Top Deals', 'subtitle': 'Best price every day'},
      // Add more features
    ];

    final List<String> imgList = [
      'https://images.unsplash.com/photo-1573855619003-97b4799dcd8b?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1492707892479-7bc8d5a4ee93?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1526178613552-2b45c6c302f0?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'https://images.unsplash.com/photo-1573518011645-aa7ab49d0aa6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTd8fGhhcHB5JTIwc2hvcHBpbmd8ZW58MHx8MHx8fDI%3D',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Hello!", style: TextStyle(fontWeight: FontWeight.w300)),
              Text("User", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        iconSize: 32,
        elevation: 8.0,
        backgroundColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        selectedItemColor: primary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: _searchTextController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 225, 225, 225),
                  hintText: "Search here",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.search, size: 43),
                  ),

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

              const SizedBox(height: 15),

              Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                child: CarouselSlider(
                  items: imgList
                      .map(
                        (item) => ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    aspectRatio: 21 / 9,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    autoPlay: true,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              showCase(
                features: features,
                screenWidth: screenWidth,
                title: "Featured",
              ),
              const SizedBox(height: 10),
              showCase(
                features: features,
                screenWidth: screenWidth,
                title: "Most Popular",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class showCase extends StatelessWidget {
  const showCase({
    super.key,
    required this.features,
    required this.screenWidth,
    required this.title,
  });

  final List<Map<String, String>> features;
  final double screenWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("See All", style: TextStyle(color: primary)),
          ],
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),

                  elevation: 2,
                  child: Container(
                    width: screenWidth * 0.4,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.shopping_cart, size: 36),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text("Watch"), Text("\$40")],
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
    );
  }
}
