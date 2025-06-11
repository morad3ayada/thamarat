import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    width: 100, // كبرنا اللوجو هنا
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

                // صورة العميل داخل إطار أبيض أكبر
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8), // زودنا الـ padding
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage('assets/user.jpg'),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'محمد العلي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 28, 98, 32),
                  ),
                ),

                const SizedBox(height: 24),

                const ProfileField(
                  label: 'الاسم',
                  value: 'محمد العلي',
                ),
                const ProfileField(
                  label: 'رقم الهاتف',
                  value: '096512345678',
                ),
                const ProfileField(
                  label: 'البريد الإلكتروني',
                  value: 'mohammad@example.com',
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
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
