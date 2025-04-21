import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(), // ✅ هنا التعديل
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
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
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 180,
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            "يرجى كتابة اسم المستخدم وكلمة السر للمتابعة",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 0),
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
                                const Text(
                                  "اسم المستخدم",
                                  style: TextStyle(color: Color(0xFF2E7D32)),
                                ),
                                const SizedBox(height: 6),
                                const TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF1FDF0),
                                    prefixIcon: Icon(Icons.person, color: Color(0xFF2E7D32)),
                                    hintText: "اسم المستخدم",
                                    hintStyle: TextStyle(color: Color(0xFF66BB6A)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF81C784)),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "كلمة السر",
                                  style: TextStyle(color: Color(0xFF2E7D32)),
                                ),
                                const SizedBox(height: 6),
                                const TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFF1FDF0),
                                    prefixIcon: Icon(Icons.lock, color: Color(0xFF2E7D32)),
                                    hintText: "كلمة السر",
                                    hintStyle: TextStyle(color: Color(0xFF66BB6A)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF81C784)),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFF388E3C), width: 2),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF43A047),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                      );
                                    },
                                    child: const Text(
                                      "تسجيل الدخول",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
