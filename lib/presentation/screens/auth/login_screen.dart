import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../logic/blocs/auth/auth_event.dart';
import '../../../logic/blocs/auth/auth_state.dart';
import '../home_page.dart';
import 'package:thamarat/presentation/app_loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (!mounted) return;
            
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          },
          child: Stack(
            children: [
              Container(
                height: size.height * 0.4,
                decoration: const BoxDecoration(
                  color: Color(0xFFBFE3B4),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/leaves_bg.png',
                        fit: BoxFit.cover,
                        color: Colors.white.withOpacity(0.19),
                        colorBlendMode: BlendMode.dstATop,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.25),
                    ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        width: size.width,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                height: 180,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "يرجى كتابة البريد الإلكتروني وكلمة السر للمتابعة",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("البريد الإلكتروني", style: TextStyle(color: Color(0xFF2E7D32))),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _emailController,
                                      focusNode: _emailFocusNode,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {
                                        // Focus on password field when email is submitted
                                        if (mounted) {
                                          _passwordFocusNode.requestFocus();
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFF1FDF0),
                                        prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
                                        hintText: "البريد الإلكتروني",
                                        hintStyle: TextStyle(color: Color(0xFF66BB6A)),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF81C784)),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red, width: 2),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'الرجاء إدخال البريد الإلكتروني';
                                        }
                                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                        if (!emailRegex.hasMatch(value.trim())) {
                                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const Text("كلمة السر", style: TextStyle(color: Color(0xFF2E7D32))),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      obscureText: !_isPasswordVisible,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        // Submit form when password is submitted
                                        if (mounted && _formKey.currentState!.validate()) {
                                          context.read<AuthBloc>().add(
                                                LoginRequested(
                                                  email: _emailController.text,
                                                  password: _passwordController.text,
                                                ),
                                              );
                                        }
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xFFF1FDF0),
                                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
                                        hintText: "كلمة السر",
                                        hintStyle: const TextStyle(color: Color(0xFF66BB6A)),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                            color: const Color(0xFF2E7D32),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible = !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF81C784)),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        focusedErrorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red, width: 2),
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.trim().isEmpty) {
                                          return 'الرجاء إدخال كلمة المرور';
                                        }
                                        if (value.trim().length < 3) {
                                          return 'كلمة المرور يجب أن تكون 3 أحرف على الأقل';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    BlocBuilder<AuthBloc, AuthState>(
                                      builder: (context, state) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF43A047),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: state is AuthLoading
                                                ? null
                                                : () {
                                                    if (_formKey.currentState!.validate()) {
                                                      context.read<AuthBloc>().add(
                                                            LoginRequested(
                                                              email: _emailController.text,
                                                              password: _passwordController.text,
                                                            ),
                                                          );
                                                    }
                                                  },
                                            child: state is AuthLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: AppLoader(),
                                                  )
                                                : const Text(
                                                    "تسجيل الدخول",
                                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 60);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
