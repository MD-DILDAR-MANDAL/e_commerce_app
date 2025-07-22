import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String profileImage =
      "https://images.unsplash.com/photo-1545238377-dee9b7db2414?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  final String userName = "Mark Adam";
  final String userMail = "mark@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  SizedBox(height: 6),
                  Text(userName),
                  SizedBox(height: 6),
                  Text(userMail),
                  SizedBox(height: 22),
                ],
              ),

              Card(
                margin: EdgeInsets.only(bottom: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: secondary,
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart_checkout,
                    color: gold,
                    size: 32,
                  ),
                  title: Text(
                    "Cart",
                    style: TextStyle(
                      color: gold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 24,
                    color: gold,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RouteManager.cartScreen);
                  },
                ),
              ),
              profileMenu(
                title: "Orders",
                setIcon: Icons.shopping_basket,
                onTap: () {},
              ),
              profileMenu(
                title: "Profile",
                setIcon: Icons.person,
                onTap: () {},
              ),
              profileMenu(
                title: "Settings",
                setIcon: Icons.settings,
                onTap: () {},
              ),
              profileMenu(title: "Contact", setIcon: Icons.mail, onTap: () {}),
              profileMenu(
                title: "ShareApp",
                setIcon: Icons.share,
                onTap: () {},
              ),
              profileMenu(title: "Help", setIcon: Icons.help, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class profileMenu extends StatelessWidget {
  const profileMenu({
    required this.title,
    required this.setIcon,
    required this.onTap,
    super.key,
  });
  final String title;
  final IconData setIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: greyBackground,
      child: ListTile(
        leading: Icon(setIcon, color: textColor, size: 32),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 24),
        onTap: onTap,
      ),
    );
  }
}
