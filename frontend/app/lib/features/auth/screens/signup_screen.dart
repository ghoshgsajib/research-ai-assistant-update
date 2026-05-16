import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  bool isValidEmail(String email) {
    return email.contains("@") && email.contains(".");
  }

  bool isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#_-])[A-Za-z\d@$!%*?&.#_-]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorMessage = "Please enter your full name.";
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        errorMessage = "Please enter a valid email address.";
      });
      return;
    }

    if (!isValidPassword(password)) {
      setState(() {
        errorMessage =
            "Password must be 8+ characters with uppercase, lowercase, number, and special character.";
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = "Passwords do not match.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    await AuthService.registerUser(name, email, password);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully. Please login."),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Create Account"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_add_alt_1,
                    color: Colors.blueAccent,
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Start managing your research smarter.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 40),

                  CustomTextField(
                    hintText: "Full Name",
                    controller: nameController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 18),

                  CustomTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(height: 16),

                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
                    ),

                  const SizedBox(height: 28),

                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(text: "Create Account", onPressed: signup),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
