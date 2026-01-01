
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthPage extends StatelessWidget {
@override
Widget build(BuildContext context) {
return DefaultTabController(
length: 2,
child: Scaffold(
appBar: AppBar(
title: Text("Welcome"),
bottom: TabBar(tabs: [
Tab(text: "Login"),
Tab(text: "Sign Up"),
]),
),
body: TabBarView(children: [
LoginPage(),
AuthPage(),
SignUpPage(),
]),
));
}
}
