import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:e_commerce_app/global_colors.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void checkLoggedIn() {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteManager.navigationManager,
          (Route<dynamic> route) => false,
          arguments: currentUser,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.1),
            radius: 1,
            colors: <Color>[triad3, primary],
            stops: <double>[0.74, 0.5],
          ),
        ),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: primary,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "email is required";
                    }
                    return null;
                  },
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: primary,
                  ),
                  controller: _passwordController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 8) {
                      return "password should be at least 8 characters";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
              ),

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: primary,
                        backgroundColor: secondary,
                        foregroundColor: Colors.white,
                        elevation: 6,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final isValid = _formkey.currentState!.validate();
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final value = await authService.signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteManager.navigationManager,
                            (Route<dynamic> route) => false,
                            arguments: authService.user,
                          );
                        } on AuthException catch (e) {
                          String msg = "Login Failed";

                          if (e.message.toLowerCase().contains(
                                'invalid login credentials',
                              ) ==
                              true) {
                            msg = "Email or password is incorrect";
                          } else if (e.message.toLowerCase().contains(
                                'user not found',
                              ) ==
                              true) {
                            msg = "User  not registered";
                          } else {
                            msg = e.message;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(msg),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                      child: Text("Login", style: TextStyle(fontSize: 20)),
                    ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, RouteManager.registerPage);
                },
                child: Text(
                  "Don't have an account?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
