import 'package:flutter/material.dart';
import '../main.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // simulasi login

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔥 BACKGROUND GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B132B), Color(0xFF1C2541)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(25),

            // 🔥 CARD GLASS EFFECT
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 TITLE
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Login to your account",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 25),

                // 🔥 EMAIL FIELD
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔥 PASSWORD FIELD
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 🔥 LOGIN BUTTON PREMIUM
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 🔥 FOOTER
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterView()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
