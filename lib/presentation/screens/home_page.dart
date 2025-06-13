import 'package:flutter/material.dart';
import 'sell/sell_page.dart';
import 'chat/chat_screen.dart';
import 'profile/profile_screen.dart';
import 'materials/materials_screen.dart';
import 'fridges/fridges_screen.dart';
import 'vendor/vendors_screen.dart'; // تأكد إنه مضاف
import 'vendor/vendor_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    FridgesScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToTab(int index) {
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIcon(0, Icons.home, 'الرئيسية'),
            buildIcon(1, Icons.local_shipping, 'البرادات'),
            buildIcon(2, Icons.chat, 'الدردشة'),
            buildIcon(3, Icons.person, 'الملف الشخصي'),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1FDF0) : Colors.transparent,
          border:
              isSelected
                  ? const Border(
                    top: BorderSide(color: Color(0xFFDAF3D7), width: 2),
                    bottom: BorderSide(color: Color(0xFFDAF3D7), width: 2),
                  )
                  : null,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color.fromARGB(255, 28, 98, 32) : Colors.grey),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Color.fromARGB(255, 28, 98, 32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          HeaderSection(),
          SizedBox(height: 20),
          SellButton(),
          SizedBox(height: 20),
          MainOptions(),
          SizedBox(height: 20),
          TodayVendorsSection(), // هنا التعديل بيتم من خلال VendorsScreen
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class MainOptions extends StatelessWidget {
  const MainOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MaterialsScreen()),
              );
            },
            child: const OptionCard(
              title: 'المواد' ,
              imagePath: 'assets/vegetables.png',
              imageHeight: 130,
               // زيادة الارتفاع
            ),
          ),
          GestureDetector(
            onTap: () {
              context
                  .findAncestorStateOfType<_HomeScreenState>()
                  ?.navigateToTab(1);
            },
            child: const OptionCard(
              title: 'البرادات',
              imagePath: 'assets/truck.png',
              imageHeight: 130, // زيادة الارتفاع
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double imageHeight; // إضافة بارامتر للارتفاع

  const OptionCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.imageHeight = 90, // قيمة افتراضية جديدة
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      width: 150, // زيادة العرض
      height: 180, // زيادة الارتفاع
      decoration: BoxDecoration(
        color: const Color(0xFFF1FDF0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: imageHeight, // استخدام الارتفاع المحدد
            fit: BoxFit.contain, // للحفاظ على نسبة العرض إلى الارتفاع
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 28, 98, 32),
              fontSize: 18, // زيادة حجم الخط
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFDAF3D7),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        image: DecorationImage(
          image: AssetImage('assets/leaves_bg.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Column(
        children: [
          Center(child: Image.asset('assets/logo.png', height: 220)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'مرحباً محمد',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold , color: Color.fromARGB(255, 28, 98, 32)), 
              ),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/user.jpg'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'أرسل رسالة سريعة لمصدر البرادات؟',
                hintStyle: const TextStyle(fontSize: 13),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.send, color: Color.fromARGB(255, 28, 98, 32)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  const SellButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SellPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 28, 98, 32),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'القيام بعملية بيع',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TodayVendorsSection extends StatelessWidget {
  const TodayVendorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VendorsScreen(), // تعديل هنا
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1FDF0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Image.asset('assets/vendor.png', height: 150),
            const SizedBox(height: 20),
            const Text(
              'المتسوقين اليوم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 28, 98, 32)),
            ),
          ],
        ),
      ),
    );
  }
}
