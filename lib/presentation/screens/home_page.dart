import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thamarat/logic/blocs/profile/profile_event.dart';
import '../../../logic/blocs/profile/profile_bloc.dart';
import '../../../logic/blocs/profile/profile_state.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600; // تعريف التابلت

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32 : 8, 
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIcon(0, Icons.home, 'الرئيسية', isTablet),
            buildIcon(1, Icons.local_shipping, 'البرادات', isTablet),
            buildIcon(2, Icons.chat, 'الدردشة', isTablet),
            buildIcon(3, Icons.person, 'الملف الشخصي', isTablet),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(int index, IconData icon, String label, bool isTablet) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1FDF0) : Colors.transparent,
          border: isSelected
              ? const Border(
                  top: BorderSide(color: Color(0xFFDAF3D7), width: 2),
                  bottom: BorderSide(color: Color(0xFFDAF3D7), width: 2),
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 10, 
          vertical: isTablet ? 12 : 6,
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isSelected ? const Color.fromARGB(255, 28, 98, 32) : Colors.grey,
              size: isTablet ? 28 : 24,
            ),
            if (isSelected)
              Padding(
                padding: EdgeInsets.only(right: isTablet ? 12 : 6),
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 28, 98, 32),
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    // Load user profile when home page is opened
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderSection(isTablet: isTablet),
          SizedBox(height: isTablet ? 32 : 20),
          SellButton(isTablet: isTablet),
          SizedBox(height: isTablet ? 32 : 20),
          MainOptions(isTablet: isTablet),
          SizedBox(height: isTablet ? 32 : 20),
          TodayVendorsSection(isTablet: isTablet),
          SizedBox(height: isTablet ? 40 : 30),
        ],
      ),
    );
  }
}

class MainOptions extends StatelessWidget {
  final bool isTablet;

  const MainOptions({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = isTablet ? 48.0 : 24.0;
    final cardWidth = isTablet ? 200.0 : 150.0;
    final cardHeight = isTablet ? 240.0 : 180.0;
    final imageHeight = isTablet ? 170.0 : 130.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MaterialsScreen()),
              );
            },
            child: OptionCard(
              title: 'المواد',
              imagePath: 'assets/vegetables.png',
              imageHeight: imageHeight,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              isTablet: isTablet,
            ),
          ),
          GestureDetector(
            onTap: () {
              context
                  .findAncestorStateOfType<_HomeScreenState>()
                  ?.navigateToTab(1);
            },
            child: OptionCard(
              title: 'البرادات',
              imagePath: 'assets/truck.png',
              imageHeight: imageHeight,
              cardWidth: cardWidth,
              cardHeight: cardHeight,
              isTablet: isTablet,
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
  final double imageHeight;
  final double cardWidth;
  final double cardHeight;
  final bool isTablet;

  const OptionCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.imageHeight,
    required this.cardWidth,
    required this.cardHeight,
    required this.isTablet,
  });

  @override 
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF1FDF0),
        borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: imageHeight,
            fit: BoxFit.contain,
          ),
          SizedBox(height: isTablet ? 16 : 10),
          Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 28, 98, 32),
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final bool isTablet;

  const HeaderSection({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = isTablet ? 32.0 : 16.0;
    final logoHeight = isTablet ? 280.0 : 220.0;
    final avatarRadius = isTablet ? 32.0 : 26.0;
    final greetingFontSize = isTablet ? 28.0 : 24.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding, 
        isTablet ? 60 : 50, 
        horizontalPadding, 
        isTablet ? 32 : 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDAF3D7),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        image: DecorationImage(
          image: const AssetImage('assets/leaves_bg.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Column(
        children: [
          Center(child: Image.asset('assets/logo.png', height: logoHeight)),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String userName = 'مرحباً';
              
              if (state is ProfileLoaded) {
                userName = 'مرحباً ${state.user.name}';
              } else if (state is ProfileLoading) {
                userName = 'مرحباً...';
              } else if (state is ProfileError) {
                userName = 'مرحباً';
              }
              
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: greetingFontSize, 
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 28, 98, 32),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: const AssetImage('assets/user.jpg'),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
            ),
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8),
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'أرسل رسالة سريعة لمصدر البرادات؟',
                hintStyle: TextStyle(fontSize: isTablet ? 16 : 13),
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.send, 
                  color: Color.fromARGB(255, 28, 98, 32),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  final bool isTablet;

  const SellButton({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = isTablet ? 48.0 : 24.0;
    final verticalPadding = isTablet ? 18.0 : 14.0;
    final fontSize = isTablet ? 22.0 : 18.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SellPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 28, 98, 32),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
          ),
        ),
        child: Text(
          'القيام بعملية بيع',
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TodayVendorsSection extends StatelessWidget {
  final bool isTablet;

  const TodayVendorsSection({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = isTablet ? 48.0 : 24.0;
    final padding = isTablet ? 24.0 : 16.0;
    final imageHeight = isTablet ? 200.0 : 150.0;
    final fontSize = isTablet ? 22.0 : 18.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VendorsScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: const Color(0xFFF1FDF0),
          borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset('assets/vendor.png', height: imageHeight),
            SizedBox(height: isTablet ? 24 : 20),
            Text(
              'المتسوقين اليوم',
              style: TextStyle(
                fontSize: fontSize, 
                fontWeight: FontWeight.bold, 
                color: const Color.fromARGB(255, 28, 98, 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
