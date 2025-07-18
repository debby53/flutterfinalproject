import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late Box<User> usersBox;

  bool _passwordVisible = false;
  String? usernameError;
  String? passwordError;

  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    usersBox = Hive.box<User>('usersBox');
    _passwordVisible = false;
  }

  void loginUser() {
    setState(() {
      usernameError = null;
      passwordError = null;
    });

    String username = usernameController.text.trim();
    String password = passwordController.text;

    bool hasError = false;
    if (username.isEmpty) {
      usernameError = 'Username cannot be empty';
      hasError = true;
    }
    if (password.isEmpty) {
      passwordError = 'Password cannot be empty';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    final user = usersBox.values.firstWhere(
          (u) => u.username == username && u.password == password,
      orElse: () => User(username: '', password: ''),
    );

    if (user.username.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, $username!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
  }

  void _onButtonTapDown(TapDownDetails details) {
    setState(() {
      _isButtonPressed = true;
    });
  }

  void _onButtonTapUp(TapUpDetails details) {
    setState(() {
      _isButtonPressed = false;
    });
  }

  void _onButtonTapCancel() {
    setState(() {
      _isButtonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonOpacity = _isButtonPressed ? 0.7 : 1.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.teal.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Please login to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 40),

                // Username TextField
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    hintText: "Username",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    errorText: usernameError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password TextField with toggle visibility
                TextField(
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    errorText: passwordError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Animated Login Button
                GestureDetector(
                  onTapDown: _onButtonTapDown,
                  onTapUp: _onButtonTapUp,
                  onTapCancel: _onButtonTapCancel,
                  onTap: loginUser,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: buttonOpacity,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45.withOpacity(buttonOpacity),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004D40) // Dark teal
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Register redirect TextButton
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register here",
                    style: TextStyle(color: Colors.white.withOpacity(0.85)),
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
