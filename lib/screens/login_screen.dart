import 'package:firebase_practice/constraints/Colours.dart';
import 'package:firebase_practice/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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

                  // Welcome Text
                  Text(
                    "Welcome Back",
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
                    "Sign in to your Firebase Task Manager",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(
                      color: Color(Colours.secondaryFontColor),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Form
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Email Label
                        _buildLabel("EMAIL ADDRESS"),

                        const SizedBox(height: 8),

                        TextFormField(
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
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

                        const SizedBox(height: 20),

                        // Password Label + Forgot Password
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [

                            _buildLabel("PASSWORD"),

                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to forgot password screen
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Password Field
                        TextFormField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          textInputAction: TextInputAction.done,

                          decoration: _inputDecoration(
                            hintText: "Enter your password",
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
                              return "Please enter your password";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,

                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              if (formKey.currentState!.validate()) {

                                final email = emailController.text.trim();

                                final password = passwordController.text;

                                // TODO: Implement Firebase Login
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(Colours.buttonColor),
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
                                  "Sign In",
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

                  const SizedBox(height: 26),

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

                  // Google Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,

                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement Google Sign In
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

                          // Google Logo
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

                  const SizedBox(height: 40),

                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Color(Colours.secondaryFontColor),
                          fontSize: 13,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                        },
                        child: const Text(
                          "Sign Up",
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

  // TextField Decoration
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