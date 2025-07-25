import 'dart:io';

import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profileImageUrl =
      "https://images.unsplash.com/photo-1740252117013-4fb21771e7ca?q=80&w=880&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  final supabase = Supabase.instance.client;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      String? uploadedUrl = await uploadImageToSupabase(pickedFile, 'avatars');

      if (uploadedUrl != null) {
        setState(() {
          profileImageUrl = uploadedUrl;
        });

        final authService = Provider.of<AuthService>(context, listen: false);
        final userId = authService.user?.id;
        if (userId != null) {
          final update = await supabase
              .from('customers')
              .update({'profile_image_url': uploadedUrl})
              .eq('customer_id', userId);
          if (update != null) {
            print("failed to update profile image url in database");
          } else {
            print("profile image updated successfully");
          }
        }
      } else {
        print("image upload failed");
      }
    }
  }

  Future<String?> uploadImageToSupabase(XFile image, String bucketName) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.id;
    final fileBytes = await image.readAsBytes();
    final fileExt = image.path.split('.').last;
    if (fileExt != 'jpg' && fileExt != 'jpeg' && fileExt != 'png') {
      print("Invalid file type. Only JPG and PNG are allowed.");
      return null;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '$userId.$fileExt';
    final filePath = fileName;
    final response = await supabase.storage
        .from(bucketName)
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(contentType: 'image/$fileExt', upsert: true),
        );
    if (response.isNotEmpty) {
      final String imageUrl = supabase.storage
          .from(bucketName)
          .getPublicUrl(filePath);
      return imageUrl;
    } else {
      print('Upload error');
      return null;
    }
  }

  Future<void> _currentProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.id;
    if (userId != null) {
      final profile = await supabase
          .from('customers')
          .select('profile_image_url')
          .eq('customer_id', userId)
          .single();
      if (profile != null) {
        setState(() {
          profileImageUrl = profile['profile_image_url'] ?? profileImageUrl;
        });
      }
    }
  }

  @override
  void initState() {
    _currentProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(profileImageUrl);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(profileImageUrl, scale: 0.8),
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text("change icon"),
                ),
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
            profileMenu(title: "Profile", setIcon: Icons.person, onTap: () {}),
            profileMenu(
              title: "Settings",
              setIcon: Icons.settings,
              onTap: () {},
            ),
            profileMenu(title: "Contact", setIcon: Icons.mail, onTap: () {}),
            profileMenu(title: "ShareApp", setIcon: Icons.share, onTap: () {}),
            profileMenu(title: "Help", setIcon: Icons.help, onTap: () {}),
          ],
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
