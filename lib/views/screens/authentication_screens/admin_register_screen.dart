import 'package:flutter/material.dart';
import 'package:flutter_curd_app/controllers/admin_controller.dart';
import 'package:flutter_curd_app/views/screens/authentication_screens/admin_login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminRegisterScreen extends StatefulWidget {
  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AdminAuthController _authController = AdminAuthController();

  String email = '';
  String fullName = '';
  String password = '';
  bool isLoading = false;

  registerAdmin() async {
    setState(() => isLoading = true);
    await _authController
        .signUpAdmin(
          context: context,
          email: email,
          fullName: fullName,
          password: password,
        )
        .whenComplete(() => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create Your Account Admin",
                    style: GoogleFonts.lato(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "To Explore the world exclusive",
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    "assets/images/Illustration.png",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  TextFormField(
                    onChanged: (value) => email = value,
                    validator: (value) =>
                        value!.isEmpty ? "Enter your email" : null,
                    decoration: const InputDecoration(
                      labelText: "Enter your email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full Name
                  TextFormField(
                    onChanged: (value) => fullName = value,
                    validator: (value) =>
                        value!.isEmpty ? "Enter your full name" : null,
                    decoration: const InputDecoration(
                      labelText: "Enter your full name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) => password = value,
                    validator: (value) =>
                        value!.isEmpty ? "Enter your password" : null,
                    decoration: const InputDecoration(
                      labelText: "Enter your password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        registerAdmin();
                      }
                    },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up"),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminLoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
