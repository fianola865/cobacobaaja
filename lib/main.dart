import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/login.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kqogfsaojwugcdyytrbn.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtxb2dmc2Fvand1Z2NkeXl0cmJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg3NTgsImV4cCI6MjA1NDk4NDc1OH0.r_CnhH-yani514JWNE9Drcn6p2cOZR3IGVWmWqNEyPE',
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir UKK',
      home: Splash()
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Expanded(
            child: Image.asset('assets/images/nola1.jpg',
            height: 300,
            width: 300,
          )
        )
      ),
      )
    );
  }
}