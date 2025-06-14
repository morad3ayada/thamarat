import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/profile/profile_bloc.dart';
import '../../../logic/blocs/profile/profile_event.dart';
import '../../../logic/blocs/profile/profile_state.dart';
import '../../../data/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isEditing = false;
  bool _showPasswordFields = false;
  bool _wasUpdated = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _showEditDialog(UserModel user) {
    _usernameController.text = user.name;
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone;
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _showPasswordFields = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'تعديل الملف الشخصي',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المستخدم',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المستخدم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!value.contains('@')) {
                        return 'الرجاء إدخال بريد إلكتروني صحيح';
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
                  Row(
                    children: [
                      Checkbox(
                        value: _showPasswordFields,
                        onChanged: (value) {
                          setState(() {
                            _showPasswordFields = value ?? false;
                          });
                        },
                      ),
                      const Text('تغيير كلمة المرور'),
                    ],
                  ),
                  if (_showPasswordFields) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور الحالية',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_showPasswordFields && (value == null || value.isEmpty)) {
                          return 'الرجاء إدخال كلمة المرور الحالية';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_showPasswordFields && (value == null || value.isEmpty)) {
                          return 'الرجاء إدخال كلمة المرور الجديدة';
                        }
                        if (_showPasswordFields && value != null && value.isNotEmpty && value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateProfile();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 28, 98, 32),
              ),
              child: const Text(
                'حفظ',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    // Only include password fields if both are filled
    String? currentPassword;
    String? newPassword;
    
    if (_showPasswordFields && 
        _currentPasswordController.text.isNotEmpty && 
        _newPasswordController.text.isNotEmpty) {
      currentPassword = _currentPasswordController.text;
      newPassword = _newPasswordController.text;
    }
    
    final request = UpdateProfileRequest(
      username: _usernameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    
    _wasUpdated = true;
    context.read<ProfileBloc>().add(UpdateProfile(request));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && _wasUpdated) {
          // Profile was just updated successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الملف الشخصي بنجاح'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          _wasUpdated = false;
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            body: Stack(
              children: [
                // الخلفية الخضراء
                Container(
                  height: isTablet ? 280 : 200,
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
                      Positioned(
                        top: isTablet ? 80 : 70,
                        right: isTablet ? 32 : 20,
                        child: Text(
                          'الملف الشخصي',
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 28, 98, 32),
                          ),
                        ),
                      ),
                      Positioned(
                        top: isTablet ? 50 : 50,
                        left: isTablet ? 32 : 20,
                        child: Image.asset(
                          'assets/logo.png',
                          width: isTablet ? 120 : 100,
                        ),
                      ),
                    ],
                  ),
                ),

                // المحتوى الكامل
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: isTablet ? 140 : 140),

                      if (state is ProfileLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (state is ProfileLoaded) ...[
                        // صورة العميل داخل إطار أبيض أكبر
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(isTablet ? 12 : 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.store,
                              size: isTablet ? 80 : 60,
                              color: const Color.fromARGB(255, 28, 98, 32),
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 16 : 12),

                        Text(
                          state.user.name,
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 28, 98, 32),
                          ),
                        ),

                        SizedBox(height: isTablet ? 32 : 24),

                        ProfileField(
                          label: 'اسم المستخدم',
                          value: state.user.name,
                          isTablet: isTablet,
                        ),
                        ProfileField(
                          label: 'رقم الهاتف',
                          value: state.user.phone,
                          isTablet: isTablet,
                        ),
                        ProfileField(
                          label: 'البريد الإلكتروني',
                          value: state.user.email ?? 'غير محدد',
                          isTablet: isTablet,
                        ),

                        SizedBox(height: isTablet ? 24 : 16),

                        // صلاحيات المستخدم
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
                          padding: EdgeInsets.all(isTablet ? 24 : 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'الصلاحيات',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet ? 18 : 15,
                                ),
                              ),
                              SizedBox(height: isTablet ? 16 : 12),
                              Row(
                                children: [
                                  Icon(
                                    state.user.sellerPermission ? Icons.check_circle : Icons.cancel,
                                    color: state.user.sellerPermission ? Colors.green : Colors.red,
                                    size: isTablet ? 24 : 20,
                                  ),
                                  SizedBox(width: isTablet ? 12 : 8),
                                  Expanded(
                                    child: Text(
                                      'صلاحية البيع',
                                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isTablet ? 12 : 8),
                              Row(
                                children: [
                                  Icon(
                                    state.user.salePermissionForSpoiledMaterials ? Icons.check_circle : Icons.cancel,
                                    color: state.user.salePermissionForSpoiledMaterials ? Colors.green : Colors.red,
                                    size: isTablet ? 24 : 20,
                                  ),
                                  SizedBox(width: isTablet ? 12 : 8),
                                  Expanded(
                                    child: Text(
                                      'صلاحية بيع المواد التالفة',
                                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isTablet ? 32 : 24),

                        // زر التعديل - مؤقتاً معطل
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     child: ElevatedButton.icon(
                        //       onPressed: () => _showEditDialog(state.user),
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: const Color.fromARGB(255, 28, 98, 32),
                        //         padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        //         ),
                        //       ),
                        //       icon: Icon(Icons.edit, color: Colors.white, size: isTablet ? 24 : 20),
                        //       label: Text(
                        //         'تعديل الملف الشخصي',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: isTablet ? 18 : 16,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: isTablet ? 40 : 30),
                      ] else if (state is ProfileError)
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
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool isTablet;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 24, 
        vertical: isTablet ? 12 : 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 17 : 15,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 6),
          TextField(
            enabled: false,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: value,
              hintStyle: TextStyle(
                color: Colors.black87,
                fontSize: isTablet ? 16 : 14,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 20 : 16,
                vertical: isTablet ? 16 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


