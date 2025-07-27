import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileChangeScreen extends StatefulWidget {
  const ProfileChangeScreen({super.key});

  @override
  State<ProfileChangeScreen> createState() => _ProfileChangeScreenState();
}

class _ProfileChangeScreenState extends State<ProfileChangeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final userData = auth.user;
    auth.getUserData();
    final name = auth.name;
    final email = userData?.email;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text("$name"),
              subtitle: Text("name"),
              onTap: () {},
            ),
            ListTile(
              title: Text("$email"),
              subtitle: Text("email"),
              onTap: () {},
            ),
            SizedBox(),
            ElevatedButton(
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await auth.signOut();
                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteManager.loginPage,
                    (Route<dynamic> route) => false,
                  );
                });
              },
              child: Text("sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
