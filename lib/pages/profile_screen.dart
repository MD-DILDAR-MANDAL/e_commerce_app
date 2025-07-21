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
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fpng.pngtree.com%2Fpng-clipart%2F20190924%2Foriginal%2Fpngtree-business-people-avatar-icon-user-profile-free-vector-png-image_4815126.jpg&f=1&nofb=1&ipt=781cdc69f6d29142fce91137b463607ab8af1e2cc0205716cc7d016cb0ba1ffb";
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
