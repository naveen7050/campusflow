import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterView extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _departmentController = TextEditingController();
  int? _selectedSemester = 1;
  bool _obscurePassword = true;

  static const _inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xFFF3F4F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.register(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      studentId: _studentIdController.text.isEmpty
          ? null
          : _studentIdController.text,
      department: _departmentController.text.isEmpty
          ? null
          : _departmentController.text,
      semester: _selectedSemester,
    );

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  OutlineInputBorder _focusedBorder() => const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFF0F5132), width: 1.5),
      );

  OutlineInputBorder _errorBorder() => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: AppColors.error),
      );

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final isLoading = authViewModel.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Header
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF5E9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              size: 22,
                              color: Color(0xFF0F5132),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'CampusFlow',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F5132),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Join CampusFlow today',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Error message
                    if (authViewModel.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          authViewModel.errorMessage!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        focusedBorder: _focusedBorder(),
                        errorBorder: _errorBorder(),
                        focusedErrorBorder: _errorBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your full name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'Email or Full Name',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        focusedBorder: _focusedBorder(),
                        errorBorder: _errorBorder(),
                        focusedErrorBorder: _errorBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter your email address.';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        focusedBorder: _focusedBorder(),
                        errorBorder: _errorBorder(),
                        focusedErrorBorder: _errorBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a password.';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Student ID (optional)
                    TextFormField(
                      controller: _studentIdController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'Student ID (Optional)',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        focusedBorder: _focusedBorder(),
                        errorBorder: _errorBorder(),
                        focusedErrorBorder: _errorBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Department (optional)
                    TextFormField(
                      controller: _departmentController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      decoration: _inputDecoration.copyWith(
                        hintText: 'Department (Optional)',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        focusedBorder: _focusedBorder(),
                        errorBorder: _errorBorder(),
                        focusedErrorBorder: _errorBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Semester dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedSemester,
                      decoration: _inputDecoration.copyWith(
                        hintText: 'Semester',
                        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                        focusedBorder: _focusedBorder(),
                        errorBorder: _errorBorder(),
                        focusedErrorBorder: _errorBorder(),
                      ),
                      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                      dropdownColor: Colors.white,
                      items: List.generate(8, (i) => i + 1)
                          .map((sem) => DropdownMenuItem(
                                value: sem,
                                child: Text('Semester $sem'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedSemester = value);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Sign Up button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F5132),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // OR divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Google button
                    SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_mobiledata_rounded,
                          size: 22,
                          color: Color(0xFF1F2937),
                        ),
                        label: const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Log in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            authViewModel.clearError();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xFF0F5132),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
