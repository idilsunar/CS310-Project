import 'package:flutter/material.dart';


class OnboardingPage1 extends StatelessWidget
{
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome to Habitflow", style: TextStyle(fontSize: 15)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {},         //skip to the next page
            child: const Text("Explore"),
          ),
        ),
      ),
    );
  }
}


class OnboardingPage4 extends StatelessWidget
{
  const OnboardingPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Keep the momentum", style: TextStyle(fontSize: 15)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {},         //skip to the next page
            child: const Text("Start"),
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingPage1(),
    );
  }
}