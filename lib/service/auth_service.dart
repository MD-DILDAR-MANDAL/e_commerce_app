import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _user;
  User? get user => _user;

  AuthService() {
    _user = _supabase.auth.currentUser;
    _supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  Future<void> signUp(
    String first_name,
    String last_name,
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception("Signup Failed");
    }

    _user = response.user;

    final insert = await _supabase.from('customers').insert({
      'customer_id': _user?.id.toString(), // user id from auth
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
    });

    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception("Login Failed");
    }
    _user = response.user;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _user = null;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;
}
