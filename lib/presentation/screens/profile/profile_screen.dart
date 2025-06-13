import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../logic/blocs/auth/auth_event.dart';
import '../../../logic/blocs/profile/profile_bloc.dart';
import '../../../logic/blocs/profile/profile_event.dart';
import '../../../logic/blocs/profile/profile_state.dart';
import '../../../data/models/user_model.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startEditing(UserModel user) {
    setState(() {
      _isEditing = true;
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _emailController.text = user.email ?? '';
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = UserModel(
        id: context.read<ProfileBloc>().state is ProfileLoaded
            ? (context.read<ProfileBloc>().state as ProfileLoaded).user.id
            : 0,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
      );
      context.read<ProfileBloc>().add(UpdateProfile(updatedUser));
      setState(() => _isEditing = false);
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          body: Stack(
            children: [
              // الخلفية الخضراء
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFDAF3D7),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 70,
                      right: 20,
                      child: Text(
                        'الملف الشخصي',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 98, 32),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),

              // المحتوى الكامل
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 140),
                    if (state is ProfileLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state is ProfileLoaded)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xFFDAF3D7),
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Color.fromARGB(255, 28, 98, 32),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (!_isEditing) ...[
                                      Text(
                                        state.user.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 28, 98, 32),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        state.user.phone,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      if (state.user.email != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          state.user.email!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: () => _startEditing(state.user),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        icon: const Icon(Icons.edit, color: Colors.white),
                                        label: const Text(
                                          'تعديل الملف الشخصي',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ] else ...[
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _nameController,
                                              decoration: const InputDecoration(
                                                labelText: 'الاسم',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'الرجاء إدخال الاسم';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: _phoneController,
                                              decoration: const InputDecoration(
                                                labelText: 'رقم الهاتف',
                                                border: OutlineInputBorder(),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'الرجاء إدخال رقم الهاتف';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: _emailController,
                                              decoration: const InputDecoration(
                                                labelText: 'البريد الإلكتروني (اختياري)',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: _cancelEditing,
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.grey.shade200,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'إلغاء',
                                                      style: TextStyle(color: Colors.black87),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: _saveProfile,
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'حفظ',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.logout,
                                      color: Color.fromARGB(255, 28, 98, 32),
                                    ),
                                    title: const Text(
                                      'تسجيل الخروج',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 28, 98, 32),
                                      ),
                                    ),
                                    onTap: _handleLogout,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (state is ProfileError)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProfileBloc>().add(LoadProfile());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            enabled: false,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: value,
              hintStyle: const TextStyle(color: Colors.black87),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
