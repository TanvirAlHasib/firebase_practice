import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/constraints/Colours.dart';
import 'package:firebase_practice/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

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
      backgroundColor: Color(Colours.backgroundColor),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).top -
                  MediaQuery.paddingOf(context).bottom - 40,
            ),

            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const Spacer(),

                  // Flutter Logo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "lib/assets/flutter_logo.png",
                      height: 32,
                      width: 32,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Title
                  Text(
                    "Create Account",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(
                      color: Color(Colours.fontColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Sign up to your Firebase Task Manager",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      color: Color(Colours.secondaryFontColor),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Registration Form
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Full Name
                        _buildLabel("FULL NAME"),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,

                          decoration: _inputDecoration(
                            hintText: "Enter your full name",
                          ),

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your full name";
                            }

                            if (value.trim().length < 3) {
                              return "Name must be at least 3 characters";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Email
                        _buildLabel("EMAIL ADDRESS"),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,

                          decoration: _inputDecoration(
                            hintText: "Enter your email",
                          ),

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
                            }

                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(value.trim())) {
                              return "Enter a valid email address";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Password
                        _buildLabel("PASSWORD"),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          textInputAction: TextInputAction.next,

                          decoration: _inputDecoration(
                            hintText: "Create a password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF94A3B8),
                                size: 20,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            }

                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Confirm Password
                        _buildLabel("CONFIRM PASSWORD"),

                        const SizedBox(height: 8),

                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !isConfirmPasswordVisible,
                          textInputAction: TextInputAction.done,

                          decoration: _inputDecoration(
                            hintText: "Confirm your password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                                });
                              },
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF94A3B8),
                                size: 20,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }

                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        // Sign Up Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,

                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                              if (formKey.currentState!.validate()) {

                                final name = nameController.text.trim();
                                final email = emailController.text.trim();
                                final password = passwordController.text;

                                // creating new document for new user
                                await FirebaseFirestore.instance.collection("taskManager").doc(email).set({
                                  "name": name,
                                  "email": email,
                                  "task": {}
                                });

                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Color(Colours.buttonColor),
                              foregroundColor: Colors.white,
                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),

                            child: isLoading
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [

                                Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                SizedBox(width: 8),

                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [

                      const Expanded(
                        child: Divider(
                          color: Color(0xFFE2E8F0),
                        ),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: Color(Colours.secondaryFontColor),
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const Expanded(
                        child: Divider(
                          color: Color(0xFFE2E8F0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Google Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,

                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement Google Sign Up
                      },

                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text(
                            "G",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4285F4),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Color(Colours.fontColor),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(height: 30),

                  // Sign In Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Color(Colours.secondaryFontColor),
                          fontSize: 13,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Footer
                  Text(
                    "Flutter  •  Firebase Auth",
                    style: TextStyle(
                      color: Color(Colours.secondaryFontColor),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Input Label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color(Colours.secondaryFontColor),
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  // Input Decoration
  InputDecoration _inputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,

      hintStyle: TextStyle(
        color: Color(Colours.secondaryFontColor),
        fontSize: 14,
      ),

      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Color(Colours.buttonColor),
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }
}