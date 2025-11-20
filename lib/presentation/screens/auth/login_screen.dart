import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/custom_auth_text_field.dart';
import '../../widgets/auth/custom_auth_button.dart';
import '../../widgets/auth/or_divider.dart';
import '../../widgets/auth/social_login_buttons.dart';
import 'register_screen.dart';
import '../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();

      final success = await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        if (success) {
          // Navigate to main app
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigation()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Login error'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.signInWithGoogle();

    if (mounted) {
      if (success) {
        // Navigate to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                authProvider.errorMessage ?? 'Google sign-in error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password feature coming soon'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 67),

                // Header Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log In',
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Log in to access your personalized meal plans.',
                      style: GoogleFonts.dmSans(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.41,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Email Input Field
                CustomAuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),

                const SizedBox(height: 10),

                // Password Input Field
                CustomAuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 24,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _handleForgotPassword,
                    child: Text(
                      'Forgot your password?',
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        height: 1.47,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 51),

                // "Or Continue With" Divider
                const OrDivider(),

                const SizedBox(height: 21),

                // Social Login Buttons
                SocialLoginButtons(
                  onGooglePressed: _handleGoogleSignIn,
                  onApplePressed: () {
                    // TODO: Implement Apple Sign-In
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Apple sign-in coming soon'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Log In Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return CustomAuthButton(
                      text: 'Log In',
                      onPressed: _handleLogin,
                      isLoading: authProvider.isLoading,
                      type: AuthButtonType.primary,
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Footer Link - Navigate to Register
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'New here? ',
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              height: 1.47,
                            ),
                          ),
                          TextSpan(
                            text: 'Create an account!',
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
